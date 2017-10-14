####################NOTICE and LICENSE##############################
#This file is part of GIRA - a claims reserving application designed for educational purposes only
##Please see https://github.com/djhindley/GIRA/blob/master/NoticeLicense.md for notice and license relating to this 
#Copyright 2017 David Hindley.
#This program is free software; you can redistribute it and/or modify it under the terms of the 
#GNU General Public License as published by the Free Software Foundation, either version 2 of the License, 
#or (at your option) any later version.
#This program is distributed in the hope that it will be useful, 
#but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#See the GNU General Public License for more details. 
#If you do not already have a copy of this license, write to 
#the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA or see http://www.gnu.org/licenses/
#####################################################################################
###server code for BF
#Date: 1 October 2017
# Return the requested dataset.  Note that use of "reactive" means it links through to selected user input.
dataset_BFInput <- reactive({
  switch(input$datasetBF,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns
         )
})
GenIns2_priors<-1000*c(4000,5500,5500,5500,5500,5500,6000,6000,6000,6000)
RAA_priors<-c(19000,17000,25000,28000,28000,1900,17000,25000,17000,19000)
UKMotor_priors<-1000*c(13,13,14,13,14,17,21)
MW2008_priors<-1000*c(4000,4000,4000,4000,4000,4000,4000,4000,4000)
MW2014_priors<-1000*c(27,27,27,27,27,27,27,30,30,30,30,30,30,30,25,25,25)
GenIns_priors<-1000*c(4000,5500,5500,5500,5500,5500,6000,6000,6000,6000)
###try setting default priors that vary by dataset
priors_BF <- reactive({
  switch(input$datasetBF,
         "Reserving book" = GenIns2_priors,
         "RAA" = RAA_priors,
         "UKMotor" = UKMotor_priors,
         "MW2008"=MW2008_priors,
         "MW2014"=MW2014_priors,
         "GenIns"=GenIns_priors
  )
})

