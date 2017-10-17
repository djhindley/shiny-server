##  MW example showing CDR for first year and subsequent years
#Load the Chainladder package
library("ChainLadder")
#View the Taylor and Ashe data that comes with the ChainLadder package
GenIns
#Apply the Mack chain ladder model to it
M <- MackChainLadder(GenIns, est.sigma="Mack")
#show results - which agree with Mack worked example
M
#Then do single CDR results
CDR(M)
#Results agree with MW example results in multi year worked example
#Now show results for all future years
Mall<-CDR(M,dev="all")
Mall
#Now write results to CSV file for importing to Excel
write.csv(Mall,"MWEGCDR_all.csv")


