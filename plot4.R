# create plots of household power consumption 
# Measurements of electric power consumption in one household with a one-minute sampling rate over
# a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.
# delimited by ;, missing data is ?
#Date: Date in format dd/mm/yyyy
#Time: time in format hh:mm:ss
#Global_active_power: household global minute-averaged active power (in kilowatt)
#Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#Voltage: minute-averaged voltage (in volt)
#Global_intensity: household global minute-averaged current intensity (in ampere)
#Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

# get the data and unzip it, put in a data table (gets entire file)
#url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#temp <- tempfile()
#download.file(url,temp)
#power <- read.table(unz(temp, "household_power_consumption.txt") sep=";", header = TRUE)
#unlink(temp)
###
library(downloader)
library(sqldf)


#download and unzip, might this be combined?
url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download(url, dest="hpc.zip", mode="wb") 
unzip ("hpc.zip")
powers <- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where Date = "1/2/2007" or Date = "2/2/2007"', sep = ";", header = TRUE)
#2880 observations
powers$datetime <- strptime(paste(powers$Date, powers$Time, sep = " "), "%d/%m/%Y %H:%M:%S")

png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
with(powers,{
  
  plot(datetime, Global_active_power, type = "l" , ylab = "Global Active Powere (kilowatts)", xlab = "")
  plot(datetime, Voltage, type = "l" , ylab = "Voltage", xlab = "datetime")
  plot(datetime, Sub_metering_1, type = 'l', ylab = "Energy SubMetering", xlab = "")
  lines(datetime, Sub_metering_2, type = 'l', col = 'red')
  lines(datetime, Sub_metering_3, type = 'l', col = 'blue')
  legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 2, col = c("black", "red","blue"), bty = "n")
  plot(datetime,  Global_reactive_power, type = 'l')
  
})
dev.off()
