# Code form original solution copied from hw4_solution.r
simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 

MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 

df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

# Modifying the last portion of code snippet for parallel execution

# Setting number of max cores
maxcores <- 10
Cores <- min(parallel::detectCores(), maxcores)

# Initiating cores
cl <- makeCluster(Cores)

# Registering the cluster
registerDoParallel(cl)

# Using foreach to parallelize the loop
  df <- 
    foreach(
    i = 1:nrow(df),
    .combine = 'rbind',
    .packages = c('tweedie','tidyverse')
  ) %dopar% 
    tibble(
      N = df$N[i],
      M = df$M[i],
      share_reject =
        MTweedieTests( 
          N=df$N[i], 
          M=df$M[i], 
          sig=.05)
    )
  
# Stopping the cluster
stopCluster(cl)