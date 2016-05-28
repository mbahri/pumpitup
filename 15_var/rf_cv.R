# Load train data and look for good parameters using grid search on a subset of the training set

source('load_and_clean.R')
source('imputation.R')
source('typing.R')

train = full_train[1:53460, ]
test = full_train[53461:59400, ]

library(ranger)
library(caret)

# Manual Search
control <- trainControl(method="cv", number=5, search="grid")
tunegrid <- expand.grid(mtry=c(13:15))
ntree <- 1500
print(paste("CV for ", ntree, " trees"))
set.seed(1)

rf_gridsearch_1 <- train(status_group~., data=train, method="ranger", tuneGrid=tunegrid, trControl=control, num.trees=ntree, verbose=TRUE)
print(rf_gridsearch_1)
plot(rf_gridsearch_1)