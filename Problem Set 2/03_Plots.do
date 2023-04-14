clear
set more off
*set scheme plotplain, permanently
set scheme s2color
grstyle init
grstyle set ci
grstyle set mesh, horizontal compact minor

**************************************************************************

*This code replicates the Figures 2-5 on Shin & Solon (2011, JPubE)
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

*cd "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

*global path "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

**************************************************************************
******************************* Figure 2 *********************************
**************************************************************************

clear
use "$path/Data/Aux Data/Wages_Salaries.dta", replace

merge 1:1  year using "$path/Data/Aux Data/Wages_Salaries_3054.dta"
drop _merge

merge 1:1  year using "$path/Data/Aux Data/Wages_Salaries_NoAge.dta"
drop _merge

merge 1:1  year using "$path/Data/Aux Data/Total_Labor_Income.dta"
drop _merge

merge 1:1  year using "$path/Data/Aux Data/Total_Net_Income.dta"
drop _merge

gen year_data =  year - 1

twoway (line mean_sdresid year_data, lcolor(magenta)) (line mean_sdresid_30_54 year_data, lcolor(maroon)) (line mean_sdresid_no_age_adjust year_data, lcolor(blue)) (line mean_sdresid_gross_income year_data, lcolor(green)) (line mean_sdresid_net_income year_data, lcolor(black)), title("Standard deviation of age-adjusted change in log earnings with various earnings measures", size(small)) xlabel(1971(3)2007) ylabel(0.2(0.05)0.65) legend(order(1 "wages & salaries" 2 "wages & salaries with ages 30-54"  3 "wages & salaries without controlling for age" 4 "total labor income (Dynan et al.)" 5 "total labor income excluding farm & business income")) legend(size(vsmall)) ytitle("") xtitle("") 

graph export "$path/Plots/Figure 2.pdf",replace

**************************************************************************
******************************* Figure 3 *********************************
**************************************************************************

twoway (line P90 year_data, lcolor(dknavy)) (line P75 year_data, lcolor(magenta)) (line P50 year_data, lcolor(black)) (line P25 year_data, lcolor(eltblue)) (line P10 year_data, lcolor(purple)), title("Quantiles of age-adjusted change in log earnings, 1969–1971 to 2004–2006", size(small)) xlabel(1971(3)2006) ylabel(-0.5(0.1)0.5) legend(order(1 "P90" 2 "P75"  3 "median" 4 "P25" 5 "P10")) ytitle("") xtitle("") 
graph export "$path/Plots/Figure 3.pdf",replace

**************************************************************************
******************************* Figure 4 *********************************
**************************************************************************

clear
use "$path/Data/Aux Data/Wages_Salaries.dta", replace

merge 1:1  year using "$path/Data/Aux Data/Relative_change.dta"
drop _merge

merge 1:1  year using "$path/Data/Aux Data/Relative_change_Outliers.dta"
drop _merge

gen year_data =  year - 1


twoway (line p90_10 year_data)(line p90_10_excluding year_data) (line p90_10_including year_data), title("90–10 differences in various measures of earnings change", size(small)) xlabel(1971(3)2006) ylabel(0.45(0.1)1.15) legend(order(1 "change in log earnings" 2 "relative change in real earnings (zeros and outliers excluded)" 3 "relative change in real earnings (zeros and outliers included)")) legend(size(*0.6)) ytitle("") xtitle("") 
graph export "$path/Plots/Figure 4.pdf",replace

**************************************************************************
******************************* Figure 5 *********************************
**************************************************************************

twoway (line P90_exclud year_data)(line P75_exclud year_data)(line P50_exclud year_data)(line P25_exclud year_data)(line P10_exclud year_data),title("Quantiles of relative age-adjusted change in real earnings (zeros and outliers excluded), 1969–1971 to 2004–2006", size(small)) xlabel( 1971(3)2006) ylabel(-0.5(0.1)0.5) legend(order(1 "P90" 2 "P75"  3 "median" 4 "P25" 5 "P10"))  ytitle("") xtitle("") 
graph export "$path/Plots/Figure 5.pdf",replace

