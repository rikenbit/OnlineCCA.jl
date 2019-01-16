using OnlineCCA
using OnlineCCA: readcsv, writecsv
using Test
using Pkg
using DelimitedFiles
using Statistics
using Distributions

tmp = mktempdir()
julia = joinpath(Sys.BINDIR, "julia")
bindir = joinpath(dirname(pathof(OnlinePCA)), "..", "bin")

function testfilesize(remove::Bool, x...)
  for n = 1:length(x)
    @test filesize(x[n]) != 0
    if remove
      rm(x[n])
    end
  end
end

#####################################
X = Int64.(ceil.(rand(NegativeBinomial(1, 0.5), 300, 99)))
X[1:50, 1:33] .= 100*X[1:50, 1:33]
X[51:100, 34:66] .= 100*X[51:100, 34:66]
X[101:150, 67:99] .= 100*X[101:150, 67:99]
writecsv(joinpath(tmp, "X.csv"), X)
#####################################


#####################################
println("####### Binarization (Julia API) #######")
csv2bin(csvfileX=joinpath(tmp, "X.csv"),
  csvfileY=joinpath(tmp, "Y.csv"),
  binfile=joinpath(tmp, "XY.zst"))

testfilesize(true, joinpath(tmp, "XY.zst"))
####################################


#####################################
println("####### Binarization (Command line) #######")
run(`$(julia) $(joinpath(bindir, "csv2bin")) --csvfileX $(joinpath(tmp, "X.csv")) --csvfileY $(joinpath(tmp, "Y.csv")) --binfile $(joinpath(tmp, "XY.zst"))`)

testfilesize(false, joinpath(tmp, "XY.zst"))
#####################################


#####################################
println("####### Summarization (Julia API) #######")
sumr(binfile=joinpath(tmp, "XY.zst"), outdir=tmp)

testfilesize(true,
  joinpath(tmp, "X_Sample_NoCounts.csv"),
  joinpath(tmp, "Y_Sample_NoCounts.csv"),
  joinpath(tmp, "X_Feature_CV2s.csv"),
  joinpath(tmp, "Y_Feature_CV2s.csv"),
  joinpath(tmp, "X_Feature_LogMeans.csv"),
  joinpath(tmp, "Y_Feature_LogMeans.csv"),
  joinpath(tmp, "X_Feature_Means.csv"),
  joinpath(tmp, "Y_Feature_Means.csv"),
  joinpath(tmp, "X_Feature_NoZeros.csv"),
  joinpath(tmp, "Y_Feature_NoZeros.csv"),
  joinpath(tmp, "X_Feature_Vars.csv"),
  joinpath(tmp, "Y_Feature_Vars.csv"))
####################################


#####################################
println("####### Summarization (Command line) #######")
run(`$(julia) $(joinpath(bindir, "sumr")) --binfile $(joinpath(tmp, "XY.zst")) --outdir $(tmp)`)

testfilesize(false,
  joinpath(tmp, "X_Sample_NoCounts.csv"),
  joinpath(tmp, "Y_Sample_NoCounts.csv"),
  joinpath(tmp, "X_Feature_CV2s.csv"),
  joinpath(tmp, "Y_Feature_CV2s.csv"),
  joinpath(tmp, "X_Feature_LogMeans.csv"),
  joinpath(tmp, "Y_Feature_LogMeans.csv"),
  joinpath(tmp, "X_Feature_Means.csv"),
  joinpath(tmp, "Y_Feature_Means.csv"),
  joinpath(tmp, "X_Feature_NoZeros.csv"),
  joinpath(tmp, "Y_Feature_NoZeros.csv"),
  joinpath(tmp, "X_Feature_Vars.csv"),
  joinpath(tmp, "Y_Feature_Vars.csv"))
#####################################


#####################################
println("####### GD (Julia API) #######")
out_gd1 = gd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="robbins-monro",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_gd2 = gd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="momentum",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_gd3 = gd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="nag",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_gd4 = gd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="adagrad",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

@test size(out_gd1[1]) == (99, 3)
@test size(out_gd1[2]) == (3, )
@test size(out_gd1[3]) == (300, 3)
@test size(out_gd1[4]) == (99, 3)
@test size(out_gd1[5]) == ()
@test size(out_gd1[6]) == ()

@test size(out_gd2[1]) == (99, 3)
@test size(out_gd2[2]) == (3, )
@test size(out_gd2[3]) == (300, 3)
@test size(out_gd2[4]) == (99, 3)
@test size(out_gd2[5]) == ()
@test size(out_gd2[6]) == ()

@test size(out_gd3[1]) == (99, 3)
@test size(out_gd3[2]) == (3, )
@test size(out_gd3[3]) == (300, 3)
@test size(out_gd3[4]) == (99, 3)
@test size(out_gd3[5]) == ()
@test size(out_gd3[6]) == ()

