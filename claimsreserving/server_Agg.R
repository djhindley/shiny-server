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
##Aggregation server code
#Date: 1 October 2017
#first define function for distribution formulation
distfunc<-function (dist, reserve,CV,quantchosen) {
  #dist1=lognormal;dist2=gamma
  #first do SD
  SD<-CV*reserve
  #then parameters
  if (dist==1)
  {Dist_parm2=sqrt(log(1+CV^2))
  Dist_parm1=log(reserve)-(Dist_parm2^2)/2
  Dist_quant<-qlnorm(quantchosen,meanlog=Dist_parm1,sdlog=Dist_parm2)
  }
  else if (dist==2)
  {Distscale=CV^2
  Dist_parm1=1/Distscale
  Dist_parm2=Dist_parm1/reserve
  Dist_quant<-qgamma(quantchosen,shape=Dist_parm1,rate=Dist_parm2)
  }
  #now output
  combined<-list(SD,Dist_parm1,Dist_parm2,Dist_quant)
  return(combined)
  #can then be accessed using for example answer<-distfunc(1,20000,0.2,Percent_values)
  #then answer[[1]] answer[[2]] will return the output items 1 and 2 etc.
} 
#now function for simulating from gamma or lognormal
simfunc<-function (dist, simnum,parm1, parm2,color) {
  #dist=1=lognormal;dist=2=gamma
  if (dist==1)
  {Dist_sim<-rlnorm(simnum,meanlog=parm1,sdlog=parm2)  
  }
  else if (dist==2)
  {
    Dist_sim=rgamma(simnum,shape=parm1,rate=parm2)
  }
  #now output
  return(Dist_sim)
  #can then be accessed using for example answer<-distfunc(1,20000,0.2,Percent_values)
  #then answer[[1]] answer[[2]] will return the output items 1 and 2 etc.
}
#functions for ggplot2 graphs
#can't seem to pass "Class A" etc as an argument of gplotfunc to be used in aes(colour=argument) so have had to do 3 separate functions!
gplotfuncClassA<-function(dist,parm1,parm2,gphcolor) {
  shading<-0.3
  if (dist==1)
  {
    a_stat<-stat_function(fun = dlnorm,args=list(mean=parm1,sd=parm2),geom="area", fill=gphcolor,alpha=shading, aes(colour = "Class A"),size=1.25)
  }
  else if (dist==2)
  {
    a_stat<-stat_function(fun = dgamma,args=list(shape=parm1,rate=parm2),geom="area", fill=gphcolor,alpha=shading,aes(colour = "Class A"),size=1.25)
  }
  return(a_stat)
}
gplotfuncClassB<-function(dist,parm1,parm2,gphcolor) {
  shading<-0.3
  if (dist==1)
  {
    a_stat<-stat_function(fun = dlnorm,args=list(mean=parm1,sd=parm2),geom="area", fill=gphcolor,alpha=shading, aes(colour = "Class B"),size=1.25)
  }
  else if (dist==2)
  {
    a_stat<-stat_function(fun = dgamma,args=list(shape=parm1,rate=parm2),geom="area", fill=gphcolor,alpha=shading,aes(colour = "Class B"),size=1.25)
  }
  return(a_stat)
}
gplotfuncClassC<-function(dist,parm1,parm2,gphcolor) {
  shading<-0.3
  if (dist==1)
  {
    a_stat<-stat_function(fun = dlnorm,args=list(mean=parm1,sd=parm2),geom="area", fill=gphcolor,alpha=shading, aes(colour = "Class C"),size=1.25)
  }
  else if (dist==2)
  {
    a_stat<-stat_function(fun = dgamma,args=list(shape=parm1,rate=parm2),geom="area", fill=gphcolor,alpha=shading,aes(colour = "Class C"),size=1.25)
  }
  return(a_stat)
}


