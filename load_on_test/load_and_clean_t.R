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
full_test <- read.csv('test_val.csv', na.strings = "")
test_id <- full_test$id

# Remove columns that we deem useless:
#   - id is not generalisable
#   - waterpoint name is not generalisable
#   - num_private is mostly zero
#   - all entries have been recorded by the same firm, and we don't care
#   - we think that the GPS coordinates might be redundant but this might need to be changed
# full_test <- dplyr::select(full_test, -id, -longitude, -latitude, -num_private, -recorded_by, -wpt_name)
full_test <- dplyr::select(full_test, -id, -num_private, -recorded_by, -wpt_name)

# Apply the correction rules
#full_test <- correctWithRules(rules, full_test)
full_test$amount_tsh[full_test$amount_tsh == 0] <- NA

# Population can be 0 or 1 when missing
full_test$population[full_test$population == 0] <- NA
full_test$population[full_test$population == 1] <- NA

full_test$construction_year[full_test$construction_year == 0] <- NA
full_test$gps_height[full_test$gps_height == 0] <- NA

full_test$funder[full_test$funder == 0] <- NA
full_test$installer[full_test$installer == 0] <- NA
full_test$scheme_name[full_test$scheme_name == 0] <- NA

# GPS coordinates, sometimes mis-reported for lake victoria
full_test$latitude[abs(full_test$latitude) < 0.001] <- NA
full_test$longitude[abs(full_test$longitude) < 0.001] <- NA

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

full_test$funder <- stringnormal(full_test$funder)
full_test$installer <- stringnormal(full_test$installer)
full_test$scheme_name <- stringnormal(full_test$scheme_name)
full_test$scheme_management <- stringnormal(full_test$scheme_management)
full_test$subvillage <- stringnormal(full_test$subvillage)
full_test$region <- stringnormal(full_test$region)
full_test$basin <- stringnormal(full_test$basin)
full_test$lga <- stringnormal(full_test$lga)
full_test$ward <- stringnormal(full_test$ward)

# Replace the multiple region codes for a single region by the most frequent code
# and remove the region column
regwc <- as.matrix(table(select(full_test, region, region_code)))
for (n in levels(as.factor(full_test$region))) {
  full_test$region_code[full_test$region == n] = as.integer(which.max(regwc[n, ]))
}
full_test <- dplyr::select(full_test, -region)

# Quantity and quantity_group and payment and payment_type are always the same in the training set so we can keep only one
# since we can't train an algorithm that will use a difference
full_test <- dplyr::select(full_test, -quantity_group, -payment)

# La flemme
full_test <- dplyr::select(full_test, -amount_tsh, -date_recorded)