####################NOTICE and LICENSE##############################
#This file is part of GIRA - a claims reserving application designed for educational purposes only
##Please see https://github.com/djhindley/shiny-server/blob/master/claimsreserving/NoticeLicense.md for notice and license relating to this 
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
###GLM server code
#Date: 1 October 2017
##Need function first to move model choice type 4 to a NULL value. Rest stay as they are
##Needed to get var.power argument in glm model fitting to be NULL so as to get
##Compound Poisson.  NULL Doesn't seem to work in glmReserve, so option 4 currently can't be input. Have left function here anyway. 
GLMmodeltype<-function(modelinput) {
  if (modelinput==4) {modelresult=NULL}
  else if (modelinput<4) {modelresult=modelinput}
  return(modelresult)
}

GLMdataset_chosen <- reactive({
  switch(input$GLM_dataset,
         "Reserving book" = GenIns2,
         "RAA" = RAA,
         "UKMotor" = UKMotor,
         "MW2008"=MW2008,
         "MW2014"=MW2014,
         "GenIns"=GenIns)
})

observeEvent(input$InfoGLM1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("GLM_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})


#Reset inputs button
observeEvent(input$ResetGLMinputs, {
  shinyjs::reset("GLM_inputpanel")
})


output$Datatri_GLM <- DT::renderDataTable({
  datasetshow <- GLMdataset_chosen()
  data_type<-input$GLM_datatoshow
  #show the dataset in raw form as in simple R script.
  #incremental or cumulative as chosen by user
  if (data_type==1) {datasetshow<-cum2incr(datasetshow)} # if incremental, convert cumulative data to incremental format for display 
  datasetshow<-comma(round(datasetshow/as.numeric(input$unitselect_GLM),digits=0))
  datasetshow
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))


output$GLM_results<-DT::renderDataTable({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  table_out<-cbind(comma(round(GLMresults$summary[1]/as.numeric(input$unitselect_GLM),digits=0)),
                   comma(round(GLMresults$summary[3]/as.numeric(input$unitselect_GLM),digits=0)),
                   comma(round(GLMresults$summary[4]/as.numeric(input$unitselect_GLM),digits=0)),
                   comma(round(GLMresults$summary[5]/as.numeric(input$unitselect_GLM),digits=0)),
                   comma(round(GLMresults$summary[6]*100,digits=0))
                         
  )       
colnames(table_out)[5]<-"CV(%)"
colnames(table_out)[3]<-"Reserve"
table_out
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

#residuals plot
output$GLM_graphsdraw1<-renderPlot({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  GLMmodel<-GLMresults$model
  GLM_resid<-residuals.glm(GLMmodel,type=c(input$GLM_residualchoice))
    plot(fitted.values(GLMmodel),GLM_resid)
  
})

#Q-Q plot
output$GLM_graphsdraw2<-renderPlot({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  GLMmodel<-GLMresults$model
  GLM_resid<-residuals.glm(GLMmodel,type=c(input$GLM_residualchoice))
    qqnorm(GLM_resid)
    qqline(GLM_resid)
})
#function to convert residuals and fitted values output from GLM to triangle format, for display purposes.
convert_resid<-function (residfile) {
  residfile_df<-as.data.frame(residfile)
  residfile_df_rownames<-row.names(residfile_df)
  dashpos<-regexpr("-",residfile_df_rownames)
  rowdim<-as.numeric(substr(residfile_df_rownames,1,dashpos-1))
  coldim<-as.numeric(substr(residfile_df_rownames,dashpos+1,nchar(residfile_df_rownames)))
  residfile_indexed<-cbind(rowdim, coldim,residfile_df)
  residfile_triangle<-as.triangle(residfile_indexed,origin="rowdim",dev="coldim",value="residfile")
  return(residfile_triangle)
} 

output$GLM_fitted<-DT::renderDataTable({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  GLMmodel<-GLMresults$model
  GLMfitted<-GLMmodel$fitted.values
  GLMfitted_tri<-convert_resid(GLMfitted)
  GLMfitted_tri<-comma(round(GLMfitted_tri/as.numeric(input$unitselect_GLM),digits=0))
  GLMfitted_tri
}   
,extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))




output$GLM_residuals<-DT::renderDataTable({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  GLMmodel<-GLMresults$model
  GLM_resid<-residuals.glm(GLMmodel,type=c(input$GLM_residualchoice))
  resid_tri<-convert_resid(GLM_resid)
  resid_tri<-comma(round(resid_tri,digits=3))
  resid_tri
}
,extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

output$GLM_fittedparms<-renderPrint({
  GLMresults<-glmReserve(GLMdataset_chosen(), var.power=GLMmodeltype(as.numeric(input$GLM_modelchoice)), link.power=0, cum=TRUE, mse.method=c("formula"))
  GLMfitted<-summary(GLMresults,type="model")
  GLMfitted
  
})