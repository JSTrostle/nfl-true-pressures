data{
  int < lower = 1 > N;
  int notes[N];
  int cat[N];
}
parameters{
  real < lower = 0, upper = 1 > kappa;
  real < lower = 0, upper = 1 > delta;
  real < lower = 0 > alpha;
  real < lower = 0 > beta;
}
model{
  beta ~ exponential(0.1);
  alpha ~ exponential(0.1);
  kappa ~ beta(1, 4);
  delta ~ beta(4, 4);
  
  real log_kappa = log(kappa);
  real log1m_kappa = log1m(kappa);
  real log_delta = log(delta);
  real log1m_delta = log1m(delta);  
  

  for (i in 1:N) {
    if (cat[i] == 1)
      target+= log_kappa + log_delta +
        poisson_lpmf (notes[i] | beta);
        
        
      if (cat[i] == 0) {
      
      
        target+= log_sum_exp(
          log_kappa + log1m_delta +
            poisson_lpmf (notes[i] | beta),
          log1m_kappa +
            poisson_lpmf (notes[i] | alpha)
        );    
      }}
  }
}