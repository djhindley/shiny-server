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
#GLM menu item
#Date: 1 October 2017
tabPanel("GLM",icon=icon("cog",lib="font-awesome"),
                     fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(id="GLM_inputpanel",    #main wellPanel for assumptions
                                 wellPanel(
                                   source("DatatriangleinputGLM.R",local=TRUE)$value,
                                   radioButtons("GLM_datatoshow", label="Data to show:", 
                                                choices = list("Incremental"=1,"Cumulative"=2
                                                ),selected = 1),
                                   selectInput("unitselect_GLM","Unit for display purposes:",c("Units"=1,"Hundreds"=100,"Thousands"=1000,"Millions"=1000000,"Billions"=1000000000),selected=1000)
                                 ),
                                 wellPanel(
                                   radioButtons("GLM_modelchoice", label="Choose Model", 
                                                choices = list("ODP"=1,"Gamma"=2,"Gaussian"=0,"Inverse Gaussian"=3
                                                               ),selected = 1)
                                 ),
                                 wellPanel(
                                   radioButtons("GLM_residualchoice", label="Choose residual type", 
                                                choices = list("Pearson"="pearson","Deviance"="deviance","Working"="working","Response"="response"
                                                ),selected = "pearson")
                                 ),
                                 fluidRow(actionButton("InfoGLM1","Help",icon = icon("info")),actionButton("ResetGLMinputs","Reset inputs",icon = icon("refresh")))
                                 ) # close overall assumption wellPanel
                        ),# close first three columns
                        column(9,
                               tabBox(width=NULL,
                                      tabPanel("Data",
                                               h5("Data triangle"),
                                               DT::dataTableOutput("Datatri_GLM")
                                      ),
                                      tabPanel("Summary of Results",
                                               h5("GLM Summary results"),
                                               DT::dataTableOutput("GLM_results")
                                                                                     ),
                                      tabPanel("Fitted values",
                                               h5("GLM fitted values"),
                                               DT::dataTableOutput("GLM_fitted")
                                      ),
                                      tabPanel("Residuals",
                                               h5("GLM residuals"),
                                               DT::dataTableOutput("GLM_residuals")
                                      ),
                                      tabPanel("Fitted parameters",
                                               verbatimTextOutput("GLM_fittedparms")
                                      ),
                                      
                                      tabPanel("Graphs",
                                               tabBox(title="", id="GLMgraphstab",width=NULL,
                                                      tabPanel("Residuals",
                                                               plotOutput(outputId="GLM_graphsdraw1")
                                                      ),
                                                      
                                                      tabPanel("Q-Q plot",
                                                               plotOutput(outputId="GLM_graphsdraw2")
                                                      )
                                                      ) # end of tabBox
                                                      
                                               ) 
                                      ) # end of tabsetPanel for results and graphs
                               ) # end of column 9
                               
                               
                        ) # end of fluidRow
                        
                        
                      ) # end of fluidPage
                      
                    ) # end of tabPanel for GLM assumptions and results
           



