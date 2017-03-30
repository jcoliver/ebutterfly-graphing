# Plotting Vanessa atalanta migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-27

rm(list = ls())

################################################################################
# SETUP
# Load dependancies
# Load data

# Load dependancies
#install.packages("maps")
library(maps)
#install.packages("mapdata")
library(mapdata)

# Load data
vatal.data <- read.csv(file = "data/vanessa-atalanta-data.csv", 
                       stringsAsFactors = FALSE)

################################################################################
# Plotting points on map, one map for each of three days
long.bound <- c(-85, -60)
lat.bound <- c(42, 47.5)

dates <- c("2012-04-15", "2012-04-16", "2012-04-17")

pdf(file = "output/figure-3-maps.pdf", useDingbats = FALSE)
# png(file = "output/figure-3-maps.png")
par(mfrow = c(3, 1),
    mar = c(1, 2, 1, 1) + 0.1)
for (one.date in dates) {
  to.plot <- vatal.data[vatal.data$date == one.date, ]
  map(database = "world",# "worldHires",
      xlim = long.bound,
      ylim = lat.bound,
      col = "#E7E7E7",
      fill = TRUE)
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




################################################################################
# Plotting points on map, one map for each of three days
#install.packages("maps")
library(maps)
#install.packages("sp")
#install.packages("raster")
library("raster")

long.bound <- c(-85, -60)
lat.bound <- c(41, 48) # lower limit must be < 43, or Lakes Erie & Ontario won't be drawn

dates <- c("2012-04-15", "2012-04-16", "2012-04-17")

us <- getData(name = "GADM", country = "USA", level = 1, path = "data/")
canada <- getData(name = "GADM", country = "CAN", level = 1)

# Subsetting data draws maps faster
us.states <- c("Maine", "New Hampshire", "Vermont", "Massachusetts", "Rhode Island",
               "Connecticut", "New York", "New Jersey", "Pennsylvania", "Ohio",
               "Michigan", "Indiana", "Deleware", "Maryland", "West Virginia", 
               "Virginia", "Kentucky", "District of Columbia")
us.state.data <- us[us$NAME_1 %in% us.states, ]
ca.provinces <- c("Ontario", "Québec", "New Brunswick", "Nova Scotia", 
                  "Prince Edward Island")
ca.province.data <- canada[canada$NAME_1 %in% ca.provinces, ]


pdf(file = "output/figure-3-maps.pdf", useDingbats = FALSE)
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
      add = TRUE)
  # Add Canada provinces
  # plot(ca.province.data, 
  #      col = "#E7E7E7", 
  #      add = TRUE)
  map(ca.province.data,
      col = "#E7E7E7",
      fill = TRUE,
      add = TRUE)
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

##########

par(mfrow = c(3, 1),
    mar = c(1, 2, 1, 1) + 0.1)
for (one.date in dates) {
  to.plot <- vatal.data[vatal.data$date == one.date, ]
  map(database = "world",# "worldHires",
      xlim = long.bound,
      ylim = lat.bound,
      col = "#E7E7E7",
      fill = TRUE)
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



# Plotting regression between start time and latitude for April 16
vatal.Apr.16 <- vatal.data[vatal.data$date == "2012-04-16", ]

vatal.Apr.16$hour <- as.numeric(gsub(":", ".", vatal.Apr.16$start.time))
# vatal.Apr.16$start.time <- strptime(x = paste0(vatal.Apr.16$date, " ", vatal.Apr.16$start.time), 
#                                     format = "%Y-%m-%d %H:%M")

lat.time.model <- lm(latitude ~ hour, data = vatal.Apr.16)
lat.time.a <- lat.time.model$coefficients['(Intercept)']
lat.time.b <- lat.time.model$coefficients['hour']

plot(x = vatal.Apr.16$hour, 
     y = vatal.Apr.16$latitude,
     xlab = "Start Time (h)",
     ylab = "Latitude",
     pch = 19,
     cex = 0.7,
     las = 1)
abline(a = lat.time.a, b = lat.time.b)
