source('global.r')

shinyServer(function(input, output) {
  dt <- createData()
  aggData <- aggredata()
  
  cat("Press \"ESC\" to exit...\n")
  # Copy the data frame (don't want to change the data
  # frame for other viewers)
  
  getFilterData <- reactive({
    start <- input$start2
    end <- input$start2 + input$num2
    localFrame <- aggData[which(aggData$variable >= start & aggData$variable <= end ),]
    localFrame
  })
  
  gettreeData <- reactive({
    localFrame <- subset(dt, Year==input$treeyr)
    localFrame
  })
  
  output$mainPlot <- renderPlot({
    print(plotArea(getFilterData()))
  })
  
  output$overviewPlot <- renderPlot({
    print(plotOverview(aggData, input$start2, input$num2))
  })
  
  output$bubble <- renderChart2({
    localFrame <- dt
    print(getbplot(localFrame, input$xvar, input$yvar, input$start, input$larea, input$bsize, input$bcol))
  })
  
  output$tree <- renderPlot({
    print(gettreemap(gettreeData(),input$areaopt, input$colopt, input$groupopt))
  })
  
  output$areaplot <- renderChart({
    print(getArea(aggData, plottype="area", colschm="cool"))
  })
})
