library(rCharts)

aggredata <- function(){
  totalpop <- read.csv('continent_pop_2050.csv')
  melttot <- melt(totalpop, id="Region")
  melttot$variable <- gsub("X","", melttot$variable)
  melttot$variable <- as.numeric(as.POSIXct(paste0(melttot$variable, "-12-31")))
  melttot$value <- melttot$value*1000
  return(melttot)
}

getArea <- function(df, plottype, colschm){
  parea <- Rickshaw$new()
  parea$layer(value ~ variable, group = "Region", data = df, 
              type = plottype)
  # add a helpful slider this easily; other features TRUE as a default
  parea$set(slider = TRUE, scheme = colschm)
  return(parea)
}

df <- aggredata()

getArea(df, "line", "cool")
