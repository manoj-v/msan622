library(ggplot2)
library(reshape)
library(plyr)
library(scales)

# Build the dataframe
myData <- data.frame(state.x77,
                 State = state.name,
                 Abbrev = state.abb,
                 Region = state.region,
                 Division = state.division
)

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
    reorderRows()
    print(getHeatmap(local, input$colSchm, input$range))
  })
  output$pcplot <- renderPlot({
    reorderRows()
    print(getHeatmap(local, input$colSchm, input$range))
  })
})