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
#This is the form for shinyapps that are in two files. Hence have ui <- and server <-
#####################################################################################
#Date: 1 October 2017
source("Preamble.R", local=TRUE)$value
header <- dashboardHeader(disable=TRUE)

sidebar <- dashboardSidebar(disable=TRUE)
jsResetCode <- "shinyjs.resetapp = function() {history.go(0);}" # Define the js method that resets the page
jscloseWindowCode<-"shinyjs.closeWindow = function() { window.close(); }" # define the js method that closes window (doesn't seem to work in Chrome or Safari though)
body<-dashboardBody(fluidPage
          (theme=shinytheme("cerulean"),
            useShinyjs(),
            inlineCSS(appCSS),
            # Loading message
            div(
              id = "loading-content",
              h2("Loading...")
            ),

            tags$style(type="text/css", "body {padding-top: 50px;}"),
            tags$head(HTML('<link rel="icon", href="favicon-line-chart.ico"/>')),
            div(style="padding: 1px 0px; width: '100%'",
                titlePanel(title="", windowTitle="Claims reserving")
            ),
              navbarPage("",position="fixed-top",collapsible = TRUE,
                        source("Menuitem_Intro.R", local=TRUE)$value, 
                        source("Menuitem_ChainLadder.R", local=TRUE)$value,
                        source("Menuitem_BF.R", local=TRUE)$value,
                        source("Menuitem_Mack.R", local=TRUE)$value,                
                        source("Menuitem_GLM.R", local=TRUE)$value,                            
                        source("Menuitem_CLBoot.R", local=TRUE)$value,                   
                        source("Menuitem_MW.R", local=TRUE)$value,                       
                        source("Menuitem_Agg.R", local=TRUE)$value,
                        source("Menuitem_Help.R", local=TRUE)$value,
                        source("Menuitem_Stop.R", local=TRUE)$value
                        ) # overall navbarPage closes 
             ) # fluidPage closes
                    ) # overall dashboard body, ending definition of UI
              
  
ui <- dashboardPage(header, sidebar, body)

