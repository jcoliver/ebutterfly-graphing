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

# Original data file is all_records_2017_01_11_08_09_57.csv
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

################################################################################
# Graph with the ggmap package, plotting density

# Map boundaries for get_map: left, bottom, right, top
map.bounds <- c(-165, 20, -50, 70)
# Location: left, bottom, right, top
north.america <- get_map(location = map.bounds, source = "stamen", maptype = "toner-lite")
checklist.map <- ggmap(north.america) + 
  stat_density2d(data = checklist.data,
                 aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..),
                 geom = "polygon",
                 bins = 200) +
  scale_fill_gradient(low = "#0000FF", high = "#FF0000") +
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
print(checklist.map)
ggsave(checklist.map, filename = "output/figure-2-ggmap.pdf", width = 6, height = 9, units = "in")
ggsave(checklist.map, filename = "output/figure-2-ggmap.png", width = 6, height = 4.125, units = "in")
