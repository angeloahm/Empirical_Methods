clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code solves XXXXXXXX on the Econ 8186: Homework #XXXXXX
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

cd "/Users/johanatch/Desktop/Homework 3/"

global path: pwd 
*global path "/Users/johanatch/Desktop/Homework 3/"

*run "01_Generate Data CPS.do"

use "$path/Data/cps_rawdata.dta", clear

**************************************************************************
************************* Clean the database *****************************
**************************************************************************

// Age between 16 to 64 during the earnings years
keep if age>=16 & age<=64

//Keep class of work in their longest job was private or goverment wage/salary 
*Varibale CLASSWLY: CLASSWLY specifies whether a person who worked during the previous calendar year was self-employed, an employee in private industry or the public sector, in the armed forces, or worked without pay in a family business or farm

keep if classwly >=20 & classwly<=28
gen private_sector=1 if classwly ==22
replace private_sector=0 if classwly >22

// Consolidate Education across waves
gen HS_dropout =.
gen HS=.
gen SCollege=.
gen College=.
gen Post_College=.  
gen year_of_educ=.  

replace HS_dropout=1 if educ>=002 & educ<070
replace HS=1 if educ>=070 & educ<080
replace SCollege=1 if educ>=080 & educ<110
replace College=1 if educ>=110 & educ<122
replace Post_College=1 if educ>=122 & educ<126


// Need to get year of experience

gen years_sch_j94 = .

gen white=1 if race ==100
replace white=2 if missing(white)


gen method1 = 0
replace method1 = 1 if year<=1991

replace years_sch_j94 = 0 if educ==002 & method1==1

replace years_sch_j94 = 1 if educ==011 & method1==1
replace years_sch_j94 = 2 if educ==012 & method1==1
replace years_sch_j94 = 3 if educ==013 & method1==1
replace years_sch_j94 = 4 if educ==014 & method1==1

replace years_sch_j94 = 5 if educ==021 & method1==1
replace years_sch_j94 = 6 if educ==022 & method1==1

replace years_sch_j94 = 7 if educ==031 & method1==1
replace years_sch_j94 = 8 if educ==032 & method1==1

replace years_sch_j94 = 9 if educ==040 & method1==1
replace years_sch_j94 = 10 if educ==050 & method1==1

replace years_sch_j94 = 11 if educ==060 & method1==1
replace years_sch_j94 = 12 if educ==072 & method1==1
replace years_sch_j94 = 12 if educ==073 & method1==1 //High school diploma

replace years_sch_j94 = 13 if educ==080 & method1==1
replace years_sch_j94 = 14 if educ==090 & method1==1

replace years_sch_j94 = 15 if educ==100 & method1==1
replace years_sch_j94 = 16 if educ==110 & method1==1
replace years_sch_j94 = 17 if educ==121 & method1==1
replace years_sch_j94 = 18 if educ==122 & method1==1

gen method2 = 0
replace method2 = 1 if year>1991 & year<=2022

*Male : white /  non-white
replace years_sch_j94 = 0.32 if educ==002 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 0.92 if educ==002 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 0.62 if educ==002 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 0 if educ==002 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 3.19 if educ==010 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 3.28 if educ==010 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 3.15 if educ==010 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 2.9 if educ==010 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 7.24 if educ==020 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 7.04 if educ==020 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 7.23 if educ==020 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 7.03 if educ==020 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 7.24 if educ==030 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 7.04 if educ==030 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 7.23 if educ==030 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 7.03 if educ==030 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 8.97 if educ==040 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 9.02 if educ==040 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 8.99 if educ==040 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 9.05 if educ==040 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 9.92 if educ==050 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 9.91 if educ==050 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 9.95 if educ==050 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 9.99 if educ==050 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 =10.86  if educ==060 & white ==1 & sex==1 & method2==1
replace years_sch_j94 =10.90  if educ==060 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 10.87 if educ==060 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 10.85 if educ==060 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 11.58 if educ==071 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 11.41 if educ==071 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 11.73 if educ==071 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 11.64 if educ==071 & white ==2 & sex==2 & method2==1
 
*Male : white /  non-white
replace years_sch_j94 =11.99  if educ==073 & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 11.98 if educ==073 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 12 if educ==073 & white ==1 & sex==2 & method2==1
replace years_sch_j94 =12  if educ==073 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 =13.48  if educ==081 & white ==1 & sex==1 & method2==1
replace years_sch_j94 =13.57  if educ==081 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 13.35 if educ==081 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 13.43 if educ==081 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 14.23 if educ==091  & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 14.33 if educ==091 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 14.22 if educ==091 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 14.33 if educ==091 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 14.23 if educ==092  & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 14.33 if educ==092 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 14.22 if educ==092 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 14.33 if educ==092 & white ==2 & sex==2 & method2==1


*Male : white /  non-white
replace years_sch_j94 =16.17  if educ==111  & white ==1 & sex==1 & method2==1
replace years_sch_j94 =16.13  if educ==111 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 16.15 if educ==111 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 16.04 if educ==111 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 =17.68 if educ== 123 & white ==1 & sex==1 & method2==1
replace years_sch_j94 =17.51  if educ==123 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 17.64 if educ==123 & white ==1 & sex==2 & method2==1
replace years_sch_j94 =17.69 if educ==123 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 =17.71 if educ== 124 & white ==1 & sex==1 & method2==1
replace years_sch_j94 =17.83  if educ==124 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 =17  if educ==124 & white ==1 & sex==2 & method2==1
replace years_sch_j94 =17.4 if educ==124 & white ==2 & sex==2 & method2==1

