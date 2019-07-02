library(datasets)
iris.df <- data.frame(iris)
View(iris.df)
str(iris.df)

##Q1 Partition into train(0.6), valid(0.4)
# Use set.seed(111) and report the dimension for each df
set.seed(111)
train.index <- sample(row.names(iris.df), 0.6*dim(iris.df)[1])
valid.index <- setdiff(row.names(iris.df), train.index)
train.df <- iris.df[train.index,]
dim(train.df)
valid.df <- iris.df[valid.index,]
dim(valid.df)

##Q2 Normalize values in train, valid, and iris data.
# Report the first five records of each after the values are normalized
library(caret)
train.norm.df <- train.df
valid.norm.df <- valid.df
iris.norm.df <- iris.df

norm.values <- preProcess(train.df[, 1:4], method = c('center', 'scale'))
train.norm.df[, 1:4] <- predict(norm.values, train.df[, 1:4])
head(train.norm.df, n=5)

valid.norm.df[, 1:4] <- predict(norm.values, valid.df[, 1:4])
head(valid.norm.df, n=5)

iris.norm.df[, 1:4] <- predict(norm.values, iris.df[, 1:4])
head(iris.norm.df[, 1:4], n=5)

##Q3 Classify a new record with the following, using k-NN model(k=4)
new.df <- data.frame(Sepal.Length = 5.0, Sepal.Width = 2.7, Petal.Length = 5.2, Petal.Width = 2.0)
new.norm.df <- predict(norm.values, new.df)

library(FNN)
nn <- knn(train = train.norm.df[, 1:4], test = new.norm.df, 
          cl = train.norm.df[, 5], k = 4)
nn

##Q4 Report the row names of the four nearest neighbors of the new record
row.names(train.df)[attr(nn, 'nn.index')]

##Q5 Develop a k-NN model using the train data and apply the model to valid data.
# Show the output of confusionMatrix() to report performance metrics.
knn.pred <- knn(train = train.norm.df[, 1:4], test = valid.norm.df[, 1:4],
                cl = train.norm.df[, 5], k = 4)
accuracy <- confusionMatrix(knn.pred, valid.norm.df[, 5])
accuracy

##Q6 Create a table that reports the overall accuracy for each k values, from 1 to 10.
accuracy.df <- data.frame(k = seq(1, 10, 1), accuracy = rep(0, 10))
for (i in 1:10){
  knn.pred <- knn(train = train.norm.df[, 1:4], test = valid.norm.df[, 1:4],
                  cl = train.norm.df[, 5], k = i)
  accuracy.df[i, 2] <- confusionMatrix(knn.pred, valid.norm.df[, 5])$overall[1]
}
options(digits = 2)
accuracy.df