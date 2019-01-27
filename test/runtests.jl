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

####################################
println("####### Binarization (Command line) #######")
run(`$(julia) $(joinpath(bindir, "csv2bin")) --csvfile $(joinpath(tmp, "X.csv")) --binfile $(joinpath(tmp, "X.zst"))`)
run(`$(julia) $(joinpath(bindir, "csv2bin")) --csvfile $(joinpath(tmp, "Y.csv")) --binfile $(joinpath(tmp, "Y.zst"))`)
run(`$(julia) $(joinpath(bindir, "csv2bin")) --csvfile $(joinpath(tmp, "Z.csv")) --binfile $(joinpath(tmp, "Z.zst"))`)

testfilesize(false, joinpath(tmp, "X.zst"))
testfilesize(false, joinpath(tmp, "Y.zst"))
testfilesize(false, joinpath(tmp, "Z.zst"))
####################################

####################################
println("####### Summarization (Julia API) #######")
mkdir(joinpath(tmp, "SumrX"))
mkdir(joinpath(tmp, "SumrY"))
mkdir(joinpath(tmp, "SumrZ"))
sumr(binfile=joinpath(tmp, "X.zst"),
  outdir=joinpath(tmp, "SumrX"))
sumr(binfile=joinpath(tmp, "Y.zst"),
  outdir=joinpath(tmp, "SumrY"))
sumr(binfile=joinpath(tmp, "Z.zst"),
  outdir=joinpath(tmp, "SumrZ"))

testfilesize(false,
  joinpath(tmp, "SumrX/Col_Means.csv"),
  joinpath(tmp, "SumrX/Col_LogMeans.csv"),
  joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrX/Col_Vars.csv"),
  joinpath(tmp, "SumrX/Col_LogVars.csv"),
  joinpath(tmp, "SumrX/Col_FTTVars.csv"),
  joinpath(tmp, "SumrX/Col_SDs.csv"),
  joinpath(tmp, "SumrX/Col_LogSDs.csv"),
  joinpath(tmp, "SumrX/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrX/Col_CV2s.csv"),
  joinpath(tmp, "SumrX/Col_NoZeros.csv"),
  joinpath(tmp, "SumrX/Col_NoCounts.csv"),
  joinpath(tmp, "SumrX/Row_Means.csv"),
  joinpath(tmp, "SumrX/Row_LogMeans.csv"),
  joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrX/Row_Vars.csv"),
  joinpath(tmp, "SumrX/Row_LogVars.csv"),
  joinpath(tmp, "SumrX/Row_FTTVars.csv"),
  joinpath(tmp, "SumrX/Row_SDs.csv"),
  joinpath(tmp, "SumrX/Row_LogSDs.csv"),
  joinpath(tmp, "SumrX/Col_FTTVars.csv"),
  joinpath(tmp, "SumrX/Row_CV2s.csv"),
  joinpath(tmp, "SumrX/Row_NoZeros.csv"),
  joinpath(tmp, "SumrX/Row_NoCounts.csv"))

testfilesize(false,
  joinpath(tmp, "SumrY/Col_Means.csv"),
  joinpath(tmp, "SumrY/Col_LogMeans.csv"),
  joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrY/Col_Vars.csv"),
  joinpath(tmp, "SumrY/Col_LogVars.csv"),
  joinpath(tmp, "SumrY/Col_FTTVars.csv"),
  joinpath(tmp, "SumrY/Col_SDs.csv"),
  joinpath(tmp, "SumrY/Col_LogSDs.csv"),
  joinpath(tmp, "SumrY/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrY/Col_CV2s.csv"),
  joinpath(tmp, "SumrY/Col_NoZeros.csv"),
  joinpath(tmp, "SumrY/Col_NoCounts.csv"),
  joinpath(tmp, "SumrY/Row_Means.csv"),
  joinpath(tmp, "SumrY/Row_LogMeans.csv"),
  joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrY/Row_Vars.csv"),
  joinpath(tmp, "SumrY/Row_LogVars.csv"),
  joinpath(tmp, "SumrY/Row_FTTVars.csv"),
  joinpath(tmp, "SumrY/Row_SDs.csv"),
  joinpath(tmp, "SumrY/Row_LogSDs.csv"),
  joinpath(tmp, "SumrY/Col_FTTVars.csv"),
  joinpath(tmp, "SumrY/Row_CV2s.csv"),
  joinpath(tmp, "SumrY/Row_NoZeros.csv"),
  joinpath(tmp, "SumrY/Row_NoCounts.csv"))

