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
