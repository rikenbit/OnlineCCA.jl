using OnlineCCA
using OnlineCCA: readcsv, writecsv
using Test
using Pkg
using DelimitedFiles
using Statistics
using Distributions

tmp = mktempdir()
julia = joinpath(Sys.BINDIR, "julia")
bindir = joinpath(dirname(pathof(OnlineCCA)), "..", "bin")

function testfilesize(remove::Bool, x...)
  for n = 1:length(x)
    @test filesize(x[n]) != 0
    if remove
      rm(x[n])
    end
  end
end

#####################################
X = Int64.(ceil.(rand(NegativeBinomial(1, 0.5), 300, 30)))
X[1:50, 1:10] .= 100*X[1:50, 1:10]
X[51:100, 11:20] .= 100*X[51:100, 11:20]
X[101:150, 21:30] .= 100*X[101:150, 21:30]
writecsv(joinpath(tmp, "X.csv"), X)

Y = Int64.(ceil.(rand(NegativeBinomial(1, 0.5), 300, 40)))
Y[1:50, 1:15] .= 100*Y[1:50, 1:15]
Y[51:100, 16:24] .= 100*Y[51:100, 16:24]
Y[101:150, 25:40] .= 100*Y[101:150, 25:40]
writecsv(joinpath(tmp, "Y.csv"), Y)

Z = Int64.(ceil.(rand(NegativeBinomial(1, 0.5), 300, 50)))
Z[1:50, 1:20] .= 100*Z[1:50, 1:20]
Z[51:100, 21:40] .= 100*Z[51:100, 21:40]
Z[101:150, 41:50] .= 100*Z[101:150, 41:50]
writecsv(joinpath(tmp, "Z.csv"), Z)
#####################################


#####################################
println("####### Binarization (Julia API) #######")
csv2bin(csvfile=joinpath(tmp, "X.csv"),
  binfile=joinpath(tmp, "X.zst"))
csv2bin(csvfile=joinpath(tmp, "Y.csv"),
  binfile=joinpath(tmp, "Y.zst"))
csv2bin(csvfile=joinpath(tmp, "Z.csv"),
  binfile=joinpath(tmp, "Z.zst"))

testfilesize(false, joinpath(tmp, "X.zst"))
testfilesize(false, joinpath(tmp, "Y.zst"))
testfilesize(false, joinpath(tmp, "Z.zst"))
####################################


# #####################################
# println("####### Binarization (Command line) #######")
# run(`$(julia) $(joinpath(bindir, "csv2bin")) --csvfileX $(joinpath(tmp, "X.csv")) --csvfileY $(joinpath(tmp, "Y.csv")) --binfile $(joinpath(tmp, "X.zst"))`)

# testfilesize(false, joinpath(tmp, "X.zst"))
# #####################################


#####################################
println("####### Summarization (Julia API) #######")
mkdir(joinpath(tmp, "SumX"))
mkdir(joinpath(tmp, "SumY"))
mkdir(joinpath(tmp, "SumZ"))
sumr(binfile=joinpath(tmp, "X.zst"),
  outdir=joinpath(tmp, "SumX"))
sumr(binfile=joinpath(tmp, "Y.zst"),
  outdir=joinpath(tmp, "SumY"))
sumr(binfile=joinpath(tmp, "Z.zst"),
  outdir=joinpath(tmp, "SumZ"))

testfilesize(false,
  joinpath(tmp, "SumX/Sample_NoCounts.csv"),
  joinpath(tmp, "SumX/Feature_Means.csv"),
  joinpath(tmp, "SumX/Feature_LogMeans.csv"),
  joinpath(tmp, "SumX/Feature_FTTMeans.csv"),
  joinpath(tmp, "SumX/Feature_Vars.csv"),
  joinpath(tmp, "SumX/Feature_LogVars.csv"),
  joinpath(tmp, "SumX/Feature_FTTVars.csv"),
  joinpath(tmp, "SumX/Feature_SDs.csv"),
  joinpath(tmp, "SumX/Feature_LogSDs.csv"),
  joinpath(tmp, "SumX/Feature_FTTSDs.csv"),
  joinpath(tmp, "SumX/Feature_CV2s.csv"),
  joinpath(tmp, "SumX/Feature_NoZeros.csv"))

