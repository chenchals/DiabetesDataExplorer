#Pima indians data explorer and Machine learning
library(shiny)
library(rCharts)

# Load helper functions
source("helperFunctions.R", local = TRUE)

csvData <- loadData('data/pima-data.csv')
cols2Clean<-c("glucose","diastolic","triceps","insulin", "bmi","age")
colNames<-colnames(csvData)
allPredictors<-colNames[-length(colNames)]
#colDesc<-csvData.descriptions
cleanFlag<-TRUE


shinyServer(function(input, output, session) 
{
  # Define and initialize reactive values
  selPredictors <- reactiveValues()
  selPredictors$values <- c()
  
  #############################################  
  # Create UI components reactively
  output$predictors <- renderUI({
    checkboxGroupInput('predictors', 'Predictors', allPredictors, selected=selPredictors$values)
  })
  
  output$pregnant <- renderUI({
    createSlider('pregnant', 'Pregnant', 1)
  })
  
  output$glucose <- renderUI({
    createSlider('glucose', 'Glucose', 1)
  })
  
  output$diastolic <- renderUI({
    createSlider('diastolic', 'Diastolic', 1)
  })  
  
  output$insulin <- renderUI({
    createSlider('triceps', 'Triceps', 1)
  }) 
  
  output$triceps <- renderUI({
    createSlider('insulin', 'Insulin', 1)
  }) 
  
  output$age <- renderUI({
    createSlider('age', 'Age', 1)
  }) 
  
  output$bmi <- renderUI({
    createSlider('bmi', 'BMI', 0)
  }) 
  
  output$diabetes <- renderUI({
    createSlider('diabetes', 'Diabetes', 0)
  }) 
  
  output$predictFlow <-renderUI({
    if(length(input$predictors) > 0){
      column(7,
             wellPanel(
               tags$style(type='text/css', '#prediction {background-color: rgba(255,128,128,0.10); color: red; font-size: 20px;}'),                
               helpText("Prediction for input values"),
               verbatimTextOutput("prediction")
             ),
             wellPanel(
               tags$style(type='text/css', '#modelSummary {background-color: rgba(255,255,255,0.10); color: blue; font-size: 11px;}'),                
               helpText("Model results..."),
               verbatimTextOutput("modelSummary")
             )
      )
    }
  })
  
  ########################################  
  observe({
    if(input$selectAllPredictors == TRUE) 
      selPredictors$values <- allPredictors
  })
  
  observe({
    if(input$selectAllPredictors== FALSE) 
      selPredictors$values <- c()
  })
  
  observe({input$cleanFlag})
  
  ########################################
  createSlider<-function(colName, label, isInt){
    if(length(input$predictors)>1){
      if(colName %in% input$predictors){
        v<-sliderParams(colName, isInt)
        s<-sliderInput(colName, colName, min=v$lo, max=v$hi, value=round(v$m,digits=2), step = v$step)
        s
      }
    }
  }
  
  sliderParams<-function(colName, isInt){
    d<-data.filter()[colName]
    v<-list()
    m<-mean(d[,1],na.rm=TRUE)
    sd<-sd(d[,1],na.rm=TRUE)
    lo<-round(m-4*sd, digits=2)
    lo[lo<0]=0
    hi<-round(m+4*sd, digits=2)
    if(isInt==1){
      v$m<-ceiling(m)
      v$lo<-ceiling(lo)
      v$hi<-ceiling(hi)
      v$step=1
    }else{
      v$m<-round(m,digits=2)
      v$lo<-round(lo,digits=2)
      v$hi<-round(hi,digits=2)
      v$step=round((v$hi-v$lo)/20, digits=2)
    }
    v
  }
  
  
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
  output$pairsPlot <- renderPlot({
    print(pairsPlot (data.filter()))
  })
  
  #########################################
  output$prediction<-renderPrint({
    if(length(input$predictors) > 1){
    rec<-test.record()
    #assuming guassian.. may be incorrect
    pred<-predict(logitModel(), newdata = rec, se.fit = T, type="response")
    cat(paste("Probability Diabetic: ",round(pred$fit*100,digits=0),"%\n"))
    }
  })
  
  output$modelSummary<-renderPrint({
    if(length(input$predictors) > 1){
    summary(logitModel())
    }
  })
  
  
  logitModel<-function(){
    if(length(input$predictors > 1)){
      model<-fitLogitModel(data.filter())
      model
    }
  }
  
  test.record<-reactive({
    if(length(input$predictors > 1)){
      test<-list()
      for(colName in input$predictors){
        test[colName]<-input[[colName]]
      }
      test["test"]<-NA
      testRec<-as.data.frame(test)
      testRec
    }
  })
  
  
})