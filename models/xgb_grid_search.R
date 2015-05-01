library("xgboost")
library("Matrix")
library("BatchJobs")
library("zip")

## train and predict function 

train_and_predict = function(params, at, ...){
  
  packrat::init(project="~/Projects/otto")
  
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
  eta=c(0.03, 0.1, 0.3, 1),
  max.depth=1:12,
  subsample=c(0.5, 0.75, 1)
)

params =  zip(param_grid)

more.args = list(at = 2^(4:12),
                 nrounds = max(at),
                 objective = "multi:softprob",
                 metrics=list("mlogloss")
)

reg = makeRegistry("xgb_scan",
                   file.dir="xgb_scan")

batchMap(reg, 
         train_and_predict, 
         params,
         more.args=more.args)

submitJobs(reg)
