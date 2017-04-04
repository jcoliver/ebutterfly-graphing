# Graphing observations and checklists over time
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-25

rm(list = ls())

################################################################################
submission.data <- read.csv(file = "data/submission-data.csv")
output.file <- "output/figure-1"
output.format <- "png"

# Create a date column
add.zero <- submission.data$month < 10
submission.data$month[add.zero] <- paste0("0", submission.data$month[add.zero])
submission.data$date <- as.Date(paste0(as.character(submission.data$year), 
                                       submission.data$month, 
                                       "01"), 
                                "%Y%m%d")

# Set up graphics values (colors, widths, etc.)
line.cols <- c("black", "steelblue3", "black")
line.types <- c(1, 1, 2)
line.widths <- c(3, 3, 3)

# Positioning and labels for x-axis
x.ticks <- as.Date(c("20120101", "20130101", "20140101", "20150101", "20160101", "20170101"), "%Y%m%d")
x.labels <- c("2012", "2013", "2014", "2015", "2016")
x.label.at <- as.Date(c("20120701", "20130701", "20140701", "20150701", "20160701"), "%Y%m%d")
################################################################################
# Two-panel graph:
# Top is Observations over time
# Bottom is Checklists over time

# Open graphics device
if (output.format == "png") {
  png(file = paste0(output.file, ".", output.format))
} else {
  pdf(file = paste0(output.file, ".pdf"), useDingbats = FALSE)
}

# Set graphic parameters
par(mfrow = c(2, 1), # multi-figure, two rows
    mgp = c(2, 0.5, 0), # move axis title & labels close to axis
    mar = c(2, 4, 2, 2) + 0.1, # reduce margins
    las = 1) # for horizontal axis labels

# Plot observations
plot(x = submission.data$date,
     y = submission.data$observations / 1000,
     type = "l",
     col = line.cols[1],
     lty = line.types[1],
     lwd = line.widths[1],
     xlab = "",
     xaxt = "n",
     ylab = "Observations (x 1000)")
axis(side = 1, at = x.ticks, labels = FALSE)
axis(side = 1, at = x.label.at, tick = FALSE, labels = x.labels)

# Plot checklists
# Plot all checklists first
plot(x = submission.data$date,
     y = submission.data$all.checklist / 100,
     type = "l",
     col = line.cols[2],
     lty = line.types[2],
     lwd = line.widths[2],
     xlab = "",
     xaxt = "n",
     ylab = "Checklists (x 100)")
axis(side = 1, at = x.ticks, labels = FALSE)
axis(side = 1, at = x.label.at, tick = FALSE, labels = x.labels)

# Add complete checklists
points(x = submission.data$date,
       y = submission.data$complete.checklist / 100,
       type = "l",
       col = line.cols[3],
       lty = line.types[3],
       lwd = line.widths[3])
legend("topleft", 
       legend = c("All Checklists", "Complete Checklists"),
       col = line.cols[2:3], 
       lty = line.types[2:3], 
       lwd = line.widths[2:3] - 1,
       cex = 0.8)

# restore graphics defaults
par(mfrow = c(1, 1),
    mgp = c(3, 1, 0),
    mar = c(5, 4, 4, 2) + 0.1, 
    las = 0)

dev.off()