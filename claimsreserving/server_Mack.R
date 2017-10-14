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
##Mack server code
#Date: 1 October 2017
dataset_MackInput <- reactive({
  switch(input$dataset_Mack,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns
  )
})
observeEvent(input$InfoMack1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("Mack_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})


#Reset inputs button
observeEvent(input$ResetMackinputs, {
  shinyjs::reset("Mack_inputpanel")
})



output$Datatri2 <- DT::renderDataTable({
  datasetshow <- dataset_MackInput()
  #show the dataset in raw form as in simple R script.
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect_Mack),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all')))
)
output$Linkratios1Mack <- DT::renderDataTable({
  datasetshow <- dataset_MackInput()
  #calculate and then show the individual link ratios for selected dataset
  chain1_link<-ata(datasetshow)
  chain1_sum<-summary(chain1_link,digits=3)
  #work out Link Ratio estimators before tail - need to run MackChainLadder to get f.
  delta_chosen <-as.integer(input$radio_estimator2)
  MackResults <-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  d<-dim(datasetshow)[1]
  link_out<-rbind(chain1_sum,round(MackResults$f[1:d-1],digits=3))
  row.names(link_out)[d+2]<-"Selected"
  link_out
}
,
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-left',targets='_all')))
)

#output tail factor.  Need to get it from Mack if exponential is selected - ie tail=TRUE
output$Tailfactor2 <-renderPrint({
  datasetshow <- dataset_MackInput()
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {tail_value=1.0} 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults <-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
    #extract tail factor from Mack results. Uses exponential so should be same as CL expo
    tail_value<-MackResults$tail$tail.factor
  }
  #next is user defined. No need to run Mack as just showing factor at this stage
  else if (tail_chosen==2) {tail_value=input$Tailfactor_userdefined2}
  #show tail value on screen
  tail_value
  
})
#define function for reformatting Mack results for use in DT package
Macktable<-function (mch,ncol,useunits,tailoffset) {   
  #input is MackChainLadder output, number of columns in triangle, units for numbers 
  #and tailoffset(1 is added to get final column in detailed Process and Parameter Risk table)
  smch<-summary(mch) # Summary of MackChainLadder
  #produces table with headings latest, ult, Reserve, Process Risk, Paramater risk, Total S.E, CV
  #with the final row as Total across all cohorts
  #start with by origins
  smch_origin<-cbind(
    smch$ByOrigin["Latest"]/useunits,
    smch$ByOrigin["Ultimate"]/useunits,
    smch$ByOrigin["IBNR"]/useunits,
    mch$Mack.ProcessRisk[,(ncol+tailoffset)]/useunits,
    mch$Mack.ParameterRisk[,(ncol+tailoffset)]/useunits,
    smch$ByOrigin["Mack.S.E"]/useunits,
    smch$ByOrigin["CV(IBNR)"]*100
  )
  colnames(smch_origin)<-list("Latest","Ultimate","Reserve","Process risk", "Param' risk","Total S.E","CV(%)")
  #now do totals
  smch_total<-cbind(
    smch$Totals["Latest",]/useunits,
    smch$Totals["Ultimate",]/useunits,
    smch$Totals["IBNR",]/useunits,
    mch$Total.ProcessRisk[(ncol+tailoffset)]/useunits,
    mch$Total.ParameterRisk[(ncol+tailoffset)]/useunits,
    smch$Totals["Mack S.E",]/useunits,
    smch$Totals["CV(IBNR)",]*100
  )
  colnames(smch_total)<-list("Latest","Ultimate","Reserve","Process risk", "Param' risk","Total S.E","CV(%)")
  row.names(smch_total)<-list("Total")
  smch_all<-rbind(smch_origin,smch_total) 
  return(smch_all)
} 

#now output the Mack results
output$Mack_results_summary <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=0
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=1
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=1
  }
  #now reformat the Mack results using function above
  results_format<-Macktable(MackResults,d,as.numeric(input$unitselect_Mack),tailoffset_chosen)
  results_format<-comma(round(results_format,digits=0))
  results_format
}
,
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all')))
)


output$Mack_varianceparms <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=0
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=1
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
    tailoffset_chosen=1
  }
  
  #now reformat the Mack results using function above
    results_format<-as.data.frame(cbind(comma(round((MackResults$sigma^2)/as.numeric(input$unitselect_Mack),digits=3))
                                    ,round(MackResults$f.se,digits=5)
                                    ,round(MackResults$f.se/MackResults$f[1:(d-1+tailoffset_chosen)]*100,digits=5)
 ))
 colnames(results_format)<-list("Sigma^2","SE(dev factors)","CV(dev factors)%")
  
  results_format
}
,
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'),list(width='10%',targets="_all"))
             )
)


output$Mack_processrisk <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack")
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
    results_format<-rbind((MackResults$Mack.ProcessRisk^2)/as.numeric(input$unitselect_Mack),
  (MackResults$Total.ProcessRisk^2)/as.numeric(input$unitselect_Mack)
  )
  row.names(results_format)[d+1]<-"Total"
  results_format<-comma(round(results_format,digits=0))
  results_format
}
,
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all')))
)

output$Mack_parameterrisk <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
  MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  results_format<-rbind((MackResults$Mack.ParameterRisk^2)/as.numeric(input$unitselect_Mack),
                        (MackResults$Total.ParameterRisk^2)/as.numeric(input$unitselect_Mack)
  )
  row.names(results_format)[d+1]<-"Total"
  results_format<-comma(round(results_format,digits=0))
  results_format
}
,
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all')))
)

#graphs
output$Mack_graphs1<-renderPlot({
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  plot(MackResults,which=1)
})
output$Mack_graphs3<-renderPlot({
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  plot(MackResults,which=3)
})
output$Mack_graphs4<-renderPlot({
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  plot(MackResults,which=4)
})
output$Mack_graphs5<-renderPlot({
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  plot(MackResults,which=5)
})
output$Mack_graphs6<-renderPlot({
  datasetshow <- dataset_MackInput()
  d<-dim(datasetshow)[1]
  delta_chosen <-as.integer(input$radio_estimator2)
  tail_chosen <-input$radio_tail2
  #taillog<- as.logical(input$radio_tail2)
  if (tail_chosen==0) {
    MackResults<-MackChainLadder(datasetshow,tail=FALSE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  } 
  #next is exponential.  Need to run Mack to find out what it is
  else if (tail_chosen==1) {
    MackResults<-MackChainLadder(datasetshow,tail=TRUE,alpha=2-delta_chosen,est.sigma="Mack",mse.method=input$crossproduct)
  }
  #next is user defined.
  else if (tail_chosen==2) {
    MackResults<-MackChainLadder(datasetshow,tail=input$Tailfactor_userdefined2,alpha=2-delta_chosen,
                                 tail.sigma=input$Sigma_tail,
                                 tail.se=input$Tailfactor_CV*input$Tailfactor_userdefined2/100,
                                 est.sigma="Mack",mse.method=input$crossproduct)
  }
  plot(MackResults,which=6)
})
