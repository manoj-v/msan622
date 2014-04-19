bookList <<- list('The Adventures of Sherlock Holmes, by Arthur Conan Doyle' = "book1", #http://www.gutenberg.org/cache/epub/1661/pg1661.txt
                  'Origin of Species, by Charles Darwin' = "book2", #http://www.gutenberg.org/cache/epub/1228/pg1228.txt
                  'Dream Psychology, by Sigmund Freud' = "book3", #http://www.gutenberg.org/cache/epub/15489/pg15489.txt
                  'Autobiography of Benjamin Franklin, by Benjamin Franklin' #http://www.gutenberg.org/cache/epub/20203/pg20203.txt
)

shinyUI(
  pageWithSidebar(
    headerPanel("Text Visualization"),
    sidebarPanel(
      selectInput("book", h5("Select Book"), choices = bookList),
      radioButtons("topn", h5("Display top"), c("10", "25", "50")),
      sliderInput("frange", h5("Frequency Range:"), min = 50, max = 1000, value = c(200, 500), 
                  step = 50, format = "00", ticks = TRUE),
      width = 4
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Word Cloud", plotOutput("wordcl")),
        tabPanel("Bar Plot", plotOutput("barplot"))
#         tabPanel("image", plotOutput("myImage"))
        )
    )
  )
)