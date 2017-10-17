##Clark models example
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#translate the index so that it is expressed in months
X <- GenIns
colnames(X) <- 12*as.numeric(colnames(X))
#fit a Clark LDF model loglogistic uncapped
Clark1<-ClarkLDF(X,G="loglogistic")
Clark1
plot(Clark1)
#fit a Clark LDF model loglogistic capped
Clark2<-ClarkLDF(X,G="loglogistic", maxage=240)
Clark2
plot(Clark2)
#fit a Clark LDF model Weibull
Clark3<-ClarkLDF(X,G="weibull")
Clark3
plot(Clark3)
#fit a Clark Cape Cod model loglogistic 
Clark4 <- ClarkCapeCod(X, G="loglogistic",Premium=10000000+400000*0:9, maxage=240)
Clark4
plot(Clark4)
#fit a Clark Cape Cod model weibull
Clark5 <- ClarkCapeCod(X, G="weibull",Premium=10000000+400000*0:9)
Clark5
plot(Clark5)