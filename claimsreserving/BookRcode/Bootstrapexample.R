##Bootstrap model example: includes both ODP and Gamma process errors.
#Load the Chainladder package
library("ChainLadder")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#set seed so can repeat results
set.seed(1328967780)
#Run a chain ladder bootstrap model with 5000 sims and ODP for process error
Boot1<-BootChainLadder(GenIns, 5000,process.dist=c("od.pois"))
#View results
Boot1summary <-summary(Boot1)
Boot1summary
#Look at residuals
Boot1Resid<-Boot1$ChainLadder.Residuals
Boot1Resid
#show graphs that summarize results
plot(Boot1)
#new plot
#plot(standard.residuals ~ cal.period, data=Residuals,
#    ylab="Standardised residuals", xlab="Calendar period")
#lines(lowess(Residuals$cal.period, Residuals$standard.residuals), col="red")
#abline(h=0, col="grey")
#show quantiles
Boot1_quant=quantile(Boot1,probs=c(0.5,0.75,0.9,0.95,0.995))
Boot1_quant
#now write results to CSV file for importing to Excel
write.csv(Boot1summary$ByOrigin,"Boot1_origin.csv")
write.csv(Boot1summary$Total,"Boot1_total.csv")
write.csv(Boot1_quant,"Boot1_quant.csv")
#fit a lognormal distribution to the bootstrap IBNR across all cohorts combined
#first load stats library
library(MASS)
fit <- fitdistr(Boot1$IBNR.Totals[Boot1$IBNR.Totals>0], "lognormal")
#show results of fit
fit
#now draw actual and fitted cumulative distribution function
plot(ecdf(Boot1$IBNR.Totals))
curve(plnorm(x,fit$estimate["meanlog"], fit$estimate["sdlog"]), col="red", add=TRUE)
#now do with Gamma process distribution
set.seed(1328967780)
#Run a chain ladder bootstrap model with 5000 sims and now gamma for process error
Boot2<-BootChainLadder2(GenIns, 5000,process.dist=c("gamma"))
#View results
Boot2summary <-summary(Boot2)
Boot2summary
#Look at residuals
Boot2Resid<-Boot2$ChainLadder.Residuals
Boot2Resid
#show graphs that summarize results
plot(Boot2)
#show qunatiles
Boot2_quant=quantile(Boot2,probs=c(0.5,0.75,0.9,0.95,0.995))
Boot2_quant
#now write results to CSV file for importing to Excel
write.csv(Boot2summary$ByOrigin,"Boot2_origin.csv")
write.csv(Boot2summary$Total,"Boot2_total.csv")
write.csv(Boot2_quant,"Boot2_quant.csv")
processfunc<-function(value)
{
  if (value==1) {proc=c("od.pois")}
  else if (value==2) {proc=c("gamma")}
}