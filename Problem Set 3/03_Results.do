clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code Produces Figure 1 and Figure 2 of the paper and table 1
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

*********************Figure 1

use "$path/Data/data_collapse.dta", replace

keep if year <=2004

gen year_graph = year-1

gen P90_P10 = P90_hw-P_10_hw
gen P90_P50 = P90_hw-P50_hw
gen P50_P10 = P50_hw-P_10_hw

label var P90_P10 "Log 90/10 wage ratio"
label var P90_P50 "Log 90/50 wage ratio"
label var P50_P10 "Log 50/10 wage ratio"

graph drop _all

*For Male
twoway (line P90_P10 year_graph if sex==1), name(plot1) xlabel(1973(3)2003) ylabel(0.9(0.1)1.6) title("Overall Male 90/10 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P90_P50 year_graph if sex==1), name(plot2) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.85) title("Overall Male 90/50 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P50_P10 year_graph if sex==1), name(plot3) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.85) title("Overall Male 50/10 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")


*For Females
twoway (line P90_P10 year_graph if sex==2), name(plot4) xlabel( 1973(3)2003) ylabel(0.9(0.1)1.6) title("Overall Female 90/10 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P90_P50 year_graph if sex==2), name(plot5) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.85) title("Overall Female 90/50 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P50_P10 year_graph if sex==2), name(plot6) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.85) title("Overall Female 50/10 Hourly Wage Inequality") xlabel( 1976(3)2004) xtitle("")

graph combine plot1 plot4 plot2 plot5 plot3 plot6, title("Figure 1. Hourly wage inequality", size(small)) xsize(4) iscale(*0.5) col(2) 
graph export "$path/Plots/FIGURE1.pdf", replace


**********************Figure 2


gen P90_P10_r = P_90_hw_residual-P_10_hw_residual
gen P90_P50_r = P_90_hw_residual-P_50_hw_residual
gen P50_P10_r = P_50_hw_residual-P_10_hw_residual

label var P90_P10_r "Log 90/10 wage residual ratio"
label var P90_P50_r "Log 90/50 wage residual ratio"
label var P50_P10_r "Log 50/10 wage residual ratio" 

*For Male
twoway (line P90_P10_r year_graph if sex==1), name(plot1r) xlabel( 1973(3)2003) ylabel(0.85(0.1)1.25) title("Overall Male 90/10  Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P90_P50_r year_graph if sex==1), name(plot2r) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.65) title("Overall Male 90/50 Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P50_P10_r year_graph if sex==1), name(plot3r) xlabel( 1973(3)2003) ylabel(0.35(0.05)0.7) title("Overall Male 50/10 Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")


