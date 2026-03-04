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

#Pivot_longer on Sub_metering to obtain one series
data2<-data%>%pivot_longer(names_to="Sub_metering",cols=starts_with("Sub_metering_"))

# Plot Energy Sub metering per day
png("plot3.PNG")
plot(data$datetime,data$Sub_metering_1,type="l",ylab="Energy sub metering")
lines(data$datetime,data$Sub_metering_2,type="l",col="red")
lines(data$datetime,data$Sub_metering_3,type="l",col="blue")
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col = c("black","red","blue"),
       lwd=2,
       lty=1)
dev.off()

