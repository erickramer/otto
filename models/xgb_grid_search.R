library("xgboost")
library("Matrix")
library("BatchJobs")

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


train_and_predict(params, 
                  metrics=list("mlogloss"),
                  objective="multi:softprob",
                  nrounds=10,
                  num_class=9)
