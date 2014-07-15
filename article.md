# Bayesian model benchmarking (working title)
## Motivation
## Setup/data description 

We are given a dataset of ratings 

$$x_{ij}|_{I_{ij}=1}\in\mathbb{R}, i=1\dots N,j=1\dots M$$ 

of $M$ counterparties by $N$ banks. The ratings $x$ are transformed to be numbers on the real line; for instance, if given as probability of default estimates $p\in[0,1]$, we transform these as $x=\log\frac{p}{1-p}$. Not all counterparties are rated by all banks; we write this as an incidence matrix $I_{ij}$ where $I_{ij}=1$ if a rating by bank $i$ for counterparty $j$ exists.

## Model description
Our model is remarkable only in its simplicity:

$$ x_{ij}  \sim  \mathrm {Normal} (q_{j} + \mu_{i}, \Lambda_{i} ) I_{ij} $$

Each rating is an estimate of the (unknown)  'true' rating $q_j$ of that counterparty. We assume that each bank $i$ uses a model characterized by a bias $\mu_i$ and a precision $\tau_i = \sigma_i^{-2}$ which are the same for each rating of that bank, and we assume that $x_{ij}$ are uncorrelated.
As it is, this model suffers from an M-way collinearity;  under the simultaneous transformations

$$
	\begin{matrix} q_j \to q_j+a_{ij} \\ \mu_i\to\mu_i-a_{ij} \end{matrix}
$$

for any set of exclusive[^1] pairs $(i,j)$  the resulting distribution of $x_{ij}$ will be the same. In


We can 'fix the gauge' by setting (for instance) all $q_j  = \sum_{i=1}^N I_{ij} x_{ij} / \sum_{i=1}^N I_{ij}$.  The bias parameters then represent the bias relative to the average rating (which may, of course, itself be a biased estimate). Note that this also removes any dependence on $x_{.j}$ where $\sum_1^N x_{ij}=1$. 
We wish to estimate the marginal posterior density for the $\mu_i$,
$$P(\mu|x,I,M,N)=\int\dots\int P(\mu|\tau,x,I,M,N)\mathrm{d}\tau_1 \dots \mathrm{d}\tau_M$$

We choose a weakly informative joint prior for the $\mu$ and $\Lambda$,

$$\begin{matrix} \mathrm{P}(\mu,\Lambda_i|\dots)=\mathrm{NW}(m_i,S_i) \\ \mathrm{P}(\tau_i|\dots)=$$

### Implementation in Stan
Stan [@stan-software:2014]

[^1]: i.e., choose all pairs $(i,j)$ such that each $i$ and $j$ occur at most once

