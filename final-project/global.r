library(shiny)
library(ggplot2)
library(reshape)
library(rCharts)
library(treemap)

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
  melttot$variable <- as.numeric(melttot$variable)
  #   melttot$variable <- as.numeric(as.POSIXct(paste0(melttot$variable, "-12-31")))
  melttot$value <- melttot$value*1000
  return(melttot)
}
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

gettreemap <- function(test, areaopt, colopt, groupopt){
  colrange = c(0.85,1.35)
  if(colopt=="popdens"){
    colrange = c(20,160)
  }
  tridx <- c(groupopt, "country")
  test$totalpop <- (test$totalpop)/1000000
  test$areaSqkm <- (test$areaSqkm)/1000000
  tree <- treemap(test, index=tridx, vSize=areaopt, # region / continent
          type="dens", vColor=colopt, 
          fontsize.labels=c(10, 9), 
          align.labels=list(c("center", "center"), c("left", "top")),
          palette="-RdBu",range=colrange
  )
  return(tree)
}

getArea <- function(df, plottype, colschm){
  parea <- Rickshaw$new()
  parea$layer(value ~ variable, group = "Region", data = df, 
              type = plottype, 
              height=300, width=500)
  # add a helpful slider this easily; other features TRUE as a default
  parea$set(scheme = colschm)
#   parea$set(slider = TRUE, scheme = colschm)
  return(parea)
}

plotOverview <- function(aggData, start = 1950, num = 10) {
  aggData$value <-aggData$value/1000000000
  xmin <- start
  xmax <- start + num 
  ymin <- 0
  ymax <- 6
  
  p <- ggplot(aggData, aes(x=variable, y=value, color=Region)) + theme_bw()
  p <- p + geom_rect(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
                     fill = 'grey', col='grey')
  
  p <- p + geom_line()
  p <- p + scale_x_continuous(expand=c(0,0), 
                              breaks=seq(1950, 2050, 5))
  p <- p + scale_y_continuous(expand=c(0,0), limits=c(0,6),
                              breaks=seq(1, 6, 1))
  
  p <- p + theme(axis.title.x = element_blank())
  p <- p + theme(axis.title.y = element_text(size=10))
  p <- p + theme(panel.background = element_blank())
  p <- p + theme(legend.position="none")
  
  return(p)
}

plotArea <- function(localFrame) {
  # Define the ranges for the small plot
  localFrame$value <-localFrame$value/1000000000
  xrange <- range(localFrame$variable)
  xmin <- xrange[1]
  xmax <- xrange[2]
  ymin <- 0
  ymax <- 10
  
  p <- ggplot(localFrame, 
              aes(x = variable, y = value, 
                  group = Region, fill = Region, color=Region))
  
  p <- p + geom_area(position='stack', alpha=0.7)
  
  p <- p + theme_bw()
  
  p <- p + scale_x_continuous(
    limits=c(xmin, xmax),expand = c(0, 0),
    breaks = seq(xmin, xmax, 1)
  )
  
  p <- p + scale_y_continuous(
    expand = c(0, 0),
    limits=c(ymin, ymax),
    breaks = seq(1, ymax, 1))
  
  p <- p + theme(axis.title = element_blank())
  
  p <- p + theme(
    legend.text = element_text(
      colour = "black",
      face = "italic"),
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.direction = "horizontal", 
    legend.position = c(0, 0.85),
    legend.justification = c(0, 0),
    legend.key = element_rect(fill = NA, colour = "black", size = 1))
  
  return(p)
}