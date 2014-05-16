shinyUI(pageWithSidebar(
  headerPanel("World Population - Growth Trends Past, Present and Beyond"),
  
  sidebarPanel(width=3,
    
    conditionalPanel(
      condition="input.conditionedPanels==2",
      h4("Data selection options"),
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
      br(),
      sliderInput("larea", h5("Land Area (Million SQ. Km) greater than:"), 
                  min = 0, max = 17, value = 2),
      br(),
      sliderInput("start", h5("Starting Point:"),
                  min = 1950, max = 2050,value = 1980, step = 1,
                  round = FALSE, ticks = TRUE, format = "####.##",
                  animate = animationOptions(interval = 1000, loop = TRUE)),
      br(),
      br(),
      radioButtons('bcol', h5('Color bubbles by:'),
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
      tabPanel("The Bubble!!",
               value=2,
               showOutput("bubble", "highcharts"),
               wellPanel(
                 h5(helpText("About the data")),
                 helpText("The data is sourced from the gapminder website and each of the columns have different definitions and descriptions; namely"),
                 helpText("1. Area in Square KMs"),
                 helpText("2. Population & Population Density - As the name suggests, it indicates the sum of male and female populations in each of the countries, the population density measure indicates the population per Square KM of land area"),
                 helpText("3. Life Expectancy - The average number of years a newborn child would live if current mortality patterns were to stay the same."),
                 helpText("4. Fertility - The number of children that would be born to each woman with prevailing age-specific fertility rates."),
                 helpText("5. Female to Male ratio - The number of females for each male")
                 )
               
      ),
      tabPanel("Asia and Africa rising",
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