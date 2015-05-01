### TRAINING PARAMETERS ###

objective = "multi:softprob"
metrics=list("mlogloss")

at = 2^(4:12) # number of trees to use
eta=c(0.03, 0.1, 0.3, 1) # training step
max.depth=1:12 # depth of tree
subsample=c(0.5, 0.75, 1) # subsampling for tree training

### SCRIPT ####

library("xgboost")
library("Matrix")
library("BatchJobs")
library("purrr")

## train and predict function 

train_and_predict = function(params, at, ...){
  
  require("dplyr")
  require("Matrix")
  require("xgboost")
  
  create_matrix = function(df){
    df %>%
      select(starts_with("feat")) %>%
      as.matrix %>%
      apply(2, as.numeric) %>%
      Matrix
  }
  
  create_target = function(df){
    y = df$target %>%
      factor %>%
      as.numeric
    y - 1
  }
  
  predict_matrix = function(x, m){
    p = lapply(at, function(ntreelimit){
      predict(m, x, ntreelimit=ntreelimit) %>%
        matrix(ncol=9, byrow=T)
    })
  }
  
  load("./data/sets.Rdata")
  
  x = lapply(sets, create_matrix)
  y = lapply(sets, create_target)
  
  m = xgboost(param=params,
              data=x[[1]],
              label=y[[1]],
              ...)
  
  
  p = lapply(x, predict_matrix, m)
  return(p)
}

param_grid = expand.grid(
  eta=eta,
  max.depth=max.depth,
  subsample=subsample
)

params =  zip(param_grid)


more.args = list(at = at,
                 nrounds = max(at),
                 objective = objective,
                 metrics=metrics,
                 num_class=9
)

reg = makeRegistry("xgb_scan",
                   file.dir="xgb_scan")

batchMap(reg, 
         train_and_predict, 
         params,
         more.args=more.args)

submitJobs(reg)
