library(ggplot2)
library(reshape)
library(plyr)
library(scales)
require(GGally)

# Build the dataframe
myData <- data.frame(state.x77, State = state.name, Abbrev = state.abb,
                     Region = state.region, Division = state.division)
colnames(myData)[1:8] <- gsub("\\.", "", colnames(myData)[1:8])

scaleMeltData <- function(dataset){
  # Rescale the data by range using rescaler function
  dataset <- rescaler(dataset, type="range")

  # melted df
  meltedData <- melt(data=dataset, varnames=c("State", "Region", "Division", "Abbrev"))
#  meltedData$Abbrev <- as.factor(meltedData$Abbrev)
  return(meltedData)
}

# Sort the melted dataset based on the input
sortMelted <- function(original, melted, sort1, sort2) {
  sortOrder <- original[order(original[[sort1]], original[[sort2]], decreasing=TRUE),'Abbrev']
  melted$Abbrev <- factor(original$Abbrev, levels = sortOrder, ordered = TRUE)
  return(melted)
}

# Function to generate heatmap
getHeatmap <- function(dataset, colSchm, midrange){
  # create base heatmap  
  p <- ggplot(dataset, aes(x = Abbrev, y = variable))
  p <- p + geom_tile(aes(fill = value), colour = "white")
  p <- p + theme_minimal()
  
  # turn y-axis text 90 degrees (optional, saves space)
  p <- p + theme(axis.text.y = element_text(angle = 90, hjust = 0.5, size=10))
  
  # remove axis titles, tick marks, and grid
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(panel.grid = element_blank())
  
  # remove legend (since data is scaled anyway)
  p <- p + theme(legend.position = "none")
  
  # remove padding around grey plot area
  p <- p + scale_x_discrete(expand = c(0, 0))
  p <- p + scale_y_discrete(expand = c(0, 0))
  
  if(colSchm!="Default"){
    n <- length(unique(myData$Region))
    palette <- brewer_pal(type = "div", palette = colSchm)(n)
    palette <- palette[order(palette, decreasing=TRUE)]
  }
  p <- p + scale_fill_gradientn(colours = palette, values = c(0, midrange[1], midrange[2], 1))
  
  return(p)
}

# Generate a scatter plot matrix
scatterPlot <- function(df, colIdx, colorby){
  local <- myData
  p <- ggpairs(local, columns = colIdx, upper="blank",
               lower=list(continuous="points"),
               diag=list(continuous="density"),
               axisLabels="none",
               color=colorby,
               title="GGPairs", legends=TRUE)
  # Below code for formatting legends, gridlines in each of the subplot
  for (i in 1:length(colIdx)) {
    # Address only the diagonal elements
    # Get plot out of matrix
    inner <- getPlot(p, i, i);
    # Add any ggplot2 settings you want
    inner <- inner + theme(panel.grid = element_blank()) +
      theme(axis.text.x = element_blank())
    # Put it back into the matrix
    p <- putPlot(p, inner, i, i)
    
    for (j in 1:length(colIdx)){
      if((i==1 & j==1)){
        inner <- getPlot(p, i, j)
        inner <- inner + theme(legend.position=c(length(colIdx)-0.25,0.50)) 
        p <- putPlot(p, inner, i, j)
      }
      else{
        inner <- getPlot(p, i, j)
        inner <- inner + theme(legend.position="none")
        p <- putPlot(p, inner, i, j)
      }
    }
  }
  p
}

getpcplot <- function(dataset, colIdx, colorby){
  p <- ggparcoord(data = myData, 
                  # Which columns to use in the plot
                  columns <- colIdx, 
                  # Which column to use for coloring data
                  groupColumn = colorby, 
                  # Allows order of vertical bars to be modified
                  order = "anyClass",
                  # Do not show points
                  showPoints = FALSE,
                  # Turn on alpha blending for dense plots
                  alphaLines = 0.6,
                  # Turn off box shading range
                  shadeBox = NULL,
                  # Will normalize each column's values to [0, 1]
                  scale = "uniminmax" # try "std" also
  )
  
  # Start with a basic theme
  p <- p + theme_minimal()
  # Decrease amount of margin around x, y values
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.text.y = element_blank())
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  # Move label to bottom
  p <- p + theme(legend.position = "bottom")
  # Figure out y-axis range after GGally scales the data
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.2
  
  # Display parallel coordinate plot
  p
}

shinyServer(function(input, output) {
  # operate on a local copy of the melted dataset
  # this way, each user has their own "view" and
  # sort order in the dataset
  local <- scaleMeltData(myData)
  
  # need the choice text used by the ui components
  choices <- gsub("\\.", " ", colnames(myData))
  
  # will reorder the dataset if the sort1 or
  # sort2 values change in the ui
  reorderRows <- reactive({
    if(input$sort1=="None"){
      index1 <- 8
    }
    else {
      index1 <- which(choices == input$sort1)
    }
    #index1 <- which(choices == input$sort1)
    index2 <- which(choices == input$sort2)
    local <<- sortMelted(myData, local, index1, index2)
  })
  
  # will regenerate the heatmap any time one of the ui
  # elements are modified
  output$heatmap <- renderPlot({
    reorderRows()
    print(getHeatmap(local, input$colSchm, input$range))
  })
  output$smplot <- renderPlot({
    print(scatterPlot(myData, input$smVar, input$plotby))
  }, height="auto")
  output$pcplot <- renderPlot({
    print(getpcplot(local, input$pcpVar, input$pcpcolor))
  })
})