testfilesize(false,
  joinpath(tmp, "SumrZ/Col_Means.csv"),
  joinpath(tmp, "SumrZ/Col_LogMeans.csv"),
  joinpath(tmp, "SumrZ/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrZ/Col_Vars.csv"),
  joinpath(tmp, "SumrZ/Col_LogVars.csv"),
  joinpath(tmp, "SumrZ/Col_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Col_SDs.csv"),
  joinpath(tmp, "SumrZ/Col_LogSDs.csv"),
  joinpath(tmp, "SumrZ/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrZ/Col_CV2s.csv"),
  joinpath(tmp, "SumrZ/Col_NoZeros.csv"),
  joinpath(tmp, "SumrZ/Col_NoCounts.csv"),
  joinpath(tmp, "SumrZ/Row_Means.csv"),
  joinpath(tmp, "SumrZ/Row_LogMeans.csv"),
  joinpath(tmp, "SumrZ/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrZ/Row_Vars.csv"),
  joinpath(tmp, "SumrZ/Row_LogVars.csv"),
  joinpath(tmp, "SumrZ/Row_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Row_SDs.csv"),
  joinpath(tmp, "SumrZ/Row_LogSDs.csv"),
  joinpath(tmp, "SumrZ/Col_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Row_CV2s.csv"),
  joinpath(tmp, "SumrZ/Row_NoZeros.csv"),
  joinpath(tmp, "SumrZ/Row_NoCounts.csv"))
####################################

####################################
println("####### Summarization (Command line) #######")
run(`$(julia) $(joinpath(bindir, "sumr")) --binfile $(joinpath(tmp, "X.zst")) --outdir $(joinpath(tmp, "SumrX"))`)
run(`$(julia) $(joinpath(bindir, "sumr")) --binfile $(joinpath(tmp, "Y.zst")) --outdir $(joinpath(tmp, "SumrY"))`)
run(`$(julia) $(joinpath(bindir, "sumr")) --binfile $(joinpath(tmp, "Z.zst")) --outdir $(joinpath(tmp, "SumrZ"))`)

testfilesize(false,
  joinpath(tmp, "SumrX/Col_Means.csv"),
  joinpath(tmp, "SumrX/Col_LogMeans.csv"),
  joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrX/Col_Vars.csv"),
  joinpath(tmp, "SumrX/Col_LogVars.csv"),
  joinpath(tmp, "SumrX/Col_FTTVars.csv"),
  joinpath(tmp, "SumrX/Col_SDs.csv"),
  joinpath(tmp, "SumrX/Col_LogSDs.csv"),
  joinpath(tmp, "SumrX/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrX/Col_CV2s.csv"),
  joinpath(tmp, "SumrX/Col_NoZeros.csv"),
  joinpath(tmp, "SumrX/Col_NoCounts.csv"),
  joinpath(tmp, "SumrX/Row_Means.csv"),
  joinpath(tmp, "SumrX/Row_LogMeans.csv"),
  joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrX/Row_Vars.csv"),
  joinpath(tmp, "SumrX/Row_LogVars.csv"),
  joinpath(tmp, "SumrX/Row_FTTVars.csv"),
  joinpath(tmp, "SumrX/Row_SDs.csv"),
  joinpath(tmp, "SumrX/Row_LogSDs.csv"),
  joinpath(tmp, "SumrX/Col_FTTVars.csv"),
  joinpath(tmp, "SumrX/Row_CV2s.csv"),
  joinpath(tmp, "SumrX/Row_NoZeros.csv"),
  joinpath(tmp, "SumrX/Row_NoCounts.csv"))

