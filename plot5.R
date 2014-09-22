library(lattice)

# reading datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#BC is Baltimore City, MD with fips == "24510"
BCPM25 <- NEI[NEI$fips == "24510",]
BCPM25$year <- as.factor(BCPM25$year)

# Per Technical Support Document:
# 4.6 On-road - all Diesel and Gasoline vehicles. This section includes the description of four EIS sectors:
#  Mobile - On-road - Diesel Heavy Duty Vehicles
#  Mobile - On-road - Diesel Light Duty Vehicles
#  Mobile - On-road - Gasoline Heavy Duty Vehicles
#  Mobile - On-road - Gasoline Light Duty Vehicles
onroad_SCC <- SCC[SCC$Data.Category=="Onroad",]
BC_onroad_pm25 <- merge(BCPM25, onroad_SCC, by.x = "SCC", by.y = "SCC", all=FALSE)

BC_onroad_pm25_sub <-  aggregate(BC_onroad_pm25$Emissions, by = list(BC_onroad_pm25$year, BC_onroad_pm25$EI.Sector), FUN="sum")
colnames(BC_onroad_pm25_sub) <- c("year","sector","emissions")
BC_onroad_pm25_sub$year <- as.factor(BC_onroad_pm25_sub$year)

cat <- sapply(BC_onroad_pm25_sub, is.factor)
BC_onroad_pm25_sub[cat] <- lapply(BC_onroad_pm25_sub[cat], factor)
BC_onroad_pm25_sub$emissions <- BC_onroad_pm25_sub$emissions/1000

png(file="plot5.png")
barchart(emissions ~ year, groups = sector, data=BC_onroad_pm25_sub, stack=T, ylab = "Emissions in Thousands", auto.key=list(space="top"))
dev.off()