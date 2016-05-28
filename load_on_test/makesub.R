# out_test <- predict(rf_gridsearch_2, full_test)
ttest <- sparse.model.matrix(~.-1, data=full_test)
out_test <- predict(xgb1, ttest) + 1

# submission <- data.frame(test_id, ranger::predictions(out_test))
submission <- data.frame(test_id, out_test)
colnames(submission) <- c("id", "status_group")

write.csv(x = submission, file = "tosub2.csv", quote = FALSE, row.names = FALSE)