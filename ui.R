#Pima diabetes data
library(shiny)
library(rCharts)

shinyUI(
  navbarPage("Diabetes Data Exploring and Analysis",
             tabPanel("Explore Data",
                      sidebarPanel(
                        wellPanel(
                          uiOutput("predictors")
                        ),
                        wellPanel(
                          checkboxInput('selectAllPredictors', 'Select All Predictors')
                        ),
                        wellPanel(
                          radioButtons(
                            "cleanFlag",
                            "Use Data:",
                            c("Clean" = "clean", "Raw" = "raw")),
                          helpText("Values of some variables that are 0 will be set to NaN.  
                                   These as blood glucose, diastolic pressure, triceps thickness, 
                                   body mass index, insulin level (may be in Type I diabetes)
                                   Check the last row in the summary for number of \"NA\" observations.")
                        )
                      ),
                      
                      mainPanel(
                        tabsetPanel(
                          tabPanel(p(icon("table"), "Data"),
                                   tags$style(type='text/css', '#dataSummary {background-color: rgba(255,255,255,0.10); color: blue; font-size: 10px;}'), 
                                   verbatimTextOutput("dataSummary"),
                                   dataTableOutput(outputId="dataTable")
                          ),#tabPanel#1of3
                          # Plots
                          tabPanel(p(icon("line-chart"), "Prepare"),
                                   plotOutput("pairsPlot", width="90%", height="900px")
                          ),#tabPanel#2of3
                          # Prediction
                          tabPanel(p(icon("?"), "Prediction"),
                                   column(3,
                                          wellPanel(
                                            radioButtons(
                                              "predict",
                                              "Machine Learning:",
                                              c("Logistic Regression" = "logistic", "Random Forrest" = "rf"))
                                          )
                                   ),
                                   column(7,
                                          plotOutput("xx")
                                   )
                          )#tabPanel#3of3                          
                        ) #tabsetPanel
                      )#mainPanel
                      
             ),#tabPanel#1
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("about.Rmd")
                      )
             )#tabPanel#2
  )
)
