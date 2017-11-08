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
#Introduction menu item
#Date: 1 October 2017
tabPanel("",icon=icon("home"),
         #actionButton(inputId='ab1', label="Go to www.claimsreserving.com", 
            #  icon = icon("home"), onclick ="location.href='http://claimsreserving.com';"),
        # h2(icon("line-chart",class="fa-3x"), align="center"),
        
         jumbotron("GIRA - General Insurance Reserving Application", "An app' to accompany the book.",
                   buttonLabel = "Introduction"),
        tags$a(imageOutput("Book1"),href="https://goo.gl/A1Gzc2"),
         bsModal("modalExample", "", "tabBut", size = "large" ,
                 
                 includeMarkdown("Intro.md"),
                 span("Provide feedback via email to: "),
                 em(
                   a("info@claimsreserving.com", href = "mailto:info@claimsreserving.com"),
                   span("")
                 )
                 #br()
         ),  #close bsModal
         
        bsModal("Licensemodal", "", trigger="", size = "large" ,
                 
                 includeMarkdown("NoticeLicense.md"),
                 span("To contact the author of this application please send an email to: "),
                 em(
                   a("info@claimsreserving.com", href = "mailto:info@claimsreserving.com"),
                   span("")
                 )
                 #br()
         ) #close bsModal
)
         
    
