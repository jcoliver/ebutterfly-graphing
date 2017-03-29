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
vatal.data <- read.delim(file = "data/vanessa-atalanta-data.txt")

################################################################################
# Plotting points on map, one map for each of three days
long.bound <- c(-85, -60)
lat.bound <- c(41, 48)

dates <- c("2012-04-15", "2012-04-16", "2012-04-17")
all.points <- vatal.data[vatal.data$date %in% dates, ]


pdf(file = "output/figure-3-maps.pdf", useDingbats = FALSE)
# png(file = "output/figure-3-maps.png")
par(mfrow = c(3, 1))
for (one.date in dates) {
  to.plot <- vatal.data[vatal.data$date == one.date, ]
  map(database = "worldHires",
      xlim = long.bound,
      ylim = lat.bound,
      col = "#E7E7E7",
      fill = TRUE)
  points(x = to.plot$longitude,
         y = to.plot$latitude,
         cex = 1.2, 
         pch = 21, 
         bg = "black",
         col = "black")
  
}
par(mfrow = c(1, 1))
dev.off()


map(database = "worldHires",
    xlim = long.bound,
    ylim = lat.bound,
    col = "#E7E7E7",
    fill = TRUE)
points(x = vatal.data$longitude,
       y = vatal.data$latitude,
       cex = 1.2, 
       pch = 21, 
       bg = "red",
       col = "black")


map(database = "worldHires", 
    xlim = c(-125, -115), 
    ylim = c(31, 41), 
    col = "#E7E7E7", 
    fill = TRUE)
points(x = localities$longitude, 
       y = localities$latitude, 
       cex = 1.2, 
       pch = 21, 
       bg = point.cols, 
       col = "black")



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
