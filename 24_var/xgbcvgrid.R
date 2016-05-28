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

# sparsetest <- sparse.model.matrix(status_group ~ .-1, data=test)
# testlab <- as.numeric(test$status_group) - 1
# 
# dtest <- xgb.DMatrix(data = sparsetest, label = testlab)
# 
# watchlist <- list(train=dtrain, test=dtest)
# 
# params = list(
# "objective" = "multi:softmax",
# "num_class" = 3,
# "eta" = 0.1,
# # params["min_child_weight"] = 7,
# # params["subsample"] = 0.7,
# # params["colsample_bytree"] = 0.7,
# # params["scale_pos_weight"] = 0.8,
# # params["silent"] = 0,
# "max_depth" = 15
# # params["eval_metric"] = "merror"
# # params["watchlist"] = watchlist
# )

# num_rounds = 100
# model = xgb.cv(params, dtrain, num_rounds, nfold=4, seed = 0)

for (rounds in seq(100, 1000, 50)){
  
  for (depth in c(4, 6, 8, 10, 15)) {
    
    for (r_sample in c(0.5, 0.75, 1)) {
      
      for (c_sample in c(0.4, 0.6, 0.8, 1)) {
        
        for (chwe in c(1,3,5)) {
          
          for (ga in c(0, 0.1, 1, 10, 100))
        
            set.seed(1024)
            eta_val = 2 / rounds
            cv.res = xgb.cv(data = dtrain, nfold = 7, 
                            nrounds = rounds, 
                            eta = eta_val, 
                            max_depth = depth,
                            subsample = r_sample, 
                            colsample_bytree = c_sample,
                            early.stop.round = 0.5*rounds,
                            min_child_weight = chwe,
                            gamma = ga,
                            objective = "multi:softmax",
                            num_class = 3)
            
            print(paste(rounds, depth, r_sample, c_sample, chwe, ga, min(as.matrix(cv.res)[,3]) ))
            # GS_LogLoss[nrow(GS_LogLoss)+1, ] = c(rounds, 
            #                                      depth, 
            #                                      r_sample, 
            #                                      c_sample, 
            #                                      min(as.matrix(cv.res)[,3]), 
            #                                      which.min(as.matrix(cv.res)[,3]))
        
          }
        }
      }
    }
  }
}