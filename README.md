# OnlineCCA.jl
Online Canonical Component Analysis

## Description
OnlineCCA.jl binarizes multiple CSV files, summarizes the information of data matrices and, performs some online-CCA functions for extreamly large scale matrices.

## Algorithms
- GD-CCA
- SGD-CCA
- RSGD-CCA

## Learning Parameter Scheduling
- Robbins-Monro : [Herbert Robbins, et. al., 1951](https://projecteuclid.org/download/pdf_1/euclid.aoms/1177729586)
- Momentum : [Ning Qian, 1999](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.57.5612&rep=rep1&type=pdf)
- Nesterov's Accelerated Gradient Descent（NAG） : [Nesterov, 1983](https://scholar.google.com/scholar?cluster=9343343034975135646&hl=en&oi=scholarr)
- ADAGRAD : [John Duchi, et. al., 2011](http://www.jmlr.org/papers/volume12/duchi11a/duchi11a.pdf)

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
