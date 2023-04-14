clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code generates the data and subsamples to replicate Figures 2-5 on Shin & Solon (2011, JPubE)
*It also creates data and plots for Question C and D in homework 2
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

cd "/Users/johanatch/Desktop/Homework 4"

pwd

global path : pwd

**************************************************************************
************************* Create the sample ******************************
**************************************************************************

run "01_Generate Data.do" // Generates the data from the PSID

**************************************************************************
************************** Data for Figures ******************************
**************************************************************************

run "02_Subsample.do" // 
						
