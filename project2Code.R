setwd("/datascience/datasciencecoursera/Class4ExploratoryAnalysis/Week4/Project")

#read data

NEI<-readRDS("summarySCC_PM25.rds")
SCC<-readRDS("Source_Classification_Code.rds")

#Plot1:
#Subset data and calculate the sum of emissions by year in U.S.

PM25<-subset(NEI,Pollutant=="PM25-PRI")
TotalPM25<-with(PM25,tapply(Emissions,year,sum,na.rm=T))
Year<-names(TotalPM25)

#Create plot 1 to show the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008 across the country.

png(filename="GitHub/plot1.png")
plot(Year,TotalPM25,type="l",lwd=2,main="Total Emissions from PM2.5 in U.S.")

#Add points to the line
points(Year,TotalPM25,col="blue",pch=20,lwd=4)
dev.off()

#Analysis shows that total PM2.5 emission was decreasing from 1999-2008 in U.S.

#Plot2:
#Subset data and calculate the sum of emissions by year in Baltimore

PM25Bal<-subset(NEI,Pollutant=="PM25-PRI" & fips=="24510")
TotalPM25Bal<-with(PM25Bal,tapply(Emissions,year,sum,na.rm=T))
Year<-names(TotalPM25Bal)

#Create plot 2 to show the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008 in Baltimore City

png(filename="GitHub/plot2.png")
plot(Year,TotalPM25Bal,type="l",lwd=2,main="Total Emissions from PM2.5 in Baltimore")

#Add points to the line

points(Year,TotalPM25Bal,col="blue",pch=20,lwd=4)
dev.off()

#Analysis shows that total PM2.5 emission decreaed from 1999-2002, then increased a little from 2002-2005, and end up decreasing from 2005-2008 in U.S.


#Plot3:
#Subset the data for Baltimore City; Merge NEI data with SCC data by "SCC" as the key

PM25Bal<-subset(NEI,Pollutant=="PM25-PRI" & fips=="24510")
PM25BalSCC<-merge(PM25Bal,SCC,by="SCC")

#Calculate total emissions by year and type

library(plyr)
PM25BalSum<-ddply(PM25BalSCC,c("year","type"),summarize,EmissionTotal=sum(Emissions))

#Create plot 3; Differentiate 4 types by different color and smooth the points with a line

library(ggplot2)
png(filename="GitHub/plot3.png")
qplot(year,EmissionTotal,data=PM25BalSum,col=type,main="Different Types of Emissions from PM2.5 in Baltimore",geom=c("point", "smooth"))
dev.off()

#Analysis shows that emissions that belong to "Non-Road","On-Road" and "Non-Point" was decreasing from 1999-2008, but emissions that belong to "Point" decreaed from 1999-2002, then increased a little from 2002-2005, and end up decreasing from 2005-2008 in U.S. which contributes to the tread of the total emissions in Baltimore.

#Plot 4 - here we use 4 plots to show how emissions from coal combustion-related sources change from 1999¨C2008 across U.S. 
#Subset the data from coal combustion-related sources; Merge NEI data with SCC data by "SCC" as the key

CoalSCC<-SCC[grep("(.*)[Cc]oal(.*)[Cc]ombustion", SCC$Short.Name),]
NEICoalSCC<-merge(NEI,CoalSCC,by="SCC")


library(plyr)
library(ggplot2)
library(gridExtra)

#Create 1st plot which shows how total emissions changes over the years across U.S.
#Calculate total emissions

CoalSum1<-ddply(NEICoalSCC,c("year"),summarize,EmissionTotal=sum(Emissions))

png(filename="GitHub/plot4.png")
p1<-qplot(year,EmissionTotal,data=CoalSum1,main="Total Emissions from Coal Combustion in U.S.",geom=c("point", "smooth"))

#Create the 2nd plot which shows how total emission changes by industry (SCC.Level.Two) over the years across U.S.

CoalSum2<-ddply(NEICoalSCC,c("year","SCC.Level.Two"),summarize,EmissionTotal=sum(Emissions))
p2<-qplot(year,EmissionTotal,data=CoalSum2,col=SCC.Level.Two,main="Emissions from Coal by Industry in U.S.",geom=c("point", "smooth"))

