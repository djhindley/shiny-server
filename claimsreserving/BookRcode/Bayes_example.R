#Bayes example
#Uses the rube and R2winbugs packages to run Winbugs directly from R
#first load the rube library and set directory where Winbugs programme is stored
library(rube)
Sys.setenv(BUGSDIR="c:\\users\\david hindley\\desktop\\winbugs14\\WinBUGS14")
#The next two lines are just test code to make sure Winbugs loads and runs correctly
#r = rube(m, d, i, "*", n.burn=0, n.thin=1, n.iter=100)
#summary(r)
#set number of sims.  Burn-in will be half this
nsims=10000
#Do first model.  Negative binomial with high variance for priors, so similar to CL
#Model 3 as per summary sheet in Excel
model1 = "model
{
# Model for Data
for(i in 1:45) {
Z[i] <- Y[i]/1000
pC[i]<-D[i]/1000
# Zeros trick
zeros[i]<- 0
zeros[i] ~ dpois(phi[i])
phi[i]<- (-pC[i]*log(1/(1 +g[row[i]]))-Z[i]*log(g[row[i]]/(1 +g[row[i]])))/scale
}
# Cumulate down the columns:
DD[3]<-DD[1]+Y[46]
for( i in 1 : 2 ) {DD[4+i]<-DD[4+i-3]+Y[49+i-3]}
for( i in 1 : 3 ) {DD[7+i]<-DD[7+i-4]+Y[52+i-4]}
for( i in 1 : 4 ) {DD[11+i]<-DD[11+i-5]+Y[56+i-5]}
for( i in 1 : 5 ) {DD[16+i]<-DD[16+i-6]+Y[61+i-6]}
for( i in 1 : 6 ) {DD[22+i]<-DD[22+i-7]+Y[67+i-7]}
for( i in 1 : 7 ) {DD[29+i]<-DD[29+i-8]+Y[74+i-8]}
for( i in 1 : 8 ) {DD[37+i]<-DD[37+i-9]+Y[82+i-9]}
# Needed for the denominator in definition of gammas
E[3]<-E[1 ]*gamma[1]
for( i in 1 : 2 ) {E[4+i]<-E[4+i-3]*gamma[2]}
for( i in 1 : 3 ) {E[7+i]<-E[7+i-4]*gamma[3]}
for( i in 1 : 4 ) {E[11+i]<-E[11+i-5]*gamma[4]}
for( i in 1 : 5 ) {E[16+i]<-E[16+i-6]*gamma[5]}
for( i in 1 : 6 ) {E[22+i]<-E[22+i-7]*gamma[6]}
for( i in 1 : 7 ) {E[29+i]<-E[29+i-8]*gamma[7]}
for( i in 1 : 8 ) {E[37+i]<-E[37+i-9]*gamma[8]}
EC[1]<-E[1]/1000
EC[2]<-sum(E[2:3])/1000
EC[3]<-sum(E[4:6])/1000
EC[4]<-sum(E[7:10])/1000
EC[5]<-sum(E[11:15])/1000
EC[6]<-sum(E[16:21])/1000
EC[7]<-sum(E[22:28])/1000
EC[8]<-sum(E[29:36])/1000
EC[9]<-sum(E[37:45])/1000
# Model for future observations
for( i in 46 : 90 ) {
a1[i]<- max(0.01,a[row[i]]*DD[i-45]/(1000*scale))
b1[i]<- 1/(gamma[row[i]]* 1000*scale)
Z[i]~dgamma(a1[i],b1[i])
Y[i]<-Z[i]
fit[i]<-Y[i]
}
scale<-52.8615
#Convert row parameters to gamma using (5.6)
for (k in 1:9) {
gamma[k]<- 1+g[k]
g[k]<-u[k]/EC[k]
a[k]<-g[k]/gamma[k]
}
# Prior distributions for row parameters.
for (k in 1:9) {
u[k]~dgamma(au[k],bu[k])
au[k]<-bu[k]*(ultm[k+1]*(1-1/f[k]))
bu[k]<-(ultm[k+1]*(1-1/f[k]))/pow(ultsd[k+1],2)
}
# The prior distribution can be changed by changing the data input values for the
# vectors ultm and ultsd
# Row totals and overall reserve
R[1] <- 0
R[2] <- fit[46]
R[3] <- sum(fit[47:48])
R[4] <- sum(fit[49:51])
R[5] <- sum(fit[52:55])
R[6] <- sum(fit[56:60])
R[7] <- sum(fit[61:66])
R[8] <- sum(fit[67:73])
R[9] <- sum(fit[74:81])
R[10] <- sum(fit[82:90])
Total <- sum(R[2:10])
}"
#Now check the model syntax
rube1<-rube(model1)
rube1
summary(rube1)
#now load the data
data1=list(
  row=c(1,1,1,1,1,1,1,1,1,
        2,2,2,2,2,2,2,2,
        3,3,3,3,3,3,3,4,4,
        4,4,4,4,5,5,5,5,5,
        6,6,6,6,7,7,7,8,
        8,9,1,2,2,3,3,3,4,4,4,
        4,5,5,5,5,5,6,6,6,6,6,6,
        7,7,7,7,7,7,7,8,8,8,8,8,
        8,8,8,9,9,9,9,9,9,9,9,
        9),
  Y=c(352118,884021,933894,1183289,445745,320996,527804,266172,425046,
      290507,1001799,926219,1016654,750816,146923,495992,280405,
      310608,1108250,776189,1562400,272482,352053,206286,
      443160,693190,991983,769488,504851,470639,
      396132,937085,847498,805037,705960,
      440832,847631,1131398,1063269,
      359480,1061648,1443370,
      376686,986608,
      344014,
      NA,
      NA,NA,
      NA,NA,NA,
      NA,NA,NA,NA,
      NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,NA,NA),
  D=c(357848,766940,610542,482940,527326,574398,146342,139950,227229,
      709966,1650961,1544436,1666229,973071,895394,674146,406122,
      1000473,2652760,2470655,2682883,1723887,1042317,1170138,
      1311081,3761010,3246844,4245283,1996369,1394370,
      1754241,4454200,4238827,5014771,2501220,
      2150373,5391285,5086325,5819808,
      2591205,6238916,6217723,
      2950685,7300564,
      3327371,
      NA,
      NA,NA,
      NA,NA,NA,
      NA,NA,NA,NA,
      NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,NA,
      NA,NA,NA,NA,NA,NA,NA,NA,NA),
  DD=c(67948,
       652275,NA,
       686527,NA,NA,
       1376424,NA,NA,NA,
       1865009,NA,NA,NA,NA,
       3207180,NA,NA,NA,NA,NA,
       6883077,NA,NA,NA,NA,NA,NA,
       7661093,NA,NA,NA,NA,NA,NA,NA,
       8287172,NA,NA,NA,NA,NA,NA,NA,NA),
  E=c(67948,
      652275,NA,
      686527,NA,NA,
      1376424,NA,NA,NA,
      1865009,NA,NA,NA,NA,
      3207180,NA,NA,NA,NA,NA,
      6883077,NA,NA,NA,NA,NA,NA,
      7661093,NA,NA,NA,NA,NA,NA,NA,
      8287172,NA,NA,NA,NA,NA,NA,NA,NA),
  #chain ladder cumulative dev factors
  f=c(1.017724725, 1.095636823, 1.154663551, 1.254275641, 1.384498969,
      1.625196481,2.368582213,4.138701016, 14.44657687),
  ultm=c(NA,5500,5500,5500,5500,5500,6000, 6000, 6000, 6000),
  ultsd=c(NA,10000,10000,10000,10000,10000,10000,10000,10000,10000))
