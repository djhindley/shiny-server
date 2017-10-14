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
##libraries and overall variables set here
#Date: 1 October 2017
library(shiny)
library(ChainLadder)
library(markdown)
library(shinydashboard)
library("copula")  #load the copula package
library("distr")  #distribution library
library("scatterplot3d")  #scatterplot3d - not always needed
library("matrixcalc")
#library("actuar")  # removed this as seemed to cause problem with ChainLadder - not sure why, as worked before!
library("shinythemes")
library("shinyLP")
library("shinyBS")
library("shinyjs")
library("scales") # used for adding commas as separators for numbers
library("DT") # for fancy datatables
library("ggplot2")  #  for good graphs
Triangle_options<-c("Reserving book", "RAA", "UKMotor","MW2008","MW2014","GenIns")
options(shiny.sanitize.errors = TRUE)
#Special CSS for loading page.
appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"
