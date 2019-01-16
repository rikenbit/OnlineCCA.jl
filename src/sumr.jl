"""
    sumr(;binfile::AbstractString="", outdir::AbstractString=".", pseudocount::Number=1.0)
Extract the summary information of data matrix.
`binfile` is a Julia Binary file generated by `csv2bin` function.
`outdir` is specified the directory you want to save the result.
`pseudocount` is specified to avoid NaN by log10(0) and used when `Feature_LogMeans.csv` <log10(mean+pseudocount) value of each feature> is generated.
Output Files
---------
- `Sample_NoCounts.csv` : Sum of counts in each column.
- `Feature_Means.csv` : Mean in each row.
- `Feature_LogMeans.csv` : Log10(Mean+pseudocount) in each row.
- `Feature_Vars.csv` : Sample variance in each row.
- `Feature_CV2s.csv` : Coefficient of Variation in each row.
- `Feature_NoZeros.csv` : Number of zero-elements in each row.
"""
function sumr(;binfile::AbstractString="", outdir::AbstractString=".", pseudocount::Number=1.0)
    # 1 / 2 : Column-wise statistics
    println("1 / 2 : Column-wise statistics are calculated...")
    Sample_NoCounts = nocounts(binfile)

    # 2 / 2 : Row-wise statistics
    println("2 / 2 : Row-wise statistics are calculated...")
    Feature_Means, Feature_LogMeans, Feature_FTTMeans, Feature_Vars, Feature_LogVars, Feature_FTTVars, Feature_CV2s, Feature_NoZeros = stats(binfile, pseudocount)

    # Save
    writecsv(joinpath(outdir, "Sample_NoCounts.csv"), Sample_NoCounts)
    writecsv(joinpath(outdir, "Feature_Means.csv"), Feature_Means)
    writecsv(joinpath(outdir, "Feature_LogMeans.csv"), Feature_LogMeans)
    writecsv(joinpath(outdir, "Feature_FTTMeans.csv"), Feature_FTTMeans)
    writecsv(joinpath(outdir, "Feature_Vars.csv"), Feature_Vars)
    writecsv(joinpath(outdir, "Feature_LogVars.csv"), Feature_LogVars)
    writecsv(joinpath(outdir, "Feature_FTTVars.csv"), Feature_FTTVars)
    writecsv(joinpath(outdir, "Feature_CV2s.csv"), Feature_CV2s)
    writecsv(joinpath(outdir, "Feature_NoZeros.csv"), Feature_NoZeros)
end

# Column-wise statistics
function nocounts(binfile::AbstractString)
    N, M = nm(binfile)
    tmpN = zeros(UInt32, 1)
    tmpM = zeros(UInt32, 1)
    x = zeros(UInt32, M)
    nc = zeros(UInt32, M)
    progress = Progress(N)
    open(binfile) do file
        stream = ZstdDecompressorStream(file)
        read!(stream, tmpN)
        read!(stream, tmpM)
        for n = 1:N
            # Data Import
            read!(stream, x)
            # Update
            nc = nc .+ x
            # Progress Bar
            next!(progress)
        end
        close(stream)
    end
    return nc
end

# Row-wise statistics
function stats(binfile::AbstractString, pseudocount::Number)
    N, M = nm(binfile)
    tmpN = zeros(UInt32, 1)
    tmpM = zeros(UInt32, 1)
    x = zeros(UInt32, M)
    m = zeros(N)
    lm = zeros(N)
    fttm = zeros(N)
    v = zeros(N)
    lv = zeros(N)
    fttv = zeros(N)
    c = zeros(N)
    nz = zeros(N)
    progress = Progress(N)
    open(binfile) do file
        stream = ZstdDecompressorStream(file)
        read!(stream, tmpN)
        read!(stream, tmpM)
        for n = 1:N
            # Data Import
            read!(stream, x)
            # Update
            m[n] = mean(x)
            lm[n] = mean(log10.(x .+ pseudocount))
            fttm[n] = mean(sqrt.(x) .+ sqrt.(x .+ 1))
            v[n] = var(x)
            lv[n] = var(log10.(x .+ pseudocount))
            fttv[n] = var(sqrt.(x) .+ sqrt.(x .+ 1))
            c[n] = v[n] / m[n]^2
            for mm = 1:M
                if x[mm] != 0
                    nz[n] = nz[n] + 1
                end
            end
            # Progress Bar
            next!(progress)
        end
        close(stream)
    end
    return m, lm, fttm, v, lv, fttv, c, nz
end