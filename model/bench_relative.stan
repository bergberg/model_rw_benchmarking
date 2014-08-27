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