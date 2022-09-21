data{
  int < lower = 1 > N;
  int < lower = 1 > N_id;
  array[N] int notes;
  array[N] int cat;
  array[N] int id;
}
parameters{
  real < lower = 0, upper = 1 > kappa;
  real < lower = 0, upper = 1 > delta;
  vector < lower = 0 > [N_id] alpha;
  vector < lower = 0 > [N_id] beta;
  real < lower = 0 > alpha_bar;
  real < lower = 0 > beta_bar;
}

model{

  real log_kappa = log(kappa);
  real log1m_kappa = log1m(kappa);
  real log_delta = log(delta);
  real log1m_delta = log1m(delta);
  
  beta_bar ~ exponential(0.1);
  alpha_bar ~ exponential(0.1);
  beta ~ exponential(1.0 / beta_bar);
  alpha ~ exponential(1.0 / alpha_bar);
  
  kappa ~ beta(4, 4);
  delta ~ beta(4, 4);
  
  for (i in 1:N) {
    if (cat[i] == 1)
      target += log_kappa + log_delta +
        poisson_lpmf (notes[i] | beta[id[i]]);
      
      if (cat[i] == 0) {
        target += log_sum_exp(
          log_kappa + log1m_delta +
            poisson_lpmf (notes[i] | beta[id[i]]),
          log1m_kappa +
            poisson_lpmf (notes[i] | alpha[id[i]])
        );
        
      }
  }
}