
library(shiny)
library(shinydashboard)
shinyUI(
  dashboardPage(
    dashboardHeader(title = "Measurement"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Pre-Test", tabName = "dashboard", icon = icon("question")),
        menuItem("Mean & Median", tabName = "widgets", icon = icon("cog")),
        menuItem("Five Summary Number & Graph", tabName = "mean", icon = icon("cog"))
      )
    ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
                h2("Match each measurement into the blanks"),
                fluidRow(
                  column(4,
                         h4("Numerical Measure")
                  ),
                  column(4,
                         h4("Senstive Measure")
                  ),
                  column(4,
                         h4("Resistant Measure")
                  )
                ),
                fluidRow(
                  column(4,
                         hr(),
                         verbatimTextOutput('out1'),
                         selectInput('in1', 'Options', choices = list(
                           "Select two measurements" = c(`Measure of center` = 'Measure of center', `Measure of spread (Variation)` = 'Variation',
                                                         `Mean` = ' False', `Standard Deviation` = 'False',
                                                         `Median` = 'False', `Interquartile Range (IQR)` = 'False')
                         ), multiple=TRUE, selectize=TRUE)
                  ),
                  column(4,
                         hr(),
                         verbatimTextOutput('out2'),
                         selectInput('in2', 'Options', choices = list(
                           "Select two measurements" = c(`Measure of center` = 'False', `Measure of spread (Variation)` = 'You are Wrong',
                                                         `Mean` = 'Mean', `Standard Deviation` = 'Standard Deviation',
                                                         `Median` = 'Try again', `Interquartile Range (IQR)` = 'Not this one')
                         ), multiple=TRUE, selectize=TRUE)
                  ),
                  column(4,
                         hr(),
                         verbatimTextOutput('out3'),
                         selectInput('in3', 'Options', choices = list(
                           "Select two measurements" = c(`Measure of center` = 'False', `Measure of spread (Variation)` = 'Try again',
                                                         `Mean` = 'Not right', `Standard Deviation` = 'Try Others',
                                                         `Median` = 'Median', `Interquartile Range (IQR)` = 'IQR')
                         ), multiple=TRUE, selectize=TRUE) 
                  ))
        ),
        
        # Second tab content
        tabItem(tabName = "widgets",
                h2("Mean & Median"),
                fluidPage(
                  numericInput("max", "Input Maximum number", 2),
                  numericInput("min", "Input Minimum number", -2),
                  sliderInput(inputId = "opt.cex",
                              label = "Point Size (cex)",                            
                              min = 0, max = 5, step = 0.25, value = 2),
                  
                  # Add a row for the main content
                  fluidRow(
                    
                    # Create a space for the plot output
                    plotOutput(
                      "clusterPlot", "100%", "500px", click="clusterClick"
                    )
                  ),
                  
                  # Create a row for additional information
                  fluidRow(
                    # Take up 2/3 of the width with this element  
                    mainPanel("Mean: ", verbatimTextOutput("numPoints1")),
                    mainPanel("Median: ", verbatimTextOutput("numPoints2")),
                    
                    # And the remaining 1/3 with this one
                    sidebarPanel(actionButton("clear", "Clear Points"))
                  )    
                )
        ),
        tabItem(tabName = "mean",
                h2("Measurements of Changing Numbers"),
                fluidRow(
                  column(6,
                         hr(),
                           helpText("Move the slider bar to observe the changes of 'Five Number Summary Table',
                                    'Boxplot' and 'Histogram'"),
                           sliderInput("X1",
                                       "X1",
                                       min = 0,
                                       max = 100,
                                       value = 30)
                         ),
                  column(6,
                         hr(),
                           textOutput("text1"),
                           verbatimTextOutput("summary")
                         )
                ),
                fluidRow(
                  column(6,
                         hr(),
                         h3(textOutput("caption")),
                         plotOutput("distPlot")),
                  column(6,
                         hr(),
                         plotOutput("hisPlot"))
                )
                  )
        )
      )
    )
  )
