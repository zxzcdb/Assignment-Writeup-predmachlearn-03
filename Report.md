## Intruction

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
K-fold cross-validation is applied to evaluate the model. In this case, I split data into 5 folds.
```{r, cache = T}
t_control <- trainControl(method="cv", 5)
modelFit <- train(classe~., data=t_train, method="rf", trControl=t_control, prox=TRUE)
```

## Test the model
```{r, cache = T}
testmd <- predict(modelFit, newdata=t_test)
confusionMatrix(t_test$classe, testmd)
```
```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1672    1    0    0    1
##          B    8 1127    4    0    0
##          C    0    1 1020    5    0
##          D    0    0   14  949    1
##          E    0    0    0    6 1076
## 
## Overall Statistics
##                                          
##                Accuracy : 0.993          
##                  95% CI : (0.9906, 0.995)
##     No Information Rate : 0.2855         
##     P-Value [Acc > NIR] : < 2.2e-16      
##                                          
##                   Kappa : 0.9912         
##  Mcnemar's Test P-Value : NA             
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9952   0.9982   0.9827   0.9885   0.9981
## Specificity            0.9995   0.9975   0.9988   0.9970   0.9988
## Pos Pred Value         0.9988   0.9895   0.9942   0.9844   0.9945
## Neg Pred Value         0.9981   0.9996   0.9963   0.9978   0.9996
## Prevalence             0.2855   0.1918   0.1764   0.1631   0.1832
## Detection Rate         0.2841   0.1915   0.1733   0.1613   0.1828
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9974   0.9979   0.9907   0.9927   0.9984
```
The accuracy is 0.993. Out of sample error is 0.70%. Model is considered accurate.

## Predict
After the model built, I will use it to predict with 20 lines of data in test file.
```{r, cache = T}
Pred <- predict(modelFit, newdata=test)
Pred
```
The result is as follows:
```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
