# Impute population based on mean of region

temp = select(full_train, region_code, population)
for (i in min(full_train$region_code):max(full_train$region_code)) {
    tt = filter(temp, region_code == i)
    m = round(mean(tt$population, na.rm=TRUE), 0)
    mask = is.na(full_train$population) & full_train$region_code == i
    full_train$population[mask] = m
}
mask = is.nan(full_train$population)
m = round(mean(full_train$population, na.rm=TRUE), 0)
full_train$population[mask] = m

# Impute altitude based on mean of region

temp = select(full_train, region_code, gps_height)
for (i in min(full_train$region_code):max(full_train$region_code)) {
  tt = filter(temp, region_code == i)
  m = round(mean(tt$gps_height, na.rm=TRUE), 0)
  mask = is.na(full_train$gps_height) & full_train$region_code == i
  full_train$gps_height[mask] = m
}
mask = is.nan(full_train$gps_height)
m = round(mean(full_train$gps_height, na.rm=TRUE), 0)
full_train$gps_height[mask] = m

# Impute public meeting based on ward, meanwhile set to True for testing
full_train$public_meeting[is.na(full_train$public_meeting)] <- "True"

# Impute construction year based on type and installer and region ?

# For testing purposes: impute every thing by most frequent value

mfreq <- function(V) {
  names(which.max(table(V))) 
}

imp_mfreq <- function(V) {
  V[is.na(V)] <- mfreq(V)
}

full_train$funder[is.na(full_train$funder)] <- mfreq(full_train$funder)
full_train$permit[is.na(full_train$permit)] <- mfreq(full_train$permit)
full_train$installer[is.na(full_train$installer)] <- mfreq(full_train$installer)
full_train$basin[is.na(full_train$basin)] <- mfreq(full_train$basin)
full_train$subvillage[is.na(full_train$subvillage)] <- mfreq(full_train$subvillage)
full_train$scheme_management[is.na(full_train$scheme_management)] <- mfreq(full_train$scheme_management)
full_train$scheme_name[is.na(full_train$scheme_name)] <- mfreq(full_train$scheme_name)
full_train$construction_year[is.na(full_train$construction_year)] <- mfreq(full_train$construction_year)

# imp_mfreq(full_train$installer)
# imp_mfreq(full_train$basin)
# imp_mfreq(full_train$subvillage)
# imp_mfreq(full_train$scheme_management)
# imp_mfreq(full_train$scheme_name)
# imp_mfreq(full_train$construction_year)

# Trop de facteurs useless
full_train <- dplyr::select(full_train, -funder, -installer, -subvillage, -scheme_name, -lga, -ward)

# Transformer les dates de creation en periodes
full_train$construction_year[full_train$construction_year < 1970] <- 1960
full_train$construction_year[full_train$construction_year >=  1970 & full_train$construction_year < 1980] <- 1970
full_train$construction_year[full_train$construction_year >=  1980 & full_train$construction_year < 1990] <- 1980
full_train$construction_year[full_train$construction_year >=  1990 & full_train$construction_year < 2000] <- 1990
full_train$construction_year[full_train$construction_year >=  2000 & full_train$construction_year < 2010] <- 2000
full_train$construction_year[full_train$construction_year >=  2010] <- 2010

full_train$construction_year <- as.factor(full_train$construction_year)

# Manual imputation of lake victoria
lake <- filter(full_train, basin == 'LAKEVICTORIA') %>% select(latitude, longitude)
latmask = full_train$basin == 'LAKEVICTORIA' & is.na(full_train$latitude)
longmask = full_train$basin == 'LAKEVICTORIA' & is.na(full_train$latitude)
full_train$latitude[latmask] <- mean(lake$latitude, na.rm=TRUE)
full_train$longitude[longmask] <- mean(lake$longitude, na.rm=TRUE)

# Same for LAKETANGANYIKA
lake <- filter(full_train, basin == 'LAKETANGANYIKA') %>% select(latitude, longitude)
latmask = full_train$basin == 'LAKETANGANYIKA' & is.na(full_train$latitude)
longmask = full_train$basin == 'LAKETANGANYIKA' & is.na(full_train$latitude)
full_train$latitude[latmask] <- mean(lake$latitude, na.rm=TRUE)
full_train$longitude[longmask] <- mean(lake$longitude, na.rm=TRUE)