*For Females
twoway (line P90_P10_r year_graph if sex==2), name(plot4r) xlabel( 1973(3)2003) ylabel(0.85(0.1)1.25) title("Overall Female 90/10 Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P90_P50_r year_graph if sex==2), name(plot5r) xlabel( 1973(3)2003) ylabel(0.4(0.05)0.65) title("Overall Female 90/50 Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")

twoway (line P50_P10_r year_graph if sex==2), name(plot6r) xlabel( 1973(3)2003) ylabel(0.35(0.05)0.7) title("Overall Female 50/10 Hourly Residual Wage Inequality") xlabel( 1976(3)2004) xtitle("")

graph combine plot1r plot4r plot2r plot5r plot3r plot6r, title("Figure 2. Hourly residual wage inequality", size(small)) xsize(4) iscale(*0.5) col(2) 
graph export "$path/Plots/FIGURE2.pdf", replace

*For Table see Result_table1_with_table
*export excel using "Results_table1.xlsx", cell(B2) firstrow(variables) replace



***************************Question 3: Extending analysis to 2020  *******************************


use "$path/Data/data_collapse.dta", replace

gen year_graph = year-1

gen P90_P10 = P90_hw-P_10_hw
gen P90_P50 = P90_hw-P50_hw
gen P50_P10 = P50_hw-P_10_hw

label var P90_P10 "Log 90/10 wage ratio"
label var P90_P50 "Log 90/50 wage ratio"
label var P50_P10 "Log 50/10 wage ratio" 

graph drop _all

*For Male
twoway (line P90_P10 year_graph if sex==1), name(plot1) xlabel(1973(6)2021) ylabel(0.9(0.1)1.6) title("Overall Male 90/10 Hourly Wage Inequality")  xtitle("")

twoway (line P90_P50 year_graph if sex==1), name(plot2) xlabel(1973(6)2021) ylabel(0.4(0.05)0.85) title("Overall Male 90/50 Hourly Wage Inequality")  xtitle("")

twoway (line P50_P10 year_graph if sex==1), name(plot3) xlabel(1973(6)2021) ylabel(0.4(0.05)0.85) title("Overall Male 50/10 Hourly Wage Inequality") xtitle("")


*For Females
twoway (line P90_P10 year_graph if sex==2), name(plot4) xlabel(1973(6)2021) ylabel(0.9(0.1)1.6) title("Overall Female 90/10 Hourly Wage Inequality") xtitle("")

twoway (line P90_P50 year_graph if sex==2), name(plot5) xlabel(1973(6)2021) ylabel(0.4(0.05)0.85) title("Overall Female 90/50 Hourly Wage Inequality") xtitle("")

twoway (line P50_P10 year_graph if sex==2), name(plot6) xlabel(1973(6)2021) ylabel(0.4(0.05)0.85) title("Overall Female 50/10 Hourly Wage Inequality") xtitle("")

graph combine plot1 plot4 plot2 plot5 plot3 plot6, title("Figure 1. Hourly wage inequality (full sample)", size(small)) xsize(4) iscale(*0.5) col(2) 
graph export "$path/Plots/FIGURE1_extended.pdf", replace

**********************Figure 2


gen P90_P10_r = P_90_hw_residual-P_10_hw_residual
gen P90_P50_r = P_90_hw_residual-P_50_hw_residual
gen P50_P10_r = P_50_hw_residual-P_10_hw_residual

label var P90_P10_r "Log 90/10 wage residual ratio"
label var P90_P50_r "Log 90/50 wage residual ratio"
label var P50_P10_r "Log 50/10 wage residual ratio" 

*For Male
twoway (line P90_P10_r year_graph if sex==1), name(plot1r) xlabel(1973(6)2021) ylabel(0.85(0.1)1.25) title("Overall Male 90/10  Hourly Residual Wage Inequality") xtitle("")

twoway (line P90_P50_r year_graph if sex==1), name(plot2r) xlabel(1973(6)2021) ylabel(0.4(0.05)0.65) title("Overall Male 90/50 Hourly Residual Wage Inequality") xtitle("")

twoway (line P50_P10_r year_graph if sex==1), name(plot3r) xlabel(1973(6)2021) ylabel(0.35(0.05)0.7) title("Overall Male 50/10 Hourly Residual Wage Inequality") xtitle("")


*For Females
twoway (line P90_P10_r year_graph if sex==2), name(plot4r) xlabel(1973(6)2021) ylabel(0.85(0.1)1.25) title("Overall Female 90/10 Hourly Residual Wage Inequality") xtitle("")

twoway (line P90_P50_r year_graph if sex==2), name(plot5r) xlabel(1973(6)2021) ylabel(0.4(0.05)0.65) title("Overall Female 90/50 Hourly Residual Wage Inequality") xtitle("")

twoway (line P50_P10_r year_graph if sex==2), name(plot6r) xlabel(1973(6)2021) ylabel(0.35(0.05)0.7) title("Overall Female 50/10 Hourly Residual Wage Inequality") xtitle("")

graph combine plot1r plot4r plot2r plot5r plot3r plot6r, title("Figure 2. Hourly residual wage inequality (full sample)", size(small)) xsize(4) iscale(*0.5) col(2) 
graph export "$path/Plots/FIGURE2_extended.pdf", replace



