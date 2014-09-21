# reading datafiles
NEI <- readRDS("summarySCC_PM25.rds")

# SCC file not necessary
# SCC <- readRDS("Source_Classification_Code.rds")

#BC is Baltimore City, MD with fips == "24510"
# Maryland State FIPS codes listed at http://www.epa.gov/envirofw/html/codes/md.html
# MD = 24 and Baltimore City = 510 such that 24510 is fips for Baltimore City, MD
BCPM25 <- NEI[NEI$fips == "24510",]
BCPM25_tot <- tapply(BCPM25$Emissions,BCPM25$year,sum)
BCPM25_tot_k <- BCPM25_tot/1000

# purple for variety
png(file="plot2.png")
barplot(BCPM25_tot_k, names.arg = names(BCPM25_tot_k), main="Total Emissions (PM2.5) in Baltimore City, MD", ylab="PM(2.5) in Thousands(000s)", col="purple")
dev.off()


