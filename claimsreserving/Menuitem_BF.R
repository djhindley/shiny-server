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
##BF menu code
#Date: 1 October 2017
tabPanel("BF",icon=icon("balance-scale"),
           fluidPage(
             fluidRow(
               column(3,
                      wellPanel(id="BF_inputpanel",    #main wellPanel for assumptions
                        wellPanel(
                        source("DatatriangleinputBF.R",local=TRUE)$value,
                        selectInput("unitselect_BF","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                      ),
                        wellPanel(
                          radioButtons("radio_tailBF", label = "Tail factor for default % dev'd",
                                       choices = list("None" = 0,"Exponential"=1,"Inverse Power"=2, "User-defined"=3), 
                                       selected = 0),
                          conditionalPanel(
                            condition = "input.radio_tailBF == 3",
                            numericInput("Tailfactor_userdefinedBF", "Enter factor:",
                                         1.000,min=0.001)
                          ),
                          #panel for no. periods into future to project if anythng other than user-defined or 1
                          ##currently got too panels as not sure how to do #OR#
                          conditionalPanel(
                            condition = "input.radio_tailBF == 1",
                            numericInput("Tailfactor_expoperiodBF", "Enter no.future projection periods:",
                                         7.000,min=1.0)
                          ),
                          conditionalPanel(
                            condition = "input.radio_tailBF == 2",
                            numericInput("Tailfactor_ipwrperiodBF", "Enter no.future projection periods:",
                                         7.000,min=1.0)
                          )  
                          
                        ),  #end wellPanel for BFr assumptions
                        
                      
                      wellPanel(h5('Individual cohort BF assumptions'),
                          numericInput("cohortBFnumber","Cohort for BF assumptions",1),
                          numericInput("percent_dev_user","% developed","100"),
                          numericInput("prior_user","Prior ultimate (in units selected above)",4000)
                          
                          ),
               wellPanel(
               fluidRow(actionButton("InfoBF","Help",icon = icon("info")),actionButton("ResetBFinputs","Reset inputs",icon = icon("refresh")))
               )
               ) # close overall assumption wellPanel
               ),# close first three columns
               column(9,
                      tabBox(width=NULL,
                      tabPanel("Data",
                               h5("Data triangle"),
                               DT::dataTableOutput("Datatri1BF")
                                ),
                      tabPanel("BF Results",
                               h5("Using default assumptions")
                               ,DT::dataTableOutput("BF_results1"),
                               h5("Using input assumptions")
                               ,DT::dataTableOutput("BF_results2")
                      )
                              
                    
                      
                      
                                      
                               ) # end of tabBox
                               
                      
                        ) # end of column 9
             
                        
                      ) # end of fluidRow
                      
               )# end of fluidPage
           ) # end of TabPanel for main BF menu  
   
           
          
