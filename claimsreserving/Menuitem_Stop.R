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
#Stop/Restart Menu item
#Date: 1 October 2017
navbarMenu("",icon=icon("power-off"),
           extendShinyjs(text = jsResetCode, functions=c("resetapp")),
           extendShinyjs(text = jscloseWindowCode, functions=c("closeWindow")),
           tabPanel(tags$a(id = "stop_menu", href = "#", class = "action-button",
                           list(icon("sign-out"), "Quit app'"))),
           tabPanel("Restart app'",icon = icon("refresh"),
                    uiOutput("Restartmenu")
                  )
           )


# end navbar menu
                    
             
           
