module OnlineCCA

using DelimitedFiles:
    writedlm, readdlm
using Statistics:
    mean, var, cor
using LinearAlgebra:
    Diagonal, lu!, qr!, svd, dot, norm, eigvecs, diag
using Random:
    randperm
using ProgressMeter:
  Progress, next!
using ArgParse:
    ArgParseSettings, parse_args, @add_arg_table
using StatsBase:
  percentile
using DataFrames:
  DataFrame
using GLM:
  glm, coef, IdentityLink, @formula
using Distributions:
  Gamma, ccdf, Chisq
using CodecZstd:
  ZstdCompressorStream, ZstdDecompressorStream

export output, common_parse_commandline, csv2bin, sumr, filtering, sgd, gd, rsgd, horst, orthiter, oocmcca

include("Utils.jl")
include("csv2bin.jl")
include("sumr.jl")
include("sgd.jl")
include("gd.jl")
include("rsgd.jl")
include("orthiter.jl")
include("horst.jl")
include("oocmcca.jl")

end