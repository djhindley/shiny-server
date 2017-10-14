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
##MW server code
#Date: 1 October 2017
############################################################
#############################MW tab#######################
############################################################
dataset_MWInput <- reactive({
  switch(input$dataset_MW,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns)
})

observeEvent(input$InfoMW1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("MW_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})


#Reset inputs button
observeEvent(input$ResetMWinputs, {
  shinyjs::reset("MW_inputpanel")
})


output$LinkratiosMW <- renderPrint({
  datasetshow <- dataset_MWInput()
  #calculate and then show the individual link ratios for selected dataset
  chain1_link<-ata(datasetshow)
  chain1_sum<-summary(chain1_link,digits=3)
  chain1_sum
})

output$DatatriMW <- DT::renderDataTable({
  datasetshow <- dataset_MWInput()
  #show the dataset in raw form as in simple R script.
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect_MW),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

output$LinkratiosMW <- DT::renderDataTable({
  datasetshow <- dataset_MWInput()
  #calculate and then show the individual link ratios for selected dataset
  chain1_link<-ata(datasetshow)
  chain1_sum<-summary(chain1_link,digits=3)
  chain1_sum
},
extensions=c('Buttons'),class = 'stripe compact',selection = 'none',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-left',targets='_all'))))





#now output the MW results

output$MW_results <- DT::renderDataTable({
  #get the delta value.  need to convert to integer from radio estimator option
  datasetshow <- dataset_MWInput()
  MackResults_forMW <-MackChainLadder(datasetshow,tail=FALSE,alpha=1,est.sigma="Mack")
  #NB: Results only valid when alpha=1 and no tail factor allowed.
  period_chosen<-input$radio_periodMW
  if (period_chosen==1) {MWtab<-CDR(MackResults_forMW)}
  else if (period_chosen==2) {MWtab<-CDR(MackResults_forMW,dev="all")}
  #now show the MW results
  MWtab<-comma(round(MWtab/as.numeric(input$unitselect_MW),digits=0))
  colwords<-colnames(MWtab)
  colwords[1]<-"Reserve"
  colnames(MWtab)<-colwords
  MWtab
},
extensions=c('Buttons'),class = 'stripe compact',selection = 'none',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))  