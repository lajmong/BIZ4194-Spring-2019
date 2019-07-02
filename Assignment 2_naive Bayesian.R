##1
#Download a csv file and read the empty cells as missing values
titanic.df <- read.csv('titanic_hw.csv', na.strings = '')
View(titanic.df)
dim(titanic.df)
str(titanic.df)

##2
#Report the number of missing values for each of the variables
colSums(is.na(titanic.df))

##3
#Create bins for Age as follows;
titanic.df$Age <- floor(titanic.df$Age)
titanic.df$AgeG <- cut(titanic.df$Age+1, seq(0,90,by=10), labels = c(0:8))
head(titanic.df, n=10)

##4
#Convert data types of variables to factors.
titanic.df$Pclass <- factor(titanic.df$Pclass)
class(titanic.df$Pclass)
class(titanic.df$Sex)
class(titanic.df$AgeG)
titanic.df$Survived <- factor(titanic.df$Survived)
class(titanic.df$Survived)
str(titanic.df)
selected.var <- c(3,5,13,2)

##5
#Partition the data into training (70%) and validation (30%), 
#and run naive Bayes on the training data. 
#Use set.seed(2) to get the same partitions when re-running the R code.
library(e1071)
set.seed(2)
train.index <- sample(c(1:dim(titanic.df)[1]), dim(titanic.df)[1]*0.7)
train.df <- titanic.df[train.index, selected.var]
valid.df <- titanic.df[-train.index, selected.var]                      
dim(train.df)
dim(valid.df)
titanic.nb <- naiveBayes(Survived~., data = train.df)

##6
#Report predicted probabilities for survival and predicted class in the valid data
pred.prob <- predict(titanic.nb, newdata = valid.df, type = 'raw')
head(pred.prob, n=10)
pred.class <- predict(titanic.nb, newdata = valid.df)
head(pred.class, n=10)

df <- data.frame(actual = valid.df$Survived, predicted = pred.class, pred.prob)
head(df, n=10)

##7
#Report actual and predicted probabilities/classes of the following;
df[valid.df$Sex == 'male' & valid.df$Pclass == '2' & 
     valid.df$AgeG == '4',]

##8
#Plot ROC curve and report AUC
library(pROC)
ROC_titanic <- roc((ifelse(valid.df$Survived == '0', 1, 0)), pred.prob[,1])
plot(ROC_titanic, col='pink')
AUC_titanic <- auc(ROC_titanic)
AUC_titanic

##9
#Plot a lift chart
library(gains)
gain <- gains(ifelse(valid.df$Survived == '0', 1, 0), 
              pred.prob[,1], groups = 10)
gain
plot(c(0, gain$cume.pct.of.total*sum(valid.df$Survived =='0'))~
       c(0, gain$cume.obs), xlab = '# cases', ylab = 'Cumulative', main = '',
     type = 'l')
lines(c(0, sum(valid.df$Survived == '0'))~c(0, dim(valid.df)[1]), lty = 2)

##10
#Report a confusion matrix for each of the train and valid data
library(caret)
pred.class <- predict(titanic.nb, newdata = train.df)
pred.class
confusionMatrix(pred.class, train.df$Survived)

pred.class <- predict(titanic.nb, newdata = valid.df)
pred.class
confusionMatrix(pred.class, valid.df$Survived)