testfilesize(false,
  joinpath(tmp, "SumY/Sample_NoCounts.csv"),
  joinpath(tmp, "SumY/Feature_Means.csv"),
  joinpath(tmp, "SumY/Feature_LogMeans.csv"),
  joinpath(tmp, "SumY/Feature_FTTMeans.csv"),
  joinpath(tmp, "SumY/Feature_Vars.csv"),
  joinpath(tmp, "SumY/Feature_LogVars.csv"),
  joinpath(tmp, "SumY/Feature_FTTVars.csv"),
  joinpath(tmp, "SumY/Feature_SDs.csv"),
  joinpath(tmp, "SumY/Feature_LogSDs.csv"),
  joinpath(tmp, "SumY/Feature_FTTSDs.csv"),
  joinpath(tmp, "SumY/Feature_CV2s.csv"),
  joinpath(tmp, "SumY/Feature_NoZeros.csv"))

testfilesize(false,
  joinpath(tmp, "SumZ/Sample_NoCounts.csv"),
  joinpath(tmp, "SumZ/Feature_Means.csv"),
  joinpath(tmp, "SumZ/Feature_LogMeans.csv"),
  joinpath(tmp, "SumZ/Feature_FTTMeans.csv"),
  joinpath(tmp, "SumZ/Feature_Vars.csv"),
  joinpath(tmp, "SumZ/Feature_LogVars.csv"),
  joinpath(tmp, "SumZ/Feature_FTTVars.csv"),
  joinpath(tmp, "SumZ/Feature_SDs.csv"),
  joinpath(tmp, "SumZ/Feature_LogSDs.csv"),
  joinpath(tmp, "SumZ/Feature_FTTSDs.csv"),
  joinpath(tmp, "SumZ/Feature_CV2s.csv"),
  joinpath(tmp, "SumZ/Feature_NoZeros.csv"))
####################################


# #####################################
# println("####### Summarization (Command line) #######")
# run(`$(julia) $(joinpath(bindir, "sumr")) --binfile $(joinpath(tmp, "X.zst")) --outdir $(tmp)`)

# testfilesize(false,
#   joinpath(tmp, "X_Sample_NoCounts.csv"),
#   joinpath(tmp, "Y_Sample_NoCounts.csv"),
#   joinpath(tmp, "X_Feature_CV2s.csv"),
#   joinpath(tmp, "Y_Feature_CV2s.csv"),
#   joinpath(tmp, "X_Feature_LogMeans.csv"),
#   joinpath(tmp, "Y_Feature_LogMeans.csv"),
#   joinpath(tmp, "X_Feature_Means.csv"),
#   joinpath(tmp, "Y_Feature_Means.csv"),
#   joinpath(tmp, "X_Feature_NoZeros.csv"),
#   joinpath(tmp, "Y_Feature_NoZeros.csv"),
#   joinpath(tmp, "X_Feature_Vars.csv"),
#   joinpath(tmp, "Y_Feature_Vars.csv"))
# #####################################


