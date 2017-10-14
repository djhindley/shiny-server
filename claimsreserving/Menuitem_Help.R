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
#Help Menu item
#Date: 1 October 2017
navbarMenu("",icon=icon("question-circle"),
           tabPanel("Notice and License",
                    fluidPage(
                      column(12,
                             wellPanel(style = "background-color: #ffffff;",
                                       includeMarkdown("NoticeLicense.md")
                             ) # end of wellPanel
                      )
                    ) # end fluidPage
           ), # end of tabPanel Notice and License  
           tabPanel("Documentation",
                  fluidPage(
                      fluidRow(
                        column(3,
                               wellPanel(
                              radioButtons("radio_help",label = "Help topic",
                          choices = list("Introduction" = 1, 
                                         "Chain Ladder" = 2,
                                         "BF" = 3,
                                         "Mack"= 4,
                                         "GLM" = 5,
                                         "CL Bootstrap" = 6,
                                         "Merz-Wuthrich"= 7,
                                         "Aggregation"=8
                                         ), 
                                             selected = 1)
                                              )
                        ),
                        
                        column(9,
                               wellPanel(style = "background-color: #ffffff;",
                                 uiOutput("Helpcontent")
                               )
                               )
                        ) # end fluidRow
                      ) # end fluidPage
           ),
           tabPanel("Packages",
                    fluidPage(
                        column(12,
                               wellPanel(
                                 h5("This shows a list of the R packages installed on the server, showing their version number. Only a subset of these are used in this application."),
                                 h5("Please contact the application author if you believe any of these should be updated."),
                                 DT::dataTableOutput("Packageslist")
                               ) # end of wellPanel
                        )
                              ) # end fluidPage
           ), # end of tabPanel Packages
           tabPanel("Source Code",
           fluidPage(
             column(12,
                    wellPanel(style = "background-color: #ffffff;",
                              includeMarkdown("Sourcecode.md")
                    ) # end of wellPanel
             )
           ) # end fluidPage
), # end of tabPanel Source code 
  
           tabPanel("Contact information",
                    fluidPage(
                      column(12,
                             wellPanel(style = "background-color: #ffffff;",
                                       span("To contact the author of this application with any questions, comments or feedback, please send an email to: "),
                                       em(
                                         a("info@claimsreserving.com", href = "mailto:info@claimsreserving.com"),
                                         span("")
                                       ),
                                       br()           
                             ) # end of wellPanel
                      )
                    ) # end fluidPage
           ) # end of tabPanel Contact information
           
           
           
                               )


# end navbar menu
                    
             
           
