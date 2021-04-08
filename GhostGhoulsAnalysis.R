##### Ghosts and Ghouls #####

library(tidyverse)
library(caret)

setwd("~/Documents/GitHub Projects/GhostsGhouls/")

test <- vroom::vroom("test.csv")
train <- vroom::vroom("train.csv")

monsters <- bind_rows("test" = test, "train" = train, .id = "Set")

train$type <- as.factor(train$type)
train$color <- as.factor(train$color)

monster_model <- train(form = type ~.,
                       data = train %>% select(-id),
                       method = "rf",
                       trControl = trainControl(
                         method = "cv",
                         number = 10)
)

preds <- predict(monster_model, newdata = test)
# my_preds <- predict(monster_model, newdata = test, type = "prob")
# submission <- cbind("id" = test$id, preds)
submission <- data.frame("id" = test$id, "type" = preds)
write.csv(x = submission, file = "submission.csv", row.names = FALSE)


############################### Stacked Model ############################### 
knn <- read.csv("Probs_KNN.csv")
names(knn)[1] <- "id"

multilayer <- read.csv("multilayerperceptron.csv")
gbm <- read.csv("probs_gbm.csv")

names(gbm)[1] <- "id"

svm <- read.csv("probs_svm.csv")
names(svm)[1] <- "id"

xgb <- read.csv("xgbTree_probs.csv")
names(xgb)[1] <- "id"

classification <- read.csv("classification_submission_rf.csv")
names(classification)[1] <- "id"

all_ghosts <- left_join(knn, multilayer, by = "id") %>%
  left_join(., gbm, by = "id") %>%
  left_join(., xgb, by = "id") %>%
  left_join(., svm, by = "id") %>%
  left_join(., classification, by = "id")

pp <- preProcess(x = all_ghosts, method = "pca")
ghost_pp <- predict(pp, all_ghosts)

model_df <- cbind(ghost_pp, monsters) 
model_df <- model_df %>% select(-id, 
                                -bone_length, 
                                -rotting_flesh, 
                                -hair_length,
                                -has_soul,
                                -color)

all_ghosts_model <- train(form = type ~.,
                          data = model_df %>% filter(Set == "train") %>% select(-Set),
                          method = "rf",
                          trControl = trainControl(
                            method = "repeatedcv",
                            number = 5,
                            repeats = 1)
)

stacked_preds <- predict(all_ghosts_model, newdata =  model_df %>% filter(Set == "test"))
submission <- data.frame("id" = test$id, "type" = stacked_preds)
write.csv(x = submission, file = "stacked_submission_rf.csv", row.names = FALSE)
