# Set working directory and read data

setwd("/datascience/datasciencecoursera/Class4ExploratoryAnalysis/Week1/Project")
HouseholdData<-read.table("HouseholdData/household_power_consumption.txt",sep=";",header=T)

# Subset data

ProjectData<-HouseholdData[(as.Date(HouseholdData$Date,"%d/%m/%Y")>="2007-02-01"&as.Date(HouseholdData$Date, "%d/%m/%Y")<="2007-02-02"),]
Plot3Data<-ProjectData[(ProjectData$Sub_metering_1)!="?"&(ProjectData$Sub_metering_2)!="?"&(ProjectData$Sub_metering_3)!="?",]

# Add DateTime variable

Plot3Data$DateTime<-with(Plot3Data, as.POSIXct(paste(Plot3Data$Date, Plot3Data$Time), format="%d/%m/%Y %H:%M:%S"))

#Plot 3
#Create the frame
png(filename="GitHub/plot3.png", width = 480, height = 480, units = "px")
with(Plot3Data, plot(Plot3Data$DateTime,as.numeric(as.character(Plot3Data$Sub_metering_1)),type="l",xlab="",ylab="Energy sub metering"))
#Add the red line
lines(Plot3Data$DateTime,as.numeric(as.character(Plot3Data$Sub_metering_2)),col="red")
#Add the blue line
lines(Plot3Data$DateTime,as.numeric(as.character(Plot3Data$Sub_metering_3)),col="blue")
#Add legend
legend("topright",lty=1,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),cex=0.6)
dev.off()




