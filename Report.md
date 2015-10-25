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

```{r, cache = T}
setwd("./Machine Learning/Assignment1")
train_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(train_url,destfile="~/training.csv")
download.file(test_url,destfile="~/testing.csv")
train <- read.csv("~/training.csv")
test <- read.csv("~/testing.csv")
```

## Preprocess data

```{r, cache = T}
dim(train)
summary(train)
```

Training data contains 19622 observations and 160 variables. Two parts of variables are removed to narrow down the dataset.
1 NA variables.
2 Irrelevant variables. In this case, I remove user name, time stamp and windows. These three types of data don't affect users' weight lifting manners.

```{r, cache = T}
train <- train[,colSums(is.na(train))==0]
test <- test[,colSums(is.na(test))==0]
train <- train[,-c(1:7)]
test <- test[,-c(1:7)]
dim(train)
```

There are 53 variables left.

```{r, cache = T}
[1] 19622    53
```

Train data are sliced into two parts, train(70%) and test(30%. The original test data are kept for future prediction.
I also set seed 704 for reproducible purpose.

```{r, cache = T}
set.seed(704)
inTrain <- createDataPartition(train$classe,p=0.7,list=FALSE)
t_train <- train[inTrain,]
t_test <- train[-inTrain,]
```

## Build model
Here we have 52 variables to predict with, so I select Random Forest algorithm to build the model because it is quite accurate in picking the correlated variables.
K-fold cross-validation is applied to evaluate the model. In this case, I split data into 10 folds.
```{r, cache = T}
t_control <- trainControl(method="cv", 10)
modelFit <- train(classe~., data=t_train, method="rf", trControl=t_control, prox=TRUE)
modelFit
```


## Evaluate the model

