# Question 4 asks: "Across the United States, how have emissions from 
# coal combustion-related sources changed from 1999-2008?

# PLEAS NOTE: I intended a stacked bar chart. By stacking the bar chart,
# we can observe whether a source contributes disproportionately to the aggregate

library(lattice)

# reading datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# My first attempt was to spell them out
# coal_codes <- subset (SCC, select=SCC, subset = (EI.Sector == "Fuel Comb - Electric Generation - Coal" | EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal" | EI.Sector == "Fuel Comb - Comm/Institutional - Coal"))

# Then I realized %in% can be used, very exciting!
# coal = "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal", "Fuel Comb - Comm/Institutional - Coal"
# coal_codes = 99 obs of 2 variables
coal <- unique(grep("coal", SCC$EI.Sector, ignore.case=TRUE, value =TRUE))
coal_codes <- subset (SCC, select=c(SCC,EI.Sector), subset = (EI.Sector %in% coal))

coal_pm25 <- merge(NEI, coal_codes, by.x = "SCC", by.y = "SCC", all=FALSE)
coal_pm25_sub <- aggregate(coal_pm25$Emissions, by = list(coal_pm25$year, coal_pm25$EI.Sector), FUN="sum")
colnames(coal_pm25_sub) <- c("year","where","emissions")
coal_pm25_sub$year <- as.factor(coal_pm25_sub$year)

cat <- sapply(coal_pm25_sub, is.factor)
coal_pm25_sub[cat] <- lapply(coal_pm25_sub[cat], factor)
coal_pm25_sub$emissions <- coal_pm25_sub$emissions/1000

# Just to clean up the legend titles for the graph by stripping repetitive text, 
# I'm sure there is a more elegant way; e.g., collapse into one line
where_char <- as.character(coal_pm25_sub$where)
where_char <- substr(where_char,13, nchar(where_char)-7)
coal_pm25_sub$where <- where_char

png(file="plot4.png")
# Stacked bar chart to observe relative contributions
# For fun, my bars are colored red/white/blue because this is United States. Get it?
colors = c("red","white","blue")
barchart(emissions ~ year, groups = where, data=coal_pm25_sub, stack=T, main="Coal combustion-related sources across United States", ylab = "Emissions in Thousands", auto.key=list(space="top"), par.settings=list(superpose.polygon=list(col=colors)))

dev.off()

