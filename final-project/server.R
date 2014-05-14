library(shiny)
library(ggplot2)
library(reshape)
library(rCharts)

source('global.r')

createData <- function(){
  all_data <- read.csv('all_data.csv')
  return(all_data)
}

dt <- createData()

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

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  # Copy the data frame (don't want to change the data
  # frame for other viewers)
  localFrame <- dt
  getData <- reactive({
    localFrame <- dt
#     localFrame <- subset(localFrame, Year==input$start)
#     localFrame <- localFrame[which(localFrame$areaSqkm>=1000000*input$larea)]
    return(localFrame)
  }
  )

output$starPlot <- renderPlot({
  print(starplot(localFrame,input$var,input$year))
})

output$starPlot <- renderPlot({
  print(gettreemap(localFrame,input$var,input$year))
})

output$timeSeriesOverviewPlot <- renderPlot({
  print(seriesOverview(localFrame_melt,input$kill,input$start,input$mon))
})

output$timeSeriesDetailPlot <- renderPlot({
  print(seriesDetail(localFrame_melt,input$kill,input$start,input$mon))
})

output$areaplot <- renderChart2({
  print(getArea(aggData, plottype="area", colschm="cool"))
})

output$bubble <- renderChart2({
#   localFrame <- getData()
  print(getbplot(localFrame, input$xvar, input$yvar, input$start, input$larea, input$bsize, input$bcol))
  })
})