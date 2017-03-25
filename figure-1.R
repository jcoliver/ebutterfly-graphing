# Graphing observations and checklists over time
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-25

rm(list = ls())

################################################################################
submission.data <- read.csv(file = "data/submission-data.csv")

add.zero <- submission.data$month < 10

submission.data$month[add.zero] <- paste0("0", submission.data$month[add.zero])

submission.data$date <- as.Date(paste0(as.character(submission.data$year), 
                                       submission.data$month, 
                                       "01"), 
                                "%Y%m%d")

line.cols <- c("darkred", "steelblue3", "black")
line.types <- c(1, 1, 3)
################################################################################
# Two-panel graph, top is Observations over time
# Bottom is checklists over time
par(mfrow = c(2, 1))

par(mgp = c(2, 0.5, 0), # default mgp = c(3, 1, 0)
    las = 1) # for horizontal axis labels
# Plot observations on left-hand y-axis
plot(x = submission.data$date,
     y = submission.data$observations / 1000,
     type = "l",
     col = line.cols[1],
     lty = line.types[1],
     lwd = 2,
     xlab = "",
     ylab = "Observations (x 1000)")

# Checklists vs complete checklists
# Plot all checklists first
plot(x = submission.data$date,
     y = submission.data$all.checklist / 100,
     type = "l",
     col = line.cols[2],
     lty = line.types[2],
     lwd = 3,
     xlab = "",
     ylab = "Checklists (x 100)")

# Add complete checklists
points(x = submission.data$date,
       y = submission.data$complete.checklist / 100,
       type = "l",
       col = line.cols[3],
       lty = line.types[3],
       lwd = 3)
legend("topleft", 
       legend = c("All Checklists", "Complete Checklists"),
       col = line.cols[2:3], 
       lty = line.types[2:3], 
       lwd = 2,
       cex = 0.7)

par(mfrow = c(1, 1))

################################################################################
# For plotting two y-axes
par(mar = c(5, 4, 4, 5) + 0.1)
# Plot observations on left-hand y-axis
plot(x = submission.data$date,
     y = submission.data$observations,
     type = "l",
     col = "darkred",
     lwd = 2,
     xlab = "Date",
     ylab = "# Observations")

# Now plot checklists on right-hand y-axis
par(new = TRUE)
plot(x = submission.data$date,
     y = submission.data$all.checklist,
     type = "l",
     col = "cadetblue",
     lwd = 2,
     xaxt = "n",
     yaxt = "n",
     xlab = "",
     ylab = "")
axis(side = 4)
mtext(text = "# Checklists", side = 4, line = 3)
legend("topleft", 
       legend = c("Observations", "Checklists"),
       col = c("darkred", "cadetblue"), 
       lty = 1, 
       lwd = 1,
       cex = 0.6)
