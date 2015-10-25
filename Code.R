## Project 1
## The goal of your project is to predict the manner in which they did the exercise. 
## This is the "classe" variable in the training set. You may use any of the other variables to predict with.
## You should create a report describing how you built your model, 
## Yes

## how you used cross validation, 
## Yes

## what you think the expected out of sample error is, 
## Yes

## and why you made the choices you did. 
## Yes

## You will also use your prediction model to predict 20 different test cases.
## Yes

## Data input and preprocessing
library(caret)
library(ggplot2)
library(randomForest)

setwd("./Machine Learning/Assignment1")
train_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(train_url,destfile="~/training.csv")
download.file(test_url,destfile="~/testing.csv")
train <- read.csv("~/training.csv", na.strings=c("NA","#DIV/0!",""))
test <- read.csv("~/testing.csv", na.strings=c("NA","#DIV/0!",""))

train <- train[,colSums(is.na(train))==0]
test <- test[,colSums(is.na(test))==0]
train <- train[,-c(1:7)]
test <- test[,-c(1:7)]

## Slice data
set.seed(704)
inTrain <- createDataPartition(train$classe,p=0.7,list=FALSE)
t_train <- train[inTrain,]
t_test <- train[-inTrain,]

## Build model
t_control <- trainControl(method="cv", 10)
modelFit <- train(classe~., data=t_train, method="rf", trControl=t_control, prox=TRUE)
modelFit
