##ODP model example
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#Fit the ODP model to the data. var.power=1 is the ODP; mse.method=formula uses the analytical approach with first order Taylor approxmation
#link.power=0 gives the log link function
fit1<-glmReserve(GenIns, var.power=1, link.power=0, cum=TRUE, mse.method=c("formula"))
#extract the fitted model results in glm format from glmReserve
fit1_glm<-fit1$model
#now view the fitted values
fit1_glm$fitted.values
#Then view the fitted parameters
summary(fit1,type="model")
#And now the results
fit1$summary
#now derive Pearson residuals and view them.  Agrees with Pearson residuals table in bootstrap numerical example
fit1_resid <-residuals(fit1_glm,type=c("pearson"))
fit1_resid
# plot of Pearsonresiduals
plot(fitted.values(fit1_glm),fit1_resid)
# qq plot of Pearson residuals
qqnorm(fit1_resid)
qqline(fit1_resid)
#now do shapiro-wilk test for Normality
shapiro.test(fit1_resid)