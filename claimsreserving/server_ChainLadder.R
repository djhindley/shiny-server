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
###server code for Chain Ladder
#Date: 1 October 2017
# Return the requested dataset.  Note that use of "reactive" means it links through to selected user input.
dataset_CLInput <- reactive({
  switch(input$datasetCL,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns
         )
})
#Info button
observeEvent(input$InfoCL1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("CL_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})

#Reset inputs button
observeEvent(input$ResetCLinputs, {
  shinyjs::reset("CL_inputpanel")
})


output$Datatri1 <- DT::renderDataTable({
  datasetshow <- dataset_CLInput()
  #show the dataset in raw form as in simple R script.
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

output$Linkratios1 <- DT::renderDataTable({
  datasetshow <- dataset_CLInput()
  #calculate and then show the individual link ratios for selected dataset
  chain1_link<-ata(datasetshow)
  chain1_sum<-summary(chain1_link,digits=3)
  delta_chosen <-as.integer(input$radio_estimator1)
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  #calc link ratios for selected chain ladder model
  chain1_LR<-round(coef(chain1),digits=3)
  link_out<-rbind(chain1_sum,chain1_LR)
  d<-dim(datasetshow)[1]
  row.names(link_out)[d+2]<-"Selected"
  link_out
},
extensions=c('Buttons'),class = 'stripe compact',selection = 'none',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-left',targets='_all'))))

#output$testing<-renderPrint(input$Linkratios1_cells_selected)  ##if want to select cells for adding explanation. 
##Also add selection = list(mode = 'single', target = 'cell') to content before "options" above


output$LinkRatioest1 <- renderPrint({
  #get the delta value.  need to convert to integer from radio estimator option
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  #calc link ratios for selected chain ladder model
  chain1_LR<-coef(chain1)
  chain1_LR
})
output$LR_plot1 <- renderPlot({
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  #calc link ratios for selected chain ladder model
  chain1_LR<-coef(chain1)
  #plot(chain1_LR, type="h",xlab="Development point",ylab="Link Ratio estimator")
})

##tailfactor display code goes here if needed.

#projected triangle show
output$CL_projtri1 <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  tail_chosen <-as.logical(input$radio_tail1)
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  chain1_predict<-predict(chain1)
  #now work out ult.  Need to add tail factor. Repeats code below, so not very efficient, but
  #fast, so probably doesn't matter.
  d<-dim(datasetshow)[1]
  dd<-d+1
  Latest<-getLatestCumulative(datasetshow)[1:d]
  Ult<-chain1_predict[,d]
  #now need to work out tail factor
  #not sure if can avoid doing twice
  tail_chosen <-input$radio_tail1
  #next is no tail, so tail factor=1.0
  if (tail_chosen==0) {tailfactor=1.0} 
  #next is exponential
  else if (tail_chosen==1) {
    #generate vector with no.cols less 1
    d<-dim(datasetshow)[1]
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_expoperiod
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
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_ipwrperiod
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
    tailfactor<-input$Tailfactor_userdefined
  }
  
  #tailfactor has now been calculated
  Ult_withtail<-Ult*tailfactor
  Ultimate<-Ult_withtail
  fullproj<-cbind(chain1_predict,Ultimate)
  #add commas and apply units selection
  
  fullproj<-comma(round(fullproj/as.numeric(input$unitselect),digits=0))
  fullproj
  
  
},
extensions=c('Buttons','KeyTable'),selection='none',class = 'stripe compact',
options=list(keys=TRUE, dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
               columnDefs=list(list(className='dt-right',targets='_all'))))


output$CL_results1 <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  #results have tail factor added now
  #not sure if output$Tailfactor will be valid value or if use "tailfactor"
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  chain1_predict<-predict(chain1)
  d<-dim(datasetshow)[1]
  Latest<-getLatestCumulative(datasetshow)[1:d]
  Ult<-chain1_predict[,d]
  #now need to work out tail factor
  #not sure if can avoid doing twice
  tail_chosen <-input$radio_tail1
  #next is no tail, so tail factor=1.0
  if (tail_chosen==0) {tailfactor=1.0} 
  #next is exponential
  else if (tail_chosen==1) {
    #generate vector with no.cols less 1
    d<-dim(datasetshow)[1]
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_expoperiod
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
    extraproj=input$Tailfactor_ipwrperiod
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
    tailfactor<-input$Tailfactor_userdefined
  }
  
  #tailfactor has now been calculated
  ultwithtail<-Ult*tailfactor
  reservewithtail<-ultwithtail-Latest
  Latest<-c(Latest,sum(Latest))
  names(Latest)[d+1]<-"Total"
  ultwithtail<-c(ultwithtail,sum(ultwithtail))
  names(ultwithtail)[d+1]<-"Total"
  reservewithtail<-c(reservewithtail,sum(reservewithtail))
  names(reservewithtail)[d+1]<-"Total"
  #change names as these are shown on output table
  Ultimate<-ultwithtail
  Reserve<-reservewithtail
  sumtab<-rbind(Latest,Ultimate,Reserve)
  sumtab<-comma(round(sumtab/as.numeric(input$unitselect),digits=0))
  sumtab
},extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))
###graphs