#list the data out to check it looks OK
data1
#Now load the initial data for the start of the MCMC
init1=list(u = c(5500, 5500, 5500, 5500, 5500, 6000, 6000, 6000, 6000),
    Z=c(NA,NA,NA,NA,NA,NA,NA,NA,NA,
        NA,NA,NA,NA,NA,NA,NA,NA,
        NA,NA,NA,NA,NA,NA,NA,
        NA,NA,NA,NA,NA,NA,
        NA,NA,NA,NA,NA,
        NA,NA,NA,NA,
        NA,NA,NA,
        NA,NA,
        NA,
        0,
        0,0,
        0,0,0,
        0,0,0,0,
        0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0))
#list it to make sure it looks right
init1
#now do a cross-check of data and the initializations against the model itself
#Doesn't run the model yet as no parameters are saved
rube2<-rube(model1,data=data1,inits=init1)
#View summary to check all OK
summary(rube2)
#Now run the model and show results
rube3<-rube(model1,data=data1,inits=init1,parameters.to.save=c("R","Total"),
            n.chains=1,n.iter=nsims,n.thin=1)
rube3
#write summary to CSV file for importing to Excel
write.csv(rube3$summary,"Bayeseg_run1.csv")
#Also write full sims output in case needed
write.csv(rube3$sims.matrix,"Bayeseg_run1_sims.csv")
#plot density of Total results
#first extract the Total sims data
d_run1<-rube3$sims.matrix[,"Total"]
plot(density(d_run1))
#also plot cdf
d_CDF_run1=ecdf(d_run1)
plot(d_CDF_run1)
#calc quantiles
quant_run1<-quantile(d_run1, probs=c(0.5,0.75,0.9,0.95,0.995))
quant_run1
#Now do BF version of NB by using v.low variance
#replace value in data for sd
data2=data1
data2$ultsd=c(NA,1,1,1,1,1,1,1,1,1)
#run new model with this in the data
rube4<-rube(model1,data=data2,inits=init1,parameters.to.save=c("R","Total"),
            n.chains=1,n.iter=nsims,n.thin=1)
write.csv(rube4$summary,"Bayeseg_run2.csv")
#Also write full sims output in case needed
write.csv(rube4$sims.matrix,"Bayeseg_run2_sims.csv")
d_run2<-rube4$sims.matrix[,"Total"]
#calc quantiles
quant_run2<-quantile(d_run2, probs=c(0.5,0.75,0.9,0.95,0.995))
quant_run2
#now try with ''medium'' variance
data3=data1
data3$ultsd=c(NA,1000,1000,1000,1000,1000,1000,1000,1000,1000)
#run new model with this in the data
rube5<-rube(model1,data=data3,inits=init1,parameters.to.save=c("R","Total"),
            n.chains=1,n.iter=2000,n.thin=1)
write.csv(rube5$summary,"Bayeseg_run3.csv")
#Also write full sims output in case needed
write.csv(rube5$sims.matrix,"Bayeseg_run3_sims.csv")
d_run3<-rube5$sims.matrix[,"Total"]
#calc quantiles
quant_run3<-quantile(d_run3, probs=c(0.5,0.75,0.9,0.95,0.995))
quant_run3
#Model below not used in book
#now try with ''medium'' variance for last 2 years and high for earlier yrs replicating BF/CL mix
data4=data1
data4$ultsd=c(NA,10000,10000,10000,10000,10000,10000,10000,1000,1000)
#run new model with this in the data
rube6<-rube(model1,data=data4,inits=init1,parameters.to.save=c("R","Total"),
            n.chains=1,n.iter=nsims,n.thin=1)
write.csv(rube6$summary,"Bayeseg_run4.csv")
#Also write full sims output in case needed
write.csv(rube6$sims.matrix,"Bayeseg_run4_sims.csv")