**************************************************************************
***************************** Question C *********************************
**************************************************************************
/*
Plot the skewness and kurtosis (3rd and 4th cen-tralized moments) of earnings change measure over time using 3 measures: wages & salaries, wages & salaries for 30-54, total labor income.
*/

clear
use "$path/Data/Aux Data/Wages_Salaries.dta",replace
merge 1:1  year using "$path/Data/Aux Data/Wages_Salaries_3054.dta"
drop _merge
merge 1:1  year using "$path/Data/Aux Data/Total_Labor_Income.dta"
drop _merge

gen year_data =  year - 1

twoway (line mean_skewresid year_data) (line skew_30_54 year_data) (line skeness_total_income year_data),title("Skeness") xlabel( 1971(3)2006) legend(order(1 "wages & salaries" 2 "wages & salaries with ages 30-54" 3 "total labor income")) ytitle("") xtitle("") 
graph export "$path/Plots/QuestionC_Skewness.pdf",replace

twoway (line mean_kurtosisresid year_data)(line kurtosis_30_54 year_data) (line kurtosis_total_income year_data),title("Kurtosis") xlabel( 1971(3)2006) legend(order(1 "wages & salaries" 2 "wages & salaries with ages 30-54" 3 "total labor income")) ytitle("") xtitle("") 
graph export "$path/Plots/QuestionC_Kurtosis.pdf",replace


**************************************************************************
***************************** Question D *********************************
**************************************************************************

clear
use "$path/Data/Aux Data/Wages_Salaries_QuestionD.dta", replace

merge 1:1  year using "$path/Data/Aux Data/Wages_Salaries_3054_QuestionD.dta"
drop _merge

merge 1:1  year using "$path/Data/Aux Data/Total_Labor_Income_QuestionD.dta"
drop _merge

gen year_data =  year - 1


twoway (line mean_skewresid_growth_drop year_data)(line skew_30_54_Q_d year_data)(line skeness_total_income_Q_d year_data),title("Skewness") xlabel( 1971(3)2006) legend(order(1 "wages & salaries" 2 "wages & salaries with ages 30-54" 3 "total labor income" )) ytitle("") xtitle("") 
graph export "$path/Plots/QuestionD_Skewness.pdf",replace

twoway (line mean_kurtosisresid_growth_drop year_data) (line kurtosis_30_54_Q_d year_data) (line kurtosis_total_income_Q_d year_data),title("Kurtosis") xlabel( 1971(3)2006) legend(order(1 "wages & salaries" 2 "wages & salaries with ages 30-54" 3 "total labor income" )) ytitle("") xtitle("") 
graph export "$path/Plots/QuestionD_Kurtosis.pdf",replace


// Do you see any noticeable difference in skewness and kurtosis graphs for any of the 3 earnings measures?

clear
use "$path/Data/Aux Data/Wages_Salaries.dta", replace
merge 1:1  year using "$path/Data/Aux Data/Wages_Salaries_QuestionD.dta"
drop _merge

gen year_data =  year - 1

twoway (line mean_skewresid year_data) (line mean_skewresid_growth_drop year_data) ,title("Skewness: Wages") xlabel( 1971(3)2006) legend(order(1 "wages & salaries - Solon & Shin (2011)" 2 "wages & salaries - excluding as suggested")) legend(size(*0.8)) ytitle("") xtitle("")
graph export "$path/Plots/QuestionD_Skewness_Comparison.pdf",replace

twoway (line mean_kurtosisresid year_data) (line mean_kurtosisresid_growth_drop year_data) ,title("Kurtosis: Wages") xlabel( 1971(3)2006) legend(order(1 "wages & salaries - Solon & Shin (2011)" 2 "wages & salaries - excluding as suggested")) legend(size(*0.8)) ytitle("") xtitle("")
graph export "$path/Plots/QuestionD_Kurtosis_Comparison.pdf",replace

 