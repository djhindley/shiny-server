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
##server CL Bootstrap
#Date: 1 October 2017
CLBootdataset_chosen <- reactive({
  switch(input$dataset_boot,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns)
})

observeEvent(input$InfoCLBoot1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("CLBoot_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})

#Reset inputs button
observeEvent(input$ResetCLBootinputs, {
  shinyjs::reset("CLBoot_inputpanel")
})


##function to change process dist
processfunc<-function(value)
{
  if (value==1) {proc="od.pois"}
  else if (value==2) {proc="gamma"}
}

##function to reformat bootstrap results for use in DT:Datatable
boottable<-function (bootsumry,useunits) {   
  #input is BootChainLadder summary output, units for numbers 
  #produces table with headings latest, Mean ult, Mean Reserve, Total S.D, CV
  #with the final row as Total across all cohorts
  #start with by origins
  sboot_origin<-cbind(
    bootsumry$ByOrigin["Latest"]/useunits,
    bootsumry$ByOrigin["Mean Ultimate"]/useunits,
    bootsumry$ByOrigin["Mean IBNR"]/useunits,
    bootsumry$ByOrigin["SD IBNR"]/useunits,
    (bootsumry$ByOrigin["SD IBNR"]/bootsumry$ByOrigin["Mean IBNR"])*100
  )
  colnames(sboot_origin)<-list("Latest","Mean Ult'","Mean Reserve","Reserve SD", "CV(%)")
  #now do totals
  sboot_total<-cbind(
    bootsumry$Totals["Latest:",]/useunits,
    bootsumry$Totals["Mean Ultimate:",]/useunits,
    bootsumry$Totals["Mean IBNR",]/useunits,
    bootsumry$Totals["SD IBNR",]/useunits,
    (bootsumry$Totals["SD IBNR",]/bootsumry$Totals["Mean IBNR",])*100
  )
  colnames(sboot_total)<-list("Latest","Mean Ult'","Mean Reserve","Reserve SD", "CV(%)")
  row.names(sboot_total)<-list("Total")
  sboot_all<-rbind(sboot_origin,sboot_total) 
  return(sboot_all)
} 

##function to reformat bootstrap percentile results for use in DT:Datatable
bootpercenttable<-function (bootquantile,useunits) {   
  #input is BootChainLadder qauntile output, units for numbers 
  #produces table with headings for reserve at default percentile values plus user-defined value 
  #with the final row as Total across all cohorts
  #start with by origins
  ncolquant<-ncol(bootquantile$ByOrigin)
  finalcolname<-colnames(bootquantile$ByOrigin[ncolquant])
  user_percentile<-substr(finalcolname,6,nchar(finalcolname))
  sbootquant_origin<-cbind(
    bootquantile$ByOrigin["IBNR 50%"]/useunits,
    bootquantile$ByOrigin["IBNR 75%"]/useunits,
    bootquantile$ByOrigin["IBNR 90%"]/useunits,
    bootquantile$ByOrigin["IBNR 95%"]/useunits,
    bootquantile$ByOrigin["IBNR 99.5%"]/useunits,
    bootquantile$ByOrigin["IBNR 99.9%"]/useunits
    ,bootquantile$ByOrigin[ncolquant]/useunits
      )
  
  colnames(sbootquant_origin)<-list("Reserve 50%","Reserve 75%","Reserve 90%","Reserve 95%","Reserve 99.5%","Reserve 99.9%",paste("Reserve @ user-selected: ",user_percentile))
  #now do totals
  sbootquant_total<-cbind(
    bootquantile$Totals["IBNR 50%",]/useunits,
    bootquantile$Totals["IBNR 75%",]/useunits,
    bootquantile$Totals["IBNR 90%",]/useunits,
    bootquantile$Totals["IBNR 95%",]/useunits,
    bootquantile$Totals["IBNR 99.5%",]/useunits,
    bootquantile$Totals["IBNR 99.9%",]/useunits
    ,bootquantile$Totals[ncolquant,]/useunits
  )
  colnames(sbootquant_total)<-list("Reserve 50%","Reserve 75%","Reserve 90%","Reserve 95%","Reserve 99.5%","Reserve 99.9%",paste("Reserve @ user-selected: ",user_percentile))
  row.names(sbootquant_total)<-list("Total")
  sbootquant_all<-rbind(sbootquant_origin,sbootquant_total) 
  return(sbootquant_all)
} 

###run bootstrap with 1 simulation just to get residuals
output$Bootstrap_residuals<-DT::renderDataTable({
  Initial_boot<-BootChainLadder2(CLBootdataset_chosen(), 1,process.dist=c(processfunc(input$bootprocessdist)),TRUE)
  resid_out<-as.data.frame(Initial_boot$ChainLadder.Residuals[,,1])
  colnames(resid_out)<-colnames(CLBootdataset_chosen())
  row.names(resid_out)<-row.names(CLBootdataset_chosen())
  resid_out<-comma(round(resid_out,digits=3))
  resid_out
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))


output$Datatri_CLBoot <- DT::renderDataTable({
  datasetshow <- CLBootdataset_chosen()
    #show the dataset in raw form as in simple R script.
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect_CLBoot),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))




#######action button to run bootstrap
observeEvent(input$Runboot,
                           {
                             #now all the code below only runs when input$Runboot changes
                             #add user-defined percentile value to list of default percentile values
                             Percent_values<-c(Percent_values,input$Boot_percentile/100)
                             if (input$seedoption==1) {set.seed(input$CLBootstrap_seed)}
                             else if (input$seedoption==0) {set.seed(NULL)}
                             Bootresults<-BootChainLadder2(CLBootdataset_chosen(), input$Boot_sims,process.dist=c(processfunc(input$bootprocessdist)),TRUE)
                             #Bootresults is a list with items such as Triangle, CL factors, all simulations in an array etc.                                
                             output$Bootstrap_results<-DT::renderDataTable({
                               Bootsumry<-summary(Bootresults)
                               Summarytoshow<-boottable(Bootsumry,as.numeric(input$unitselect_CLBoot))
                               Summarytoshow<-comma(round(Summarytoshow,digits=0))
                               Summarytoshow
                             },
                             extensions=c('Buttons'),selection='none',class = 'stripe compact',
                             options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
                                          ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
                                          columnDefs=list(list(className='dt-right',targets='_all'))))
                             
                             
                             output$Bootstrap_graphs1<-renderPlot({
                               boot_run<-Bootresults
                               plot(boot_run,which=1)
                             })
                             output$Bootstrap_graphs2<-renderPlot({
                               boot_run<-Bootresults
                               plot(boot_run,which=2)
                             })
                             output$Bootstrap_graphs3<-renderPlot({
                               boot_run<-Bootresults
                               plot(boot_run,which=3)
                             })
                             output$Bootstrap_graphs4<-renderPlot({
                               boot_run<-Bootresults
                               plot(boot_run,which=4)
                             })
                             
                             
                             output$Bootstrap_percentiles<-DT::renderDataTable({
                               quantiles_run<-quantile(Bootresults,probs=Percent_values)
                               percentiles_toshow<-bootpercenttable(quantiles_run,as.numeric(input$unitselect_CLBoot))
                               percentiles_toshow<-comma(round(percentiles_toshow,digits=0))
                               percentiles_toshow
                             },
                             extensions=c('Buttons'),selection='none',class = 'stripe compact',
                             options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
                                          ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
                                          columnDefs=list(list(className='dt-right',targets='_all'))))
                             
                             
                             }) # Reactive ends
