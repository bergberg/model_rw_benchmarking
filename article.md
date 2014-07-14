# Bayesian rating model benchmarking
(working title)
## Motivation
## Setup/data description 

We are given a dataset of ratings 
$$x_{ij}\in\mathbb{R},i=1\dots N,j=1\dots M$$ 

of $M$ counterparties by $N$ banks. The ratings $x$ are transformed to be numbers on the real line; for instance, if given as probability of default estimates $p\in[0,1]$, we transform these as $x=\log\frac{p}{1-p}$. Not all counterparties are rated by all banks; we write this as an incidence matrix $I_{ij}$ where $I_{ij}=1$ if a rating by bank $i$ for counterparty $j$ exists.

## Model description
We make the following assumptions:

$$x_{ij} \sim \mathrm{Normal}(\lambda_{j}+\mu_{i},\tau_{i}) $$

where $\tau$ are precision parameters. Each rating is an estimate of the (unknown)  'true' rating $\lambda_j$ of that counterparty. We assume that each bank $i$ uses a model characterized by a bias $\mu_i$ and a precision $\tau_i$ which are the same for each rating of that bank.

    
### Implementation in Stan

Stan [@stan-software:2014]