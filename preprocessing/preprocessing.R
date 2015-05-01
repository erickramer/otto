library("data.table")
library("tidyr")
library("dplyr")

train = fread("./data/train.csv")
test = fread("./data/test.csv")

train1 = train %>%
  group_by(target) %>%
  sample_frac(.95) %>%
  ungroup

train2 = train %>%
  anti_join(train1 %>% select(id)) %>%
  group_by(target) %>%
  sample_frace(0.8) %>%
  ungroup

train3 = train %>%
  anti_join(train1 %>% select(id)) %>%
  anti_join(train2 %>% select(id))
  
save(train, file="./data/train.Rdata")
save(train1, file="./data/train1.Rdata")
save(train2, file="./data/train2.Rdata")
save(train3, file="./data/train3.Rdata")
save(test, file="./data/test.Rdata")

sets = list(train1=train1,
            train2=train2,
            train3=train3,
            test=test)

save(sets, file="./data/sets.Rdata")
