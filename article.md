---
title: Bayesian model benchmarking (draft)
author: dr. P. J. van den Berg
date: 6 August, 2014
tags: benchmarking, statistics, bayesian, draft
abstract:  |
	We describe a simple model for comparing model outcomes and apply
	it to a dataset of common counterparty ratings, explicitly including the
	treatment of missing values.
---

Introduction
---------------------

As a part of model validation, we often want to compare the outcomes of
several models on a set of common subjects. For instance, we would want to
compare ratings by several banks on common counterparties, or compare the
outcomes of different [...]

Model description 
---------------------

We are given a dataset of ratings 

$$\left[ x_{ij}\right]_{I_{ij}=1}\in\mathbb{R}, i=1\dots N,j=1\dots M, I_{ij} \in [0,1]$$

of $M$ rating subjects by $N$ models. The ratings $x$ are transformed to be
numbers on the real line and standardized; for instance, if given as
probability of default estimates $p\in[0,1]$, we transform these as
$x=\Phi^{-1}(p)$ and $x\to(x - \bar{x}) / \mathrm{sd}(x)$. Not all
subjects are rated by all models; we write this as an incidence matrix
$I_{ij}$ where $I_{ij}=1$ if a rating by model $i$ for counterparty $j$
exists, and $0$ otherwise.

Our model is particularly simple (see also [figure \ref{fig:diagram}](#fig:diagram)):

$$ x_{ij|I_{ij}=1}
\sim  \mathrm {Normal} (q_{j} + \mu_{i},\sigma_i ) $$ $$ I_{ij}  \sim
\mathrm{Bernoulli}(p) $$

<div id="fig:diagram"> ![A graphical depiction of the model showing the
corresponding Bayesian network of conditional
dependencies\label{fig:diagram}](graph.pdf)

</div>

Each rating $x_{.j}$ is an estimate of the (unknown) 'true' rating
(probability of default, loss given default, ...) $q_j$ of that counterparty.
We assume that each model $i$ uses a model characterized by a bias $\mu_i$ and
error $\sigma_i$ which are the same for each rating of that model, and we
assume that these are uncorrelated between models. We also assume whether a
rating is present is independent of either model or counterparty.

As it is, this model suffers from a collinearity;  under the simultaneous
transformations $q_j \to q_j+a,\ \mu_i\to\mu_i-a$ the resulting distribution
of $x_{ij}$ will be the same. We remove this collinearity by specifying a
prior on the $q_j$ which breaks the symmetry. The bias parameters represent
the bias relative to the average rating. We also remove any dependence on
$x_{.j}$ where $\sum_1^N x_{ij}=1$, i.e., subjects for which only one rating
is available.

We wish to estimate the marginal posterior density for the $\mu_i$,

$$P(\mu|x,I,M,N)=\int\dots\int P(\mu|\tau,x,I,M,N)\mathrm{d}\tau_1 \dots \mathrm{d}\tau_M$$

We choose weakly informative conjugate joint priors for the $\mu_i$ and $\tau_i$,

$$\mathrm{P}(\mu_i,\tau_i|\dots)=\mathrm{NormalGamma}(\mu_{0i},\nu_i,\alpha_i,\beta_i)$$

with

$$\begin{matrix} \mu_{0i}=0, i=1\dots N \\ \nu_i = \mathrm{large number}\end{matrix}$$

[...]

Data
-----------

As an example, we use data from the 2012 Dutch Hypothetical Portfolio Exercise
(HPE). These data contain PD and LGD predictions for 342 corporate
subjects by 7 models and rating agencies. We exclude PD values equal to
1, set PD/LGD values equal to 1(0) to $\Phi(+(-)8.1259)$
(corresponding to the largest (smallest) representable double precision float)
and normalize as

$$ \begin{matrix} \mathrm{R} \to x = (\Phi^{-1}(\mathrm{R}) - \mathrm{mean}(x')) / \mathrm{sd}(x) \\ \mathrm{with} \\ x' = \Phi^{-1}(\mathrm{R})  \end{matrix} $$

where $\mathrm{R}$ is either the PD or LGD.
Figures **???** show the resulting distributions for the biases $\mathbf{mu}$


Results
----------

<div id="fig:lalune">
![A voyage to the moon\label{fig:lalune}](C:\Users\rn8089\Desktop\LGD_dutch_mortgages.png)

</div>

See [figure \ref{fig:lalune}](#fig:lalune).

Appendix: Stan implementation
=============================

	data {
		int<lower=0> N; // number of models      
		int<lower=0> M; // number of subjects

		real x[M,N]; // standardized model estimates
		int<lower=0,upper=1>I[M,N]; // is rating (i,j) present or not
	}

	parameters {
		real q[M]; // true values
		real y[M,N]; // unobserved ratings
		real mu[N]; // model relative bias
		real<lower=0>tau[N]; // model precision
		real<lower=0,upper=1>p; // probability of having a rating
		real<lower=0>a; // 
		real<lower=0>b; // parameters of the prior to p

	}

	transformed parameters {	
		real<lower=0>sigma[N];
		for (j in 1:N)
			sigma[j] <- pow(tau[j], -0.5);
	}

	model {
		real X[M,N];  // combination of observed and unobserved ratings

		for (i in 1:M)
			for (j in 1:N)
				if (I[i,j]==1)
					X[i,j] <- x[i,j];
				else
					X[i,j] <- y[i,j];

		for (i in 1:M)
			for (j in 1:N) {
				increment_log_prob(normal_log(X[i,j],q[i] + mu[j],sigma[j])); //X[i,j] ~ normal(q[i] + mu[j], sigma[j]);	
				I[i,j] ~ bernoulli(p);
			}

		for (j in 1:N) {
			mu[j] ~ cauchy(0,10);
			tau[j] ~ cauchy(0,10);
		}

		for (i in 1:M)
			q[i] ~ cauchy(0,10);

		p ~ beta(a,b);
	}
	

Appendix: Diagnostic output
=============================

The following diagnostic results serve to ascertain the convergence of the
MCMC sampling procedure.


Stan [@stan-software:2014]

[^1]: I.e., choose all pairs $(i,j)$ such that each $i$ and $j$ occur at most once
