# xgb.train(data = dtrain, 
#           eta = 0.01,
#           max_depth = 15, 
#           subsample = 0.5,
#           colsample_bytree = 0.5,
#           seed = 1,
#           nrounds = 1000, 
#           objective="multi:softmax", 
#           num_class=3,
#           watchlist = watchlist)

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

params = list(
"objective" = "multi:softmax",
"num_class" = 3,
"eta" = 0.1,
# params["min_child_weight"] = 7,
# params["subsample"] = 0.7,
# params["colsample_bytree"] = 0.7,
# params["scale_pos_weight"] = 0.8,
# params["silent"] = 0,
"max_depth" = 15
# params["eval_metric"] = "merror"
# params["watchlist"] = watchlist
)

num_rounds = 100
model = xgb.cv(params, dtrain, num_rounds, nfold=4, seed = 0)