#Create the 3rd plot which shows how total emission changes by Coal Type (SCC.Level.Four) over the years across U.S.

CoalSum3<-ddply(NEICoalSCC,c("year","SCC.Level.Four"),summarize,EmissionTotal=sum(Emissions))

#Create a new column with a concised label to use as legend
CoalSum3$SCCType<-gsub("Atmospheric Fluidized Bed Combustion: ","",CoalSum3$SCC.Level.Four)
CoalSum3$SCCType<-gsub("Atmospheric Fluidized Bed Combustion - ","",CoalSum3$SCCType)

p3<-qplot(year,EmissionTotal,data=CoalSum3,col=SCCType,main="Emissions from 		Coal by Coal in U.S.",geom=c("point", "smooth"))

#Create the 4th plot which shows how total emission changes by Industry and by Coal Type (SCC.Level.Four) over the years across U.S.

CoalSum4<-ddply(NEICoalSCC,c("year","Short.Name"),summarize,EmissionTotal=sum(Emissions))

#Create a new column with a concised label to use as legend
CoalSum4$SCCType<-gsub("Ext Comb /","",CoalSum4$Short.Name)
CoalSum4$SCCType<-gsub("Atmospheric Fluidized Bed Combustion: ","",CoalSum4$SCCType)
CoalSum4$SCCType<-gsub("Atmospheric Fluidized Bed Combustion - ","",CoalSum4$SCCType)
CoalSum4$SCCType<-gsub("/","\n",CoalSum4$SCCType)

p4<-qplot(year,EmissionTotal,data=CoalSum4,col=SCCType,main="Emissions from Coal by Industry by Coal in U.S.",geom=c("point", "smooth"))

#Plot all the 4 plots in the same grid
grid.arrange(p1, p2, p3, p4,nrow = 2)
dev.off()

#Analysis shows that total emissions from Coal Conbustion was decreasing from 1999-2002, but increasing from 2002-2008 across the country. From the remaining plots, we can see what Coal types or industry contribute to the trend.

#Plot5:here we use 5 plots to show how emissions from Motor Vehicle sources change from 1999¨C2008 in Baltimore. 
#Subset the data for Baltimore City and Motor Vehicle sources; Merge NEI data with SCC data by "SCC" as the key

NEIBal<-subset(NEI,fips=="24510")
VehicleSCC<-SCC[grep("[Mm]otor|[Vv]ehicle", SCC$Short.Name),]
NEIVehicleSCC<-merge(NEIBal,VehicleSCC,by="SCC")

library(tidyr)
library(plyr)
library(ggplot2)
library(gridExtra)

#Create 1st plot which shows how total emissions changes over the years in Baltimore.
#Calculate total emissions

VehicleSum1<-ddply(NEIVehicleSCC,c("year"),summarize,EmissionTotal=sum(Emissions))
png(filename="GitHub/plot5.png")
p1<-qplot(year,EmissionTotal,data=VehicleSum1,main="Total Emissions from Motor Vehicles in Baltimore",geom=c("point", "smooth"))


#Create 2nd plot which shows how total emissions changes by Fuel Type(SCC.Level.Two) over the years in Baltimore.
#Calculate total emissions by Fuel Type

VehicleSum2<-ddply(NEIVehicleSCC,c("year","SCC.Level.Two"),summarize,EmissionTotal=sum(Emissions))
p2<-qplot(year,EmissionTotal,data=VehicleSum2,col=SCC.Level.Two, main="Emissions from Motor Vehicles by Fuel Type in Baltimore",geom=c("line", "smooth"))

#Create 3rd plot which shows how total emissions changes by Fuel Type and by Vehicle Type(SCC.Level.Three) over the years in Baltimore.
#Calculate total emissions by Fuel Type and by Vehicle Type

VehicleSum3<-ddply(NEIVehicleSCC,c("year","SCC.Level.Three"),summarize,EmissionTotal=sum(Emissions))
p3<-qplot(year,EmissionTotal,data=VehicleSum3,col=SCC.Level.Three, main="Emissions from Motor Vehicles by Fuel Type by Vehicle Type in Baltimore",geom=c("line", "smooth"))


