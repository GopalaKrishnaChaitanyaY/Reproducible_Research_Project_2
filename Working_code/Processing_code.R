# dowloading data
if (!file.exists("./data")) {
        dir.create("./data")
}
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
              destfile = "./data/Storm.csv.bz2")

# reading data
connection <- bzfile("./data/Storm.csv.bz2")
storms.raw <- read.csv(connection, stringsAsFactors = FALSE)

# libraries
library(dplyr)

# getting into the data
str(storms.raw)
length(unique(storms.raw$EVTYPE))

# preprocessing data
evtype.ranking <- storms.raw %>% group_by(EVTYPE) %>% 
        summarize(count=n(),fatalities=sum(FATALITIES),inuries = sum(INJURIES), 
                  prop.damages=sum(PROPDMG),crop.damages=sum(CROPDMG)) %>%
        arrange(desc(count))
evtype.ranking <- mutate(evtype.ranking, health.impact = fatalities + inuries,
                         economic.impact = prop.damages + crop.damages)

evtype.rank.health <- arrange(evtype.ranking,desc(health.impact))
evtype.rank.economic <- arrange(evtype.ranking,desc(economic.impact))
evtype.rank.health
colSums(evtype.rank.health[1:10,-1])/colSums(evtype.ranking[,-1])
evtype.rank.economic
colSums(evtype.rank.economic[1:10,-1])/colSums(evtype.ranking[,-1])

