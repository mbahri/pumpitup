# "region_code"           "district_code"         "population"            "public_meeting"       
# [7] "scheme_management"     "permit"                "construction_year"     "extraction_type"       "extraction_type_group" "extraction_type_class"
# [13] "management"            "management_group"      "payment_type"          "water_quality"         "quality_group"         "quantity"             
# [19] "source"                "source_type"           "source_class"          "waterpoint_type"       "waterpoint_type_group" "status_group"         

# Correction des types des colonnes
full_test$gps_height <- as.numeric(full_test$gps_height)
full_test$basin <- as.factor(full_test$basin)
full_test$population <- as.numeric(full_test$population)
full_test$public_meeting <- as.factor(full_test$public_meeting)
full_test$scheme_management <- as.factor(full_test$scheme_management)
full_test$permit <- as.factor(full_test$permit)
full_test$construction_year <- as.factor(full_test$construction_year)
full_test$extraction_type <- as.factor(full_test$extraction_type)
full_test$extraction_type_group <- as.factor(full_test$extraction_type_group)
full_test$extraction_type_class <- as.factor(full_test$extraction_type_class)
full_test$management <- as.factor(full_test$management)
full_test$management_group <- as.factor(full_test$management_group)
full_test$payment_type <- as.factor(full_test$payment_type)
full_test$water_quality <- as.factor(full_test$water_quality)
full_test$quality_group <- as.factor(full_test$quality_group)
full_test$quantity <- as.factor(full_test$quantity)
full_test$source <- as.factor(full_test$source)
full_test$source_type <- as.factor(full_test$source_type)
full_test$source_class <- as.factor(full_test$source_class)
full_test$waterpoint_type <- as.factor(full_test$waterpoint_type)
full_test$waterpoint_type_group <- as.factor(full_test$waterpoint_type_group)

full_test <- select(full_test, -region_code, -district_code)

# full_test <- select(full_test, -waterpoint_type_group, -source_class, -source_type, -quality_group, 
#                      -management_group, -extraction_type_class, -extraction_type_group, -permit, -population)