#Create 4th plot which shows how total emissions changes by Area - Rural or Urban (SCC.Level.Four) over the years in Baltimore.
#SplitSCC.Level.Four into 2 variables - Areas & Origin; Calculate total emissions by Area - Rural or Urban

VehicleSplit<-NEIVehicleSCC
VehicleSplit<-VehicleSplit %>% separate (SCC.Level.Four, c("SCC.Level.Four.Area","SCC.Level.Four.Origin"),":")
VehicleSum4<-ddply(VehicleSplit,c("year","SCC.Level.Four.Area"),summarize,EmissionTotal=sum(Emissions))
p4<-qplot(year,EmissionTotal,data=VehicleSum4,col=SCC.Level.Four.Area, main="Emissions from Motor Vehicles by Area in Baltimore",geom=c("line", "smooth"))


#Create 5th plot which shows how total emissions changes by Origin - Break, Tires, etc. (SCC.Level.Four) over the years in Baltimore.
#Calculate total emissions by Origin - Break, Tires, etc.

VehicleSum5<-ddply(VehicleSplit,c("year","SCC.Level.Four.Origin"),summarize,EmissionTotal=sum(Emissions))
p5<-qplot(year,EmissionTotal,data=VehicleSum5,col=SCC.Level.Four.Origin, main="Emissions from Motor Vehicles by Origin in Baltimore",geom=c("line", "smooth"))

#Plot all the 5 plots in the same grid
grid.arrange(p1, p2, p3, p4,p5, nrow = 3)
dev.off()

#Analysis shows that total emissions from Motor Vehicles was decreasing from 1999-2008 in Baltimore.Also, we can see the different decreasing paces for different Vehicle types, Fuel types, Areas, Origins from the plots with more details.

#Plot6: here we use 3 plots to ompare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California.
#Subset the data for Baltimore City and Los Angeles County; Subset the data for Motor Vehicle sources; Merge NEI data with SCC data by "SCC" as the key

NEIBalLos<-subset(NEI,fips=="24510"|fips=="06037")
VehicleSCC<-SCC[grep("[Mm]otor|[Vv]ehicle", SCC$Short.Name),]
NEIBLVehicleSCC<-merge(NEIBalLos,VehicleSCC,by="SCC")

#Create 1st plot which shows how total emissions changes over the years in Baltimore.
#Calculate total emissions by year and by city

VehicleBLSum1<-ddply(NEIBLVehicleSCC,c("year","fips"),summarize,EmissionTotal=sum(Emissions))
NEIBalVehicleSCC<-subset(VehicleBLSum1,fips=="24510")

#Create a label column to show the City Names

VehicleBLSum1$City<-factor(VehicleBLSum1$fips,levels = c("24510","06037"),labels = c("Baltimore City","Los Angeles County"))

png(filename="GitHub/plot6.png")
p1<-qplot(year,EmissionTotal,data=NEIBalVehicleSCC,main="Total Emissions from Motor Vehicles in Baltimore",geom=c("point", "smooth"))

#Create 2nd plot which shows how total emissions changes over the years in Los Angeles.

NEILosVehicleSCC<-subset(VehicleBLSum1,fips=="06037")
p2<-qplot(year,EmissionTotal,data=NEILosVehicleSCC,main="Total Emissions from Motor Vehicles in Los Angeles",geom=c("point", "smooth"))


#Create 3nd plot which shows how total emissions changes over the years in Baltimore and Los Angeles in the same plot.

p3<-qplot(year,EmissionTotal,data=VehicleBLSum1,facets=.~City, col=City,main="Compare Motor Vehicles Emissions between Baltimore and Los Angeles",geom=c("point", "smooth"))

#Plot all the 3 plots in the same grid
#By having 1st plot and 2nd plot in the same row, we can clearly see what is the percentage of change in emissions in each city

grid.arrange(p1, p2, p3, nrow = 2)
dev.off()

#Analysis shows that the Amount of emmisions from Motor Vehicles in Los Angeles was decreasing much more than Baltimore from 1999-2008 in Los Angeles, but the percentage of emmisions from Motor Vehicles in Baltimore is decreasing more than Los Angeles, although the amount is not significant.

