#Pima diabetes data
library(shiny)
library(rCharts)

shinyUI(
  navbarPage("Diabetes Data Exploring and Analysis",
             tabPanel("Explore Data",
                      sidebarPanel(width = 3,
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
                          ),#Data#1of3
                          tabPanel(p(icon("line-chart"), "Prepare"),
                                   plotOutput("pairsPlot", width="85%", height="600px")
                          ),#Plots#2of3
                          tabPanel(p(icon("?"), "Prediction"),
                                   wellPanel(
                                     radioButtons(
                                       "learning",
                                       inline=TRUE,
                                       width="100%",
                                       "Model:",
                                       c("Logistic Regression" = "logistic", "Random Forrest (not yet)" = "rf"))
                                   ),
                                   column(width = 4,
                                          wellPanel(
                                            helpText("Selected Predictor(s) Values"),
                                            uiOutput("predict"),
                                            uiOutput("pregnant"),
                                            uiOutput("glucose"),
                                            uiOutput("diastolic"),
                                            uiOutput("triceps"),
                                            uiOutput("insulin"),
                                            uiOutput("bmi"),
                                            uiOutput("diabetes"),
                                            uiOutput("age")
                                          )
                                   ),
                                   fluidRow(
                                     uiOutput("predictFlow")
                                   )
                                   
                          )#Prediction#3of3                          
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