output$CL_graphs_cum_unscaled<-renderPlot({
  #op=par(mfrow=c(1,1))
  datasetshow <- dataset_CLInput()
  matplot(t(datasetshow), type="l", main="Cumulative claims development graph", 
          xlab="Development period", ylab="Amount", ylim=c(0,1.05*max(datasetshow,na.rm=TRUE)),lwd=2.0)
  
})
output$CL_graphs_inc_unscaled<-renderPlot({
  #op=par(mfrow=c(1,1))
  datasetshow <- dataset_CLInput()
  matplot(t(cum2incr(datasetshow)), type="l", main="Incremental claims development graph", 
          xlab="Development period", ylab="Amount", ylim=c(0,1.05*max(cum2incr(datasetshow),na.rm=TRUE)),lwd=2.0)
  
})
###for scaled graphs need ults.
###so have to repeat tail calculation and derive ultimates for a third time!
###all done within each renderPlot below. very messy. needs correcting. maybe use reactive stuff.
output$CL_graphs_cum_scaled<-renderPlot({
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  chain1_predict<-predict(chain1)
  d<-dim(datasetshow)[1]
  Latest<-getLatestCumulative(datasetshow)[1:d]
  Ult<-chain1_predict[,d]
  #now need to work out tail factor
  #not sure if can avoid doing twice
  tail_chosen <-input$radio_tail1
  #next is no tail, so tail factor=1.0
  if (tail_chosen==0) {tailfactor=1.0} 
  #next is exponential
  else if (tail_chosen==1) {
    #generate vector with no.cols less 1
    d<-dim(datasetshow)[1]
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_expoperiod
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
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_ipwrperiod
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
    tailfactor<-input$Tailfactor_userdefined
  }
  
  #tailfactor has now been calculated
  ultwithtail<-Ult*tailfactor
  scaled<-datasetshow/ultwithtail
  matplot(t(scaled), type="l", main="Cumulative claims development graph - scaled to ultimate", 
          xlab="Development period", ylab="Proportion of ult", ylim=c(0,max(1.05,1.05*max(scaled,na.rm=TRUE))),lwd=2.0)
  abline(h=1.0,lwd=2.0)
})
###now incremental scaled graph

output$CL_graphs_inc_scaled<-renderPlot({
  delta_chosen <-as.integer(input$radio_estimator1)
  datasetshow <- dataset_CLInput()
  chain1<-chainladder(datasetshow,weights=1, delta=delta_chosen)
  chain1_predict<-predict(chain1)
  d<-dim(datasetshow)[1]
  Latest<-getLatestCumulative(datasetshow)[1:d]
  Ult<-chain1_predict[,d]
  #now need to work out tail factor
  #not sure if can avoid doing twice
  tail_chosen <-input$radio_tail1
  #next is no tail, so tail factor=1.0
  if (tail_chosen==0) {tailfactor=1.0} 
  #next is exponential
  else if (tail_chosen==1) {
    #generate vector with no.cols less 1
    d<-dim(datasetshow)[1]
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_expoperiod
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
    x<-1:(d-1)
    #define how far to project into tail. change this if want more
    extraproj=input$Tailfactor_ipwrperiod
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
    tailfactor<-input$Tailfactor_userdefined
  }
  
  #tailfactor has now been calculated
  ultwithtail<-Ult*tailfactor
  scaled<-cum2incr(datasetshow)/ultwithtail
  matplot(t(scaled), type="l", main="Incremental claims development graph - scaled to ultimate", 
          xlab="Development period", ylab="Proportion of ult", ylim=c(0,1.05*max(scaled,na.rm=TRUE)),lwd=2.0)
})


output$Regcolumn <-renderUI({
  CLregnumcols<-dim(dataset_CLInput())[1] #number columns in triangle.
  sliderInput("Firstcol_reg", "First column for regression",min=1,max=CLregnumcols-1,
              value=1)
})

#now do regresssion calcs to draw plot
output$LR_plot1reg<-renderPlot({
  #first get x and y values
  x<-dataset_CLInput()[,input$Firstcol_reg]
  y<-dataset_CLInput()[,(input$Firstcol_reg+1)]
  #select weights depending on choice of link ratio estimator
  if (input$radio_estimator1==1) {weights_chosen=1/x} # column sum average
  else if (input$radio_estimator1==2) {weights_chosen=(1/x^2)}
  #now fit regression
  linreg<-lm(y~x+0,weights=weights_chosen)
  #define value for plot
  xy_plot<-cbind(x,y)
  plot(xy_plot,xlim=c(0,1.05*(max(x,na.rm=TRUE))),ylim=c(0,1.05*max(y,na.rm=TRUE)))
  abline(0,linreg$coefficients)
})
#now show linear regression results
output$CLreg_line_equation<-renderPrint({
  #first get x and y values
  x<-dataset_CLInput()[,input$Firstcol_reg]
  y<-dataset_CLInput()[,(input$Firstcol_reg+1)]
  #select weights depending on choice of link ratio estimator
  if (input$radio_estimator1==1) {weights_chosen=1/x} # column sum average
  else if (input$radio_estimator1==2) {weights_chosen=(1/x^2)}
  #now fit regression
  linreg2<-lm(y~x+0,weights=weights_chosen)
  linreg2
})
#"radio_estimator1reg", label = "Estimator type",
#plotOutput(outputId = "LR_plot1reg", height = "300px"),
#verbatimTextOutput("CLreg_line_equation")
