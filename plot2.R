#
# Program:      plot2.R
#
# Description:
#
#               The Code Processes The UCI Electric Power 
#               Consumption Dataset Into A Global Active 
#               Power Line Graph With The Days On The 
#               X-Axis And Global Active Power In Kilowatts 
#               On The Y-Axis For A Single Household Over The 
#               Two-Day Period From 01Feb2007 To 02Feb2007.
#
#               The Full Data Set Is Comprised Of 2,075,259 
#               Observations Of Nine Variables And Requires 
#               Roughly 285 MB Of Memory:
#               
#               2,075,259 x 9 x 8 bytes/number = 149,418,648 bytes
#               149,418,648 bytes / 2^20 bytes/MB = ~142.50 MB
#               ~142.50 MB x 2 = ~285MB
#
# Coursera:     Data Sciences => Exploratory Data Analysis - Project 1
# Author:       Marc Genty
# Last Updated: 07Jan15
#

# ==========================================================================
# Get Dataset And Unzip It:
# ==========================================================================

# Create The Working Directory If It Does Not Already Exist:
if (!file.exists("proj1data")) {
    dir.create("proj1data")
}

# Switch Into The Working Directory:
setwd("./proj1data/")

# Download The Data Set:
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="proj1data.zip", method="curl")

# Unzip The Files:
unzip("proj1data.zip")

# Remove ZIP File If Unzip Completed Successfully:
if (file.exists("household_power_consumption.txt")) {
    file.remove("proj1data.zip")
}

# Set stringsAsFactors Option Globally:
options(stringsAsFactors=FALSE)

# ==========================================================================
# Read And Subset The Dataset To The Two Days Of Interest: 01Feb07-02Feb07:
# ==========================================================================

# Read The Dataset & Replace "?" Characters With NA:
fullPowerDF <- read.table("household_power_consumption.txt", 
    colClasses = c(rep("character", 2), rep("numeric", 7)),
    header = TRUE, sep = ";",
    na.strings = c("?"))

# Convert Date And Time Fields To A Date/Time Class:
fullPowerDF$DateAndTime <- strptime(
    paste(fullPowerDF$Date, fullPowerDF$Time), 
    "%d/%m/%Y %H:%M:%S", 
    tz = "")
fullPowerDF <- fullPowerDF[, c(1, 2, 10, 3, 4, 5, 6, 7, 8, 9)]

# Subset Dataset To Just The Days Of Interest:
d1 <- "1/2/2007"
d2 <- "2/2/2007"
powerDF <- fullPowerDF[fullPowerDF$Date == d1 | fullPowerDF$Date == d2, ]
# Verify:
dim(powerDF) # (60 Min/Hr x 24 Hr/Day x 2 Days = 2880)

# Clean Up The Column Names:
names(powerDF) <- c("Date", "Time", "DateAndTime",
                    "GlobalActivePower", "GlobalReactivePower",
                    "Voltage", "GlobalIntensity",
                    "SubMetering1", "SubMetering2", "SubMetering3")

# ==========================================================================
# Output The Final Plot Image In png Format:
# ==========================================================================

# Open The Graphics Device:
png(file = "plot2.png", width = 480, height = 480)

# Make The Plot:
plot(powerDF$DateAndTime, powerDF$GlobalActivePower, 
    xlab = "", ylab = "Global Active Power (kilowatts)", 
    type = "n")
lines(powerDF$DateAndTime, powerDF$GlobalActivePower)

# Close The Graphics Device:
dev.off()

# Note: Opening The plot2.png In Preview On The Mac
#       And Hitting cmd-i (%-i) Verifies That The
#       Image Size Is 480 Pixels By 480 Pixels.

# That's It!
