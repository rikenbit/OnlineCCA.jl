# OnlineCCA.jl
Online Canonical Component Analysis

## Description
OnlineCCA.jl binarizes multiple CSV files, summarizes the information of data matrices and, performs some online-CCA functions for extreamly large scale matrices.

Except for SIMPLS, multiple (over three) datasets can be specified against each algorithm (multiple CCA; mCCA).

Contrary to PCA, which is the eigenvalue problem of the covariance matrix w'X'Xw with the constraint condition norm(w) = 1, CCA is solved as the generalized eigenvalue problem of the cross-product matrix w'X'Yv with the constraint condition cor(Xw, Yv) = 1.

When the column vectors of X and Y is standarized (mean 0, variance 1), the problem is simplified as the eigenvalue problem of the cross-product matrix w'X'Yv with the constraint condition norm(w) = norm(v) = 1 and called Orthogonal CCA. When the column vectors of X and Y is centerized (mean 0), this problem is also known as PLS-SVD. OnlineCCA.jl can perform both approarches by the specifying the arguments "colmeanlist" and "colmeanlist".

It is known that simultaneous orthogonalization of both w (eigenvectors) and Xw (latent variables) is difficult. When using the latent variables for prediction problem such as regression/discriminant analysis, the orthogonalization of latent variables is preferred from the viewpoint of the multicolinearity (cf. PLS-R, PLS-DA, NIPALS, SIMPLS, and O2PLS). OnlineCCA.jl provides SIMPLS for such approarch.

## Algorithms
- Orthogonal Eigenvectors-type
	- Gradient-based
		- GD-CCA
		- SGD-CCA
		- RSGD-CCA
	- Krylov subspace-based
		- Orthgonal Iteration (A power method to calculate multiple eigenvectors at once)
		- HOrst Iteration (Horst-Jacobi algorithm)
		- Witten's method
	- Random projection-based
		- oocCCA (Out-of-core CCA)
- Orthogonal latent variables-type
	- SIMPLS

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
