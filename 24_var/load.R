# Function to plot a barplot of the proportion of each y by factor x.
# Expects: x, y column names as strings, data: data set as data.frame or data.table
prop_hist <- function(x, y, data) {
  xx = data[[x]]
  yy = data[[y]]
  print(ggplot2::ggplot(data, ggplot2::aes(xx, fill=yy)) + ggplot2::geom_bar(position="fill") + 
    ggplot2::xlab(x) + ggplot2::labs(fill = y) + ggplot2::ggtitle(paste(y, " vs ", x)))
}

# by_installer = as.data.frame.matrix(table(full_train$installer, full_train$status_group))
# by_region = as.data.frame.matrix(table(full_train$region, full_train$status_group))
# 
# # Construction year
# # permit
# # scheme management
# # extraction_type
# # extraction_type_group
# # extraction_type_class
# # quality_group
# # source_type
# # source_class
# 
# 
# by_const_year = as.data.frame.matrix(table(full_train$construction_year, full_train$status_group))
# by_quality_group = as.data.frame.matrix(table(full_train$quality_group, full_train$status_group))
# by_source_class = as.data.frame.matrix(table(full_train$source_class, full_train$status_group))
# 
# #prop_hist("region", "status_group", full_train)
# 
# for (i in colnames(full_train)) {
#   prop_hist(i, "status_group", full_train)
# }
# 
# # Read the levels of the factor variables to try to find duplicates
# 
# for (i in colnames(full_train)) {
#   if (class(full_train[[i]]) == 'factor') {
#     # print(levels(full_train[[i]]))
#     print(i)
#   }
# }

source('load_and_clean.R')
source('imputation.R')
source('typing.R')