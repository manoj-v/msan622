library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("World Population - Growth Trends Past, Present and Beyond"),
  
  sidebarPanel(
    width=3,
    
    conditionalPanel(
      condition="input.conditionedPanels==1",
      selectInput('xvar', 'X-Axis:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'areaSqkm'),
                  selected='areaSqkm'),
      selectInput('yvar', 'Y-Axis:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'areaSqkm'),
                  selected='totalpop'),
      selectInput('bsize', 'Size bubble by:',
                  c('Fertility'='fert','Life Expectancy'='lifexp','F/M Ratio' = 'fmr',
                    'GDP'='totgdpb', 'Population Density'='popdens', 'Population' = 'totalpop', 
                    'Area' = 'areaSqkm'),
                  selected='lifexp'),
      br(),
      sliderInput("larea", h5("Land Area (Million SQ. Km) greater than:"), 
                  min = 0, max = 17, value = 2),
      br(),
      sliderInput("start", "Starting Point:",
                  min = 1950, max = 2050,value = 2014, step = 1,
                  round = FALSE, ticks = TRUE, format = "####.##",
                  animate = animationOptions(interval = 1000, loop = TRUE)),
      radioButtons('bcol', 'Color bubbles by:',
                   c('continent','region', 'country'),
                   selected='continent'),
      width = 3
    ),
    
    conditionalPanel(
      condition="input.conditionedPanels==2"
    ),
    
    conditionalPanel(
      condition="input.conditionedPanels==2",
      radioButtons('DEMO2', 'Choose:',
                   c('By Continent','By Region')),
      br(),
      sliderInput("yrs2", "Years:", 
                  min = 1, max = 10, value = 5, step = 1),
      br(),
      sliderInput("start2", "Starting Point:",
                  min = 1950, max = 2050,value = 2014, step = 1,
                  round = FALSE, ticks = TRUE, format = "####.##",
                  animate = animationOptions(interval = 1, loop = TRUE)),
      width = 3
    ),
    
    conditionalPanel(
      condition="input.conditionedPanels==3",
      radioButtons('areaopt', 'Area of Elements', 
                   c('By Area','By Population')),
      br(),
      radioButtons('colopt', 'Color of Elements',
                   c('By population density','By female to male ratio')),
      br(),
      radioButtons('groupopt', 'Group by',
                   c('Continent','Region')),
      width = 3
    )
  ),
  
  mainPanel(
    width=9,
    tabsetPanel(
      tabPanel("Bubble Plot",
               value=1,
               showOutput("bubble", "highcharts")
               #                plotOutput('bubble',width='100%',height='600px')
      ),
      tabPanel("Time Series Plot",
               value=2,
               showOutput("areaplot", "rickshaw")
#                plotOutput('timeSeriesDetailPlot'), 
#                plotOutput('timeSeriesOverviewPlot',height='200px')
      ),
      tabPanel("Treemap",
               value=3,
               plotOutput('treemap',width='100%',height='600px')
      ),
#       tabPanel("Area Chart",
#                value=2,
#                div(id = "myplot", style = "display:inline;position:absolute"
#                    ,showOutput("areaplot", "rickshaw"))
#                #                showOutput("areaplot", "rickshaw")
#                
#                #                plotOutput('bubble',width='100%',height='600px')
#       ),
      id="conditionedPanels")
  )
))