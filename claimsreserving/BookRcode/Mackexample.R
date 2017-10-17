##  Mack model example
#Load the Chainladder package
library("ChainLadder", lib.loc="C:/Users/David Hindley/Documents/R/win-library/3.0")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#Apply Mack model.weights=1 just uses same weight for all values in triangle.
#alpha=1 uses actual chain-ladder dev' factors. Other options are possible.
#est.sigma="Mack" means use Mack approximation for last sigma value, as per Mack's 1999 paper.
#tail=FALSE means no tail factor is used.
GenInsMack<-MackChainLadder(GenIns, weights=1, alpha=1,est.sigma="Mack",tail=FALSE)
#View results
GenInsMack
#Now show split of the results between process and estimation (or Parameter error, as MackChainLadder refers to it as).
GenInsMack$Mack.ProcessRisk
GenInsMack$Mack.ParameterRisk
GenInsMack$Mack.S.E
GenInsMack$Total.ProcessRisk
GenInsMack$Total.ParameterRisk
GenInsMack$Total.Mack.S.E
#Now show diagnostic charts including residual plots
plot(GenInsMack)
#Now produce results with a specified tail factor of 1.029 and specified sigma and s.e values in tail
GenInsMack2<-MackChainLadder(GenIns, weights=1, alpha=1, est.sigma="Mack", tail=1.029, tail.sigma=27.5, tail.se=0.01029)
#View results
GenInsMack2
#Now produce results allowing MackChainLadder package to fit tail factor and sigma and s.e values in tail
GenInsMack3<-MackChainLadder(GenIns, weights=1, alpha=1, est.sigma="Mack", tail=TRUE)
#View results
GenInsMack3
#Now test the impact of including the cross-product term, without a tail factor
GenInsMack4<-MackChainLadder(GenIns, weights=1, alpha=1,est.sigma="Mack",tail=FALSE,mse.method="Independence")
#View results
GenInsMack4
#Now try with different alpha values.
#First try alpha=0 which is equivalent to using a simple average dev factor. Done with no tail factor.
GenInsMack5<-MackChainLadder(GenIns, weights=1, alpha=0,est.sigma="Mack",tail=FALSE)
#View results
GenInsMack5
#Now with alpha=2 which is equivalent to a regression. Also done with no tail factor.
GenInsMack6<-MackChainLadder(GenIns, weights=1, alpha=2,est.sigma="Mack",tail=FALSE)
#View results
GenInsMack6
#Finally with alpha=0 plus tail factor and cross-product term
GenInsMack7<-MackChainLadder(GenIns, weights=1, alpha=0,est.sigma="Mack",tail=TRUE,mse.method="Independence")
#View results
GenInsMack7