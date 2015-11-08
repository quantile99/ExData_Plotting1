## plot 2

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
pc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE
                 ,stringsAsFactors = FALSE)

# add a column for filtering dates
pc$Date1 <- as.Date(pc$Date, format = "%d/%m/%Y")

# keep only desired dates
pc <- pc[pc$Date1 >= "2007-02-01" & pc$Date1 <= "2007-02-02", ]

# introduce new POSIXct column for continuous display
pc <- transform(pc, DateTime = strptime(paste(pc$Date, pc$Time), format = "%d/%m/%Y %H:%M:%S"))

# make Global_active_power numeric so we can plot it.
pc <- transform(pc, Global_active_power = as.numeric(Global_active_power))

##
## Plotting data
##

## scale font down
par(cex = .7) ## scale font down
## open png device
png(filename = "plot2.png", width = 480, height = 480, units = "px")
## generate plot
plot(pc$DateTime, pc$Global_active_power, ylab="Global Active Power (kilowatts)", type = "o", pch = "", xlab = "")
## close device
dev.off()

