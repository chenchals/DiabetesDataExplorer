library(GGally)

#' Lod dataset
#' 
#' @param pimaLocal fullpath to filename
#' @return data.frame
#'
loadData<-function(pimaLocal){
  #load pima indians data
  pimaUrl<-"http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data"
  #pimaLocal<-"data/pima-data.csv"
  #download.file(url = pimaUrl, destfile = pimaLocal, method = "curl")
  csvData<-read.csv(pimaLocal)
  columnDescriptions<-c("Number of times pregnant",
                        "Plasma glucose concentration a 2 hours in an oral glucose tolerance test",
                        "Diastolic blood pressure (mm Hg)",
                        "Triceps skin fold thickness (mm)",
                        "2-Hour serum insulin (mu U/ml)",
                        "Body mass index (weight in kg/(height in m)^2)",
                        "Diabetes pedigree function",
                        "Age (years)",
                        "Class variable (0 or 1))"
  )
  columnNames<-c("pregnant","glucose","diastolic","triceps","insulin", "bmi","diabetes","age", "test")
  colnames(csvData)<-columnNames
  # csvData.descriptions<-columnDescriptions
  csvData
}

#' Filter dataset by selected predictors and clean flag
#' 
#' @param data data.frame
#' @param selAttributes list of predictor names
#' @param cleanFlag 1= clean 0=raw
#' @return data.frame
#'
filterData<-function(data, selAttributes, cleanFlag){
  ind<-match(selAttributes,colnames(data))
  if(length(ind)>0){
    if(cleanFlag=="clean"){
      cleanData(data[c(ind,9)])
    }else{
      data[c(ind,9)]
    }
  }else{
    subset(data,test>1) # no rows
  }
}

#' Clean sets values that are 0 to NaN
#' 
#' @param data data.frame
#' @return data.frame
#'
cleanData<-function(data){
  colNames<-colnames(data)
  for(col in colNames) {
    if(col %in% cols2Clean){
      data[col][data[col]==0]=NaN
    }
  }
  data
}

############PLOTS##############
#' Create ggpairs plot (not used)
#' 
#' @param inData data.frame
#' @return plot
#'
pairsPlotCorr <- function (inData) {
  nPredictors<-dim(inData)[2]-1
  if(nPredictors>1){
    cc<-complete.cases(inData)
    data<-inData[cc,]
    data$test[data$test==0]="Norm."
    data$test[data$test==1]="Diab."
    ggpairs(data = data, columns = c(1:nPredictors), 
            colour="test", alpha=0.4,
            params=list(corSize=4))     
  }
  else
  {
    cat(paste("Plotting when nPredictors =",nPredictors,"\n"))
    plot(0, 0, axes=FALSE, frame.plot=FALSE, xlab = "", ylab="",cex=0.01, main = "Please select at least 2 predictors for plotting")    
  }
}

#' Create pairsPlot
#' 
#' @param inData data.frame
#' @return plot
#'
pairsPlot <- function (inData) {
  nPredictors<-dim(inData)[2]-1
  if(nPredictors>1){
    cc<-complete.cases(inData)
    data<-inData[cc,]
    cols <- character(nrow(data))
    cols[] <- "blue"
    data$test[data$test==0]="Normal"
    data$test[data$test==1]="Diabetic"
    
    cols[data$test=="Normal"] <- "blue"
    cols[data$test=="Diabetic"] <- "red"
    pairs(data[1:nPredictors],col=cols, pch=20, cex=1)
    par(xpd=TRUE)
    legend(-0.05, 1.03, as.vector(unique(data$test)),  
           fill=c("blue", "red"))
  }
  else
  {
    cat(paste("Plotting when nPredictors =",nPredictors,"\n"))
    plot(0, 0, axes=FALSE, frame.plot=FALSE, xlab = "", ylab="",cex=0.01, main = "Please select at least 2 predictors for plotting")    
  }
  
}

#' Fit logistic regression
#' 
#' @param inData data.frame
#' @return model
#'
fitLogitModel<-function(inData){
  nPredictors<-dim(inData)[2]-1
  if(nPredictors > 0){
    model<-glm(test~., data=inData, family=binomial(link=logit))
    model
  }
  
}