testfilesize(false,
  joinpath(tmp, "SumrY/Col_Means.csv"),
  joinpath(tmp, "SumrY/Col_LogMeans.csv"),
  joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrY/Col_Vars.csv"),
  joinpath(tmp, "SumrY/Col_LogVars.csv"),
  joinpath(tmp, "SumrY/Col_FTTVars.csv"),
  joinpath(tmp, "SumrY/Col_SDs.csv"),
  joinpath(tmp, "SumrY/Col_LogSDs.csv"),
  joinpath(tmp, "SumrY/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrY/Col_CV2s.csv"),
  joinpath(tmp, "SumrY/Col_NoZeros.csv"),
  joinpath(tmp, "SumrY/Col_NoCounts.csv"),
  joinpath(tmp, "SumrY/Row_Means.csv"),
  joinpath(tmp, "SumrY/Row_LogMeans.csv"),
  joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrY/Row_Vars.csv"),
  joinpath(tmp, "SumrY/Row_LogVars.csv"),
  joinpath(tmp, "SumrY/Row_FTTVars.csv"),
  joinpath(tmp, "SumrY/Row_SDs.csv"),
  joinpath(tmp, "SumrY/Row_LogSDs.csv"),
  joinpath(tmp, "SumrY/Col_FTTVars.csv"),
  joinpath(tmp, "SumrY/Row_CV2s.csv"),
  joinpath(tmp, "SumrY/Row_NoZeros.csv"),
  joinpath(tmp, "SumrY/Row_NoCounts.csv"))

testfilesize(false,
  joinpath(tmp, "SumrZ/Col_Means.csv"),
  joinpath(tmp, "SumrZ/Col_LogMeans.csv"),
  joinpath(tmp, "SumrZ/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrZ/Col_Vars.csv"),
  joinpath(tmp, "SumrZ/Col_LogVars.csv"),
  joinpath(tmp, "SumrZ/Col_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Col_SDs.csv"),
  joinpath(tmp, "SumrZ/Col_LogSDs.csv"),
  joinpath(tmp, "SumrZ/Col_FTTSDs.csv"),
  joinpath(tmp, "SumrZ/Col_CV2s.csv"),
  joinpath(tmp, "SumrZ/Col_NoZeros.csv"),
  joinpath(tmp, "SumrZ/Col_NoCounts.csv"),
  joinpath(tmp, "SumrZ/Row_Means.csv"),
  joinpath(tmp, "SumrZ/Row_LogMeans.csv"),
  joinpath(tmp, "SumrZ/Col_FTTMeans.csv"),
  joinpath(tmp, "SumrZ/Row_Vars.csv"),
  joinpath(tmp, "SumrZ/Row_LogVars.csv"),
  joinpath(tmp, "SumrZ/Row_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Row_SDs.csv"),
  joinpath(tmp, "SumrZ/Row_LogSDs.csv"),
  joinpath(tmp, "SumrZ/Col_FTTVars.csv"),
  joinpath(tmp, "SumrZ/Row_CV2s.csv"),
  joinpath(tmp, "SumrZ/Row_NoZeros.csv"),
  joinpath(tmp, "SumrZ/Row_NoCounts.csv"))
####################################

####################################
println("####### GD (Julia API) #######")
out_gd1 = gd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="robbins-monro",
  stepsize=1.0e-15,
  numepoch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_gd2 = gd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="momentum",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_gd3 = gd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="nag",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_gd4 = gd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="adagrad",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_gd1[1][1]) == (30, 3)
@test size(out_gd1[1][2]) == (40, 3)
@test size(out_gd1[1][3]) == (50, 3)
@test size(out_gd1[2][1]) == (3, )
@test size(out_gd1[2][2]) == (3, )
@test size(out_gd1[2][3]) == (3, )
@test size(out_gd1[3][1]) == (300, 3)
@test size(out_gd1[3][2]) == (300, 3)
@test size(out_gd1[3][3]) == (300, 3)
@test size(out_gd1[4][1]) == ()
@test size(out_gd1[4][2]) == ()
@test size(out_gd1[4][3]) == ()
@test size(out_gd1[5][1]) == ()
@test size(out_gd1[5][2]) == ()
@test size(out_gd1[5][3]) == ()
@test size(out_gd1[6][1]) == ()
@test size(out_gd1[6][2]) == ()
@test size(out_gd1[6][3]) == ()
@test size(out_gd1[7][1]) == ()
@test size(out_gd1[7][2]) == ()
@test size(out_gd1[7][3]) == ()
@test size(out_gd1[8]) == ()

