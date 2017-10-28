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
#CL Bootstrap menu item
#Date: 1 October 2017
tabPanel("CL Bootstrap",icon=icon("random",lib="font-awesome"),
                   fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(id="CLBoot_inputpanel",    #main wellPanel for assumptions
                                 wellPanel(
                                   source("DatatriangleinputCLBoot.R",local=TRUE)$value,
                                   selectInput("unitselect_CLBoot","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                                 ),
                                 wellPanel(
                                   radioButtons("bootprocessdist", "Process distribution", 
                                                choices = list("ODP"=1,"Gamma"=2),selected = 2)
                                 ),
                                 wellPanel(
                                   numericInput("Boot_sims", "Number of simulations",
                                               min = 0, max = 1000000, value = 5000)
                                 ),
                                 wellPanel(
                                   radioButtons("seedoption","Simulation seed option",choices=c("Not set"=0,"Specify"=1),selected=0),
                                   conditionalPanel(
                                     condition = "input.seedoption == 1",
                                     numericInput("CLBootstrap_seed", "Simulation seed value",value=1328967780,
                                               min = 0)
                                   )
                                 ),
                                 wellPanel(
                                   numericInput("Boot_percentile", "Additional percentile value(%)",
                                                min = 0, max = 100, value = 85)
                                 ),
                                 
                                 wellPanel(
                                   actionButton("Runboot", "Run bootstrap")
                                 ),
                                 fluidRow(actionButton("InfoCLBoot1","Help",icon = icon("info")),actionButton("ResetCLBootinputs","Reset inputs",icon = icon("refresh")))
                                  ) # close overall assumption wellPanel
                        ),# close first three columns
                        column(9,
                               tabBox(width=NULL,
                                      tabPanel("Data",
                                               h5("Data triangle"),
                                               DT::dataTableOutput("Datatri_CLBoot")
                                      ),
                                      tabPanel("Residuals",
                                               DT::dataTableOutput("Bootstrap_residuals")
                                      ),
                                      tabPanel("Results Summary",
                                               DT::dataTableOutput("Bootstrap_results")
                                      ),
                                      tabPanel("Bootstrap percentiles",
                                               DT::dataTableOutput("Bootstrap_percentiles")
                                      ),
                                      tabPanel("Graphs",
                                               tabBox(title="", id="CLBootgraphstab",width=NULL,
                                                      tabPanel("Histogram",
                                                               plotOutput(outputId="Bootstrap_graphs1")
                                                      ),
                                                      
                                                      tabPanel("Cum' dist function",
                                                               plotOutput(outputId="Bootstrap_graphs2")
                                                      ),
                                                      tabPanel("Sim results by cohort",
                                                               plotOutput(outputId="Bootstrap_graphs3")
                                                      ),
                                                      
                                                      tabPanel("Back test latest dev yr",
                                                               plotOutput(outputId="Bootstrap_graphs4")
                                                      )
                                               ) # end of tabBox
                                               
                                      ) # end of Graphs tabPanel 
                               ) # end of tabsetPanel for results and graphs
                        ) # end of column 9
                        
                        
                      ) # end of fluidRow
                      
                      
                    ) # end of fluidPage
                    
           ) # end of tabPanel for GLM assumptions and results


           
           
           