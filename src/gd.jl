"""
    gd(;input::AbstractArray=[], outdir::Union{Nothing,AbstractString}=nothing, scale::AbstractArray=[], pseudocount::AbstractArray=[], colmeanlist::AbstractArray="", colvarlist::Union{Nothing,AbstractString,AbstractArray}="", dim::Number=3, stepsize::Number=0.1, numepoch::Number=3, scheduling::AbstractString="robbins-monro", g::Number=0.9, epsilon::Number=1.0e-8, lower::Number=0, upper::Number=1.0f+38, evalfreq::Number=5000, offsetFull::Number=1f-20, offsetStoch::Number=1f-20, logdir::Union{Nothing,AbstractString}=nothing, initW::Union{Nothing,AbstractArray}=nothing, perm::Bool=false)
Online CCA solved by gradient descent method.
Input Arguments
---------
- `input` : Julia Binary file generated by `OnlineCCA.csv2bin` function.
- `outdir` : The directory specified the directory you want to save the result.
- `scale` : {log,ftt,raw}-scaling of the value.
- `pseudocount` : The number specified to avoid NaN by log10(0) and used when `Feature_LogMeans.csv` <log10(mean+pseudocount) value of each feature> is generated.
- `colmeanlist` : The mean of each column of matrix. The CSV file is generated by `OnlineCCA.sumr` functions.
- `colvarlist` : The variance of each column of matrix. The CSV file is generated by `OnlineCCA.sumr` functions.
- `dim` : The number of dimension of CCA.
- `stepsize` : The parameter used in every iteration.
- `numepoch` : The number of epoch.
- `scheduling` : Learning parameter scheduling. `robbins-monro`, `momentum`, `nag`, and `adagrad` are available.
- `g` : The parameter that is used when scheduling is specified as nag.
- `epsilon` : The parameter that is used when scheduling is specified as adagrad.
- `lower` : Stopping Criteria (When the relative change of error is below this value, the calculation is terminated)
- `upper` : Stopping Criteria (When the relative change of error is above this value, the calculation is terminated)
- `evalfreq` : Evaluation Frequency of Reconstruction Error
- `offsetFull` : Off set value for avoding overflow when calculating full gradient
- `offsetStoch` : Off set value for avoding overflow when calculating stochastic gradient
- `initW` : The CSV file saving the initial values of eigenvectors.
- `logdir` : The directory where intermediate files are saved, in every 1000 iteration.
- `perm` : Whether the data matrix is shuffled at random.
Output Arguments
---------
- `W` : Eigen vectors of covariance matrix (No. columns of the data matrix × dim)
- `λ` : Eigen values (dim × dim)
- `V` : Latent variables of covariance matrix (No. rows of the data matrix × dim)
- `ExpCorVar` : Explained correlation/variance by the eigenvectors
- `TotalCorVar` : Total correlation/variance of the data matrix
- `Objective` : The summation of object function (e.g. w_i' X_i' X_j w_j)
- `AvgLatentCor` : The mean of correlation efficient of latent variables (e.g. cor(X_i w_i, X_j w_j))
- stop : Whether the calculation is converged
"""
function gd(;input::AbstractArray=[], outdir::Union{Nothing,AbstractString}=nothing, scale::AbstractArray=[], pseudocount::AbstractArray=[], colmeanlist::AbstractArray="", colvarlist::Union{Nothing,AbstractString,AbstractArray}="", dim::Number=3, stepsize::Number=0.1, numepoch::Number=3, scheduling::AbstractString="robbins-monro", g::Number=0.9, epsilon::Number=1.0e-8, lower::Number=0, upper::Number=1.0f+38, evalfreq::Number=5000, offsetFull::Number=1f-20, offsetStoch::Number=1f-20, initW::Union{Nothing,AbstractArray}=nothing, logdir::Union{Nothing,AbstractString}=nothing, perm::Bool=false)
    # Initial Setting
    cca = GD()
    if scheduling == "robbins-monro"
        scheduling = ROBBINS_MONRO()
    elseif scheduling == "momentum"
        scheduling = MOMENTUM()
    elseif scheduling == "nag"
        scheduling = NAG()
    elseif scheduling == "adagrad"
        scheduling = ADAGRAD()
    else
        error("Specify the scheduling as robbins-monro, momentum, nag or adagrad")
    end
    pseudocount, stepsize, g, epsilon, W, v, D, colmeanlist, colmeanvec, colvarlist, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetFull, offsetStoch = init(input, pseudocount, stepsize, g, epsilon, dim, colmeanlist, colvarlist, initW, logdir, cca, lower, upper, evalfreq, offsetFull, offsetStoch, scale)
    # Perform CCA
    out = gd(input, outdir, scale, pseudocount, colmeanlist, colvarlist, dim, stepsize, numepoch, scheduling, g, epsilon, logdir, cca, W, v, D, colmeanvec, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetFull, offsetStoch, perm)
    if outdir isa String
        output(outdir, out, cca)
    end
    return out
