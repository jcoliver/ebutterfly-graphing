# Plotting Vanessa atalanta migration 2012
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-27

rm(list = ls())

################################################################################
vatal.data <- read.delim(file = "data/vanessa-atalanta-data.txt")

# Plotting points on map, color by date


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
