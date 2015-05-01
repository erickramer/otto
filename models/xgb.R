library("xgboost")
library("Matrix")

x = train %>%
  select(starts_with("feat")) %>%
  as.matrix %>%
  apply(2, as.numeric) %>%
  Matrix

y = train$target %>%
  factor %>%
  as.numeric 

y = y -1

params = list(
  objective="multi::softprob",
  num_class=9,
  label=y
  )

m = xgboost(params=params,
            data=x, 
            nrounds=30,
            num_class=9,
            nfold=3,
            label=y,,
            metrics=list("mlogloss"),
            objective="multi:softprob")
