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
##MW menu item
#Date: 1 October 2017
tabPanel("Merz-Wüthrich",icon=icon("stats",lib="glyphicon"),
                   fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(id="MW_inputpanel",    #main wellPanel for assumptions
                                 wellPanel(
                                   source("DatatriangleinputMW.R",local=TRUE)$value,
                                   selectInput("unitselect_MW","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                                 ),
                                 wellPanel(
                                   radioButtons("radio_periodMW", label = "Select period",
                                                choices = list("One year" = 1,"All years"=2), 
                                                selected = 2)),
                               wellPanel(
                                 fluidRow(actionButton("InfoMW1","Help",icon = icon("info")),actionButton("ResetMWinputs","Reset inputs",icon = icon("refresh")))
                                 )
                               ) # close overall assumption wellPanel
                        ),# close first three columns
                        column(9,
                               tabBox(width=NULL,
                                      tabPanel("Data and Link Ratios",
                                               h5("Data triangle"),
                                               DT::dataTableOutput("DatatriMW"),
                                               hr(),
                                               h5("Link ratios and estimators"),
                                               DT::dataTableOutput("LinkratiosMW")
                                              ),
                                      tabPanel("Results",
                                               DT::dataTableOutput("MW_results")
                                      )
                                     ) # end of tabsetPanel for results and graphs
                                     
                               ) # end of column 9
                               
                               
                        
                        
                        
                      ) # end of fluidRow
                      
                    )# end of fluidPage
           ) # end of TabPanel for main MW menu  


