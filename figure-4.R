# Plotting Danaus plexippus migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-30

rm(list = ls())

################################################################################
# SUMMARY
# Plots observations of Danaus plexippus over three months in 2012 (May, June, 
# July).

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
dplex.data <- read.csv(file = "data/danaus-plexippus-data.csv", 
                       stringsAsFactors = FALSE)

# Subset as appropriate
dplex.data <- dplex.data[dplex.data$Year == 2012, ] # To be sure
incl.months <- c(5, 6, 7)
dplex.data <- dplex.data[dplex.data$Month %in% incl.months, ]

################################################################################
# Plotting points on map, one map for each of three days

long.bound <- c(-124, -56)
lat.bound <- c(41, 58) # lower limit must be < 43, or Lakes Erie & Ontario won't be drawn
# CONSIDER making the upper lat limit 48, as the tail is quite long, and there 
# aren't (relatively) many points above

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

pdf(file = "output/figure-4.pdf", useDingbats = FALSE)
par(mfrow = c(3, 1),
    mar = c(1, 2, 1, 1) + 0.1)
for (one.month in incl.months) {
  to.plot <- dplex.data[dplex.data$Month == one.month, ]
  # Create plot for desired data
  
  # Use map to establish the image boundaries, as plot will *expand* the drawing area if 
  # it is called first
  map(database = "worldHires", 
      xlim = long.bound, 
      ylim = lat.bound,
      fill = TRUE,
      col = "#E7E7E7")
  # Add lakes
  map(database = "lakes", add = TRUE,
      xlim = long.bound,
      ylim = lat.bound,
      col = "#FFFFFF",
      fill = TRUE)
  # Add points
  points(x = to.plot$Longitude,
         y = to.plot$Latitude,
         cex = 1.2, 
         pch = 21, 
         bg = "orangered",
         col = "black")
  legend("bottomright", 
         legend = one.month, # FIX
         cex = 2.0,
         bty = "n")
}
par(mfrow = c(1, 1),
    mar = c(5, 4, 4, 2) + 0.1)
dev.off()
