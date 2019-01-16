# OnlineCCA.jl
Online Canonical Component Analysis

## Description
OnlineCCA.jl binarizes multiple CSV files, summarizes the information of data matrices and, performs some online-CCA functions for extreamly large scale matrices.

## Algorithms
- GD-CCA
- SGD-CCA
- RSGD-CCA

## Learning Parameter Scheduling
- Robbins-Monro : Herbert Robbins, et. al., 1951
- Momentum : Ning Qian, 1999
- Nesterov's Accelerated Gradient Descent（NAG） : Nesterov, 1983
- ADAGRAD : John Duchi, et. al., 2011

## Installation
<!-- ```julia
julia> Pkg.add("OnlineCCA")
```
 -->
```julia
# push the key "]" and type the following command.
(v1.0) pkg> add https://github.com/rikenbit/OnlineCCA.jl
(v1.0) pkg> add PlotlyJS
# After that, push Ctrl + C to leave from Pkg REPL mode
```

## Basic API usage
### Preprocess of CSV
...

### Setting for plot
...

### GD-CCA
...

### SGD-CCA
...

### RSGD-CCA
...

## Command line usage
...

## Distributed Computing with Mulitple Stepsize Setting
...