@test size(out_gd2[1][1]) == (30, 3)
@test size(out_gd2[1][2]) == (40, 3)
@test size(out_gd2[1][3]) == (50, 3)
@test size(out_gd2[2][1]) == (3, )
@test size(out_gd2[2][2]) == (3, )
@test size(out_gd2[2][3]) == (3, )
@test size(out_gd2[3][1]) == (300, 3)
@test size(out_gd2[3][2]) == (300, 3)
@test size(out_gd2[3][3]) == (300, 3)
@test size(out_gd2[4][1]) == ()
@test size(out_gd2[4][2]) == ()
@test size(out_gd2[4][3]) == ()
@test size(out_gd2[5][1]) == ()
@test size(out_gd2[5][2]) == ()
@test size(out_gd2[5][3]) == ()
@test size(out_gd2[6][1]) == ()
@test size(out_gd2[6][2]) == ()
@test size(out_gd2[6][3]) == ()
@test size(out_gd2[7][1]) == ()
@test size(out_gd2[7][2]) == ()
@test size(out_gd2[7][3]) == ()
@test size(out_gd2[8]) == ()

@test size(out_gd3[1][1]) == (30, 3)
@test size(out_gd3[1][2]) == (40, 3)
@test size(out_gd3[1][3]) == (50, 3)
@test size(out_gd3[2][1]) == (3, )
@test size(out_gd3[2][2]) == (3, )
@test size(out_gd3[2][3]) == (3, )
@test size(out_gd3[3][1]) == (300, 3)
@test size(out_gd3[3][2]) == (300, 3)
@test size(out_gd3[3][3]) == (300, 3)
@test size(out_gd3[4][1]) == ()
@test size(out_gd3[4][2]) == ()
@test size(out_gd3[4][3]) == ()
@test size(out_gd3[5][1]) == ()
@test size(out_gd3[5][2]) == ()
@test size(out_gd3[5][3]) == ()
@test size(out_gd3[6][1]) == ()
@test size(out_gd3[6][2]) == ()
@test size(out_gd3[6][3]) == ()
@test size(out_gd3[7][1]) == ()
@test size(out_gd3[7][2]) == ()
@test size(out_gd3[7][3]) == ()
@test size(out_gd3[8]) == ()

@test size(out_gd4[1][1]) == (30, 3)
@test size(out_gd4[1][2]) == (40, 3)
@test size(out_gd4[1][3]) == (50, 3)
@test size(out_gd4[2][1]) == (3, )
@test size(out_gd4[2][2]) == (3, )
@test size(out_gd4[2][3]) == (3, )
@test size(out_gd4[3][1]) == (300, 3)
@test size(out_gd4[3][2]) == (300, 3)
@test size(out_gd4[3][3]) == (300, 3)
@test size(out_gd4[4][1]) == ()
@test size(out_gd4[4][2]) == ()
@test size(out_gd4[4][3]) == ()
@test size(out_gd4[5][1]) == ()
@test size(out_gd4[5][2]) == ()
@test size(out_gd4[5][3]) == ()
@test size(out_gd4[6][1]) == ()
@test size(out_gd4[6][2]) == ()
@test size(out_gd4[6][3]) == ()
@test size(out_gd4[7][1]) == ()
@test size(out_gd4[7][2]) == ()
@test size(out_gd4[7][3]) == ()
@test size(out_gd4[8]) == ()
####################################

####################################
println("####### GD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "gd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### SGD (Julia API) #######")
out_sgd1 = sgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="robbins-monro",
  stepsize=1.0e-15,
  numepoch=10,
  numbatch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_sgd2 = sgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="momentum",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_sgd3 = sgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="nag",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_sgd4 = sgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="adagrad",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_sgd1[1][1]) == (30, 3)
@test size(out_sgd1[1][2]) == (40, 3)
@test size(out_sgd1[1][3]) == (50, 3)
@test size(out_sgd1[2][1]) == (3, )
@test size(out_sgd1[2][2]) == (3, )
@test size(out_sgd1[2][3]) == (3, )
@test size(out_sgd1[3][1]) == (300, 3)
@test size(out_sgd1[3][2]) == (300, 3)
@test size(out_sgd1[3][3]) == (300, 3)
@test size(out_sgd1[4][1]) == ()
@test size(out_sgd1[4][2]) == ()
@test size(out_sgd1[4][3]) == ()
@test size(out_sgd1[5][1]) == ()
@test size(out_sgd1[5][2]) == ()
@test size(out_sgd1[5][3]) == ()
@test size(out_sgd1[6][1]) == ()
@test size(out_sgd1[6][2]) == ()
@test size(out_sgd1[6][3]) == ()
@test size(out_sgd1[7][1]) == ()
@test size(out_sgd1[7][2]) == ()
@test size(out_sgd1[7][3]) == ()
@test size(out_sgd1[8]) == ()

