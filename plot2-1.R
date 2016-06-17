# Set working directory and read data

setwd("C:/Users/hufeiling/learning/datascience/datasciencecoursera/Class4ExploratoryAnalysis/Week1/Project")
HouseholdData<-read.table("HouseholdData/household_power_consumption.txt",sep=";",header=T)

# Subset data

ProjectData<-HouseholdData[(as.Date(HouseholdData$Date,"%d/%m/%Y")>="2007-02-01"&as.Date(HouseholdData$Date, "%d/%m/%Y")<="2007-02-02"),]
Plot2Data<-ProjectData[ProjectData$Global_active_power!="?",]

# Add DateTime variable

Plot2Data$DateTime<-with(Plot2Data, as.POSIXct(paste(Plot2Data$Date, Plot2Data$Time), format="%d/%m/%Y %H:%M:%S"))

#Plot 2

png(filename="GitHub/plot2.png",width = 480, height = 480, units = "px")
plot(Plot2Data$DateTime,as.numeric(as.character(Plot2Data$Global_active_power)),type="l",xlab="",ylab="Global Active Power (kilowatts)")
dev.off()

