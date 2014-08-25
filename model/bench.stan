data {
	int<lower=0> N; // number of models      
	int<lower=0> M; // number of subjects

	real x[M,N]; // (standardized) model estimates
	int<lower=0,upper=1>I[M,N]; // masks x
}

parameters {
	real y[M,N]; // unobserved ratings
	real mu[N]; // model bias
	real<lower=0>sigma[N]; // model error
	real q[M]; // true values
}


model {
	real X[M,N];  // combination of observed and unobserved ratings

	for (j in 1:M)
		for (i in 1:N)
			if (I[i,j]==1)
				X[i,j] <- x[i,j];
			else
				X[i,j] <- y[i,j];


	for (j in 1:M)
		for (i in 1:N)
			increment_log_prob(normal_log(X[i,j],q[j] + mu[i],sigma[i])); //X[i,j] ~ normal(q[j] + mu[i], sigma[i]);



	for (j in 1:M)
		q[j] ~ cauchy(0,10);

	for (i in 1:N) {
		mu[i] ~ cauchy(0,10); 
		sigma[i] ~ cauchy(0,10);
	}

}