#Info button
observeEvent(input$InfoBF, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("BF_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})

#Reset inputs button
observeEvent(input$ResetBFinputs, {
  shinyjs::reset("BF_inputpanel")
})

output$Datatri1BF <- DT::renderDataTable({
  datasetshow <- dataset_BFInput()
  #show the dataset in raw form as in simple R script.
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect_BF),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

##work out BF results with default CL % developed and default priors. NB only allows CSA
output$BF_results1 <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  #results have tail factor added now
  #not sure if output$Tailfactor will be valid value or if use "tailfactor"
  delta_chosen <-1  #column sum 
  datasetshow <- dataset_BFInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  chain1_predict<-predict(chain1)
  d<-dim(datasetshow)[1]
  Latest<-getLatestCumulative(datasetshow)[1:d]
  Ult<-chain1_predict[,d]
  #now need to work out tail factor
  #not sure if can avoid doing twice
  tail_chosen <-input$radio_tailBF
  #next is no tail, so tail factor=1.0
  if (tail_chosen==0) {tailfactor=1.0} 
  #next is exponential
  else if (tail_chosen==1) {
    #generate vector with no.cols less 1
    d<-dim(datasetshow)[1]
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_expoperiodBF
    projmax=d+extraproj
    chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
    #calc link ratios for selected chain ladder model
    chain1_LR<-coef(chain1)
    y<-as.data.frame(chain1_LR)$chain1_LR
    #Exponential curve
    chain1_model<-lm(log(y-1)~x)
    chain1_fitted<-1+exp(chain1_model$fitted.values)
    #work out tail factor up to extraproj beyond triangle.
    #first get coefficients
    C<-coef(chain1_model)
    tail1<-exp(C[1]+c(d:(projmax-1))*C[2])+1
    #multiply factors together to get overall tail factor
    tailfactor<-prod(tail1)
  }
  #next is inverse power  
  else if (tail_chosen==2) {
    d<-dim(datasetshow)[1]
    dd<-d+1
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_ipwrperiodBF
    projmax=d+extraproj
    chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
    #calc link ratios for selected chain ladder model
    chain1_LR<-coef(chain1)
    y<-as.data.frame(chain1_LR)$chain1_LR
    #Exponential curve
    chain2_model<-lm(log(y-1)~log(x))
    chain2_fitted<-1+exp(chain2_model$fitted.values)
    #work out tail factor up to extraproj beyond triangle.
    #first get coefficients
    C2<-coef(chain2_model)
    #next formula is as per Table 3.12
    tail2<-exp(C2[1])*c(d:(projmax-1))^C2[2]+1
    #multiply factors together to get overall tail factor
    tailfactor<-prod(tail2)
  }
  #next is user defined
  else if (tail_chosen==3) {
    tailfactor<-input$Tailfactor_userdefinedBF
  }
  
  CL_ultimate<-Ult*tailfactor
  Percent_developed<-(Latest/CL_ultimate)*100
  Prior_ultimate<-priors_BF()
  BF_ultimate<-Latest+(1-Percent_developed/100)*Prior_ultimate
  Latest<-c(Latest,sum(Latest))
  names(Latest)[d+1]<-"Total"
  BF_ultimate<-c(BF_ultimate,sum(BF_ultimate))
  BF_reserve<-BF_ultimate-Latest
  Latest<-comma(round(Latest/as.numeric(input$unitselect_BF),digits=0))
  names(BF_ultimate)[d+1]<-"Total"
  BF_ultimate<-comma(round(BF_ultimate/as.numeric(input$unitselect_BF),digits=0))
  BF_reserve<-comma(round(BF_reserve/as.numeric(input$unitselect_BF),digits=0))
  Percent_developed<-c(Percent_developed,NA)
  names(Percent_developed)[d+1]<-"Total"
  Percent_developed<-comma(round(Percent_developed,digits=2))
  Prior_ultimate<-c(Prior_ultimate,sum(Prior_ultimate))
  names(Prior_ultimate)[d+1]<-"Total"
  Prior_ultimate<-comma(round(Prior_ultimate/as.numeric(input$unitselect_BF),digits=0))
  CL_ultimate<-c(CL_ultimate,sum(CL_ultimate))
  names(CL_ultimate)[d+1]<-"Total"
  CL_ultimate<-comma(round(CL_ultimate/as.numeric(input$unitselect_BF),digits=0))
  sumtab<-rbind(Latest,CL_ultimate,Percent_developed,Prior_ultimate,BF_ultimate,BF_reserve)
  row.names(sumtab)<-c("Latest","Chain Ladder Ultimate","CL % developed", "Prior ultimate", "BF ultimate","BF reserve")
  sumtab
},extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

output$BF_results2 <- DT::renderDataTable({
  datasetshow <- dataset_BFInput()
  d<-dim(datasetshow)[1]
  cohort_index<-input$cohortBFnumber-as.numeric(rownames(datasetshow)[1])+1
  Latest<-getLatestCumulative(datasetshow)[cohort_index]
  Percent_developed<-input$percent_dev_user
  Prior_ultimate<-input$prior_user*as.numeric(input$unitselect_BF)
  BF_ultimate<-Latest+(1-Percent_developed/100)*Prior_ultimate
  PercentDev_ult<-Latest/(Percent_developed/100)
  BF_reserve<-BF_ultimate-Latest
  Latest<-comma(round(Latest/as.numeric(input$unitselect_BF),digits=0))
  Percent_developed<-comma(round(Percent_developed,digits=2))
  Prior_ultimate<-comma(round(Prior_ultimate/as.numeric(input$unitselect_BF),digits=0))
  BF_ultimate<-comma(round(BF_ultimate/as.numeric(input$unitselect_BF),digits=0))
  BF_reserve<-comma(round(BF_reserve/as.numeric(input$unitselect_BF),digits=0))
  PercentDev_ult<-comma(round(PercentDev_ult/as.numeric(input$unitselect_BF),digits=0))
  sumtab<-rbind(Latest,Percent_developed,PercentDev_ult,Prior_ultimate,BF_ultimate,BF_reserve)
  row.names(sumtab)<-c("Latest","% developed","Ultimate based on % dev'd", "Prior ultimate", "BF ultimate", "BF reserve")
  sumtab
},extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

