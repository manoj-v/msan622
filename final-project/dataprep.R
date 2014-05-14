library(countrycode)
library(ggplot2)
library(treemap)
# Read the csv file 
popfem <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/tot_pop_female_2050.csv', 
                   header=TRUE, stringsAsFactors=FALSE)
# extract Continent
popfem$continent <- as.factor(countrycode(popfem$country, "country.name", "continent"))
# Extract Region
popfem$region <- as.factor(countrycode(popfem$country, "country.name", "region"))
names(popfem)


contidx <- which(is.na(popfem$region))
popfem$region[which(popfem$country=='Caribbean')] = "Caribbean"
popfem$continent[which(popfem$country=='Caribbean')] = "Americas"

popfem$region[which(popfem$country=='Channel Islands')] = "Western Europe"
popfem$continent[which(popfem$country=='Channel Islands')] = "Europe"

popfem$region[which(popfem$country=='Melanesia')] = "Melanesia"
popfem$continent[which(popfem$country=='Melanesia')] = "Oceania"

popfem$region[which(popfem$country=='Polynesia')] = "Polynesia"
popfem$continent[which(popfem$country=='Polynesia')] = "Oceania"

# gsub(" ", "", paste("p", seq(1:5)))
# aggregate(cbind(X2099, X2100) ~ continent, data = popfem, sum)
  
# plot time
# Stacked Area plot
library(reshape)
melted_df <- melt(popfem, id=c("country", "region", "continent", "land_sqkm"))
melted_df$variable <- gsub("X","", melted_df$variable)
head(melted_df)



popmale <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/tot_pop_male_2050.csv', 
                   header=TRUE, stringsAsFactors=FALSE)
# extract Continent
popmale$continent <- as.factor(countrycode(popmale$country, "country.name", "continent"))
# Extract Region
popmale$region <- as.factor(countrycode(popmale$country, "country.name", "region"))
names(popmale)
popmale$region[which(popmale$country=='Caribbean')] = "Caribbean"
popmale$continent[which(popmale$country=='Caribbean')] = "Americas"

popmale$region[which(popmale$country=='Channel Islands')] = "Western Europe"
popmale$continent[which(popmale$country=='Channel Islands')] = "Europe"

popmale$region[which(popmale$country=='Melanesia')] = "Melanesia"
popmale$continent[which(popmale$country=='Melanesia')] = "Oceania"

popmale$region[which(popmale$country=='Polynesia')] = "Polynesia"
popmale$continent[which(popmale$country=='Polynesia')] = "Oceania"

melted_dfm <- melt(popmale, id=c("country", "region", "continent"))
melted_dfm$variable <- gsub("X","", melted_dfm$variable)

# MERGE THE DATA TO A SINGLE DATAFRAME
all_data  <- merge(melted_df, melted_dfm, 
                   by=c( "variable", "country", "region", "continent"))
colnames(all_data)[1] <- "Year"
colnames(all_data)[5] <- "areaSqkm"
colnames(all_data)[6] <- "femPop"
colnames(all_data)[7] <- "malePop"

# Read aggregated data
popagg <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/continent_pop_2050.csv',
                    header=TRUE)
popagg <- melt(popagg, id=c("Region"))
popagg$variable <- gsub("X","", popagg$variable)
head(popagg)

# fertility estimates
fert <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/tot_fertitlity_2099.csv',
                     header=TRUE)
fert <- melt(fert, id=c("Country"))
fert$variable <- gsub("X","", fert$variable)
colnames(fert)[3] <- "fert"
# Life expectancy estimates
lifexp <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/life_exp_at_birth_2099.csv',
                    header=TRUE)
lifexp <- melt(lifexp, id=c("Country"))
lifexp$variable <- gsub("X","", lifexp$variable)
colnames(lifexp)[3] <- "lifexp"
merged <- merge(fert, lifexp, by=c("Country", "variable"), all.x=TRUE)

# GDP per capita
gdpall <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/gdp_per_capita_2012.csv',
                   header=TRUE)
gdpall <- melt(gdpall, id=c("Country"))
gdpall$variable <- gsub("X","", gdpall$variable)
colnames(gdpall)[3] <- "gdppc"
merged <- merge(merged, gdpall, by=c("Country", "variable"), all.x=TRUE)
colnames(merged)[2] <- "Year"
colnames(merged)[1] <- "country"

all_data <- merge(all_data, merged, by=c('country', 'Year'), all.x=TRUE)
all_data$country <- as.factor(all_data$country)
all_data$Year <- as.numeric(all_data$Year)

all_data$totalpop <- all_data$femPop + all_data$malePop
all_data$popdens <- all_data$totalpop / all_data$areaSqkm
all_data$fmr <- all_data$femPop / all_data$malePop
all_data$totgdpb <- all_data$gdppc * all_data$totalpop / 1000000000

write.csv(all_data, file='all_data.csv', row.names=FALSE)
