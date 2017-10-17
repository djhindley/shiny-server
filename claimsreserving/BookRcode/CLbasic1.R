##  Basic chain ladder example, including linear regression and least squares for curve fitting to derive tail factor
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#apply basic chain ladder
#delta=1 is col sum avg. If out delta=2 get simple averages
chain1<-chainladder(GenIns,weights=1, delta=1)
#calc ata just for display purposes
chain1_link<-ata(GenIns)
#show link ratio estimators - numbers and graph
chain1_LR<-coef(chain1)
chain1_LR
plot(chain1_LR, type="h")
#show summary
chain1_sum<-summary(chain1_link,digits=3)
chain1_sum
#show projected triangle
chain1_predict<-predict(chain1)
chain1_predict
#now fit tail factor
x<-c(1,2,3,4,5,6,7,8,9)
y<-as.data.frame(chain1_LR)$chain1_LR
#Exponential curve
chain1_model<-lm(log(y-1)~x)
chain1_model
chain1_fitted<-1+exp(chain1_model$fitted.values)
chain1_fitted
#plot fitted line
lines(chain1_fitted,col="blue")
#show fit diagnostics for curve
summary(chain1_model)
#Inverse Power curve
chain2_model<-lm(log(y-1)~log(x))
chain2_model
chain2_fitted<-1+exp(chain2_model$fitted.values)
chain2_fitted
lines(chain2_fitted,col="green")
summary(chain2_model)
#now try least squares fitting method for exponential curve.
#starting values for a and b
a1=4
b1=2
nlschain1=nls(y~1+a1/(b1^x), start=list(a1=a1,b1=b1))
#summarise fit
summary(nlschain1)
a2=a1
b2=b1
weights=c(0,0,0,1,1,1,1,1,1)
nlschain2=nls(y~(1+a2/(b2^x)), weights=weights,start=list(a2=a2,b2=b2))
summary(nlschain2)
fitted.values(nlschain2)

