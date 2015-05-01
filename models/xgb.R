library("xgboost")
library("Matrix")

load("./data/train1")

x = train1 %>%
  select(starts_with("feat")) %>%
  as.matrix %>%
  apply(2, as.numeric) %>%
  Matrix

y = train1$target %>%
  factor %>%
  as.numeric 

y = y-1

params = list(
  
  )

m = xgboost(params=params,
          data=x, 
          nrounds=10,
          num_class=9,
          label=y[[1]],
          metrics=list("mlogloss"),
          objective="multi:softprob")


