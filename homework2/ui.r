library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  #headerPanel(),
  # headerPanel(list(tags$head(tags$style("body {background-color: black; }")))),
  headerPanel(
    list(tags$head(tags$style("body {background-color: black; }")), 
         HTML('<p style="color:white"> IMDB Movie Ratings </p>' ))
  ),

  # Sidebar with a multiple inputs
  sidebarPanel(
    # Radio buttons for selecting mpaa ratings
    radioButtons(
      "mpaaRating", "MPAA Rating:",
      c("All", "NC-17", "PG", "PG-13", "R")),
    
    # Check box group input.
    checkboxGroupInput(
      "movieGenres", "Movie Genres",
      c("Action", "Animation", "Comedy", "Documentary", "Drama", "Romance", "Short"),
      selected = c("Action", "Animation", "Comedy", "Documentary", "Drama", "Romance", "Short")),
    
    # Dropdown for the color scheme to be used on the scatter plot.
    selectInput(
      "colSchm", "Color Scheme:",
      choices = c("Default", "Accent", "Set 1"="Set1", "Set 2"="Set2", "Set 3"="Set3", 
                  "Dark 2"="Dark2", "Pastel 1"="Pastel1","Pastel 2"="Pastel2")),
    
    # Add a slider for dot size
    sliderInput("dotSize", "Dot Size:", 
                min = 1, max = 10, value = 5, step=1),
    
    # Add a slider for dot size
    sliderInput("dotAlpha", "Dot transparency:", 
                min = 0.1, max = 1, value = 0.5, step=0.1, format="#.#")
  ),
  
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("scatterPlot")
  )
))