@test size(out_sgd2[1][1]) == (30, 3)
@test size(out_sgd2[1][2]) == (40, 3)
@test size(out_sgd2[1][3]) == (50, 3)
@test size(out_sgd2[2][1]) == (3, )
@test size(out_sgd2[2][2]) == (3, )
@test size(out_sgd2[2][3]) == (3, )
@test size(out_sgd2[3][1]) == (300, 3)
@test size(out_sgd2[3][2]) == (300, 3)
@test size(out_sgd2[3][3]) == (300, 3)
@test size(out_sgd2[4][1]) == ()
@test size(out_sgd2[4][2]) == ()
@test size(out_sgd2[4][3]) == ()
@test size(out_sgd2[5][1]) == ()
@test size(out_sgd2[5][2]) == ()
@test size(out_sgd2[5][3]) == ()
@test size(out_sgd2[6][1]) == ()
@test size(out_sgd2[6][2]) == ()
@test size(out_sgd2[6][3]) == ()
@test size(out_sgd2[7][1]) == ()
@test size(out_sgd2[7][2]) == ()
@test size(out_sgd2[7][3]) == ()
@test size(out_sgd2[8]) == ()

@test size(out_sgd3[1][1]) == (30, 3)
@test size(out_sgd3[1][2]) == (40, 3)
@test size(out_sgd3[1][3]) == (50, 3)
@test size(out_sgd3[2][1]) == (3, )
@test size(out_sgd3[2][2]) == (3, )
@test size(out_sgd3[2][3]) == (3, )
@test size(out_sgd3[3][1]) == (300, 3)
@test size(out_sgd3[3][2]) == (300, 3)
@test size(out_sgd3[3][3]) == (300, 3)
@test size(out_sgd3[4][1]) == ()
@test size(out_sgd3[4][2]) == ()
@test size(out_sgd3[4][3]) == ()
@test size(out_sgd3[5][1]) == ()
@test size(out_sgd3[5][2]) == ()
@test size(out_sgd3[5][3]) == ()
@test size(out_sgd3[6][1]) == ()
@test size(out_sgd3[6][2]) == ()
@test size(out_sgd3[6][3]) == ()
@test size(out_sgd3[7][1]) == ()
@test size(out_sgd3[7][2]) == ()
@test size(out_sgd3[7][3]) == ()
@test size(out_sgd3[8]) == ()

@test size(out_sgd4[1][1]) == (30, 3)
@test size(out_sgd4[1][2]) == (40, 3)
@test size(out_sgd4[1][3]) == (50, 3)
@test size(out_sgd4[2][1]) == (3, )
@test size(out_sgd4[2][2]) == (3, )
@test size(out_sgd4[2][3]) == (3, )
@test size(out_sgd4[3][1]) == (300, 3)
@test size(out_sgd4[3][2]) == (300, 3)
@test size(out_sgd4[3][3]) == (300, 3)
@test size(out_sgd4[4][1]) == ()
@test size(out_sgd4[4][2]) == ()
@test size(out_sgd4[4][3]) == ()
@test size(out_sgd4[5][1]) == ()
@test size(out_sgd4[5][2]) == ()
@test size(out_sgd4[5][3]) == ()
@test size(out_sgd4[6][1]) == ()
@test size(out_sgd4[6][2]) == ()
@test size(out_sgd4[6][3]) == ()
@test size(out_sgd4[7][1]) == ()
@test size(out_sgd4[7][2]) == ()
@test size(out_sgd4[7][3]) == ()
@test size(out_sgd4[8]) == ()
####################################