end

function gd(input, outdir, scale, pseudocount, colmeanlist, colvarlist, dim, stepsize, numepoch, scheduling, g, epsilon, logdir, cca, W, v, D, colmeanvec, colvarvec, N, M, TotalCorVar, lower, upper, evalfreq, offsetFull, offsetStoch, perm)
    # If not 0 the calculation is converged
    stop = 0
    s = 1
    n = 1
    # Each epoch s
    progress = Progress(numepoch)
    while(stop == 0 && s <= numepoch)
        next!(progress)
        # Update Eigen vector
        W, v = gdupdate(scheduling, stepsize, g, epsilon, D, N, M, W, v, s, input, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, offsetFull, offsetStoch, perm)
        # NaN
        checkNaN(W, cca)
        # Retraction
        W .= Retraction(W)
        # save log file
        if logdir isa String
            stop = outputlog(s, input, dim, logdir, W, cca, TotalCorVar, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, lower, upper, stop)
        end
        s += 1
    end
    # Return, W, λ, V
    out = WλV(W, input, dim, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, TotalCorVar)
    return (out[1], out[2], out[3], out[4], out[5], out[6], out[7], stop)
end

# GD × Robbins-Monro
function gdupdate(scheduling::ROBBINS_MONRO, stepsize, g, epsilon, D, N, M, W, v, s, input, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, offsetFull, offsetStoch, perm)
    W .= W + ∇f(W, input, D, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, stepsize/s, offsetFull, offsetStoch, perm)
    v = nothing
    return W, v
end

# GD × Momentum
function gdupdate(scheduling::MOMENTUM, stepsize, g, epsilon, D, N, M, W, v, s, input, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, offsetFull, offsetStoch, perm)
    v .= g .* v .+ ∇f(W, input, D, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, stepsize/s, offsetFull, offsetStoch, perm)
    W .= W .+ v
    return W, v
end

# GD × NAG
function gdupdate(scheduling::NAG, stepsize, g, epsilon, D, N, M, W, v, s, input, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, offsetFull, offsetStoch, perm)
    v = g .* v + ∇f(W - g .* v, input, D, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, stepsize/s, offsetFull, offsetStoch, perm)
    W .= W .+ v
    return W, v
end

# GD × Adagrad
function gdupdate(scheduling::ADAGRAD, stepsize, g, epsilon, D, N, M, W, v, s, input, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, offsetFull, offsetStoch, perm)
    grad = ∇f(W, input, D, scale, pseudocount, colmeanlist, colmeanvec, colvarlist, colvarvec, stepsize/s, offsetFull, offsetStoch, perm)
    grad = grad / stepsize
    l = length(grad)
    for i=1:l
        v[i] .= v[i] .+ grad[i] .* grad[i]
        W[i] .= W[i] .+ stepsize ./ (sqrt.(v[i]) .+ epsilon) .* grad[i]
    end
    return W, v
end