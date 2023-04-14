clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code generates the data and subsamples to replicate Figures 2-5 on Shin & Solon (2011, JPubE)
*It also creates data and plots for Question C and D in homework 2
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

*cd "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2/"

pwd

*global path "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

global path : pwd

**************************************************************************
************************* Create the sample ******************************
**************************************************************************

run "01_Generate Data.do" // Generates the data from the PSID

**************************************************************************
************************** Data for Figures ******************************
**************************************************************************

run "02_Subsamples.do" // Generates the subsamples to replicate Figures 2 and 3. 
						// Also the generates the results for Question C.
						
run "02_Subsamples CPI.do" // Generates the subsamples to replicate Figures 4 and 5. 

run "02_Subsamples Question D.do" // Generates the results for Question D.

**************************************************************************
******************************* Plots ************************************
**************************************************************************

run "03_Plots.do" // Generates the plots for the solutions
