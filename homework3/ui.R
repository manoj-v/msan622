library(shiny)

myData <- data.frame(state.x77, State = state.name, Abbrev = state.abb,
                     Region = state.region, Division = state.division)
colnames(myData)[1:8] <- gsub("\\.", "", colnames(myData)[1:8])

# replace the period in the column names and use those
# as the sort choices in the ui
sortChoices1 <- c("None", "Region", "Division")
sortChoices2 <- gsub("\\.", " ", colnames(myData)[1:8])
regions <- levels(myData$Region)

shinyUI(
  navbarPage("U.S. Stats",collapsable=TRUE,
             tabPanel("Heatmap",
                      fluidPage(
                        titlePanel("US State Facts and Figures"),
                        # Fluid row contains all the controls for input sorting and also the plot
                        fluidRow(
                          sidebarPanel(
                            fluidRow(radioButtons("sort1", h5("Sort by:"), sortChoices1, selected = sortChoices1[1])),
                            fluidRow(radioButtons("sort2", h5("Sort by:"), sortChoices2, selected = sortChoices2[1])),
                            fluidRow(selectInput("colSchm", "Color Scheme:", 
                                                 choices = c("Accent", "Set 1"="Set1", "Set 2"="Set2", 
                                                             "Set 3"="Set3","Dark 2"="Dark2"))),
                            width=2),
                          column(10, wellPanel(plotOutput("heatmap")))
                          ),
                        # Fluid row contains the sliders
                        fluidRow(column(12, sliderInput("range", "Gradient Range:", min = 0, max = 1,
                                                        value = c(0.45, 0.55), step = 0.05,
                                                        format = "0.00", ticks = TRUE),
                                        br(), helpText(paste("This will control the middle break points for the color",
                                                             "gradient. The selected range will become white."))
                                        )
                                 )
                        )
             ),
             tabPanel("Scatter plot matrix",
                      fluidPage(
                        titlePanel("US State Facts and Figures"),
                        fluidRow(
                          column(2, wellPanel(
                            fluidRow(checkboxGroupInput("smVar", h5("Select variables"), sortChoices2, 
                                                        selected = sortChoices2[1:3])),
                            fluidRow(radioButtons("plotby", h5("Plot densities by:"), sortChoices1[2:3], 
                                                 selected = sortChoices1[2])),
                            checkboxGroupInput("selRegions", h5("Select region"),
                                               regions, selected = regions),
                            width=2)),
                          column(10, wellPanel(plotOutput("smplot")))
                          )
                        )
                      ),
             tabPanel("Parallel coordinates",
                      fluidPage(
                        titlePanel("US State Facts and Figures"),
                        fluidRow(
                          sidebarPanel(
                            fluidRow(checkboxGroupInput("pcpVar", h5("Select variables"), sortChoices2, 
                                                        selected = sortChoices2[1:3])),
                            fluidRow(radioButtons("pcpcolor", h5("Color by:"), sortChoices1[2:3], 
                                                  selected = sortChoices1[2])),
                            checkboxGroupInput("selRegions", h5("Select region"),
                                               regions, selected = regions),
                            width=2),
                          column(10, wellPanel(plotOutput("pcplot")))
                          )
                        )
                      )
             )
  )