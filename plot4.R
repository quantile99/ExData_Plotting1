## plot 4

##
## Get data if you haven't got it
##
file = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file, destfile = "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip")

##
## Cleaning up data
##
# read in data file
pc <- read.table(file="household_power_consumption.txt", sep = ";", 
                 header = TRUE, 
                 stringsAsFactors = FALSE)


# add a column for filtering dates
pc$Date1 <- as.Date(pc$Date, format = "%d/%m/%Y")
# keep only desired dates
pc <- pc[pc$Date1 >= "2007-02-01" & pc$Date1 <= "2007-02-02", ]
# introduce new POSIXct column for continuous display
pc <- transform(pc, DateTime = strptime(paste(pc$Date, pc$Time), format = "%d/%m/%Y %H:%M:%S"))
# make Sub_metering_X numeric so we can plot it.
pc <- transform(pc, Sub_metering_1 = as.numeric(Sub_metering_1))
pc <- transform(pc, Sub_metering_2 = as.numeric(Sub_metering_2))
pc <- transform(pc, Sub_metering_3 = as.numeric(Sub_metering_3))
pc <- transform(pc, Global_active_power = as.numeric(Global_active_power))
pc <- transform(pc, Global_reactive_power = as.numeric(Global_reactive_power))
pc <- transform(pc, Voltage = as.numeric(Voltage))


##
## Plotting data
##
## open png device
png(filename = "plot4.png", width = 480, height = 480, units = "px")

# create a 2x2 multi-plot, scale font down
par(mfrow = c(2,2), cex = .7)
# create a function to group plots together. Otherwise I only get the last plot in the output.
plot.all <- function() {
    # Plot 1
    plot(pc$DateTime, pc$Global_active_power, ylab="Global Active Power", type = "o", pch = "", xlab = "")
    # Plot 2
    plot(pc$DateTime, pc$Voltage, ylab="Voltage", type = "o", pch = "", xlab = "datetime")
    
    # Plot 3. This is also a function.
    # y-axis minimum value
    plot.3 <- function() {
        ymin <- min(c(min(pc$Sub_metering_1), min(pc$Sub_metering_2), min(pc$Sub_metering_3)))
        # y-axis maximum value
        ymax <- max(c(max(pc$Sub_metering_1), max(pc$Sub_metering_2), max(pc$Sub_metering_3)))
        # x-axis minimum value
        xmin <- min(pc$DateTime)
        # x-axis maximum value
        xmax <- max(pc$DateTime)
        ## generate empty plot, with x and y axis minimums pre-calculated.
        plot(pc$DateTime, rep(0, length(pc$DateTime)), 
             xlim = c(xmin, xmax), ylim = c(ymin,ymax), 
             type = "n", xlab="", ylab="Energy Submetering", pch = "")
        # add lines
        lines(pc$DateTime, pc$Sub_metering_1, type = "o", pch = "", col="black")
        lines(pc$DateTime, pc$Sub_metering_2, type = "o", pch = "", col="red")
        lines(pc$DateTime, pc$Sub_metering_3, type = "o", pch = "", col="blue")
        
        
        # add legend
        legend("topright", 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               col = c("black","red","blue"),
               lty = c(1, 1, 1) )
    
    }
    plot.3()
    
    #Plot 4
    plot(pc$DateTime, pc$Global_reactive_power, ylab="Global_reactive_power", type = "o", pch = "", xlab = "datetime")
}
plot.all()
## close device
dev.off()