####################################
println("####### SGD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "sgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### RSGD (Julia API) #######")
out_rsgd1 = rsgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="robbins-monro",
  stepsize=1.0e-15,
  numepoch=10,
  numbatch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_rsgd2 = rsgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="momentum",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_rsgd3 = rsgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="nag",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

out_rsgd4 = rsgd(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  scheduling="adagrad",
  stepsize=1.0e-15,
  numepoch=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_rsgd1[1][1]) == (30, 3)
@test size(out_rsgd1[1][2]) == (40, 3)
@test size(out_rsgd1[1][3]) == (50, 3)
@test size(out_rsgd1[2][1]) == (3, )
@test size(out_rsgd1[2][2]) == (3, )
@test size(out_rsgd1[2][3]) == (3, )
@test size(out_rsgd1[3][1]) == (300, 3)
@test size(out_rsgd1[3][2]) == (300, 3)
@test size(out_rsgd1[3][3]) == (300, 3)
@test size(out_rsgd1[4][1]) == ()
@test size(out_rsgd1[4][2]) == ()
@test size(out_rsgd1[4][3]) == ()
@test size(out_rsgd1[5][1]) == ()
@test size(out_rsgd1[5][2]) == ()
@test size(out_rsgd1[5][3]) == ()
@test size(out_rsgd1[6][1]) == ()
@test size(out_rsgd1[6][2]) == ()
@test size(out_rsgd1[6][3]) == ()
@test size(out_rsgd1[7][1]) == ()
@test size(out_rsgd1[7][2]) == ()
@test size(out_rsgd1[7][3]) == ()
@test size(out_rsgd1[8]) == ()

@test size(out_rsgd2[1][1]) == (30, 3)
@test size(out_rsgd2[1][2]) == (40, 3)
@test size(out_rsgd2[1][3]) == (50, 3)
@test size(out_rsgd2[2][1]) == (3, )
@test size(out_rsgd2[2][2]) == (3, )
@test size(out_rsgd2[2][3]) == (3, )
@test size(out_rsgd2[3][1]) == (300, 3)
@test size(out_rsgd2[3][2]) == (300, 3)
@test size(out_rsgd2[3][3]) == (300, 3)
@test size(out_rsgd2[4][1]) == ()
@test size(out_rsgd2[4][2]) == ()
@test size(out_rsgd2[4][3]) == ()
@test size(out_rsgd2[5][1]) == ()
@test size(out_rsgd2[5][2]) == ()
@test size(out_rsgd2[5][3]) == ()
@test size(out_rsgd2[6][1]) == ()
@test size(out_rsgd2[6][2]) == ()
@test size(out_rsgd2[6][3]) == ()
@test size(out_rsgd2[7][1]) == ()
@test size(out_rsgd2[7][2]) == ()
@test size(out_rsgd2[7][3]) == ()
@test size(out_rsgd2[8]) == ()

@test size(out_rsgd3[1][1]) == (30, 3)
@test size(out_rsgd3[1][2]) == (40, 3)
@test size(out_rsgd3[1][3]) == (50, 3)
@test size(out_rsgd3[2][1]) == (3, )
@test size(out_rsgd3[2][2]) == (3, )
@test size(out_rsgd3[2][3]) == (3, )
@test size(out_rsgd3[3][1]) == (300, 3)
@test size(out_rsgd3[3][2]) == (300, 3)
@test size(out_rsgd3[3][3]) == (300, 3)
@test size(out_rsgd3[4][1]) == ()
@test size(out_rsgd3[4][2]) == ()
@test size(out_rsgd3[4][3]) == ()
@test size(out_rsgd3[5][1]) == ()
@test size(out_rsgd3[5][2]) == ()
@test size(out_rsgd3[5][3]) == ()
@test size(out_rsgd3[6][1]) == ()
@test size(out_rsgd3[6][2]) == ()
@test size(out_rsgd3[6][3]) == ()
@test size(out_rsgd3[7][1]) == ()
@test size(out_rsgd3[7][2]) == ()
@test size(out_rsgd3[7][3]) == ()
@test size(out_rsgd3[8]) == ()

@test size(out_rsgd4[1][1]) == (30, 3)
@test size(out_rsgd4[1][2]) == (40, 3)
@test size(out_rsgd4[1][3]) == (50, 3)
@test size(out_rsgd4[2][1]) == (3, )
@test size(out_rsgd4[2][2]) == (3, )
@test size(out_rsgd4[2][3]) == (3, )
@test size(out_rsgd4[3][1]) == (300, 3)
@test size(out_rsgd4[3][2]) == (300, 3)
@test size(out_rsgd4[3][3]) == (300, 3)
@test size(out_rsgd4[4][1]) == ()
@test size(out_rsgd4[4][2]) == ()
@test size(out_rsgd4[4][3]) == ()
@test size(out_rsgd4[5][1]) == ()
@test size(out_rsgd4[5][2]) == ()
@test size(out_rsgd4[5][3]) == ()
@test size(out_rsgd4[6][1]) == ()
@test size(out_rsgd4[6][2]) == ()
@test size(out_rsgd4[6][3]) == ()
@test size(out_rsgd4[7][1]) == ()
@test size(out_rsgd4[7][2]) == ()
@test size(out_rsgd4[7][3]) == ()
@test size(out_rsgd4[8]) == ()
####################################

####################################
println("####### RSGD (Command line) #######")
run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling robbins-monro --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling momentum --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling nag --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))

