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
##Chain ladder menu code
#Date: 1 October 2017
tabPanel("Chain Ladder",icon=icon("menu-hamburger",lib="glyphicon"),
             fluidPage(
             fluidRow(
               column(3,
                      wellPanel(id="CL_inputpanel",    #main wellPanel for assumptions
                        wellPanel(
                          
                          source("DatatriangleinputCL.R",local=TRUE)$value,
                          
                        selectInput("unitselect","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                      ),
                      wellPanel(
                        radioButtons("radio_estimator1", label = "Link Ratio estimator",
                                     choices = list("Column Sum" = 1, "Simple Average" = 2), 
                                     selected = 1)
                      ),
                      wellPanel(
                        radioButtons("radio_tail1", label = "Tail factor",
                                     choices = list("None" = 0,"Exponential"=1,"Inverse Power"=2, "User-defined"=3), 
                                     selected = 0),
                        conditionalPanel(
                          condition = "input.radio_tail1 == 3",
                          numericInput("Tailfactor_userdefined", "Enter factor:",
                                       1.000,min=0.001)
                        ),
                        #panel for no. periods into future to project if anythng other than user-defined or 1
                        ##currently got too panels as not sure how to do #OR#
                        conditionalPanel(
                          condition = "input.radio_tail1 == 1",
                          numericInput("Tailfactor_expoperiod", "Enter no.future projection periods:",
                                       7.000,min=1.0)
                        ),
                        conditionalPanel(
                          condition = "input.radio_tail1 == 2",
                          numericInput("Tailfactor_ipwrperiod", "Enter no.future projection periods:",
                                       7.000,min=1.0)
                      )  
                        
               ), # close wellPanel for tail factor assumption selection
               wellPanel(
               #regression inputs now - need to make dependent on selection of regression on tabsets as per Radiant
               uiOutput("Regcolumn") 
               ), # close regression inner wellPanel
               fluidRow(actionButton("InfoCL1","Help",icon = icon("info")),actionButton("ResetCLinputs","Reset inputs",icon = icon("refresh")))
               ) # close overall assumption wellPanel
               ),# close first three columns
               column(9,
                      tabBox(width=NULL,
                      tabPanel("Data and Link Ratios",
                               h5("Data triangle"),
                               DT::dataTableOutput("Datatri1"),
                               hr(),
                               h5("Link ratios and estimators"),
                               DT::dataTableOutput("Linkratios1")
                               ),
                      tabPanel("Results",
                               h5("Projected triangle"),
                          DT::dataTableOutput("CL_projtri1"),
                          hr(),
                          h5("Summary of results"),
                          DT::dataTableOutput("CL_results1")
                          ),
                               
                      tabPanel("Graphs",
                               tabBox(title="", id="CLgraphstab",width=NULL,
                                      tabPanel("Cumulative scaled",
                                               plotOutput(outputId="CL_graphs_cum_scaled")
                                      ),
                                      
                                      tabPanel("Cumulative unscaled",
                                               plotOutput(outputId="CL_graphs_cum_unscaled")
                                      ),
                                      tabPanel("Incremental unscaled",
                                               plotOutput(outputId="CL_graphs_inc_unscaled")
                                      ),
                                      
                                      tabPanel("Incremental scaled",
                                               plotOutput(outputId="CL_graphs_inc_scaled")
                                      )
                                      
                               ) # end of tabBox
                               ),  # end Graphs tabPanel
                        tabPanel("Regression",
                                 plotOutput(outputId = "LR_plot1reg", height = "300px"),
                                 verbatimTextOutput("CLreg_line_equation")
                                 ) # end of Regression output tabPanel       
                      ) # end of tabsetPanel for results and graphs
                      
                      
                        ) # end of column 9
             
                        
                      ) # end of fluidRow
                      
               )# end of fluidPage
           ) # end of TabPanel for main CL menu  

           
          
