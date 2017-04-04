# Plotting Vanessa atalanta migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-27

rm(list = ls())

################################################################################
# SUMMARY
# Plots observations of Vanessa atalanta over three days in 2012 (15-17 April).
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
vatal.data <- read.csv(file = "data/vanessa-atalanta-data.csv", 
                       stringsAsFactors = FALSE)
# Subset to only those three days of interest
vatal.data <- vatal.data[vatal.data$date %in% c("2012-04-15", "2012-04-16", "2012-04-17"), ]
# Omit one point that is very far north
vatal.data <- vatal.data[vatal.data$latitude < 54, ]

################################################################################
# Graph with the ggmap package

# Setup map boundaries
# Map boundaries for get_map: left, bottom, right, top
map.bounds <- c(-85, 42, -60, 48)
# Location: left, bottom, right, top
canada.map <- get_map(location = map.bounds, source = "stamen", maptype = "toner-lite")

# POINT MAP
vatal.map <- ggmap(canada.map) + 
  geom_point(data = vatal.data, 
             aes(x = longitude, y = latitude), 
             shape = 21,
             fill = "orangered",
             color = "black",
             size = 2) +
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  facet_wrap(~date, nrow = 3)
print(vatal.map)
ggsave(vatal.map, filename = "output/figure-3-ggmap-points.pdf", width = 6, height = 9, units = "in")
ggsave(vatal.map, filename = "output/figure-3-ggmap-points.png", width = 6, height = 9, units = "in")

# POINT DENSITY MAP
vatal.map <- ggmap(canada.map) + 
  stat_density2d(data = vatal.data,
                 aes(x = longitude, y = latitude, fill = ..level.., alpha = ..level..),
                 geom = "polygon",
                 bins = 25) +
  scale_fill_gradient(low = "#0000FF", high = "#FF0000") +
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  facet_wrap(~date, nrow = 3)
print(vatal.map)
ggsave(vatal.map, filename = "output/figure-3-ggmap-density.pdf", width = 6, height = 9, units = "in")

