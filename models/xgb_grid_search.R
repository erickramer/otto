library("xgboost")
library("Matrix")
library("BatchJobs")

## train and predict function 

train_and_predict = function(params, ...){
  
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
  

  
}

x = train1 %>%
  select(starts_with("feat")) %>%
  as.matrix %>%
  apply(2, as.numeric) %>%
  Matrix

y = train1$target %>%
  factor %>%
  as.numeric 

y = y-1