## plot 1

##
## Get data if you haven't got it
##
file = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file, destfile = "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip")

##
## Cleaning up data
##
pc <- read.table("household_power_consumption.txt", sep = ";", header = TRUE,
                 stringsAsFactors = FALSE)
pc <- transform(pc, Date = as.Date(Date, format = "%d/%m/%Y"))
# keep only desired dates
pc <- pc[pc$Date >= "2007-02-01" & pc$Date <= "2007-02-02", ]
pc <- transform(pc, Time = strptime(Time, format = "%H:%M:%S"))
pc <- transform(pc, Global_active_power = as.numeric(Global_active_power))


## scale font down
par(cex = .7) ## scale font down
## open png device
png(filename = "plot1.png",width = 480, height = 480, units = "px")
## generate histogram
hist(pc$Global_active_power, xlab="Global Active Power (kilowatts)", col = "red", main = "Global Active Power")
## close device
dev.off()