#####################################
println("####### GD (Julia API) #######")
out_gd1 = gd(
  input=(joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")),
  dim=3,
  scheduling="robbins-monro",
  stepsize=1.0e-15,
  numepoch=1,
  rowmeanlist=(joinpath(tmp, "SumX/Feature_FTTMeans.csv"),
    joinpath(tmp, "SumY/Feature_FTTMeans.csv"),
    joinpath(tmp, "SumZ/Feature_FTTMeans.csv")),
  rowsdlist=(joinpath(tmp, "SumX/Feature_FTTSDs.csv"),
    joinpath(tmp, "SumY/Feature_FTTSDs.csv"),
    joinpath(tmp, "SumZ/Feature_FTTSDs.csv")),
  logdir=tmp)

# out_gd2 = gd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="momentum",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_gd3 = gd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="nag",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_gd4 = gd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="adagrad",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# @test size(out_gd1[1]) == (99, 3)
# @test size(out_gd1[2]) == (3, )
# @test size(out_gd1[3]) == (300, 3)
# @test size(out_gd1[4]) == (99, 3)
# @test size(out_gd1[5]) == ()
# @test size(out_gd1[6]) == ()

# @test size(out_gd2[1]) == (99, 3)
# @test size(out_gd2[2]) == (3, )
# @test size(out_gd2[3]) == (300, 3)
# @test size(out_gd2[4]) == (99, 3)
# @test size(out_gd2[5]) == ()
# @test size(out_gd2[6]) == ()

# @test size(out_gd3[1]) == (99, 3)
# @test size(out_gd3[2]) == (3, )
# @test size(out_gd3[3]) == (300, 3)
# @test size(out_gd3[4]) == (99, 3)
# @test size(out_gd3[5]) == ()
# @test size(out_gd3[6]) == ()

# @test size(out_gd4[1]) == (99, 3)
# @test size(out_gd4[2]) == (3, )
# @test size(out_gd4[3]) == (300, 3)
# @test size(out_gd4[4]) == (99, 3)
# @test size(out_gd4[5]) == ()
# @test size(out_gd4[6]) == ()
# #####################################


# #####################################
# println("####### GD (Command line) #######")
# run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(false,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "gd")) --initW $(joinpath(tmp, "Eigen_vectorsX.csv")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(false,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "gd")) --initV $(joinpath(tmp, "Eigen_vectorsY.csv")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))
# #####################################


# #####################################
# println("####### SGD (Julia API) #######")
# out_sgd1 = sgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="robbins-monro",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_sgd2 = sgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="momentum",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_sgd3 = sgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="nag",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_sgd4 = sgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="adagrad",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# @test size(out_sgd1[1]) == (99, 3)
# @test size(out_sgd1[2]) == (3, )
# @test size(out_sgd1[3]) == (300, 3)
# @test size(out_sgd1[4]) == (99, 3)
# @test size(out_sgd1[5]) == ()
# @test size(out_sgd1[6]) == ()

# @test size(out_sgd2[1]) == (99, 3)
# @test size(out_sgd2[2]) == (3, )
# @test size(out_sgd2[3]) == (300, 3)
# @test size(out_sgd2[4]) == (99, 3)
# @test size(out_sgd2[5]) == ()
# @test size(out_sgd2[6]) == ()

# @test size(out_sgd3[1]) == (99, 3)
# @test size(out_sgd3[2]) == (3, )
# @test size(out_sgd3[3]) == (300, 3)
# @test size(out_sgd3[4]) == (99, 3)
# @test size(out_sgd3[5]) == ()
# @test size(out_sgd3[6]) == ()

# @test size(out_sgd4[1]) == (99, 3)
# @test size(out_sgd4[2]) == (3, )
# @test size(out_sgd4[3]) == (300, 3)
# @test size(out_sgd4[4]) == (99, 3)
# @test size(out_sgd4[5]) == ()
# @test size(out_sgd4[6]) == ()
# #####################################


# #####################################
# println("####### SGD (Command line) #######")
# run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))
# #####################################


# #####################################
# println("####### RSGD (Julia API) #######")
# out_rsgd1 = rsgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="robbins-monro",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_rsgd2 = rsgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="momentum",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_rsgd3 = rsgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="nag",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# out_rsgd4 = rsgd(input=joinpath(tmp, "X.zst"),
#   dim=3, scheduling="adagrad",
#   stepsize=1.0e-15, numepoch=1,
#   rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
#   rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
#   rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
#   rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
#   logdir=tmp)

# @test size(out_rsgd1[1]) == (99, 3)
# @test size(out_rsgd1[2]) == (3, )
# @test size(out_rsgd1[3]) == (300, 3)
# @test size(out_rsgd1[4]) == (99, 3)
# @test size(out_rsgd1[5]) == ()
# @test size(out_rsgd1[6]) == ()

# @test size(out_rsgd2[1]) == (99, 3)
# @test size(out_rsgd2[2]) == (3, )
# @test size(out_rsgd2[3]) == (300, 3)
# @test size(out_rsgd2[4]) == (99, 3)
# @test size(out_rsgd2[5]) == ()
# @test size(out_rsgd2[6]) == ()

# @test size(out_rsgd3[1]) == (99, 3)
# @test size(out_rsgd3[2]) == (3, )
# @test size(out_rsgd3[3]) == (300, 3)
# @test size(out_rsgd3[4]) == (99, 3)
# @test size(out_rsgd3[5]) == ()
# @test size(out_rsgd3[6]) == ()

# @test size(out_rsgd4[1]) == (99, 3)
# @test size(out_rsgd4[2]) == (3, )
# @test size(out_rsgd4[3]) == (300, 3)
# @test size(out_rsgd4[4]) == (99, 3)
# @test size(out_rsgd4[5]) == ()
# @test size(out_rsgd4[6]) == ()
# #####################################


# #####################################
# println("####### RSGD (Command line) #######")
# run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))

# run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

# testfilesize(true,
#   joinpath(tmp, "Eigen_vectorsX.csv"),
#   joinpath(tmp, "Eigen_values.csv"),
#   joinpath(tmp, "Eigen_vectorsY.csv"))
# #####################################
