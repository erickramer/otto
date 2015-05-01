library("data.table")
library("tidyr")
library("dplyr")

train = fread("./data/train.csv")
test = fread("./data/test.csv")

train_counts = train %>%
  gather(variable, value, -id, -target) %>%
  select(variable, value) %>%
  distinct() %>%
  group_by(variable) %>%
  summarize(n=n())

save(train, file="./data/train.csv")
save(test, file="./data/test.csv")
