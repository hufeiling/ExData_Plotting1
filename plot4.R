# Set working directory and read data

setwd("C:/Users/hufeiling/learning/datascience/datasciencecoursera/Class4ExploratoryAnalysis/Week1/Project")
HouseholdData<-read.table("HouseholdData/household_power_consumption.txt",sep=";",header=T)

# Subset data

ProjectData<-HouseholdData[(as.Date(HouseholdData$Date,"%d/%m/%Y")>="2007-02-01"&as.Date(HouseholdData$Date, "%d/%m/%Y")<="2007-02-02"),]
Plot4Data<-ProjectData[ProjectData$Global_reactive_power!="?",]

# Add DateTime variable

Plot4Data$DateTime<-with(Plot4Data, as.POSIXct(paste(Plot4Data$Date, Plot4Data$Time), format="%d/%m/%Y %H:%M:%S"))

# Plot 4

# Setup the frame
png(filename="GitHub/plot4.png")
par(mfcol=c(2,2),mar=c(1,4,1,1))
# 1st plot in Plot 4
plot(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Global_active_power)),type="l",xlab="",ylab="Global Active Power(kilowatts)")
# 2nd plot in Plot 4
with(Plot4Data, plot(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Sub_metering_1)),type="l",xlab="",ylab="Energy sub metering"))
lines(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Sub_metering_2)),col="red")
lines(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Sub_metering_3)),col="blue")
legend("topright",lty=1,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex=0.6)
# 3rd plot in Plot 4
plot(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Voltage)),type="l",xlab="",ylab="Voltage")
# 4th plot in Plot 4
plot(Plot4Data$DateTime,as.numeric(as.character(Plot4Data$Global_reactive_power)),type="l",xlab="",ylab="Global Reactive Power(kilowatts)")
dev.off()
