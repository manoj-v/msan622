shinyUI(pageWithSidebar(
  headerPanel("World Population - Growth Trends Past, Present and Beyond"),
  
  sidebarPanel(width=3,
    
    conditionalPanel(
      condition="input.conditionedPanels==2",
      selectInput('xvar', 'X-Axis:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'areaSqkm'),
                  selected='fert'),
      selectInput('yvar', 'Y-Axis:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'Life Expectancy'),
                  selected='lifexp'),
      selectInput('bsize', 'Size bubble by:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'areaSqkm'),
                  selected='fmr'),
      br(),
      sliderInput("larea", h5("Land Area (Million SQ. Km) greater than:"), 
                  min = 0, max = 17, value = 2),
      br(),
      sliderInput("start", "Starting Point:",
                  min = 1950, max = 2050,value = 1980, step = 1,
                  round = FALSE, ticks = TRUE, format = "####.##",
                  animate = animationOptions(interval = 1000, loop = TRUE)),
      radioButtons('bcol', 'Color bubbles by:',
                   c('continent','region', 'country'),
                   selected='country'),
      width = 3
    ),
    
    conditionalPanel(
      condition="input.conditionedPanels==1",
      sliderInput("num2", "Years:", 
                  min = 5, max = 25, value = 10, step = 5),
      br(),
      sliderInput("start2", "Starting Point:",
                  min = 1950, max = 2050, value = 1980, step = 1,
                  round = FALSE, ticks = TRUE, format = "####.##",
                  animate = animationOptions(interval = 500, loop = TRUE)),
      width = 3
    ),
    
    conditionalPanel(
      condition="input.conditionedPanels==3",
      numericInput("treeyr", "Choose year:", 1950),
      radioButtons('areaopt', 'Area of Elements', 
                   c('By Area'='areaSqkm','By Population'='totalpop')),
      br(),
      radioButtons('colopt', 'Color of Elements',
                   c('By population density'='popdens','By female to male ratio'='fmr')),
      br(),
      radioButtons('groupopt', 'Group by',
                   c('Continent'='continent','Region'='region')),
      width = 3
    )
  ),
  
  mainPanel(
    width=9,
    tabsetPanel(
      tabPanel("Bubble Plot",
               value=2,
               showOutput("bubble", "highcharts"),
               wellPanel(
                 h5(helpText("This is a test message")),
                 helpText("This is a test message")
                 )
               
      ),
      tabPanel("Time Series Plot",
               value=1,
               plotOutput(outputId = "mainPlot", width = "100%",  height = "400px"),
               br(),
               plotOutput(outputId = "overviewPlot", width = "100%", height = "200px")
      ),
      tabPanel("Treemap",
               value=3,
               plotOutput('tree',width='100%',height='600px')
      ),
      id="conditionedPanels")
  )
))