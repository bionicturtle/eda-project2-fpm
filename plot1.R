# reading datafile
NEI <- readRDS("summarySCC_PM25.rds")

# SCC file not necessary
# SCC <- readRDS("Source_Classification_Code.rds")

totEmis <- tapply(NEI$Emissions, NEI$year, sum)
totEmis_k <- totEmis/1000

# blue color for fun
png(file="plot1.png")
barplot(totEmis_k, names.arg = names(totEmis_k), main="Total Emissions (PM2.5) in US", ylab="PM(2.5) in Thousands(000s)", col="blue")
dev.off()

