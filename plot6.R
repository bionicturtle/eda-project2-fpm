library(lattice)

# reading datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# BC is Baltimore City, MD with fips == "24510"
# LA is Los Angeles, CA with fips == "06037"
BC_LA_PM25 <- NEI[(NEI$fips == "24510" | NEI$fips =="06037"),]
BC_LA_PM25$year <- as.factor(BC_LA_PM25$year)

onroad_SCC <- SCC[SCC$Data.Category=="Onroad",]
BC_LA_onroad_pm25 <- merge(BC_LA_PM25, onroad_SCC, by.x = "SCC", by.y = "SCC", all=FALSE)

BC_LA_onroad_pm25_sub <-  aggregate(BC_LA_onroad_pm25$Emissions, by = list(BC_LA_onroad_pm25$fips, BC_LA_onroad_pm25$year, BC_LA_onroad_pm25$EI.Sector), FUN="sum")
colnames(BC_LA_onroad_pm25_sub) <- c("fips", "year", "sector", "emissions")
BC_LA_onroad_pm25_sub$year <- as.factor(BC_LA_onroad_pm25_sub$year)

cat <- sapply(BC_LA_onroad_pm25_sub, is.factor)
BC_LA_onroad_pm25_sub[cat] <- lapply(BC_LA_onroad_pm25_sub[cat], factor)
BC_LA_onrsoad_pm25_sub$emissions <- BC_LA_onroad_pm25_sub$emissions/1000


BC_LA_onroad_pm25_sub$fips[BC_LA_onroad_pm25_sub$fips == "06037"] <- "Los Angeles"
BC_LA_onroad_pm25_sub$fips[BC_LA_onroad_pm25_sub$fips == "24510"] <- "Baltimore City"

png(file="plot6.png")
barchart(emissions ~ year | fips, groups = sector, data=BC_LA_onroad_pm25_sub, stack=T, ylab="Emissions in Thousands", scales = list(relation="free"), auto.key=list(space="top"))
dev.off()
