train = full_train[1:53460, ]
test = full_train[53461:59400, ]

library(xgboost)
library(Matrix)

sparsetrain <- sparse.model.matrix(status_group ~ .-1, data=train)
trainlab <- as.numeric(train$status_group) - 1

dtrain <- xgb.DMatrix(data = sparsetrain, label = trainlab)

sparsetest <- sparse.model.matrix(status_group ~ .-1, data=test)
testlab <- as.numeric(test$status_group) - 1

dtest <- xgb.DMatrix(data = sparsetest, label = testlab)

watchlist <- list(train=dtrain, test=dtest)

xgb1 <- xgb.train(data = dtrain, 
                eta = 0.01,
                max_depth = 15, 
                subsample = 0.5,
                colsample_bytree = 0.5,
                seed = 1,
                nrounds = 1000, 
                objective="multi:softmax", 
                num_class=3,
                watchlist = watchlist)