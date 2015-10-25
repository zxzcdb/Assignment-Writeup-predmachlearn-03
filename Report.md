## Introduction

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit, it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. 

In this project, My goal is to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. There are two data files engaged in my research. "pml-training.csv" will be used to build the prediction model, including training and testing, and "pml-testing.csv" will be used to make the prediction.

====================================

## Preprocess

Following packages will be used during my research.

###　Packages
```{r, cache = T}
library(caret)
library(ggplot2)
library(randomForest)
```

##　Data input
Two groups of data are imported.
"train" will be used to build and test the algorithm model.
"test" will be used to make prediction.
```{r, cache = T}
setwd("./Machine Learning/Assignment1")
train_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(train_url,destfile="~/training.csv")
download.file(test_url,destfile="~/testing.csv")
train <- read.csv("~/training.csv", na.strings=c("NA","#DIV/0!",""))
test <- read.csv("~/testing.csv", na.strings=c("NA","#DIV/0!",""))
```

## Preprocess data
Two parts of variables are removed to narrow down the dataset.
1 NA variables.
2 Irrelevant variables. In this case, I remove user name, time stamp and windows. These three types of data don't affect users' weight lifting manners.

```{r, cache = T}
train <- train[,colSums(is.na(train))==0]
test <- test[,colSums(is.na(test))==0]
train <- train[,-c(1:7)]
test <- test[,-c(1:7)]
dim(train)
dim(test)
```

There are 53 variables left in both groups of data.

```{r, cache = T}
[1] 19622    53
[1] 20 53
```

"train" data are sliced into two training part and testing part, with the proportion of 7:3. "test" data are kept for prediction in the next stage.
I also set seed 704 for reproducible purpose.

```{r, cache = T}
set.seed(704)
inTrain <- createDataPartition(train$classe,p=0.7,list=FALSE)
t_train <- train[inTrain,]
t_test <- train[-inTrain,]
```

## Build model
Here we have 52 variables to predict with, so I select Random Forest algorithm to build the model because it is quite accurate in picking the correlated variables. It takes long time but produce better result.
K-fold cross-validation is applied to evaluate the model. In this case, I split data into 10 folds.
```{r, cache = T}
t_control <- trainControl(method="cv", 10)
modelFit <- train(classe~., data=t_train, method="rf", trControl=t_control, prox=TRUE)
modelFit
```
```
Random Forest 

13737 samples
   52 predictor
    5 classes: 'A', 'B', 'C', 'D', 'E' 

No pre-processing
Resampling: Cross-Validated (10 fold) 

Summary of sample sizes: 12362, 12365, 12363, 12363, 12364, 12361, ... 

Resampling results across tuning parameters:

  mtry  Accuracy   Kappa      Accuracy SD  Kappa SD   
   2    0.9920661  0.9899627  0.003037128  0.003842659
  27    0.9919928  0.9898707  0.003049733  0.003858651
  52    0.9858791  0.9821367  0.005211504  0.006592073

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 2. 
```

## Test the model
```{r, cache = T}
testmd <- predict(modelFit, newdata=t_test)
confusionMatrix(t_test$classe, testmd)
```
```
Confusion Matrix and Statistics

          Reference
Prediction    A    B    C    D    E
         A 1673    0    0    0    1
         B    2 1137    0    0    0
         C    0    1 1025    0    0
         D    0    0   10  954    0
         E    0    0    0    0 1082

Overall Statistics
                                         
               Accuracy : 0.9976         
                 95% CI : (0.996, 0.9987)
    No Information Rate : 0.2846         
    P-Value [Acc > NIR] : < 2.2e-16      
                                         
                  Kappa : 0.997          
 Mcnemar's Test P-Value : NA             

Statistics by Class:

                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            0.9988   0.9991   0.9903   1.0000   0.9991
Specificity            0.9998   0.9996   0.9998   0.9980   1.0000
Pos Pred Value         0.9994   0.9982   0.9990   0.9896   1.0000
Neg Pred Value         0.9995   0.9998   0.9979   1.0000   0.9998
Prevalence             0.2846   0.1934   0.1759   0.1621   0.1840
Detection Rate         0.2843   0.1932   0.1742   0.1621   0.1839
Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
Balanced Accuracy      0.9993   0.9993   0.9951   0.9990   0.9995
```
The accuracy is 0.997.
```{r, cache = T}
out <- 1 - as.numeric(confusionMatrix(t_test$classe,testmd)$overall[1])
```
```
[1] 0.002378929
```
Out of sample error is 0.23%. Model is considered accurate.
 
## Predict
After the model built, I will use it to predict with 20 lines of data in test file.
```{r, cache = T}
Pred <- predict(modelFit, newdata=test)
Pred
```
The result is as follows:
```
[1] B A B A A E D B A A B C B A E E A B B B
Levels: A B C D E
```
