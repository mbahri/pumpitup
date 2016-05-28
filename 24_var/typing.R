# "region_code"           "district_code"         "population"            "public_meeting"       
# [7] "scheme_management"     "permit"                "construction_year"     "extraction_type"       "extraction_type_group" "extraction_type_class"
# [13] "management"            "management_group"      "payment_type"          "water_quality"         "quality_group"         "quantity"             
# [19] "source"                "source_type"           "source_class"          "waterpoint_type"       "waterpoint_type_group" "status_group"         

# Correction des types des colonnes
full_train$gps_height <- as.numeric(full_train$gps_height)
full_train$basin <- as.factor(full_train$basin)
full_train$population <- as.numeric(full_train$population)
full_train$public_meeting <- as.factor(full_train$public_meeting)
full_train$scheme_management <- as.factor(full_train$scheme_management)
full_train$permit <- as.factor(full_train$permit)
full_train$construction_year <- as.factor(full_train$construction_year)
full_train$extraction_type <- as.factor(full_train$extraction_type)
full_train$extraction_type_group <- as.factor(full_train$extraction_type_group)
full_train$extraction_type_class <- as.factor(full_train$extraction_type_class)
full_train$management <- as.factor(full_train$management)
full_train$management_group <- as.factor(full_train$management_group)
full_train$payment_type <- as.factor(full_train$payment_type)
full_train$water_quality <- as.factor(full_train$water_quality)
full_train$quality_group <- as.factor(full_train$quality_group)
full_train$quantity <- as.factor(full_train$quantity)
full_train$source <- as.factor(full_train$source)
full_train$source_type <- as.factor(full_train$source_type)
full_train$source_class <- as.factor(full_train$source_class)
full_train$waterpoint_type <- as.factor(full_train$waterpoint_type)
full_train$waterpoint_type_group <- as.factor(full_train$waterpoint_type_group)

full_train <- select(full_train, -region_code, -district_code)

# full_train <- select(full_train, -waterpoint_type_group, -source_class, -source_type, -quality_group, 
#                      -management_group, -extraction_type_class, -extraction_type_group, -permit, -population)