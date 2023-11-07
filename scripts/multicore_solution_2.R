# Code form original solution copied from hw4_solution.r
simTweedieTest <-  
  function(N){ 
    t.test( 
      rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 

# Modifying the last portion of code snippet for parallel execution
MTweedieTests <-  
  function(N,M,sig){ 
    results <- 
      foreach(i = 1:M, 
              .combine = 'rbind',
              .packages = 'tweedie') %dopar% {
      simTweedieTest(N) < sig
    }
    proportion <- sum(results) / M
    return(proportion)
  } 

df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 

# Setting number of max cores
maxcores <- 10
Cores <- min(parallel::detectCores(), maxcores)

# Initiating cores
cl <- makeCluster(Cores)

# Registering the cluster
registerDoParallel(cl)

# Export the simTweedieTest function to the parallel workers
clusterExport(cl, "simTweedieTest")

for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
}

# Stopping the cluster
stopCluster(cl)
