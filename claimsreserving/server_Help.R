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
###server code for Help
#Date: 1 October 2017
output$Helpcontent <-renderUI({
  helptopic<-input$radio_help
  if (helptopic==1){  #intro
    includeMarkdown("Intro.md")
  }
  else if (helptopic==2) {  #chain ladder
    includeMarkdown("CL_documentation.md")
  }
  else if (helptopic==3) {  #BF
    includeMarkdown("BF_documentation.md")
  }
  else if (helptopic==4) {  #Mack
    includeMarkdown("Mack_documentation.md")
  }
  else if (helptopic==5) {  #GLM
    includeMarkdown("GLM_documentation.md")
  }
  else if (helptopic==6) {  #CL Bootstrap
    includeMarkdown("CLBoot_documentation.md")
  }
  else if (helptopic==7) {  #MW
    includeMarkdown("MW_documentation.md")
  }
  else if (helptopic==8) {  #Aggregation
    includeMarkdown("Agg_documentation.md")
  }
})

output$Packageslist<-DT::renderDataTable({
  ip <- as.data.frame(installed.packages()[,c(1,3:4)])
  rownames(ip) <- NULL
  ip <- ip[is.na(ip$Priority),1:2,drop=FALSE]
  ip
}   
,extensions=c('Buttons'),selection='none',class = 'stripe compact',
options=list(dom='Bfrtip',buttons=list('copy','print',list(extend='collection',buttons=c('csv','excel','pdf'),text='Download'))
             ,scrollY=TRUE,scrollX=TRUE,ordering=FALSE,paging=FALSE,searching=FALSE,info=FALSE,
             columnDefs=list(list(className='dt-right',targets='_all'))))