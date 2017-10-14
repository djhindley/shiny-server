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
###########################SERVER####################################################
#####################################################################################
#load the new version of Boot Chain Ladder
#this new version includes a progress bar
#Date: 1 October 2017
source("BootChain_new.R")
attach(loadNamespace("ChainLadder"), name = "ChainLadder_all")
server <- function(input, output, session) {
  
  ##########Things that apply generally go here
  Percent_values<-c(0.5,0.75,0.9,0.95,0.995,0.999)
  #note that CL Bootstrap percentile results table column headings will need changing if the above values change
  #Change GenIns cohort and development periods of GenIns so that they are as per reserving book
  GenIns2<-GenIns
  row.names(GenIns2)<-c(0,1,2,3,4,5,6,7,8,9)
  colnames(GenIns2)<-c(0,1,2,3,4,5,6,7,8,9)
  ##############################################
  
  toggleModal(session, "Licensemodal", toggle = "open")
  
  ##################################################################
  ################Chain Ladder######################################
  ##################################################################
  
  
  source("server_ChainLadder.R", local=TRUE)$value 
  
  ##################################################################
  ################BF######################################
  ##################################################################
  
  
  source("server_BF.R", local=TRUE)$value
  
  ##################################################################
  #############################Mack tab#############################
  ##################################################################
  
  source("server_Mack.R", local=TRUE)$value
  
        ############################################################
        #############################GLM tab########################
        ############################################################ 
        
  source("server_GLM.R", local=TRUE)$value
        
        ############################################################
        #############################CL Bootstrap###################
        ############################################################ 
        
  source("server_CLBoot.R", local=TRUE)$value    
        
  ##################################################################
  #############################MW###################################
  ##################################################################
  
  source("server_MW.R", local=TRUE)$value    
  
  ##################################################################
  ##################################Aggregate results section#######
  ##################################################################
        
  source("server_Agg.R", local=TRUE)$value    
  
  ####################################################################
  ########################Stop code###############################
  ####################################################################
  
  
  source("server_Stop.R", local=TRUE)$value
  
  ####################################################################
  ########################Help code###############################
  ####################################################################
  
  
  source("server_Help.R", local=TRUE)$value
  
  hide(id = "loading-content", anim = TRUE, animType = "fade")

}      #end the server stuff
    

