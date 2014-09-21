library(ggplot2)

# reading datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#BC is Baltimore City, MD with fips == "24510"
BCPM25 <- NEI[NEI$fips == "24510",]
BCPM25$year <- as.factor(BCPM25$year)

png(file="plot3.png")

# Setup ggplot with data frame; lecture 02-02 page 43
p <- ggplot(BCPM25)

# Add layers
p + geom_bar(aes(x=BCPM25$year,y=BCPM25$Emissions), stat="identity") +
    facet_wrap(~ type)+
    theme_bw()+
    xlab("") + #Years already displayed
    ylab("PM2.5 Emissions in Thousands, 000s")

dev.off()

