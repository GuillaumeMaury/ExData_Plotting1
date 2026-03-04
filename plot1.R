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

# plot : Global Active Power
png("plot1.PNG")
hist(data$Global_active_power, 
     col="red",
     xlab="Global Active Power (kilowatts)",
     ylim=c(0,1300),
     main="Global Active Power")
dev.off()