#Help button
observeEvent(input$InfoAgg1, {
  showModal(modalDialog(
    title = "",
    includeMarkdown("Agg_documentation.md"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})

#Reset inputs button
observeEvent(input$ResetAgginputs, {
  shinyjs::reset("Agg_inputpanel")
})

observeEvent(input$Aggpdfdoc, {
  showModal(modalDialog(
    title = "",
    tags$iframe(style="height:400px; width:100%; scrolling=yes", 
                         src="http://claimsreserving.com/Aggregationexample.pdf"),
    easyClose = TRUE,
    footer = modalButton("Close")
  ))
})



ClassAdistribution_chosen <- reactive({
  switch(input$ClassAdistribution,
         "Lognormal" = 1,
         "Gamma" = 2)
})

#   
ClassBdistribution_chosen <- reactive({
  switch(input$ClassBdistribution,
         "Lognormal" = 1,
         "Gamma" = 2)
})
ClassCdistribution_chosen <- reactive({
  switch(input$ClassCdistribution,
         "Lognormal" = 1,
         "Gamma" = 2)
})

#now determine class distribution diagnostics
#first work out undiversified SD using VCV approach
#class summary first
output$Class_summary<-DT::renderDataTable({
  Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
  ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
  ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
  ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
  Dist1_SD<-ClassA_dist[[1]]
  Dist2_SD<-ClassB_dist[[1]]
  Dist3_SD<-ClassC_dist[[1]]
  Class1_parm1<-ClassA_dist[[2]]
  Class1_parm2<-ClassA_dist[[3]]
  Class2_parm1<-ClassB_dist[[2]]
  Class2_parm2<-ClassB_dist[[3]]
  Class3_parm1<-ClassC_dist[[2]]
  Class3_parm2<-ClassC_dist[[3]]
  #work out SD for undiversified case using VCV
  Correllower <- c(1,1,1)
  Corrmatrix <- p2P(Correllower,d=3)  #put it in a matrix format using p2P function.
  Corrmatrix
  diag_matrix<-diag(x=c(ClassA_dist[[1]],ClassB_dist[[1]],ClassC_dist[[1]]))
  VCV_matrix<-diag_matrix%*%Corrmatrix%*%diag_matrix
  SD_tot<-sqrt(sum(VCV_matrix))
  Mean_tot<-input$ClassAReserve+input$ClassBReserve+input$ClassCReserve
  CV_tot<-100*(SD_tot)/Mean_tot
  Means<-c(comma(round(input$ClassAReserve,0)),comma(round(input$ClassBReserve,0)),comma(round(input$ClassCReserve,0)),comma(round(Mean_tot,0)))
  SDS<-c(comma(round(Dist1_SD,0)),comma(round(Dist2_SD,0)),comma(round(Dist3_SD,0)),comma(round(SD_tot,0)))
  CVS<-c(round(input$ClassACV,0),round(input$ClassBCV,0),round(input$ClassCCV,0),round(CV_tot,0))
  Parm1<-c(as.character(c(round(Class1_parm1,4),round(Class2_parm1,4),round(Class3_parm1,4))),"")
  Parm2<-c(as.character(c(round(Class1_parm2,4),round(Class2_parm2,4),round(Class3_parm2,4))),"")
  Distnames<-c(input$ClassAdistribution,input$ClassBdistribution,input$ClassCdistribution,"")
  summary_results<-as.data.frame(rbind(Means,SDS,CVS,Distnames,Parm1,Parm2))
  colnames(summary_results)<-c("Class A","Class B", "Class C","Total(Undivers'd)")
  row.names(summary_results)<-c("Mean","SD","CV(%)","Distribution","Param' 1","Param' 2")
  summary_results
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))
#percentiles first
output$Class_diag_percentile<-DT::renderDataTable({
  Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
  ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
  ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
  ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
  Dist1_quant<-ClassA_dist[[4]]
  Dist2_quant<-ClassB_dist[[4]]
  Dist3_quant<-ClassC_dist[[4]]
  Sumtot<-Dist1_quant+Dist2_quant+Dist3_quant
  Percentile<-100*Percent_values_use
  Allresults_quant=as.data.frame(cbind(Percentile, 
        comma(round(Dist1_quant,0)), comma(round(Dist2_quant,0)), comma(round(Dist3_quant,0)),comma(round(Sumtot,0))))
  colnames(Allresults_quant)<-c("Percentile","Class A","Class B", "Class C","Total(Undivers'd)")
  Allresults_quant
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))

#now ratios to mean
output$Class_diag_ratios<-DT::renderDataTable({
  Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
  ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
  ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
  ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
  Dist1_quant<-ClassA_dist[[4]]
  Dist2_quant<-ClassB_dist[[4]]
  Dist3_quant<-ClassC_dist[[4]]
  Sumtot<-Dist1_quant+Dist2_quant+Dist3_quant
  Dist1_ratio<-round(100*Dist1_quant/input$ClassAReserve,0)
  Dist2_ratio<-round(100*Dist2_quant/input$ClassBReserve,0)
  Dist3_ratio<-round(100*Dist3_quant/input$ClassCReserve,0)
  Classtotreserve<-input$ClassAReserve+input$ClassBReserve+input$ClassCReserve
  Tot_ratio<-round(100*Sumtot/Classtotreserve,0)
  Percentile<-100*Percent_values_use
  Allresults_ratio<-as.data.frame(cbind(Percentile, Dist1_ratio, Dist2_ratio,Dist3_ratio,Tot_ratio))
  names(Allresults_ratio)<-c("Percentile","Class A","Class B", "Class C","Total(Undivers'd)")
  Allresults_ratio
},
extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))
#plot of distributions now
output$Class_plot<-renderPlot({
  Percent_values_use<-c(0.001,0.995)
  ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
  ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
  ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
  a1<-gplotfuncClassA(ClassAdistribution_chosen(),ClassA_dist[[2]],ClassA_dist[[3]],"hotpink3")
  a2<-gplotfuncClassB(ClassBdistribution_chosen(),ClassB_dist[[2]],ClassB_dist[[3]],"lightskyblue")
  a3<-gplotfuncClassC(ClassCdistribution_chosen(),ClassC_dist[[2]],ClassC_dist[[3]],"darkgrey")
  #work out lower and upper ranges for x axis - set at min of 5th and 99.5th percentile values
  lowerx<-0.8*min(ClassA_dist[[4]][1],ClassB_dist[[4]][1],ClassC_dist[[4]][1])
  upperx<-1.1*max(ClassA_dist[[4]][2],ClassB_dist[[4]][2],ClassC_dist[[4]][2])
  plot1<-ggplot(data.frame(x = c(lowerx, upperx)), aes(x = x)) +
    a1+a2+a3+
    scale_colour_manual("", values = c("hotpink3", "lightskyblue","darkgrey"), labels=c("Class A", "Class B","Class C"))
  plot1<-plot1+scale_x_continuous(name="Total claims")+scale_y_continuous(name="Probability")
  plot1<-plot1+ggtitle("Probability density function of individual classes of business")+theme_light()+
    theme(axis.line = element_line(size=1, colour = "black"),
          panel.grid.major = element_line(colour = "#d3d3d3"),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(), panel.background = element_blank(),
          plot.title = element_text(size = 14, face = "bold"),
          axis.text.x=element_text(colour="black", size = 9),
          axis.text.y=element_text(colour="black", size = 9),
          legend.position = "bottom")
  plot1
  
})

##now CDF plots for each class
##CDf function for plots first
gplotfunc_CDF<-function(dist,parm1,parm2) {
  shading<-0.3
  if (dist==1)
  {
    a_stat<-stat_function(fun = plnorm,args=list(meanlog=parm1,sdlog=parm2),geom="line", aes(colour="curve"),size=1.25)
  }
  else if (dist==2)
  {
    a_stat<-stat_function(fun = pgamma,args=list(shape=parm1,rate=parm2),geom="line",aes(colour="curve"),size=1.25)
  }
  return(a_stat)
}
output$Class_plot_CDF<-renderPlot({
  Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
  if (input$CDF_graph_choice==1)
 {CDF_name<-"Class A"
 CDF_disttype<-ClassAdistribution_chosen()
 CDF_reserve<-input$ClassAReserve
 CDF_CV<-input$ClassACV
 }
  else if (input$CDF_graph_choice==2)
  {CDF_name<-"Class B"
  CDF_disttype<-ClassBdistribution_chosen()
  CDF_reserve<-input$ClassBReserve
  CDF_CV<-input$ClassBCV
  }
  else if (input$CDF_graph_choice==3)
  {CDF_name<-"Class C"
    CDF_disttype<-ClassCdistribution_chosen()
    CDF_reserve<-input$ClassCReserve
    CDF_CV<-input$ClassCCV
  }
  Class_dist<-distfunc(CDF_disttype,CDF_reserve,CDF_CV/100,Percent_values_use)
  Dist_SDEV<-Class_dist[[1]]
  Dist_parm1<-Class_dist[[2]]
  Dist_parm2<-Class_dist[[3]]
  Dist_quant<-Class_dist[[4]]
  #calcs
  lowerx<-0
  upperx<-1.1*Dist_quant[6]
  if (CDF_disttype==1){
    mean_yvalue<-plnorm(CDF_reserve,meanlog=Dist_parm1,sdlog=Dist_parm2)
    Dist_type<-"Lognormal"
  }
  else if (CDF_disttype==2){
    mean_yvalue<-pgamma(CDF_reserve,shape=Dist_parm1,rate=Dist_parm2)
    Dist_type<-"Gamma"
  }
  
  mean_annotate<-paste("Percentile of mean = ",as.character(round(100*mean_yvalue,1)))
  perc<-input$Agg_percentile/100
  pchosen<-Dist_quant[7]
  perc2<-0.995
  p995<-Dist_quant[5]
  annotatechosen<-paste(as.character(round(input$Agg_percentile,0)),"%ile = ",as.character(round(pchosen,0)))
  annotate995<-paste("99.5th %ile = ",as.character(round(p995,0)))
  #plot
  a1<-gplotfunc_CDF(CDF_disttype,Dist_parm1,Dist_parm2)
  ggplot(data.frame(x = c(lowerx, upperx)), aes(x = x),y=seq(0, 1, length.out = 10)) +
    a1 +
    scale_x_continuous(name="Value",expand = c(0, 0),limits=c(0,upperx),breaks=pretty(1:upperx,10))+
    scale_y_continuous(name="Cumulative probability",expand = c(0, 0),labels=scales::percent,limits=c(0,1),breaks=seq(0,1,0.05)) +
    geom_segment(aes(x=CDF_reserve, y=0,
                     xend=CDF_reserve,
                     yend=mean_yvalue,
                     colour="mean"), # mean label
                 size=1.25) +
    geom_segment(aes(x=0, y=mean_yvalue,
                     xend=CDF_reserve,
                     yend=mean_yvalue,
                     colour="mean"), # mean label
                 size=1.25, linetype="dotted",
                 show.legend = FALSE) +
    geom_segment(aes(x=pchosen, y=0,
                     xend=pchosen, yend=perc,
                     colour="chosen"), # chosen percentile label
                 size=1.25) +
    geom_segment(aes(x=0, y=perc, xend=pchosen,
                     yend=perc,
                     colour="chosen"), # chosen percentile label
                 size=1.25, linetype="dotted",
                 show.legend = FALSE) +
    geom_segment(aes(x=p995, y=0, xend=p995,
                     yend=perc2,
                     colour="995th"), # 99.5th percentile label
                 size=1.25) +
    geom_segment(aes(x=0, y=perc2, xend=p995,
                     yend=perc2,
                     colour="995th"), # 99.5th percentile label
                 size=1.25, linetype="dotted",
                 show.legend = FALSE) +
    annotate("text",x=0.9*0.5*CDF_reserve,y=1.05*mean_yvalue, label=mean_annotate,size=4.0)+
    annotate("text",x=0.5*(pchosen+p995),y=0.25, label=annotatechosen,size=4.0)+
    annotate("text",x=0.5*(pchosen+p995),y=0.2, label=annotate995,size=4.0)+theme_light()+
    theme(axis.line = element_line(size=1, colour = "black"),
          panel.grid.major = element_line(colour = "#d3d3d3"),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(), panel.background = element_blank(),
          plot.title = element_text(size = 14, face = "bold"),
          axis.text.x=element_text(colour="black", size = 9),
          axis.text.y=element_text(colour="black", size = 9),
          legend.position = "bottom")+
    scale_colour_manual(name="",
                        # labels map onto colors and pretty labels
                        values=c("curve"="blue",
                                 "mean"="red",
                                 "chosen"="green",
                                 "995th"="orange"),
                        labels=c("curve"=paste(CDF_name,"(",Dist_type,")"),
                                 "mean"="Mean",
                                 "chosen"=paste(as.character(round(input$Agg_percentile,0))," %ile"),
                                 "995th"="99.5th %ile"))
  
})


####now correlations
#function needed first

corrfunc<-function(corrtype,inputAB,inputAC,inputBC){
  if (corrtype==0) { #Fully
    CorrAB=1.0
    CorrAC=1.0
    CorrBC=1.0
  }
  else if (corrtype==1) { # high
    CorrAB=0.8
    CorrAC=0.6
    CorrBC=0.5
  } 
  
  else if (corrtype==2) { #low
    CorrAB=0.1
    CorrAC=0.2
    CorrBC=0.1
  }
  else if (corrtype==3) { #zero
    CorrAB=0.0
    CorrAC=0.0
    CorrBC=0.0
  }
  #next is user defined
  else if (corrtype==4) { #user defined
    CorrAB<-inputAB
    CorrAC<-inputAC
    CorrBC<-inputBC
  }
  Correllower <- c(CorrAB,CorrAC,CorrBC)
  Corrmatrix <- p2P(Correllower,d=3) #put it in a matrix format using p2P function. 
  results<-list(Correllower,Corrmatrix)
  return(results)
}

#now print it out    
output$SelectedCorrmatrix<-renderPrint({
  Corrmatrix_chosen<-corrfunc(input$Corrtype,input$CorrclassAB,input$CorrclassBC,input$CorrclassAC)
  Corrmatrix_chosen[[2]]})

#and show if it is positive definite
#check positive definite
output$SelectedCorrmatrix_POSDEF<-renderPrint({
  Corrmatrix_chosen<-corrfunc(input$Corrtype,input$CorrclassAB,input$CorrclassBC,input$CorrclassAC)  
  POS<-is.positive.definite(Corrmatrix_chosen[[2]])
  POS})



#copula results now
#first define the functions needed
distname<-c("lnorm","gamma")
distparms<-function(type,Dist_parm1,Dist_parm2){
  if(type==1){
    distlist<-list(meanlog=Dist_parm1,sdlog=Dist_parm2)}
  else if(type==2){
    distlist<-list(shape=Dist_parm1,rate=Dist_parm2)
  }
  return(distlist)
}


docopula<-function(coptype,df_chosen,corrlower,dist1type,dist1_parm1,dist1_parm2,
                   dist2type,dist2_parm1,dist2_parm2,dist3type,dist3_parm1,dist3_parm2,nsims){
  withProgress(message = 'Running copula', value = 0, {
    
    if (coptype==0) # independence
    {cop_eg<-indepCopula(dim=3)}
    else if(coptype==1) #Normal
    {cop_eg<-normalCopula(param=corrlower,dim=3,dispstr="un")}
    else if (coptype==2)
    {cop_eg<-tCopula(param=corrlower,dim=3,dispstr="un",df=1)}
    else if (coptype==3)
    {cop_eg<-tCopula(param=corrlower,dim=3,dispstr="un",df=4)}
    else if (coptype==4)
    {cop_eg<-tCopula(param=corrlower,dim=3,dispstr="un",df=df_chosen)}
    #joint dist
    incProgress(2/5, detail="Running copula simulation") #1/5
    joint_dist<-mvdc(
      cop_eg, margins=c(distname[dist1type],distname[dist2type],distname[dist3type]),
      paramMargins=list(distparms(dist1type,dist1_parm1,dist1_parm2),
                        distparms(dist2type,dist2_parm1,dist2_parm2),
                        distparms(dist3type,dist3_parm1,dist3_parm2))
    )
    #simulate from chosen copula and margins
    Sim_cop<-rMvdc(nsims,joint_dist)
    incProgress(3/5, detail="Finished copula simulation") #3/5
  })
  #output results in a dataframe
  return(as.data.frame(Sim_cop))
}
#function for axes for copula graph
chooseaxis<-function(axischoice,simsdata) {
  if (axischoice==1) {
    data_chosen=simsdata$V1
    label_chosen="Class A"
}
  else if (axischoice==2){
    data_chosen=simsdata$V2
    label_chosen="Class B"
  }
  else if (axischoice==3){
    data_chosen=simsdata$V3
    label_chosen="Class C"
  }
  results<-list(data_chosen,label_chosen)
  return(results)
  
}


#action button will run code after input$Update_results is pressed
observeEvent(input$Update_results,{

                                #now all the code below only runs when input$Update_results changes
                                #first get the chosen lower correlation matrix
                                
                                Corrfunc_results<-corrfunc(input$Corrtype,input$CorrclassAB,input$CorrclassBC,input$CorrclassAC)
                                Corrlower_chosen<-Corrfunc_results[[1]] #as corrfunc produces two items in a list. First is corrmatrix
                                #now get dist parameters
                                Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
                                ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
                                ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
                                ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
                                #now run copula function. This returns a dataframe of results.
                                if (input$seedoption_agg==1) {set.seed(input$Agg_seed)}
                                else if (input$seedoption_agg==0) {set.seed(NULL)}
                                
                                copula_sims<-docopula(input$Copula_type,input$tcop_degfree,Corrlower_chosen,
                                                      ClassAdistribution_chosen(),ClassA_dist[[2]],ClassA_dist[[3]],
                                                      ClassBdistribution_chosen(),ClassB_dist[[2]],ClassB_dist[[3]],
                                                      ClassCdistribution_chosen(),ClassC_dist[[2]],ClassC_dist[[3]],input$Copula_sims)
                                
#now output the results
output$copula_basicstats<-DT::renderDataTable({
  rowsum_cop<-rowSums(copula_sims)
  mean_cop<-mean(rowsum_cop)
  SD_cop<-sqrt(var(rowsum_cop))
  quantile_results<-quantile(rowSums(copula_sims),probs=Percent_values)
  ##now diversification benefits
  Percent_values_use<-c(Percent_values,input$Agg_percentile/100)
  ClassA_dist<-distfunc(ClassAdistribution_chosen(),input$ClassAReserve,input$ClassACV/100,Percent_values_use)
  ClassB_dist<-distfunc(ClassBdistribution_chosen(),input$ClassBReserve,input$ClassBCV/100,Percent_values_use)
  ClassC_dist<-distfunc(ClassCdistribution_chosen(),input$ClassCReserve,input$ClassCCV/100,Percent_values_use)
  Dist1_quant<-ClassA_dist[[4]]
  Dist2_quant<-ClassB_dist[[4]]
  Dist3_quant<-ClassC_dist[[4]]
  Sumtot<-(Dist1_quant+Dist2_quant+Dist3_quant)
  cop_quantiles<-quantile(rowSums(copula_sims),probs=Percent_values_use)
  divers_benefit<-round((Sumtot-cop_quantiles)/Sumtot*100,2)
  #comma(round(datasetshow/as.numeric(input$unitselect),digits=0))
  basic_stats<-rbind(comma(round(mean_cop,digits=0)),comma(round(SD_cop,digits=0)),round(SD_cop/mean_cop*100,digits=2))
  basic_stats<-cbind(basic_stats,c("","",""),c("","",""))
  row.names(basic_stats)<-c("Mean","SD","CV(%)")
  quant_divers<-cbind(comma(round(cop_quantiles,digits=0)),comma(round(Sumtot,digits=0)),comma(round(divers_benefit,digits=2)))
  all_results<-rbind(basic_stats,quant_divers)
  colnames(all_results)<-c("Selection","Undiversified","Divers'n benefit(%)")
  all_results
  }
  ,
  extensions=c('Buttons'),selection='none',class = 'stripe compact',
  options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
               ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
               columnDefs=list(list(className='dt-right',targets='_all'))))

#now do the copula plot
output$copula_graphs<-renderPlot({
plot(chooseaxis(input$copula_graphaxis1,copula_sims)[[1]],chooseaxis(input$copula_graphaxis2,copula_sims)[[1]],
     xlab=chooseaxis(input$copula_graphaxis1,copula_sims)[[2]],ylab=chooseaxis(input$copula_graphaxis2,copula_sims)[[2]])
})
}) # finish the observe event
###Aggregation code finished