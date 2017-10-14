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
##aggregation menu item
#Date: 1 October 2017
tabPanel("Aggregation",icon=icon("plus-square-o",lib="font-awesome"),
                  fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(id="Agg_inputpanel",
                                tabBox(width="NULL",    #main tabBox for assumptions
                                 tabPanel("Class assumptions", # Class Assumptions tabPanel
                                   tabBox(width=NULL,
                                          tabPanel("Class A",
                                                  
                                 selectInput("ClassAdistribution", label="Class A Distribution",choices=c("Lognormal","Gamma")),
                                 #change to allow default to be selected or user input. Conditional panel if user input.
                                 #means can always revert back to default if needed
                                 numericInput("ClassAReserve", label="Class A reserve",
                                              20219),
                                 
                                 numericInput("ClassACV", "Class A Coefficient of Variation(%)",
                                             min = 0, max = 100, value = 16)
                                
                                          
                                 ), # end of Class A wellPanel
                                 
                                   tabPanel("Class B", # Class B tabPanel
                                     selectInput("ClassBdistribution", label="Class B Distribution",choices=c("Lognormal","Gamma"),selected="Gamma"),
                                     numericInput("ClassBReserve", label="Class B reserve",
                                                  21250),
                                     numericInput("ClassBCV", "Class B Coefficient of Variation(%)",
                                                 min = 0, max = 100, value = 7.67)
                                     
                                    
                                   ), 
                                   
                                     tabPanel("Class C", # Class C tabPanel
                                       
                                       selectInput("ClassCdistribution", label="Class C Distribution",choices=c("Lognormal","Gamma")),
                                       numericInput("ClassCReserve", label="Class C reserve",
                                                    18606),
                                       numericInput("ClassCCV", "Class C Coefficient of Variation(%)",
                                                   min = 0, max = 100, value = 25.395)
                                       
                                               
                                       
                                       
                                     )  #close Class C tabPanel
                                   ) # close tabBox for Class assumptions
                                 ), # close tabPanel for Class assumptions
                                 tabPanel ("Correlations", # correlations tabPanel
                                   radioButtons("Corrtype", label = h3(""),
                                                choices = list("Fully (i.e. 1)"=0,"High" = 1,"Low"=2,"Zero"=3,"User-defined"=4), 
                                                selected = 1),
                                   conditionalPanel(
                                     condition = "input.Corrtype == 4",
                                     sliderInput("CorrclassAB", "Corr Class A,B",
                                                 min = 0, max = 1, value = 0.8),
                                     sliderInput("CorrclassAC", "Corr Class A,C",
                                                 min = 0, max = 1, value = 0.6),
                                     sliderInput("CorrclassBC", "Corr Class B,C",
                                                 min = 0.00, max = 1.00, value = 0.5)
                                     
                                     
                                   ),
                                   
                                            h5("Correlation matrix"),
                                    
                                   verbatimTextOutput("SelectedCorrmatrix"),
                                   
                                            h5("Positive Definite?"),
                                     
                                   verbatimTextOutput("SelectedCorrmatrix_POSDEF")
                                   
                                   
                                   
                                 ), # close Correlations tabPanel
                                 tabPanel("Copula", # copula wellPanel
                                   radioButtons("Copula_type", label = h3(""),
                                                choices = list("Independence" = 0,"Gaussian"=1,"t-copula 1 df"=2,"t-copula 4 df"=3,"t-copula user defined df"=4), 
                                                selected = 1),
                                   conditionalPanel(
                                     condition = "input.Copula_type == 4",
                                     numericInput("tcop_degfree", "Degrees of Freedom",
                                                  1,min=1)
                                     
                                   )
                                   
                                 )# close copula tabPanel
                               ), # close tab box for class assumptions
                               wellPanel(actionButton("Update_results", "Update Aggregation results")),
                               wellPanel(
                                 numericInput("Copula_sims", "Number of simulations",
                                              min = 0, max = 10000000, value = 100000)
                               ),
                               wellPanel(
                                 radioButtons("seedoption_agg","Simulation seed option",choices=c("Not set"=0,"Specify"=1),selected=1),
                                 conditionalPanel(
                                   condition = "input.seedoption_agg == 1",
                                   numericInput("Agg_seed", "Simulation seed value",value=1328967,
                                                min = 0)
                                 )
                               ),#close no. sims wellPanel
                               wellPanel(
                                 numericInput("Agg_percentile", "Additional percentile value(%)",
                                              min = 0, max = 100, value = 85)
                               ),
                                
                               fluidRow(
                               
                                actionButton("InfoAgg1","Help",icon = icon("info")),
                                actionButton("ResetAgginputs","Reset inputs",icon = icon("refresh")),
                                actionButton(inputId='ab2', label="Read pdf article", 
                                            icon = icon("book"), onclick ="location.href='http://claimsreserving.com/Aggregationexample_temp.pdf';")
                                )
                                 
                               ) # close overall assumption wellPanel
                        ),# close first three columns
                        ###Output UI starts here
                        column(9,
                               tabBox(width=NULL,
                                      tabPanel("Class of business details",
                                               tabBox(title="",id="Aggclasssum",width=NULL,
                                                      tabPanel("Summary",
                                                               DT::dataTableOutput("Class_summary")),
                                                      tabPanel("Percentiles",
                                                               DT::dataTableOutput("Class_diag_percentile")),
                                                      tabPanel("Ratio to mean",
                                                               DT::dataTableOutput("Class_diag_ratios")),
                                                      tabPanel("Density Graph",
                                                               plotOutput("Class_plot")),
                                                      tabPanel("CDF Graphs",
                                                               tabBox(title="",id="copulagraphs",width=NULL,
                                                                      tabPanel("CDF Graphs",
                                                                               plotOutput("Class_plot_CDF")
                                                                               
                                                                      )
                                                                      
                                                               ),# end of graphs tabBox
                                                               fluidRow(column(1,radioButtons("CDF_graph_choice","Class", choices=c("Class A"=1,"Class B"=2,"Class C"=3),selected=1))
                                                               
                                                               )
                                                      )  # end of tabPanel for graphs 
                        
                                               ) # end of class of business details tabBox
                                      ), # end of Class of business tabPanel
                                      
                                      tabPanel("Aggregation results",
                                               tabBox(title="",id="Aggclassresults",width=NULL,
                                                      tabPanel("Summary",
                                                               DT::dataTableOutput("copula_basicstats"))
                                                      
                                               ) # end of results tabBox
                                      ), # end of Agg results tabPanel
                                      tabPanel("Copula graph",
                                               tabBox(title="",id="copulagraphs",width=NULL,
                                                      tabPanel("Copula graph",
                                               plotOutput("copula_graphs")
                                               
                                                      )
                                                      
                                               ),# end of graphs tabBox
                                               fluidRow(column(1,radioButtons("copula_graphaxis1","Axis 1:",choices=c("Class A"=1,"Class B"=2,"Class C"=3),selected=1)),
                                                        column(1,radioButtons("copula_graphaxis2","Axis 2:",choices=c("Class A"=1,"Class B"=2,"Class C"=3),selected=2))       
                                               )
                                               )  # end of tabPanel for graphs 
                               )     # end of tabBox for all results      
                       
                      
                               
                        ) # end of column 9
                        
                        
                      ) # end of fluidRow
                      
                    )# end of fluidPage
           ) # end of TabPanel for main Agg menu  


           