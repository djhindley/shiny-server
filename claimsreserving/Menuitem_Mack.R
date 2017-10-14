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
#Mack Menu item
#Date: 1 October 2017
tabPanel("Mack",icon=icon("bullseye"),
                     fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(id="Mack_inputpanel",  #main wellPanel for assumptions
                                 wellPanel(
                                   source("DatatriangleinputMack.R",local=TRUE)$value,
                                   selectInput("unitselect_Mack","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                                 ),
                                 wellPanel(
                                   radioButtons("radio_estimator2", label = "Link Ratio estimator",
                                                choices = list("Column Sum" = 1, "Simple Average" = 2,"Regression-type"= 0), 
                                                selected = 1)
                                 ),
                                 wellPanel(
                                   radioButtons("radio_tail2", label = "Tail factor",
                                                choices = list("None" = 0,"Exponential"=1,"User-defined"=2), 
                                                selected = 0),
                                   conditionalPanel(
                                     condition = "input.radio_tail2 == 2",
                                     h5("Tail factor"),
                                     numericInput("Tailfactor_userdefined2", "",
                                                  1.000,min=0.001),
                                     h5("CV of tail factor(%)"),
                                     numericInput("Tailfactor_CV", "",
                                                  1.000,min=0.001),
                                     h5("Sigma for tail"),
                                     numericInput("Sigma_tail", "",
                                                  27.5,min=0.001)
                                   ),
                                   verbatimTextOutput("Tailfactor2")
                                 ), # close wellPanel for tail factor assumption selection
                                 wellPanel(
                                   radioButtons("crossproduct", label = "Cross-product term?",
                                                choices = c("No"="Mack","Yes"="Independence")
                                 )),
                                 fluidRow(actionButton("InfoMack1","Help",icon = icon("info")),actionButton("ResetMackinputs","Reset inputs",icon = icon("refresh")))
                                 ) # close overall assumption wellPanel
                        ),# close first three columns
                        column(9,
                               tabBox(width=NULL,
                                      tabPanel("Data and Link Ratios",
                                               h5("Data triangle"),
                                               DT::dataTableOutput("Datatri2"),
                                               hr(),
                                               h5("Link Ratios and Estimators"),
                                               DT::dataTableOutput("Linkratios1Mack")
                                      ),
                                      tabPanel("Results",
                                               tabBox(title="", id="MackResultstab",width=NULL,
                                                      tabPanel("Summary",
                                                               DT::dataTableOutput("Mack_results_summary")
                                                      ),
                                                      
                                                      tabPanel("Variance parameters",
                                                               DT::dataTableOutput("Mack_varianceparms")
                                                      ),
                                                      tabPanel("Process risk",
                                                               DT::dataTableOutput("Mack_processrisk")
                                                               ),
                                                      tabPanel("Parameter risk",
                                                                        DT::dataTableOutput("Mack_parameterrisk")
                                                      )
                                                      
                                               ) # end of tabBox for results
                                               
                                      ),# end of tabPanel Results
                                      tabPanel("Graphs",
                                               tabBox(title="", id="MackGraphstab",width=NULL,
                                                      tabPanel("Histogram",
                                                               plotOutput("Mack_graphs1")
                                                      ),
                                                      tabPanel("Residuals - by fitted values",
                                                               plotOutput("Mack_graphs3")
                                                      ),
                                                      tabPanel("Residuals - by cohort",
                                                               plotOutput("Mack_graphs4")
                                                      ),
                                                      tabPanel("Residuals - by calendar period",
                                                               plotOutput("Mack_graphs5")
                                                      ),
                                                      tabPanel("Residuals - by dev't period",
                                                               plotOutput("Mack_graphs6")
                                                      )
                                               ) # end of tabBox for Mack graphs
                                               
                                      )
                                      
                                      
                               ) # end of tabsetPanel for results and graphs
                               
                               
                        ) # end of column 9
                        
                        
                      ) # end of fluidRow
                      
                    )# end of fluidPage
           ) # end of TabPanel for main Mack menu  

