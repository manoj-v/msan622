library(shiny)
library(ggplot2)
library(reshape)
library(rCharts)

# Function to read detailed breakup of population projections
createData <- function(){
  all_data <- read.csv('all_data.csv')
  return(all_data)
}

# Function to read aggregate population data by region
aggredata <- function(){
  totalpop <- read.csv('continent_pop_2050.csv')
  melttot <- melt(totalpop, id="Region")
  melttot$variable <- gsub("X","", melttot$variable)
  # melttot$variable <- as.numeric(melttot$variable)
  melttot$variable <- as.numeric(as.POSIXct(paste0(melttot$variable, "-12-31")))
  melttot$value <- melttot$value*1000
  return(melttot)
}

aggData <- aggredata()

dt <- createData()

summary(dt)

# Bubble plot
#getbplot(localFrame, input$xvar, input$yvar, input$start, input$larea, input$bsize, input$bcol)
getbplot <- function(df, xvar, yvar, yr, larea, bsize, bcol){
  df <- subset(df, Year==yr)
  df <- subset(df, areaSqkm>=1000000*larea)
  bplot <- hPlot(x = xvar , y = yvar, data = df, 
                 type = c("bubble"), group = bcol, size = bsize)
  bplot$set(dom = "plot")
  # h1$print("chart5")
  return(bplot)
}

gettreemap <- function(df, yr, areaopt, colopt, groupopt){
  test <- subset(dt, Year==yr)
  tridx <- c(groupopt, "country")
  test$totalpop <- (test$totalpop)/100000
  test$areaSqkm <- (test$areaSqkm)/100000
  treemap(test, index=tridx, vSize=areaopt, # region / continent
          type="dens", vColor=colopt, 
          fontsize.labels=c(10, 9), 
          align.labels=list(c("center", "center"), c("left", "top")),
          #           palette=terrain.colors(5)
          palette="-RdBu",range=c(1,300)
          #           palette.HCL.options=palette.HCL.options
  )
}

getArea <- function(df, plottype, colschm){
  parea <- Rickshaw$new()
  parea$layer(value ~ variable, group = "Region", data = df, 
              type = plottype, 
              height=300, width=500)
  # add a helpful slider this easily; other features TRUE as a default
  parea$set(slider = TRUE, scheme = colschm)
  return(parea)
}
