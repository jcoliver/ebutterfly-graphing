# Plotting Vanessa atalanta migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-27

rm(list = ls())

################################################################################
# SUMMARY
# Plots observations of Vanessa atalanta over three days in 2012 (15-17 April).
# Uses SpatialPolygons2map (via generic `plot` call)

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

################################################################################
# Graph with the ggmap package, plotting density

# Map boundaries for get_map: left, bottom, right, top
map.bounds <- c(-85, 42, -60, 48)
# Omit one point that is very far north
vatal.data <- vatal.data[vatal.data$latitude < 54, ]
# Location: left, bottom, right, top
canada.map <- get_map(location = map.bounds, source = "stamen", maptype = "toner-lite")
vatal.map <- ggmap(canada.map) + 
  stat_density2d(data = vatal.data,
                 aes(x = longitude, y = latitude, fill = ..level.., alpha = ..level..),
                 geom = "polygon",
                 bins = 25) +
  scale_fill_gradient(low = "#0000FF", high = "#FF0000") +
  # geom_point(data = vatal.data, aes(x = longitude, y = latitude))
  theme(legend.position = "none") +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  facet_wrap(~date, nrow = 3)
print(vatal.map)
ggsave(vatal.map, filename = "output/figure-3-ggmap.pdf", width = 6, height = 9, units = "in")


################################################################################
# SETUP
# Load dependancies
# Load data

# Load dependancies
#install.packages("maps")
library("maps")
#install.packages("mapdata")
library("mapdata")
#install.packages("sp")
#install.packages("raster")
library("raster")

# Load data
vatal.data <- read.csv(file = "data/vanessa-atalanta-data.csv", 
                       stringsAsFactors = FALSE)

################################################################################
# Plotting points on map, one map for each of three days

long.bound <- c(-85, -60)
lat.bound <- c(41, 48) # lower limit must be < 43, or Lakes Erie & Ontario won't be drawn

dates <- c("2012-04-15", "2012-04-16", "2012-04-17")

us <- getData(name = "GADM", country = "USA", level = 1, path = "data/")
canada <- getData(name = "GADM", country = "CAN", level = 1, path = "data/")

# Subsetting data draws maps faster
us.states <- c("Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island",
               "Connecticut", "New York", "New Jersey", "Pennsylvania", "Ohio",
               "Michigan", "Indiana", "Deleware", "Maryland", "West Virginia", 
               "Virginia", "Kentucky", "District of Columbia")
us.state.data <- us[us$NAME_1 %in% us.states, ]
ca.provinces <- c("Ontario", "Québec", "New Brunswick", "Nova Scotia", 
                  "Prince Edward Island")
ca.province.data <- canada[canada$NAME_1 %in% ca.provinces, ]

pdf(file = "output/figure-3.pdf", useDingbats = FALSE)
par(mfrow = c(3, 1),
    mar = c(1, 2, 1, 1) + 0.1)
for (one.date in dates) {
  to.plot <- vatal.data[vatal.data$date == one.date, ]
  # Create plot for desired data

  # Use map to establish the image boundaries, as plot will *expand* the drawing area if 
  # it is called first
  map(database = "worldHires", 
      xlim = long.bound, 
      ylim = lat.bound)
  # Draw US States
  # plot(us.state.data,
  #      col = "#E7E7E7",
  #      add = TRUE)
  map(us.state.data,
      col = "#E7E7E7",
      fill = TRUE,
      add = TRUE,
      namefield = "NAME_1") # Will issue warning without this
  # Add Canada provinces
  # plot(ca.province.data,
  #      col = "#E7E7E7",
  #      add = TRUE)
  map(ca.province.data,
      col = "#E7E7E7",
      fill = TRUE,
      add = TRUE,
      namefield = "NAME_1") # Will issue warning without this
  # Add lakes
  map(database = "lakes", add = TRUE,
      xlim = long.bound,
      ylim = lat.bound,
      col = "#FFFFFF",
      fill = TRUE)
  # Add points
  points(x = to.plot$longitude,
         y = to.plot$latitude,
         cex = 1.2, 
         pch = 21, 
         bg = "orangered",
         col = "black")
  legend("bottomright", 
         legend = one.date, 
         cex = 2.0,
         bty = "n")
}
par(mfrow = c(1, 1),
    mar = c(5, 4, 4, 2) + 0.1)
dev.off()