run(`$(julia) $(joinpath(bindir, "rsgd")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --scheduling adagrad --stepsize 1.0e-15 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### Orthogonal Iteration (Julia API) #######")
out_orthiter = orthiter(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  numepoch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_orthiter[1][1]) == (30, 3)
@test size(out_orthiter[1][2]) == (40, 3)
@test size(out_orthiter[1][3]) == (50, 3)
@test size(out_orthiter[2][1]) == (3, )
@test size(out_orthiter[2][2]) == (3, )
@test size(out_orthiter[2][3]) == (3, )
@test size(out_orthiter[3][1]) == (300, 3)
@test size(out_orthiter[3][2]) == (300, 3)
@test size(out_orthiter[3][3]) == (300, 3)
@test size(out_orthiter[4][1]) == ()
@test size(out_orthiter[4][2]) == ()
@test size(out_orthiter[4][3]) == ()
@test size(out_orthiter[5][1]) == ()
@test size(out_orthiter[5][2]) == ()
@test size(out_orthiter[5][3]) == ()
@test size(out_orthiter[6][1]) == ()
@test size(out_orthiter[6][2]) == ()
@test size(out_orthiter[6][3]) == ()
@test size(out_orthiter[7][1]) == ()
@test size(out_orthiter[7][2]) == ()
@test size(out_orthiter[7][3]) == ()
@test size(out_orthiter[8]) == ()
####################################

####################################
println("####### Orthogonal Iteration (Command line) #######")
run(`$(julia) $(joinpath(bindir, "orthiter")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### Horst-Jacobi algorithm (Julia API) #######")
out_horst = horst(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  numepoch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_horst[1][1]) == (30, 3)
@test size(out_horst[1][2]) == (40, 3)
@test size(out_horst[1][3]) == (50, 3)
@test size(out_horst[2][1]) == (3, )
@test size(out_horst[2][2]) == (3, )
@test size(out_horst[2][3]) == (3, )
@test size(out_horst[3][1]) == (300, 3)
@test size(out_horst[3][2]) == (300, 3)
@test size(out_horst[3][3]) == (300, 3)
@test size(out_horst[4][1]) == ()
@test size(out_horst[4][2]) == ()
@test size(out_horst[4][3]) == ()
@test size(out_horst[5][1]) == ()
@test size(out_horst[5][2]) == ()
@test size(out_horst[5][3]) == ()
@test size(out_horst[6][1]) == ()
@test size(out_horst[6][2]) == ()
@test size(out_horst[6][3]) == ()
@test size(out_horst[7][1]) == ()
@test size(out_horst[7][2]) == ()
@test size(out_horst[7][3]) == ()
@test size(out_horst[8]) == ()
####################################

####################################
println("####### Horst-Jacobi algorithm (Command line) #######")
run(`$(julia) $(joinpath(bindir, "horst")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv")) --logdir $(tmp)`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### Out-of-core Multi-set CCA (Julia API) #######")
out_oocmcca = oocmcca(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst"),
    joinpath(tmp, "Z.zst")],
  scale=["ftt", "ftt", "ftt"],
  pseudocount=[1.0, 1.0, 1.0],
  dim=3,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrZ/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv"),
    joinpath(tmp, "SumrZ/Col_FTTVars.csv")])

@test size(out_oocmcca[1][1]) == (30, 3)
@test size(out_oocmcca[1][2]) == (40, 3)
@test size(out_oocmcca[1][3]) == (50, 3)
@test size(out_oocmcca[2][1]) == (3, )
@test size(out_oocmcca[2][2]) == (3, )
@test size(out_oocmcca[2][3]) == (3, )
@test size(out_oocmcca[3][1]) == (300, 3)
@test size(out_oocmcca[3][2]) == (300, 3)
@test size(out_oocmcca[3][3]) == (300, 3)
@test size(out_oocmcca[4][1]) == ()
@test size(out_oocmcca[4][2]) == ()
@test size(out_oocmcca[4][3]) == ()
@test size(out_oocmcca[5][1]) == ()
@test size(out_oocmcca[5][2]) == ()
@test size(out_oocmcca[5][3]) == ()
@test size(out_oocmcca[6][1]) == ()
@test size(out_oocmcca[6][2]) == ()
@test size(out_oocmcca[6][3]) == ()
@test size(out_oocmcca[7][1]) == ()
@test size(out_oocmcca[7][2]) == ()
@test size(out_oocmcca[7][3]) == ()
####################################

####################################
println("####### Out-of-core Multi-set CCA (Command line) #######")
run(`$(julia) $(joinpath(bindir, "oocmcca")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst"))","$(joinpath(tmp, "Z.zst")) --scale ftt,ftt,ftt --pseudocount 1.0,1.0,1.0 --outdir $(tmp) --dim 3 --numepoch 3 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTMeans.csv")) --colvarlist $(joinpath(tmp, "SumrX/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrY/Col_FTTVars.csv"))","$(joinpath(tmp, "SumrZ/Col_FTTVars.csv"))`)

testfilesize(true,
  joinpath(tmp, "Eigen_vectors1.csv"),
  joinpath(tmp, "Eigen_vectors2.csv"),
  joinpath(tmp, "Eigen_vectors3.csv"),
  joinpath(tmp, "Eigen_values1.csv"),
  joinpath(tmp, "Eigen_values2.csv"),
  joinpath(tmp, "Eigen_values3.csv"),
  joinpath(tmp, "ExpCorVar1.csv"),
  joinpath(tmp, "ExpCorVar2.csv"),
  joinpath(tmp, "ExpCorVar3.csv"),
  joinpath(tmp, "LatentVariables1.csv"),
  joinpath(tmp, "LatentVariables2.csv"),
  joinpath(tmp, "LatentVariables3.csv"))
####################################

####################################
println("####### NIPALS (Julia API) #######")
out_nipals = nipals(
  input=[joinpath(tmp, "X.zst"),
    joinpath(tmp, "Y.zst")],
  scale=["ftt", "ftt"],
  pseudocount=[1.0, 1.0],
  dim=3,
  numepoch=10,
  colmeanlist=[joinpath(tmp, "SumrX/Col_FTTMeans.csv"),
    joinpath(tmp, "SumrY/Col_FTTMeans.csv")],
  colvarlist=[joinpath(tmp, "SumrX/Col_FTTVars.csv"),
    joinpath(tmp, "SumrY/Col_FTTVars.csv")],
  logdir=tmp)

@test size(out_nipals[1]) == (300, 3)
@test size(out_nipals[2]) == (30, 3)
@test size(out_nipals[3]) == (300, 3)
@test size(out_nipals[4]) == (40, 3)
@test size(out_nipals[5]) == (3, 3)
####################################

####################################
println("####### NIPALS (Command line) #######")
run(`$(julia) $(joinpath(bindir, "nipals")) --input $(joinpath(tmp, "X.zst"))","$(joinpath(tmp, "Y.zst")) --scale ftt,ftt --pseudocount 1.0,1.0 --outdir $(tmp) --dim 3 --numepoch 10 --colmeanlist $(joinpath(tmp, "SumrX/Col_FTTMeans.csv"))","$(joinpath(tmp, "SumrY/Col_FTTMeans.csv"))`)

testfilesize(true,
  joinpath(tmp, "T.csv"),
  joinpath(tmp, "P.csv"),
  joinpath(tmp, "U.csv"),
  joinpath(tmp, "Q.csv"),
  joinpath(tmp, "B.csv"))
####################################