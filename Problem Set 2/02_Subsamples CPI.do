clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code generates the data to replicate Figures 2-5 on Shin & Solon (2011, JPubE)
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

*cd "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

*global path "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

local varlist 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007

**************************************************************************
*********************** Create the sub-samples ***************************
**************************** for Figures *********************************
**************************************************************************

**************************************************************************
* 1) Relative change in real earnings (zeros and outliers excluded)

/*
"We use the CPI-U-RS to put earnings into real terms. Again we account for the mean effects of year, age, and cohort by estimating a separate regression each year of change in real earnings on a quadratic in age, and then proceed to study the residualized real earnings change. We rescale the residualized real earnings change between years t-2 and t into relative terms by dividing it by the simple average of the sample means of real earnings in the two years." (Shin & Solon, 2011 JPubE)
*/

clear
use "$path/Data/main_database.dta"


la var id "Individual Identification"
la var id_68 "1968 Interview Number"
la var age "Age of HH"
la var gender "Sex of HH"
la var wage "Wage Income"
la var acc_wage "Accuracy Wage"
la var inc "Total Labor Income"
la var acc_inc "Accuracy Labor Income"
la var farm "Farm Income"
la var acc_farm "Accuracy Farm Income"
la var bus "Business Income"
la var acc_bus "Accuracy Business Income"
la var relhd "Relationship with HH"

sort id wave

codebook id // I have 66,853 individuals
gen year = wave
order id year
xtset id year //Declare data to be panel
sort id year

// Add the CPI-U-RS
merge m:1 year using "$path/Data/Original Data/CPI.dta"
keep if _merge==3
drop _merge

// Keep only data of Survey Research Component of PSID
drop if id>3000000 //(1,312,278 observations deleted)
*drop if id_68 <3000 //(682,346 observations deleted)

replace relhd = 1 if relhd == 10
keep if relhd == 1
keep if gender == 1

*drop if age <= 25
*drop if age >= 59

drop if age < 25
drop if age > 59

keep if acc_bus  == 0 | acc_bus  == .
keep if acc_wage == 0 | acc_wage == .
keep if acc_inc   == 0 | acc_inc   == .
keep if acc_farm == 0 | acc_farm == .

// Generate measures of Income : Total labor income exluding farming and bussiness
gen totinc_net = .
replace totinc_net= inc if year > 1993
gen aux_farm=-1*farm
gen aux_bus=-1*bus
egen aux_totinc_net = rowtotal(inc aux_farm aux_bus)
replace totinc_net= aux_totinc_net if year>1993 & year>1976 
drop aux_*

// Generate measures of Income : Total labor income +Buss (excluding possitive farm income)
gen totinc_gross=.
replace totinc_gross= inc if year <=1993
egen aux_totinc_gross = rowtotal(inc bus farm) 
replace totinc_gross= aux_totinc_gross if year >1993 
drop aux_*
 
// Drop individuals who only appear once in survey
bys id: egen obs = count(year)
drop if obs == 1
*drop if obs == 2

// Drop individuals with weird age behavior
sort id year
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
//Gen wage accounting for CPI-U-RS
gen wage2= (wage/cpi)*100

// Keep if positive wages
keep if wage2 >0

// Drop percentiles
egen ptile = xtile(wage2), by(year) n(100)
*egen ptile2 = xtile(wage), by(year) n(100) // Usual as in the main database
tab ptile 
drop if ptile == 100
drop if ptile == 1

// Gen log wages

*gen logwage= ln(wage)
gen logwage= wage2
sort id year
bys id: gen ave_logwage = (logwage[_n] +logwage[_n-2])/2
bys id: gen gr_logwage = (logwage[_n] - logwage[_n-2])/ave_logwage

save "$path/Data/data_cleaned_pt5.dta",replace

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n ave_logwage cpi wage2
save "$path/Data/lu_unique_ids5.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt5.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n ave_logwage cpi wage2
tsset year 
tsfill, full
save "$path/Data/lu_unique_years5.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids5.dta"
save "$path/Data/year_id_shell5.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell5.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt5.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g ave_logwage_v2 = (logwage[_n] +logwage[_n-2])/2
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])/ ave_logwage_v2
  
order id year gr_logwage_v2  gr_logwage ave_logwage_v2 ave_logwage logwage
drop gr_logwage  
drop ave_logwage  
rename  gr_logwage_v2 gr_logwage
rename  ave_logwage_v2 ave_logwage
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final5.dta", replace 

erase "$path/Data/data_cleaned_pt5.dta"
erase "$path/Data/lu_unique_years5.dta"
erase "$path/Data/lu_unique_ids5.dta"
erase "$path/Data/year_id_shell5.dta"

************************* Collapse for plots *****************************

gen sd_resid = .
gen Resid =.

foreach y of local varlist{
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y'
qui: g aux1 = r(sd)
qui: replace sd_resid = aux1 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux aux1 yhat
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen mean_wage = mean(ave_logwage)
gen Resid_2 = Resid*ave_logwage/mean_wage
bys year: egen P90 = pctile(Resid_2),p(90)
bys year: egen P75 = pctile(Resid_2),p(75)
bys year: egen P50 = pctile(Resid_2),p(50)
bys year: egen P25 = pctile(Resid_2),p(25)
bys year: egen P10 = pctile(Resid_2),p(10)
 
gen p90_10 = (P90-P10)
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 
collapse (mean) p90_10_excluding=p90_10 (count) id (p90) P90_exclud = Resid (p75) P75_exclud=Resid (p50) P50_exclud=Resid (p25) P25_exclud=Resid (p10) P10_exclud=Resid (sd) sd_resid_exclud=Resid ,by(year)
save "$path/Data/Aux Data/Relative_change.dta",replace


**************************************************************************
* 2) Relative change in real earnings (zeros and outliers included)

