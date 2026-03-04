library(tidyverse)
library(data.table)

#load
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, dest)

# List contents
unzip(dest, list = TRUE)

# Extract
unzip(dest, exdir = "/Users/xaviermaury/Documents/Exdata")

# Make a data.table with the selected dates
system("grep '^[12]/2/2007;' household_power_consumption.txt > subset.txt")
system("head -n 1 household_power_consumption.txt > names.txt")
data <- read.table("subset.txt", sep = ";", header = FALSE)
df <-fread("names.txt", sep = ";", header = TRUE)
colnames(data)<-colnames(df)
data<-rbind(df,data)
rm(dest,url,df)

# Make a datetime column
#data<-data %>% unite("datetime", Date, Time, sep=" ")
data[, datetime := as.POSIXct(paste(Date, Time),
                              format = "%d/%m/%Y %H:%M:%S")]
data[,c("Date","Time") := NULL]

# plot : Global Active Power per minute average, through 2 days
png("plot2.PNG")
plot(data$datetime,data$Global_active_power,type="l",
     xlab = "Global Active Power (kilowatts)",
     ylim=c(0,8))

dev.off()
