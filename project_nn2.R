vgs.df=read.csv("VGSp.csv",na.strings="")

library(neuralnet)
library(nnet)
library(caret)

vgs.df$Global_Sales=ifelse(vgs.df$Global_Sales>=1,1,0)
vgs.df1=data.frame(class.ind(vgs.df$Global_Sales))
genre=data.frame(class.ind(vgs.df$Genre))
View(genre)
names(genre)=paste("G_",names(genre))

platform=data.frame(class.ind(vgs.df$Platform))
View(platform)
names(platform)=paste("P_",names(platform))

rating=data.frame(class.ind(vgs.df$Rating))
View(rating)
names(rating)=paste("R_",names(rating))

View(vgs.df1)
names(vgs.df1)=c("no_hit","hit")
vars=c("Platform","Genre","Rating")
vgs.df2=cbind.data.frame(platform,genre,rating,vgs.df1)
View(vgs.df2)


set.seed(2)
train.index=sample(rownames(vgs.df2),dim(vgs.df2)[1]*0.6)
valid.index=setdiff(row.names(vgs.df2),train.index)

train.df=data.frame(vgs.df2[train.index,])
valid.df=data.frame(vgs.df2[valid.index,])

nn=neuralnet(no_hit+hit~P_.Nintendo+P_.PC+P_.Playstation+
               P_.Xbox+G_.Action+G_.Adventure+G_.Fighting+
               G_.Misc+G_.Platform+G_.Puzzle+G_.Racing+
               G_.Role.Playing+G_.Shooter+G_.Simulation+
               G_.Sports+G_.Strategy+R_.E+R_.E10.+R_.M+
               R_.RP+R_.T,data=train.df,hidden=3)
plot(nn)

training.prediction=compute(nn,train.df[,-c(22:23)])
training.class=apply(training.prediction$net.result,1,which.max)-1
confusionMatrix(factor(training.class),factor(vgs.df[train.index,]$Global_Sales))

valid.prediction=compute(nn,valid.df[,-c(22:23)])
valid.class=apply(valid.prediction$net.result,1,which.max)-1
confusionMatrix(factor(valid.class),factor(vgs.df[valid.index,]$Global_Sales))