*Male : white /  non-white
replace years_sch_j94 = 17.83 if educ==125  & white ==1 & sex==1 & method2==1
replace years_sch_j94 = 18 if educ==125 & white ==2 & sex==1 & method2==1
*Female: white / Non-white
replace years_sch_j94 = 17.76 if educ==125 & white ==1 & sex==2 & method2==1
replace years_sch_j94 = 18 if educ==125 & white ==2 & sex==2 & method2==1

gen pot_exp = floor(age - years_sch_j94 - 6)

keep if pot_exp>=0 & pot_exp<=39

*Full time people according to census and more than 40 weeks

gen full_time_paper=1 if  wkswork1>=40 & fullpart==1
replace full_time_paper=0 if missing(full_time_paper)

*keep if full_time_paper==1

*Drop Allocated earnings
gen no_imputation=.

replace no_imputation =1 if qincwage==0 & year<=1987
replace no_imputation =1 if qoincwage==0 & qinclong==0 & year>1987

keep if no_imputation==1

*** Replace Topcode by 1.5 top code
gen top_code_inc=.
gen top_code_inc_1=.
gen top_code_inc_2=.


sort year
by year: egen maximun_wage = max(incwage)
by year: egen maximun_wage_1 = max(oincwage)
by year: egen maximun_wage_2 = max(inclongj)

replace top_code_inc =1 if incwage==maximun_wage & year<=1987
replace top_code_inc =0 if incwage<maximun_wage & year<=1987

replace top_code_inc_1 =1 if oincwage==maximun_wage_1 & year>1987
replace top_code_inc_1 =0 if oincwage<maximun_wage_1 & year>1987

replace top_code_inc_2 =1 if inclongj==maximun_wage_2 & year>1987
replace top_code_inc_2 =0 if inclongj<maximun_wage_2 & year>1987

*Assign Incomes
gen income_wage=.

replace income_wage =incwage if top_code_inc==0 & year<=1987
replace income_wage =incwage*1.5 if top_code_inc==1 & year<=1987


*Apply new variables : Top coding after 1988
gen income_wage_1=.
gen income_wage_2=.

replace income_wage_1 =oincwage if top_code_inc_1==0 & year>1987
replace income_wage_1 =oincwage*1.5 if top_code_inc_1==1 & year>1987
replace income_wage_2 =inclongj if top_code_inc_2==0 & year>1987
replace income_wage_2 =inclongj*1.5 if top_code_inc_2==1 & year>1987
replace income_wage= income_wage_1+income_wage_2 if year>1987


** Now define Hourly
gen total_hours = wkswork1* uhrsworkly
drop if total_hours==.

gen hourly_earnings= income_wage/total_hours
gen weekly_earnings= income_wage/wkswork1

*$2000 Dollars
gen real_hourly_earnings=hourly_earnings*cpi99*1.034126163
gen real_weekly_earnings=weekly_earnings*cpi99*1.034126163

*Final Drop

drop if real_weekly_earnings <=112
drop if real_hourly_earnings <=2.8

gen top_code_weekly_earnings = maximun_wage/52

drop if hourly_earnings > (1/35)*top_code_weekly_earnings

******************************* SAVE RELEVANT VARIABLES TO USE **********************************************
keep year serial cpsid asecflag asecwth pernum cpsidp asecwt age sex race HS_dropout HS SCollege College Post_College hourly_earnings weekly_earnings real_hourly_earnings real_weekly_earnings total_hours wkswork1 uhrsworkly pot_exp white years_sch_j94

save "$path/Data/clean_data.dta",replace

use "$path/Data/clean_data.dta",replace

tab year
*keep if year <=2004

* Weights

gen weight_hours = asecwt*total_hours
gen weight_full_time= asecwt*wkswork1

gen log_hourly_wage = ln(hourly_earnings)
gen log_weekly_wage = ln(weekly_earnings)

gen education_level=.
replace education_level = 0 if HS_dropout==1
replace education_level = 1 if HS==1
replace education_level = 2 if SCollege==1
replace education_level = 3 if College==1
replace education_level = 4 if Post_College==1

gen pot_exp_interval =.
local N = 13
forvalues i = 1 / `N' {
replace pot_exp_interval = `i' if pot_exp>=3*(`i'-1) & pot_exp<3*`i'
}

*Bechmark category?
replace pot_exp_interval=0 if missing(pot_exp_interval)


gen resid_hourly_earnings=.
local N = 2021
forvalues i = 1976 / `N' {
qui: reg log_hourly_wage i.education_level i.pot_exp_interval i.education_level#i.pot_exp_interval [iweight =weight_hours] if year==`i' & sex ==1
predict yhat,resid
qui: replace resid_hourly_earnings=yhat if year==`i' & sex==1

qui: reg log_hourly_wage i.education_level i.pot_exp_interval i.education_level#i.pot_exp_interval [iweight =weight_hours] if year==`i' & sex ==2
predict yhat2,resid
qui: replace resid_hourly_earnings=yhat2 if year==`i' & sex==2
qui: drop yhat yhat2
}

*Saving Data after regressions
save "$path/Data/data_to_use.dta",replace

collapse (p10) P_10_hw = log_hourly_wage P_10_hw_residual=resid_hourly_earnings  (p90) P90_hw= log_hourly_wage P_90_hw_residual=resid_hourly_earnings (p50) P50_hw=log_hourly_wage P_50_hw_residual=resid_hourly_earnings [iweight =weight_hours], by(year sex)

*We use this data to to all the analysis
*Saving Collapsed
save "$path/Data/data_collapse.dta", replace
