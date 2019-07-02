library(caret)
library(FNN)

video.df <- read.csv('VGS.csv', na.strings = '')

# Change Critic score into numeric and divide it by 10
video.df$Critic_Score <- video.df$Critic_Score / 10

# Cols we will be using are (10, 11, 13)
video.df <- video.df[, c(10, 11, 13)]

# Split the Global_Sales into fail and success
# Cut the data from the 95% percentile, because of overfitting issue
# Criteria we will be using is 0.29, 0.10, 0.15 deciding whether it's (SUCCESS) or (FAILURE)
video.df <- video.df[video.df$Global_Sales < 
                       quantile(video.df$Global_Sales, 0.95),]
video.df$Global_Sales <- factor(ifelse(video.df$Global_Sales < 1.5, 'Fail', 'Success'))

# Split data set into 7:3 ratio
set.seed(2)
train.index <- sample(row.names(video.df), 0.7*dim(video.df)[1])
train.df <- video.df[train.index,]
valid.index <- setdiff(row.names(video.df), train.index)
valid.df <- video.df[valid.index,]

# Plot with User Scores & Critic Scores
plot(Critic_Score ~ User_Score, data = train.df, 
     pch = ifelse(train.df$Global_Sales == 'Success', 16, 4))
legend('bottomright', c('Success', 'Fail'), pch = c(16,4))

# Normalizing data
video.norm.df <- video.df
train.norm.df <- train.df
valid.norm.df <- valid.df

norm.values <- preProcess(train.df[, c(2:3)], method = c('center', 'scale'))
video.norm.df[, 2:3] <- predict(norm.values, video.df[, 2:3])
train.norm.df[, 2:3] <- predict(norm.values, train.df[, 2:3])
valid.norm.df[, 2:3] <- predict(norm.values, valid.df[, 2:3])

knn.pred1 <- knn(train = train.norm.df[, 2:3], test = valid.norm.df[, 2:3], 
                 cl = train.norm.df[, 1], k = 14 )
confusionMatrix(knn.pred1, valid.norm.df[,1])
