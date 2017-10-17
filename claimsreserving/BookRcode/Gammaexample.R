##Gamma model and other glm models example
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#Fit the Gamma model to the data. var.power=2 is the Gamma; mse.method=formula uses the analytical approach 
#with first order Taylor approxmation.link.power=0 is the log-link
fit1<-glmReserve(GenIns, var.power=2, link.power=0, cum=TRUE, mse.method=c("formula"))
#extract the fitted model results in glm format from glmReserve
fit1_glm<-fit1$model
#now view the fitted values
fit1_glm$fitted.values
#Then view the fitted parameters
summary(fit1,type="model")
#And now the results
fit1$summary
#now derive Pearson residuals and view them
fit1_resid <-residuals(fit1_glm,type=c("pearson"))
fit1_resid
# plot of Pearsonresiduals
plot(fitted.values(fit1_glm),fit1_resid)
# qq plot of Pearson residuals
qqnorm(fit1_resid)
qqline(fit1_resid)
#write results to csv file for viewing in Excel
write.csv(fit1$summary,"Gamma1.csv")
##Now Normal with var.power=0
fit2<-glmReserve(GenIns, var.power=0, link.power=0, cum=TRUE, mse.method=c("formula"))
#extract the fitted model results in glm format from glmReserve
fit2_glm<-fit2$model
#now view the fitted values
fit2_glm$fitted.values
#Then view the fitted parameters
summary(fit2,type="model")
#And now the results
fit2$summary
#write results to csv file for viewing in Excel
write.csv(fit2$summary,"Gamma2.csv")
##Now var.power allowed to vary in 1 to 2 interval . Get this by putting var.power as NULL.
fit3<-glmReserve(GenIns,link.power=0, var.power=NULL,cum=TRUE, mse.method=c("formula"))
#extract the fitted model results in glm format from glmReserve
fit3_glm<-fit3$model
#now view the fitted values
fit3_glm$fitted.values
#Then view the fitted parameters
summary(fit3,type="model")
#And now the results
fit3$summary
#write results to csv file for viewing in Excel
#Note: results not shown in Table in text as they are the same as ODP
write.csv(fit3$summary,"Gamma3.csv")
#Now Inverse Gaussian with var.power=3
fit4<-glmReserve(GenIns, var.power=3, link.power=0, cum=TRUE, mse.method=c("formula"))
#extract the fitted model results in glm format from glmReserve
fit4_glm<-fit4$model
#now view the fitted values
fit4_glm$fitted.values
#Then view the fitted parameters
summary(fit4,type="model")
#And now the results
fit4$summary
#write results to csv file for viewing in Excel
write.csv(fit4$summary,"Gamma4.csv")

