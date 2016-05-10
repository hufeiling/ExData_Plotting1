setwd("C:/Users/hufeiling/learning/datascience/datasciencecoursera/Class4ExploratoryAnalysis/Week1/Project")
HouseholdData<-read.table("HouseholdData/household_power_consumption.txt",sep=";",header=T)
ProjectData<-HouseholdData[(as.Date(HouseholdData$Date,"%d/%m/%Y")>="2007-02-01"&as.Date(HouseholdData$Date, "%d/%m/%Y")<="2007-02-02"),]
Plot1Data<-ProjectData[ProjectData$Global_active_power!="?",]
png(filename="GitHub/plot1.png")
hist(as.numeric(as.character(Plot1Data$Global_active_power)),col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.off()
