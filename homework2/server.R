library(ggplot2)
library(shiny)
library(scales)

loadMovies <- function(){
  data(movies)
  # Cleanup the movie dataset
  # Filter out rows with 0, negative or no budget information and remove
  # Additional filter to remove movies without any ratings
  idx <- which((movies$budget <=0 | is.na(movies$budget))) 
  movies <- movies[-idx,]
  idx <- which(movies$mpaa=='')
  movies <- movies[-idx,]
  
  # Data
  genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & movies$Action == 1)] = "Action"
  genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
  genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  genre[which(count == 1 & movies$Short == 1)] = "Short"
  
  # Add the Genre column to the movies2 dataframe
  movies$Genre <- movies$Genre <- as.factor(genre)
  
  colIdx <- which(colnames(movies) %in% c('title', 'rating', 'mpaa', 'Genre', 'budget'))
  movies <- movies[,colIdx]
  movies$mpaa <- factor(movies$mpaa)
  rownames(movies) <- NULL
  return(movies)
}

# Reusing Sophie's code for formatting budgets
# Label formatter for numbers in thousands.
million_formatter <- function(x) {
  return(sprintf("$%2.0fM", round(x / 1000000)))
}

#getPlot <- function(localFrame, dotSize, dotAlpha, movieGenres, colSchm = "None") {
getPlot <- function(localFrame, dotSize, dotAlpha, colSchm) {
  
# Create base plot.
  localPlot <- ggplot() + 
    geom_point(data=localFrame, aes(x=budget, y=rating, col=mpaa),size=dotSize, alpha=dotAlpha, shape=1) +
    xlab("Budget in Millions, USD") + scale_y_continuous(breaks=c(seq(0,10,1))) + 
    ylab("Rating") + scale_x_continuous(label = million_formatter, 
                                        expand=c(0,100000), breaks=c(1000000*seq(0,270,50))) +
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank()) +
    theme(axis.title = element_text(colour = "black")) +
    theme(axis.text = element_text(size = 12)) +
    theme(axis.text = element_text(colour="black")) + 
    theme(legend.position="bottom", legend.background=element_blank()) +
    theme(legend.direction='horizontal') +
    theme(panel.grid.major = element_line(color="grey", size=0.1)) +
    theme(panel.grid.minor = element_line(color="grey", size=0.1)) +
    theme(panel.border = element_rect(fill=NA, color="white", size=0.1)) + 
    theme(plot.background = element_rect(fill=NA, color="black")) +
    theme(panel.background = element_rect(fill="black", color="black"))+
    ggtitle("Movies by Genre") 
  
  if(colSchm!="Default"){
    n <- length(unique(localFrame$mpaa))
    palette <- brewer_pal(type = "qual", palette = colSchm)(n)
    localPlot <- localPlot + scale_color_manual(values = palette)
  }

  return(localPlot)
}

globalData <- loadMovies()

shinyServer(function(input,output){
  localFrame<-globalData
  
  dat <- reactive({
    if(length(input$movieGenres)==0){
      genreList <- c("Action", "Animation", "Comedy", "Documentary", 
                     "Drama", "Mixed", "Romance", "Short", "None")}
    else{
      genreList <- input$movieGenres
    }
    if(input$mpaaRating == "All"){
      subset(localFrame, Genre %in% genreList)}
    else{
      subset(localFrame, (mpaa == input$mpaaRating) & (Genre %in% genreList))}
  })
  
  output$scatterPlot <- renderPlot({
    scatterPlot <- getPlot(dat(), dotSize=input$dotSize, dotAlpha=input$dotAlpha, 
                           colSchm=input$colSchm)
    print(scatterPlot)
  }, width=900, height=600)
  
})
