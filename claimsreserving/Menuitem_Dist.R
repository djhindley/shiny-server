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
##Lognormal menu item
#Date: 1 October 2017
tabPanel("Dist",icon=icon("area-chart"),
         fluidPage(
           fluidRow(
             column(3,
                    wellPanel(id="Dist_inputpanel",  #main wellPanel for assumptions
                              selectInput("Dist_type", label="Distribution",choices=c("Lognormal","Gamma")),
                                
                                  numericInput("Dist_mean", "Mean",
                                               100,min=0.0001),
                                  numericInput("Predict_error", "CV of Prediction Error(%)",
                                               25.0,min=0.001),
                                  numericInput("Dist_percentchosen", "Required percentile(%)",
                                               75.0,min=0.001)
                                ), # close wellPanel for assumption selection
                              fluidRow(actionButton("InfoDist1","Help",icon = icon("info")),actionButton("ResetDistinputs","Reset inputs",icon = icon("refresh")))
                    
             ),# close first three columns
             column(9,
                    tabBox(width=NULL,
                           tabPanel("Results",
                              
                              DT::dataTableOutput("Dist_results")
                           ),
                           tabPanel("Graph",
                                    h5("Cumulative density function of estimated future claims outgo"),
                                    plotOutput("Dist_graphs")
                                           )
                                    ) # end of tabBox for results

                    ) # end of column 9
             
             
           ) # end of fluidRow
           
         )# end of fluidPage
) # end of TabPanel for main Dist menu  