/*
The same calculation described above with the dataset that includes zero earnings.
*/

clear
use "$path/Data/main_database.dta"


la var id "Individual Identification"
la var id_68 "1968 Interview Number"
la var age "Age of HH"
la var gender "Sex of HH"
la var wage "Wage Income"
la var acc_wage "Accuracy Wage"
la var inc "Total Labor Income"
la var acc_inc "Accuracy Labor Income"
la var farm "Farm Income"
la var acc_farm "Accuracy Farm Income"
la var bus "Business Income"
la var acc_bus "Accuracy Business Income"
la var relhd "Relationship with HH"

sort id wave

codebook id // I have 66,853 individuals
gen year = wave
order id year
xtset id year //Declare data to be panel
sort id year

// Add the CPI-U-RS
merge m:1 year using "$path/Data/Original Data/CPI.dta"
keep if _merge==3
drop _merge

// Keep only data of Survey Research Component of PSID
drop if id>3000000 //(1,312,278 observations deleted)
*drop if id_68 <3000 //(682,346 observations deleted)

replace relhd = 1 if relhd == 10
keep if relhd == 1
keep if gender == 1

*drop if age <= 25
*drop if age >= 59

drop if age < 25
drop if age > 59

keep if acc_bus  == 0 | acc_bus  == .
keep if acc_wage == 0 | acc_wage == .
keep if acc_inc   == 0 | acc_inc   == .
keep if acc_farm == 0 | acc_farm == .

// Generate measures of Income : Total labor income exluding farming and bussiness
gen totinc_net = .
replace totinc_net= inc if year > 1993
gen aux_farm=-1*farm
gen aux_bus=-1*bus
egen aux_totinc_net = rowtotal(inc aux_farm aux_bus)
replace totinc_net= aux_totinc_net if year<1994 & year>=1976 
drop aux_*

// Generate measures of Income : Total labor income +Buss (excluding possitive farm income)
gen totinc_gross=.
replace totinc_gross= inc if year <=1993
egen aux_totinc_gross = rowtotal(inc bus farm) 
replace totinc_gross= aux_totinc_gross if year >1993 
drop aux_*
 
// Drop individuals who only appear once in survey
bys id: egen obs = count(year)
drop if obs == 1
*drop if obs == 2

// Drop individuals with weird age behavior
sort id year
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
//Gen wage accounting for CPI-U-RS
gen wage2= (wage/cpi)*100

// Keep if positive wages
*keep if wage2 >0. // Include this time

// Drop percentiles // Include this time
egen ptile = xtile(wage2), by(year) n(100)
*egen ptile2 = xtile(wage), by(year) n(100) // Usual as in the main database
*tab ptile 
*drop if ptile == 100
*drop if ptile == 1

// Gen log wages

*gen logwage= ln(wage)
gen logwage= wage2
sort id year
bys id: gen ave_logwage = (logwage[_n] +logwage[_n-2])/2
bys id: gen gr_logwage = (logwage[_n] - logwage[_n-2])/ave_logwage

save "$path/Data/data_cleaned_pt6.dta",replace

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
save "$path/Data/lu_unique_ids6.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt6.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
tsset year 
tsfill, full
save "$path/Data/lu_unique_years6.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids6.dta"
save "$path/Data/year_id_shell6.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell6.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt6.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g ave_logwage_v2 = (logwage[_n] +logwage[_n-2])/2
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])/ ave_logwage_v2
 
order id year gr_logwage_v2  gr_logwage ave_logwage_v2 ave_logwage logwage
  
drop gr_logwage  
drop ave_logwage  
rename  gr_logwage_v2 gr_logwage
rename  ave_logwage_v2 ave_logwage
 
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final6.dta", replace 

erase "$path/Data/data_cleaned_pt6.dta"
erase "$path/Data/lu_unique_years6.dta"
erase "$path/Data/lu_unique_ids6.dta"
erase "$path/Data/year_id_shell6.dta"

************************* Collapse for plots *****************************

gen sd_resid = .
gen Resid =.

foreach y of local varlist{
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y'
qui: g aux1 = r(sd)
qui: replace sd_resid = aux1 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux aux1 yhat
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen mean_wage = mean(ave_logwage)
gen Resid_2 = Resid*ave_logwage/mean_wage
bys year: egen P90 = pctile(Resid_2),p(90)
bys year: egen P75 = pctile(Resid_2),p(75)
bys year: egen P50 = pctile(Resid_2),p(50)
bys year: egen P25 = pctile(Resid_2),p(25)
bys year: egen P10 = pctile(Resid_2),p(10)
 
gen p90_10 = (P90-P10)
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "

collapse (mean) p90_10_including=p90_10 (count) id (sd) sd_resid_includ=Resid_2 ,by(year)
save "$path/Data/Aux Data/Relative_change_Outliers.dta",replace

**************************************************************************
****************** Delete no longer need databases ***********************
**************************************************************************

erase "$path/Data/data_cleaned_final5.dta"
erase "$path/Data/data_cleaned_final6.dta"
