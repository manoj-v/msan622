require(wordcloud)
library(tm)
library(ggplot2)
library(SnowballC)

book1 <- read.csv('sherlock.csv')
book2 <- read.csv('olivertwist.csv')
book3 <- read.csv('dream.csv')
book4 <- read.csv('autobio.csv')

genBar <- function(df){
  p <- ggplot(df, aes(x = word, y = freq)) +
    geom_bar(stat = "identity", fill="grey60") +
    xlab("Top Words (Stop Words Removed)") +
    ylab("Frequency") +
    theme_minimal() +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    theme(panel.grid.major.y = element_blank()) +
    theme(axis.ticks = element_blank()) + 
    coord_flip()
  p
}

shinyServer(function(input, output) {
  getData <- reactive({
    if(input$book == 'book1'){
      df <- book1
    }
    else if(input$book == 'book2'){
      df <- book2
    }
    else if(input$book == 'book3'){
      df <- book3
    }
    else if(input$book == 'book4'){
      df <- book4
    }
    plot <- df[which(df$freq >=input$frange[1] & df$freq <=input$frange[2]),]
    #     plot <- df[which(df$freq >=100 & df$freq <= 200),]
    plot$word <- factor(plot$word, levels=plot$word, ordered=TRUE)
    plot$word <- factor(plot$word,levels(plot$word)[nrow(plot):1])
    plot <- head(plot, input$topn)
    plot
  })
  
  output$barplot <- renderPlot({
    d <- getData()
    barplot <- genBar(d)
    print(barplot)
    #     barplot <- genBar(d)
    #     print(barplot)
  })
  
  #   Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  output$wordcl <- renderPlot({
    d <- getData()
    wordcloud_rep(d$word, d$freq, scale=c(7,0.5), min.freq = 1, 
                  max.words=input$frange[2]-input$frange[1],
                  colors = brewer.pal(9, "Paired"), random.color = FALSE, 
                  use.r.layout = FALSE)
  })
  
#   output$myImage <- renderImage({
#     # A temp file to save the output.
#     # This file will be removed later by renderImage
#     outfile <- 'assignment4_q3_p2.png'
# 
#     # Return a list containing the filename
#     list(src = outfile,
#          contentType = 'image/png',
#          width = 500,
#          height = 300)
#   })
})