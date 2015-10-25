### Intruction

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit, it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. 

In this project, My goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. There are two data files engaged in my research. "pml-training.csv" will be used to build the prediction model, including training and testing, and "pml-testing.csv" will be used to make the prediction.

====================================

### Preprocess

Following packages will be used during my research.

##　Packages:
```{r, cache = T}
library(caret)
library(AppliedPredictiveModeling)
library(randomForest)
library(ggplot2)
```

I will export the data into my working directory.

##　Data input:
```{r, cache = T}
setwd("./Machine Learning/Assignment1")
train_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test_url<-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(train_url,destfile="~/training.csv")
download.file(test_url,destfile="~/testing.csv")
train <- read.csv("~/training.csv", na.strings=c("NA","#DIV/0!",""))
test <- read.csv("~/testing.csv", na.strings=c("NA","#DIV/0!",""))
```

I take a breif look at the training data. It contains 19622 * 160 entries of data. Some of the variables are inessential for my research.

```{r, cache = T}
dim(train)
summary(train)
```

I remove following two kinds of variables:
1: Variables dont affect classe.
2: NA columns.

```{r, cache = T}



```

There are 406 


