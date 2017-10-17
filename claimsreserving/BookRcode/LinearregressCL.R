##  linear regression example showing equivalence to chain ladder
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#now do linear regression for first two columns.
#Use intercept of zero and weight is 1/x as per Section D6 of UK Claims reserving manual by Mack
x <-GenIns[,1]
y <-GenIns[,2]
#y~x+0 is a linear regression with intercept zero. weights 1/x gives col sum avg
linreg<-lm(y~x+0,weights=1/x)
linreg
#result should agree with column sum CL of 3.491
#Now use weight of 1/x^2, intercept of zero. Then get simple average.
linreg2<-lm(y~x+0,weights=1/(x^2))
linreg2
#above result is 3.566 which is simple average
#Now do for columns 4 and 5 which are as used in linear regression graph in relevant section
x2 <-GenIns[,4]
y2 <-GenIns[,5]
#y~x+0 is a linear regression with intercept zero. weights 1/x gives col sum avg
linreg4<-lm(y2~x2+0,weights=1/x2)
linreg4
#gives 1.174 as per graph of linear regression shown in CL as linear regression section
#show plot
X<-cbind(x2,y2)
plot(X,xlim=c(0,5000000),ylim=c(0,5000000),xlab="Column 4",ylab="Column 5")
abline(0,linreg4$coefficients)


