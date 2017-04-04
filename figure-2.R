# Mapping observation/checklist density
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-31

rm(list = ls())

################################################################################
# See: https://visualecology.wordpress.com/2014/09/29/displaying-plots-or-points-by-density-in-r-with-the-ggmap-package/

# Load dependencies
# install.packages("ggplot2")
library("ggplot2")
# install.packages("ggmap")
library("ggmap")


# Cleaned these data, dropping deg, min, sec records via (in bash):
# grep [^0-9a-zA-Z,\-\.\:\s] observation-data.csv > observation-data-clean.csv
# sed "s/'/REPLACEME/g" observation-data-clean.csv > observation-data-clean-02.csv
# sed 's/"/REPLACEME/g' observation-data-clean-02.csv > observation-data-clean-03.csv
# grep -v REPLACEME observation-data-clean-03.csv > observation-data-clean-04.csv
# STILL had to open in text editor and find/replace degree symbol
# And deleted lines with N42.66423, W110.88 format, too (could have probably been done with sed or grep)
# And found lines with 49 40.2 N,125.23.55 W, so used text editor find/replace on [0-9]{3}\.[0-9]{2}\.
# Same as line above with search [0-9]{2}\.[0-9]{2}\.

obs.data <- read.csv(file = "data/observation-data-clean-04.csv", header = TRUE)
# Just take first occurrence of a checklist
checklist.data <- obs.data[!duplicated(obs.data$ChecklistID), ]
checklist.data$Longitude <- as.numeric(as.character(checklist.data$Longitude))
checklist.data$Latitude <- as.numeric(as.character(checklist.data$Latitude))
checklist.data <- checklist.data[!is.na(checklist.data$Longitude), ]
checklist.data <- checklist.data[!is.na(checklist.data$Latitude), ]

# Very brute force, get rid of anything with unreasonable lat/long
# Lat bounds: 20, 70
# Long bounds: -180, -50
checklist.data <- checklist.data[checklist.data$Latitude >= 20 & checklist.data$Latitude <= 70, ]
checklist.data <- checklist.data[checklist.data$Longitude >= -180 & checklist.data$Longitude <= -50, ]

