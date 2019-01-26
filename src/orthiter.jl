"""
    orthiter(;input::AbstractArray=[], outdir::Union{Nothing,AbstractString}=nothing, scale::AbstractArray=[], pseudocount::AbstractArray=[], colmeanlist::AbstractArray="", colvarlist::Union{AbstractString,AbstractArray}="", dim::Number=3, numepoch::Number=3, lower::Number=0, upper::Number=1.0f+38, evalfreq::Number=5000, offsetStoch::Number=1f-20, initW::Union{Nothing,AbstractArray}=nothing, logdir::Union{Nothing,AbstractString}=nothing, perm::Bool=false)
Online CCA solved by orthogonal iteraction (power method).
Input Arguments
---------
- `input` : Julia Binary file generated by `OnlineCCA.csv2bin` function.
- `outdir` : The directory specified the directory you want to save the result.
- `scale` : {log,ftt,raw}-scaling of the value.
- `pseudocount` : The number specified to avoid NaN by log10(0) and used when `Feature_LogMeans.csv` <log10(mean+pseudocount) value of each feature> is generated.
- `colmeanlist` : The mean of each column of matrix. The CSV file is generated by `OnlineCCA.sumr` functions.
- `colvarlist` : The variance of each column of matrix. The CSV file is generated by `OnlineCCA.sumr` functions.
- `dim` : The number of dimension of CCA.
- `numepoch` : The number of epoch.
- `lower` : Stopping Criteria (When the relative change of error is below this value, the calculation is terminated)
- `upper` : Stopping Criteria (When the relative change of error is above this value, the calculation is terminated)
- `evalfreq` : Evaluation Frequency of Reconstruction Error
- `offsetStoch` : Off set value for avoding overflow when calculating stochastic gradient
- `initW` : The CSV file saving the initial values of eigenvectors.
- `logdir` : The directory where intermediate files are saved, in every evalfreq (e.g. 5000) iteration.
- `perm` : Whether the data matrix is shuffled at random.
Output Arguments
---------
- `W` : Eigen vectors of covariance matrix (No. columns of the data matrix × dim)
- `λ` : Eigen values (dim × dim)
- `V` : Loading vectors of covariance matrix (No. rows of the data matrix × dim)
- `ExpCorVar` : Explained correlation/variance by the eigenvectors
- `TotalCorVar` : Total correlation/variance of the data matrix
- `Objective` : The summation of object function (e.g. w_i' X_i' X_j w_j)
- `AvgLatentCor` : The mean of correlation efficient of latent variables (e.g. cor(X_i w_i, X_j w_j))
- stop : Whether the calculation is converged
"""
function orthiter(;input::AbstractArray=[], outdir::Union{Nothing,AbstractString}=nothing, scale::AbstractArray=[], pseudocount::AbstractArray=[], colmeanlist::AbstractArray="", colvarlist::Union{AbstractString,AbstractArray}="", dim::Number=3, numepoch::Number=3, lower::Number=0, upper::Number=1.0f+38, evalfreq::Number=5000, offsetStoch::Number=1f-6, initW::Union{Nothing,AbstractArray}=nothing, logdir::Union{Nothing,AbstractString}=nothing, perm::Bool=false)
    # Initial Setting
    cca = ORTHITER()
    pseudocount, W, v, D, colmeanlist, colmeanvec, colvarlist, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetStoch = init(input, pseudocount, dim, colmeanlist, colvarlist, initW, logdir, cca, lower, upper, evalfreq, offsetStoch, scale)
    # Perform CCA
    out = orthiter(input, outdir, scale, pseudocount, colmeanlist, colvarlist, dim, numepoch, logdir, cca, W, v, D, colmeanvec, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetStoch, perm)
    if outdir isa String
        output(outdir, out, cca)
    end
    return out
end

function orthiter(input, outdir, scale, pseudocount, colmeanlist, colvarlist, dim, numepoch, logdir, cca, W, v, D, colmeanvec, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetStoch, perm)
    N, M = nm(input)
    tmpN = zeros(UInt32, 1)
    tmpM = zeros(UInt32, 1)
    l = length(input)
    x = Any[]
    normx = Any[]
    for i=1:l
        push!(x, zeros(UInt32, M[i]))
        push!(normx, zeros(Float32, M[i]))
    end
    # If not 0 the calculation is converged
    stop = 0
    s = 1
    n = 1
    stream = Any[]
    # Each epoch s
    progress = Progress(numepoch*N[1])
    while(stop == 0 && s <= numepoch)
        next!(progress)
        if n == 1
            stream = Any[]
            # Stream
            for i=1:l
                push!(stream, ZstdDecompressorStream(open(input[i])))
            end
            # tmpN, tmpN
            for i=1:l
                read!(stream[i], tmpN)
                read!(stream[i], tmpM)
            end
        else
            # x, norm
            for i=1:l
                read!(stream[i], x[i])
                normx[i] = normalizex(x[i], n, stream[i], scale[i], pseudocount[i], colmeanlist[i], colmeanvec[i], colvarlist[i], colvarvec[i])
                if perm
                    normx[i] .= normx[randperm(length(normx[i]))]
                end
            end
            # Update Eigen vector
            for i=1:l
                for k=1:l
                    if i != k
                        W[i] .+= normx[i] * (normx[k]'W[k] * offsetStoch)
                    end
                end
            end
            # close
            if n == N[1]
                for i=1:l
                    close(stream[i])
                end
            end
        end
        n += 1
        if n == N[1] + 1
            # NaN
            checkNaN(W, GD())
            # Retraction
            W .= Retraction(W)
            # save log file
            if logdir isa String
                stop = outputlog(s, input, dim, logdir, W, GD(), TotalCorVar, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, lower, upper, stop)
            end
            s += 1
            n = 1
        end
    end

    # Return, W, λ, V
    out = WλV(W, input, dim, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, TotalCorVar)
    return (out[1], out[2], out[3], out[4], out[5], out[6], out[7], stop)
end