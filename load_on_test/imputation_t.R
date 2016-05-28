# Impute population based on mean of region

temp = select(full_test, region_code, population)
for (i in min(full_test$region_code):max(full_test$region_code)) {
    tt = filter(temp, region_code == i)
    m = round(mean(tt$population, na.rm=TRUE), 0)
    mask = is.na(full_test$population) & full_test$region_code == i
    full_test$population[mask] = m
}
mask = is.nan(full_test$population)
m = round(mean(full_test$population, na.rm=TRUE), 0)
full_test$population[mask] = m

# Impute altitude based on mean of region

temp = select(full_test, region_code, gps_height)
for (i in min(full_test$region_code):max(full_test$region_code)) {
  tt = filter(temp, region_code == i)
  m = round(mean(tt$gps_height, na.rm=TRUE), 0)
  mask = is.na(full_test$gps_height) & full_test$region_code == i
  full_test$gps_height[mask] = m
}
mask = is.nan(full_test$gps_height)
m = round(mean(full_test$gps_height, na.rm=TRUE), 0)
full_test$gps_height[mask] = m

# Impute public meeting based on ward, meanwhile set to True for testing
full_test$public_meeting[is.na(full_test$public_meeting)] <- "True"

# Impute construction year based on type and installer and region ?

# For testing purposes: impute every thing by most frequent value

mfreq <- function(V) {
  names(which.max(table(V))) 
}

imp_mfreq <- function(V) {
  V[is.na(V)] <- mfreq(V)
}

full_test$funder[is.na(full_test$funder)] <- mfreq(full_test$funder)
full_test$permit[is.na(full_test$permit)] <- mfreq(full_test$permit)
full_test$installer[is.na(full_test$installer)] <- mfreq(full_test$installer)
full_test$basin[is.na(full_test$basin)] <- mfreq(full_test$basin)
full_test$subvillage[is.na(full_test$subvillage)] <- mfreq(full_test$subvillage)
full_test$scheme_management[is.na(full_test$scheme_management)] <- mfreq(full_test$scheme_management)
full_test$scheme_name[is.na(full_test$scheme_name)] <- mfreq(full_test$scheme_name)
full_test$construction_year[is.na(full_test$construction_year)] <- mfreq(full_test$construction_year)

# imp_mfreq(full_test$installer)
# imp_mfreq(full_test$basin)
# imp_mfreq(full_test$subvillage)
# imp_mfreq(full_test$scheme_management)
# imp_mfreq(full_test$scheme_name)
# imp_mfreq(full_test$construction_year)

# Trop de facteurs useless
full_test <- dplyr::select(full_test, -funder, -installer, -subvillage, -scheme_name, -lga, -ward)

# Transformer les dates de creation en periodes
full_test$construction_year[full_test$construction_year < 1970] <- 1960
full_test$construction_year[full_test$construction_year >=  1970 & full_test$construction_year < 1980] <- 1970
full_test$construction_year[full_test$construction_year >=  1980 & full_test$construction_year < 1990] <- 1980
full_test$construction_year[full_test$construction_year >=  1990 & full_test$construction_year < 2000] <- 1990
full_test$construction_year[full_test$construction_year >=  2000 & full_test$construction_year < 2010] <- 2000
full_test$construction_year[full_test$construction_year >=  2010] <- 2010

full_test$construction_year <- as.factor(full_test$construction_year)

# Manual imputation of lake victoria
lake <- filter(full_test, basin == 'LAKEVICTORIA') %>% select(latitude, longitude)
latmask = full_test$basin == 'LAKEVICTORIA' & is.na(full_test$latitude)
longmask = full_test$basin == 'LAKEVICTORIA' & is.na(full_test$latitude)
full_test$latitude[latmask] <- mean(lake$latitude, na.rm=TRUE)
full_test$longitude[longmask] <- mean(lake$longitude, na.rm=TRUE)

# Same for LAKETANGANYIKA
lake <- filter(full_test, basin == 'LAKETANGANYIKA') %>% select(latitude, longitude)
latmask = full_test$basin == 'LAKETANGANYIKA' & is.na(full_test$latitude)
longmask = full_test$basin == 'LAKETANGANYIKA' & is.na(full_test$latitude)
full_test$latitude[latmask] <- mean(lake$latitude, na.rm=TRUE)
full_test$longitude[longmask] <- mean(lake$longitude, na.rm=TRUE)