## Q1
ebay.df <- read.csv('eBayAuctions.csv', na.strings = '')

## Q2
ebay.df$Duration <- factor(ebay.df$Duration)
class(ebay.df$Duration)

## Q3
set.seed(1)
train.index <- sample(c(1:dim(ebay.df)[1]), dim(ebay.df)[1]*0.6)
train.df <- ebay.df[train.index,]
valid.df <- ebay.df[-train.index,]
dim(train.df)
dim(valid.df)

## Q4
library(rpart)
library(rpart.plot)
default.ct <- rpart(Competitive.~., data = train.df, method = 'class')
prp(default.ct, type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10)

## Q5
library(caret)

default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class") 
confusionMatrix(table(default.ct.point.pred.valid, valid.df$Competitive.))

## Q6
smaller.ct <- rpart(Competitive.~., data = train.df, method = 'class',
                    minbucket = 50, maxdepth = 7)
prp(smaller.ct, type = 1, extra = 1, under = TRUE, split.font = 2, varlen = -10)

## Q7
smaller.ct.point.pred.valid <- predict(smaller.ct, valid.df, type = 'class')
confusionMatrix(table(smaller.ct.point.pred.valid, valid.df$Competitive.))
