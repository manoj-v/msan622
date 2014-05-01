library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("World Population - Growth Trends Past, Present and Beyond"),
  
  sidebarPanel(
    conditionalPanel(
      condition="input.conditionedPanels==1",
      selectInput('year', 'Year:', seq(1950,2050),
                  selected=2013:2020, multiple=T),
      br(),
      selectInput('var', 'Y Axis:',
                  c('Fertility'='fert','Education'='edu','M/F Ratio' = 'mfr'),
                  selected='mfr'),
      width = 2
      ),
#     conditionalPanel(
#       condition="input.conditionedPanels==2",
#       selectInput('year', 'Year:', seq(1950,2050),
#                   selected=2013:2020, multiple=T),
#       br(),
#       selectInput('var', 'Y Axis:',
#                   c('Fertility'='fert','Education'='edu','M/F Ratio' = 'mfr'),
#                   selected='mfr'),
#       width = 3
#     ),
    conditionalPanel(
#       "Time Series",
      condition="input.conditionedPanels==2",
      radioButtons('ByContinent', 'ByRegion',
        c('By Continent','By Region')),
      br(),
      sliderInput("yrs", "Years:", 
        min = 5, max = 10, value = 5, step = 1),
      br(),
      sliderInput("start", "Starting Point:",
        min = 1950, max = 2050,value = 2014, step = 1,
        round = FALSE, ticks = TRUE, format = "####.##",
        animate = animationOptions(interval = 100, loop = TRUE)),
      width = 3
      )
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Treemap",
               value=1,
               plotOutput('treemap',width='100%',height='600px')
               ),
      tabPanel("Time Series Plot",
               value=2,
               plotOutput('timeSeriesDetailPlot'), 
               plotOutput('timeSeriesOverviewPlot',height='200px')
               ),
      id="conditionedPanels")
    )
  ))