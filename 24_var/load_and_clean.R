library(ggplot2)
library(dplyr)
library(stringr)
library(stringdist)
library(arules)
library(deducorrect)
library(data.table)
library(editrules)
library(FactoMineR)
library(lubridate)

# Deducorrect correction rules
# rules <- deducorrect::correctionRules("rules.txt")

# Load the data, empty fields should be treated as NA
train_val <- read.csv('train_val.csv', na.strings = "")
train_lab <- read.csv('train_lab.csv')

# Merge the labels and the variables
full_train <- merge(train_val, train_lab)

# full_train <- read.csv('test_val.csv', na.strings = "")

# Remove columns that we deem useless:
#   - id is not generalisable
#   - waterpoint name is not generalisable
#   - num_private is mostly zero
#   - all entries have been recorded by the same firm, and we don't care
#   - we think that the GPS coordinates might be redundant but this might need to be changed
# full_train <- dplyr::select(full_train, -id, -longitude, -latitude, -num_private, -recorded_by, -wpt_name)
full_train <- dplyr::select(full_train, -id, -num_private, -recorded_by, -wpt_name)

# Apply the correction rules
#full_train <- correctWithRules(rules, full_train)
full_train$amount_tsh[full_train$amount_tsh == 0] <- NA

# Population can be 0 or 1 when missing
full_train$population[full_train$population == 0] <- NA
full_train$population[full_train$population == 1] <- NA

full_train$construction_year[full_train$construction_year == 0] <- NA
full_train$gps_height[full_train$gps_height == 0] <- NA

full_train$funder[full_train$funder == 0] <- NA
full_train$installer[full_train$installer == 0] <- NA
full_train$scheme_name[full_train$scheme_name == 0] <- NA

# GPS coordinates, sometimes mis-reported for lake victoria
full_train$latitude[abs(full_train$latitude) < 0.001] <- NA
full_train$longitude[abs(full_train$longitude) < 0.001] <- NA

# Apply text normalization INCOMPLETE

stringnormal <- function(S) {
  gsub("[[:punct:]]|[[:space:]]", "", iconv(toupper(stringr::str_trim(S)), to = "ASCII//TRANSLIT"))
}

reduce_factors <- function(col) {
  f <- levels(as.factor(col))
  distances <- as.matrix(stringdist::stringdistmatrix(f))
  #distances <- melt(distances) %>% distinct()
  long_words <- which(stringr::str_length(f) > 3)
}

full_train$funder <- stringnormal(full_train$funder)
full_train$installer <- stringnormal(full_train$installer)
full_train$scheme_name <- stringnormal(full_train$scheme_name)
full_train$scheme_management <- stringnormal(full_train$scheme_management)
full_train$subvillage <- stringnormal(full_train$subvillage)
full_train$region <- stringnormal(full_train$region)
full_train$basin <- stringnormal(full_train$basin)
full_train$lga <- stringnormal(full_train$lga)
full_train$ward <- stringnormal(full_train$ward)

# Replace the multiple region codes for a single region by the most frequent code
# and remove the region column
regwc <- as.matrix(table(select(full_train, region, region_code)))
for (n in levels(as.factor(full_train$region))) {
  full_train$region_code[full_train$region == n] = as.integer(which.max(regwc[n, ]))
}
full_train <- dplyr::select(full_train, -region)

# Quantity and quantity_group and payment and payment_type are always the same in the training set so we can keep only one
# since we can't train an algorithm that will use a difference
full_train <- dplyr::select(full_train, -quantity_group, -payment)

# La flemme
full_train <- dplyr::select(full_train, -amount_tsh, -date_recorded)