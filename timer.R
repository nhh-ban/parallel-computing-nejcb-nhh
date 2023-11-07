# Calling various libraries
library(tweedie) 
library(tidyverse)
library(tictoc)
library(doParallel)

# Measuring performance of solution 1
tic()
source("scripts/original_solution.r")
toc()

# Measuring performance of solution 2
tic()
source("scripts/multicore_solution_1.r")
toc()

# Measuring performance of solution 3
tic()
source("scripts/multicore_solution_2.r")
toc()

# The fastest method by far is changing the MTweedieTests function
# to run in parallel (time elapsed: 11.21 s) in comparison to the 
# original method (time elapsed: 46.91 s) and the method of running
# the for loop in parallel (time elapsed: 35.66 s). I assume that 
# the latter did not run much faster since the for loop was moving
# through a data frame and had to make calculations one by one 
# regardless. On the other hand changing the MTweedieTests ran
# much faster due to the function just replicating a task M-amount
# of times which is considerably faster in parallel execution.