@test size(out_gd4[1]) == (99, 3)
@test size(out_gd4[2]) == (3, )
@test size(out_gd4[3]) == (300, 3)
@test size(out_gd4[4]) == (99, 3)
@test size(out_gd4[5]) == ()
@test size(out_gd4[6]) == ()
#####################################


#####################################
println("####### GD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "XY.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(false,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --initW $(joinpath(tmp, "Eigen_vectorsX.csv")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(false,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --initV $(joinpath(tmp, "Eigen_vectorsY.csv")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))
#####################################


#####################################
println("####### SGD (Julia API) #######")
out_sgd1 = sgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="robbins-monro",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_sgd2 = sgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="momentum",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_sgd3 = sgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="nag",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_sgd4 = sgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="adagrad",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

@test size(out_sgd1[1]) == (99, 3)
@test size(out_sgd1[2]) == (3, )
@test size(out_sgd1[3]) == (300, 3)
@test size(out_sgd1[4]) == (99, 3)
@test size(out_sgd1[5]) == ()
@test size(out_sgd1[6]) == ()

@test size(out_sgd2[1]) == (99, 3)
@test size(out_sgd2[2]) == (3, )
@test size(out_sgd2[3]) == (300, 3)
@test size(out_sgd2[4]) == (99, 3)
@test size(out_sgd2[5]) == ()
@test size(out_sgd2[6]) == ()

@test size(out_sgd3[1]) == (99, 3)
@test size(out_sgd3[2]) == (3, )
@test size(out_sgd3[3]) == (300, 3)
@test size(out_sgd3[4]) == (99, 3)
@test size(out_sgd3[5]) == ()
@test size(out_sgd3[6]) == ()

@test size(out_sgd4[1]) == (99, 3)
@test size(out_sgd4[2]) == (3, )
@test size(out_sgd4[3]) == (300, 3)
@test size(out_sgd4[4]) == (99, 3)
@test size(out_sgd4[5]) == ()
@test size(out_sgd4[6]) == ()
#####################################


#####################################
println("####### SGD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "XY.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))
#####################################


#####################################
println("####### RSGD (Julia API) #######")
out_rsgd1 = rsgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="robbins-monro",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_rsgd2 = rsgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="momentum",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_rsgd3 = rsgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="nag",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

out_rsgd4 = rsgd(input=joinpath(tmp, "XY.zst"),
  dim=3, scheduling="adagrad",
  stepsize=1.0e-15, numepoch=1,
  rowmeanlistX=joinpath(tmp, "X_Feature_FTTMeans.csv"),
  rowmeanlistY=joinpath(tmp, "Y_Feature_FTTMeans.csv"),
  rowsdlistX=joinpath(tmp, "X_Feature_FTTSDs.csv"),
  rowsdlistY=joinpath(tmp, "Y_Feature_FTTSDs.csv"),
  logdir=tmp)

@test size(out_rsgd1[1]) == (99, 3)
@test size(out_rsgd1[2]) == (3, )
@test size(out_rsgd1[3]) == (300, 3)
@test size(out_rsgd1[4]) == (99, 3)
@test size(out_rsgd1[5]) == ()
@test size(out_rsgd1[6]) == ()

@test size(out_rsgd2[1]) == (99, 3)
@test size(out_rsgd2[2]) == (3, )
@test size(out_rsgd2[3]) == (300, 3)
@test size(out_rsgd2[4]) == (99, 3)
@test size(out_rsgd2[5]) == ()
@test size(out_rsgd2[6]) == ()

@test size(out_rsgd3[1]) == (99, 3)
@test size(out_rsgd3[2]) == (3, )
@test size(out_rsgd3[3]) == (300, 3)
@test size(out_rsgd3[4]) == (99, 3)
@test size(out_rsgd3[5]) == ()
@test size(out_rsgd3[6]) == ()

@test size(out_rsgd4[1]) == (99, 3)
@test size(out_rsgd4[2]) == (3, )
@test size(out_rsgd4[3]) == (300, 3)
@test size(out_rsgd4[4]) == (99, 3)
@test size(out_rsgd4[5]) == ()
@test size(out_rsgd4[6]) == ()
#####################################


#####################################
println("####### RSGD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "XY.zst")) --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "XY.zst"))  --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 1 --rowmeanlistX $(joinpath(tmp, "X_Feature_FTTMeans.csv")) --rowmeanlistY $(joinpath(tmp, "Y_Feature_FTTMeans.csv")) --rowsdlistX $(joinpath(tmp, "X_Feature_FTTSDs.csv")) --rowsdlistY $(joinpath(tmp, "Y_Feature_FTTSDs.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectorsX.csv"),
  joinpath(tmp, "Eigen_values.csv"),
  joinpath(tmp, "Eigen_vectorsY.csv"))
#####################################
