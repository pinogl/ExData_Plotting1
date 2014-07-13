# setwd("E:/Courses/Coursera/DSS4 - EDA/projects/prj1")

# set locale in order to get English names for time related variables
Sys.setlocale("LC_TIME", "English")

# define the columns dataype
cols <- c(rep("character", 2), rep("numeric", 7))

# compute skip and nrows parameters for read.table function 
d0 <- as.POSIXct("16/12/2006 17:24:00", format="%d/%m/%Y %H:%M:%S")
d1 <- as.POSIXct("1/2/2007", format="%d/%m/%Y")
d2 <- as.POSIXct("3/2/2007", format="%d/%m/%Y")
skip <- as.numeric(difftime(d1, d0, units="mins")) + 1 # header row
nrows <-  as.numeric(difftime(d2, d1, units="mins"))

# read only the required part fo the data set
hepc <- read.table("household_power_consumption.txt", sep=";", colClasses=cols,
                   nrows=nrows, skip=skip, stringsAsFactors=FALSE,
                   na.strings="?", comment.char="")

# set the name from the first row
names(hepc) <-  read.table("household_power_consumption.txt", sep=";", nrows=1,
                           stringsAsFactors=FALSE)

# create the datetime variable
hepc$datetime <- as.POSIXct(paste(hepc$Date, hepc$Time, sep=" "),
                            format="%d/%m/%Y %H:%M:%S")

# add 'day of week' variable
hepc$dow = as.factor(weekdays(hepc$datetime, abbreviate=TRUE))  # day of week

# keep only relevantvariables and reorder them
hepc <- hepc[c(10:11, 3:9)]

# Plot4
png(file="plot4.png", width=480, height=480, bg="transparent")

par(mfrow=c(2,2))

with(hepc, {
    plot(datetime, Global_active_power, type = "l", xlab = "", 
         ylab = "Global Active Power", main = "")
    
    plot(datetime, Voltage, type = "l", main = "")
    
    plot(hepc$datetime, hepc$Sub_metering_1, type = "n", xlab = "", 
         ylab = "Energy sub metering", main = "")
    lines(hepc$datetime, hepc$Sub_metering_1, col = "black")
    lines(hepc$datetime, hepc$Sub_metering_2, col = "red")
    lines(hepc$datetime, hepc$Sub_metering_3, col = "blue")
    legend("topright", names(hepc)[7:9], col=c('black','red', 'blue'), bty="n")
    
    plot(datetime, Global_reactive_power, type = "l", main = "")    
})

dev.off()

# reset time locale to the default value
Sys.setlocale("LC_TIME", "")