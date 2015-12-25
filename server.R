#Pima indians data explorer and Machine learning
library(shiny)
library(rCharts)

# Load helper functions
source("helperFunctions.R", local = TRUE)

csvData <- loadData('data/pima-data.csv')
colNames<-colnames(csvData)
allPredictors<-colNames[-length(colNames)]
#colDesc<-csvData.descriptions
cleanFlag<-TRUE


shinyServer(function(input, output, session) 
{
  
  # Define and initialize reactive values
  selPredictors <- reactiveValues()
  selPredictors$values <- c()
  
  # Create data vars checkbox
  output$predictors <- renderUI({
    checkboxGroupInput('predictors', 'Predictors', allPredictors, selected=selPredictors$values)
  })
  
  observe({
    if(input$selectAllPredictors == TRUE) 
    selPredictors$values <- allPredictors
  })
  
  observe({
    if(input$selectAllPredictors== FALSE) 
    selPredictors$values <- c()
  })
 
  observe({input$cleanFlag          
           })
  
  ########################################
  # Dataset for Data tab
  data.filter <- reactive({
    filterData(csvData, input$predictors, input$cleanFlag)
  })
    
  # Prepare dataset 
  dataTable <- reactive({
    data.filter()
  })
  
  # Render data table
  output$dataTable <- renderDataTable(dataTable() )   
  
  output$dataSummary <- renderPrint({
    data<-data.filter()
    nPredictors<-dim(data)[2]-1
    nObs<-dim(data)[1]
    if(nPredictors>1 && nObs>0){
       summary.data.frame(data[1:nPredictors])
    }
  })
  
#########################################
# Render Plots

# Pairs plot
 output$pairsPlot <- renderPlot({
   print(pairsPlot (data.filter()))
 })
#summary



})