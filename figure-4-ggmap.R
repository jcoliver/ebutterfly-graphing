# Plotting Danaus plexippus migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-30

rm(list = ls())

################################################################################
# SUMMARY
# Plots observations of Danaus plexippus over three months in 2012 (May, June, 
# July).
# Uses ggmap & ggplot for display

################################################################################
# SETUP
# Load dependancies
# Load data

# Load dependencies
# install.packages("ggplot2")
library("ggplot2")
# install.packages("ggmap")
library("ggmap")

# Load data
dplex.data <- read.csv(file = "data/danaus-plexippus-data.csv", 
                       stringsAsFactors = FALSE)

# Subset as appropriate
dplex.data <- dplex.data[dplex.data$Year == 2012, ] # To be sure
incl.months <- c(5, 6, 7)
dplex.data <- dplex.data[dplex.data$Month %in% incl.months, ]
dplex.data$MonthName <- "May 2012"
dplex.data$MonthName[dplex.data$Month == 6] <- "June 2012"
dplex.data$MonthName[dplex.data$Month == 7] <- "July 2012"
dplex.data$MonthName <- factor(dplex.data$MonthName, levels = c("May 2012", "June 2012", "July 2012"))

################################################################################
# Graph with the ggmap package, plotting density

# Map boundaries for get_map: left, bottom, right, top
map.bounds <- c(-124, 41, -52, 55) # One point at 57.33 Lat
# Location: left, bottom, right, top
canada.map <- get_map(location = map.bounds, source = "stamen", maptype = "toner-lite")

# POINT MAP
dplex.map <- ggmap(canada.map) + 
  geom_point(data = dplex.data, 
             aes(x = Longitude, y = Latitude), 
             shape = 21,
             fill = "orangered",
             color = "black",
             size = 2) +
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  facet_wrap(~MonthName, nrow = 3)
print(dplex.map)
ggsave(dplex.map, filename = "output/figure-4-ggmap-points.pdf", width = 6, height = 9, units = "in")
ggsave(dplex.map, filename = "output/figure-4-ggmap-points.png", width = 6, height = 9, units = "in")

# POINT DENSITY MAP
dplex.map <- ggmap(canada.map) + 
  stat_density2d(data = dplex.data,
                 aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..),
                 geom = "polygon",
                 bins = 60) +
  scale_fill_gradient(low = "#0000FF", high = "#FF0000") +
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  facet_wrap(~MonthName, nrow = 3)
print(dplex.map)
ggsave(dplex.map, filename = "output/figure-4-ggmap-density.pdf", width = 6, height = 9, units = "in")
