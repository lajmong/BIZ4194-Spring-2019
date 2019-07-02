bank.df <- read.csv('bank.csv')
bank.df = na.omit(bank.df)
str(bank.df)
head(bank.df)
## Q1
bank.df$age <- (bank.df$age - min(bank.df$age)) /
                (max(bank.df$age) - min(bank.df$age))
bank.df$balance <- (bank.df$balance - min(bank.df$balance)) /
  (max(bank.df$balance) - min(bank.df$balance))
bank.df$campaign <- (bank.df$campaign - min(bank.df$campaign)) /
  (max(bank.df$campaign) - min(bank.df$campaign))

head(bank.df, n = 6)

## Q2
library(nnet)
bank.df1 <- cbind(bank.df, class.ind(bank.df$education),
                  class.ind(bank.df$y))
names(bank.df1) = c(names(bank.df), paste('edu_', c(1, 2, 3, 9), sep = ''), 
                    paste('term_d_', c('yes', 'no'), sep = ''))
head(bank.df1)
names(bank.df1)

## Q3
vars = c('age', 'balance', 'campaign', 'previous')
bank.df2 <- cbind(bank.df[, c(vars)], class.ind(bank.df$education),
                  class.ind(bank.df$y))
names(bank.df2) = c(vars, paste('edu_', c(1, 2, 3, 9), sep = ''), 
                    paste('term_d_', c('yes', 'no'), sep = ''))
head(bank.df2)
names(bank.df2)

## Q4
set.seed(2)
train.index = sample(rownames(bank.df2), dim(bank.df2)[1] * 0.6)
valid.index = setdiff(rownames(bank.df2), train.index)

train.df <- bank.df2[train.index,]
valid.df <- bank.df2[valid.index,]
dim(train.df)
dim(valid.df)

## Q5
library(neuralnet)
nn1 <- neuralnet(term_d_yes + term_d_no ~., data = train.df, 
                 hidden = c(3, 2))
plot(nn1)

## Q6(a)
library(caret)
train.pred <- compute(nn1, train.df[, -c(9, 10)])
#head(train.pred$net.result, n = 10)
train.class <- apply(train.pred$net.result, 1, which.max) - 1
#head(train.class, n = 10)
confusionMatrix(factor(train.class),
                factor(bank.df2[train.index,]$term_d_no))

## Q6(b)
valid.pred <- compute(nn1, valid.df[, -c(9, 10)])
valid.class <- apply(valid.pred$net.result, 1, which.max) - 1
confusionMatrix(factor(valid.class),
                factor(bank.df2[valid.index,]$term_d_no))
