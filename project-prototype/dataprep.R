library(countrycode)
library(ggplot2)
# Read the csv file 
popfem <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/1_indicator_total population female.csv', 
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



popmale <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/1_indicator_total population male.csv', 
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
all_data$totalpop <- all_data$femPop + all_data$malePop
names(all_data)
head(all_data)


# More dense the country the bigger the square 
for(i in seq(1950,2050, 20)){
  test <- subset(all_data, Year==i)
  test$popSqkm <- (test$totalpop/ test$areaSqkm)
  treemap(test, index=c("continent", "country"), vSize="popSqkm", 
          type="index", vColor="areaSqkm")
}

# More bigger the rectangle, bigger is the area
# Still figuring out the coloring scheme
palette.HCL.options <- list(hue_start=270, hue_end=360+150)
for(i in seq(1950,2050, 50)){
  test <- subset(all_data, Year==i)
  test$popSqkm <- (test$totalpop/ test$areaSqkm)
  test$totalpop <- (test$totalpop)/100000
  test$areaSqkm <- (test$areaSqkm)/100000
  treemap(test, index=c("continent", "country"), vSize="areaSqkm", # region / continent
          type="dens", vColor="totalpop", 
          fontsize.labels=c(10, 9), 
          align.labels=list(c("center", "center"), c("left", "top")),
#           palette=terrain.colors(5)
          palette="-RdBu",range=c(1,300)
#           palette.HCL.options=palette.HCL.options
          )
}


# Read aggregated data
popagg <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/1_World_population_continent_2050.csv',
                    header=TRUE)
popagg <- melt(popagg, id=c("Region"))
popagg$variable <- gsub("X","", popagg$variable)
head(popagg)

fertagg <- read.csv('/home/ubuntu/Dropbox/Manoj/MSAN622_DataViz_Sophie/data/1_Fertility_continent_2050.csv',
                     header=TRUE)
fertagg <- melt(fertagg, id=c("Region"))
fertagg$variable <- gsub("X","", fertagg$variable)


