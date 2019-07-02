vgs.df=read.csv("VGS.csv",na.strings="")

library(neuralnet)
library(nnet)
library(caret)

View(vgs.df)
vgs.df$Global_Sales=ifelse(vgs.df$Global_Sales>=1,1,0)
vgs.df$Critic_Score=round((vgs.df$Critic_Score-min(vgs.df$Critic_Score))/(max(vgs.df$Critic_Score)-min(vgs.df$Critic_Score)),digit=2)
vgs.df$User_Score=round((vgs.df$User_Score-min(vgs.df$User_Score))/(max(vgs.df$User_Score)-min(vgs.df$User_Score)),digit=2)

vgs.df1=data.frame(class.ind(vgs.df$Global_Sales))
names(vgs.df1)=c("no_hit","hit")
vars=c("Critic_Score","User_Score")
vgs.df2=cbind.data.frame(vgs.df[,vars],vgs.df1)

set.seed(2)
train.index=sample(rownames(vgs.df2),dim(vgs.df2)[1]*0.6)
valid.index=setdiff(row.names(vgs.df2),train.index)

train.df=data.frame(vgs.df2[train.index,])
valid.df=data.frame(vgs.df2[valid.index,])

nn=neuralnet(no_hit+hit~Critic_Score+User_Score,data=train.df,hidden=3)
plot(nn)


training.prediction=compute(nn,train.df[,-c(3:4)])
training.class=apply(training.prediction$net.result,1,which.max)-1
confusionMatrix(factor(training.class),factor(vgs.df[train.index,]$Global_Sales))

valid.prediction=compute(nn,valid.df[,-c(3:4)])
valid.class=apply(valid.prediction$net.result,1,which.max)-1
confusionMatrix(factor(valid.class),factor(vgs.df[valid.index,]$Global_Sales))
