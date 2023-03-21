data{
	int<lower=1> plays;
	int<lower=1> teams;
	 int team_id [plays]; 
	 real epa [plays];
	 int hit [plays];
}
parameters{
	real<lower=0>  alpha [teams];
	real<lower=0> alpha_bar;
	real beta [teams];
	real beta_bar;
	real<lower=0, upper=1> kappa [teams];
	real<lower=0, upper=1> kappa_bar;
	real<lower=0, upper=1> delta_bar;
	real<lower=0, upper=1> delta [teams];
	real<lower=0> sigma;
}
model{
	vector[plays] mu;
  beta ~ normal(beta_bar, 1);
	alpha ~ exponential(1.0 / alpha_bar);
	alpha_bar ~ exponential(0.1);
	beta_bar ~ normal(0, 1);
	kappa_bar ~ beta(4,4);
	delta_bar ~ beta(4,4);
	kappa ~ beta(2.0 / kappa_bar,4);
	delta ~ beta(2.0 / delta_bar,4);
  sigma ~ exponential(1.0);
	
	
	for (i in 1:plays ) {
	  if (hit[i]==1 )
	  target += log(kappa[team_id[i]]) + log(delta[team_id[i]]) + normal_lpdf(epa[i] | beta[team_id[i]], sigma);
	  if (hit[i]==0 ) {
	    target += log_sum_exp(
	      log(kappa[team_id[i]]) + log1m(delta[team_id[i]]) + normal_lpdf(epa[i] | beta[team_id[i]], sigma),
	      log1m(kappa[team_id[i]]) + normal_lpdf(epa[i] | alpha[team_id[i]], sigma));
	  }
	}
}
generated quantities{
  vector [plays] hit_impute;
for ( i in 1:plays) {
real logPxy;
real logPy;
if (hit[i] == 0) {
logPxy = log(kappa[team_id[i]]) + log1m(delta[team_id[i]]) + normal_lpdf(epa[i] | beta[team_id[i]], sigma);
logPy = log_sum_exp(
	      log(kappa[team_id[i]]) + log1m(delta[team_id[i]]) + normal_lpdf(epa[i] | beta[team_id[i]], sigma),
	      log1m(kappa[team_id[i]]) + normal_lpdf(epa[i] | alpha[team_id[i]], sigma));
	      hit_impute[i] = exp(logPxy - logPy);
	     } else
	     hit_impute[i] = hit[i];
	     }
}
