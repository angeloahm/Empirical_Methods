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
* 1) Wages & Salaries

/*
Wages & Salaries: Take the log of the wage and salary income (wage) for both years, take the difference, regress on a quadratic in age, save the residuals, save the standard deviation of the residuals.
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
sort id year //Check1
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
// Keep if positive wages
keep if wage >0

// Drop percentiles
egen ptile = xtile(wage), by(year) n(100)
tab ptile 
drop if ptile == 100
drop if ptile == 1

// Gen log wages

gen logwage= ln(wage)
sort id year
bys id: gen gr_logwage = (logwage[_n] - logwage[_n-2]) 

save "$path/Data/data_cleaned_pt1.dta",replace

********************* Create the summary tables **************************

clear 
use "$path/Data/data_cleaned_pt1.dta"

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
save "$path/Data/lu_unique_ids.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt1.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
tsset year 
tsfill, full
save "$path/Data/lu_unique_years.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids.dta"
save "$path/Data/year_id_shell.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt1.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])
order id year gr_logwage_v2 gr_logwage logwage
  
drop gr_logwage  
rename  gr_logwage_v2 gr_logwage
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final.dta", replace 

erase "$path/Data/data_cleaned_pt1.dta"
erase "$path/Data/lu_unique_years.dta"
erase "$path/Data/lu_unique_ids.dta"
erase "$path/Data/year_id_shell.dta"

**************************************************************************
************************* Summary Statistics *****************************
**************************************************************************

tabstat age wage, stat(n mean median sd min max skewness kurtosis iqr)  col(stat) long  
asdoc tabstat age wage, stat(N mean median sd min max skewness kurtosis iqr) col(stat) long save(Summary Statistics.doc) title(Summary Statistics) replace

************************* Collapse for plots *****************************

gen sd_resid = .
gen Resid =.
gen skewness_resid =.
gen kurtosis_resid =.

foreach y of local varlist{
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y', detail
qui: g aux1 = r(sd)
qui: g aux2 = r(skewness)
qui: g aux3 = r(kurtosis)
qui: replace sd_resid = aux1 if year == `y'
qui: replace skewness_resid = aux2 if year == `y'
qui: replace kurtosis_resid = aux3 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux1 yhat aux2 aux3
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen mean_skewresid = mean(skewness_resid)
bys year: egen mean_kurtosisresid = mean(kurtosis_resid)
bys year: egen P90 = pctile(Resid),p(90)
bys year: egen P75 = pctile(Resid),p(75)
bys year: egen P50 = pctile(Resid),p(50)
bys year: egen P25 = pctile(Resid),p(25)
bys year: egen P10 = pctile(Resid),p(10)
 
gen p90_10 = P90-P10
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 

collapse (mean) mean_sdresid=sd_resid  p90_10 mean_skewresid mean_kurtosisresid (count) id (p90) P90 = Resid (p75) P75=Resid (p50) P50=Resid (p25) P25=Resid (p10) P10=Resid (sd) sd_resid=Resid ,by(year)
save "$path/Data/Aux Data/Wages_Salaries.dta",replace

**************************************************************************
* 2) Wages & salaries without controlling for age

/*
Wages & Salaries without controlling for age: Take the log of the wage and salary income (wage) for both years, take the difference, save the standard deviation of the difference.
*/

use "$path/Data/data_cleaned_final.dta", clear

************************* Collapse for plots *****************************

g sd_resid = .
g Resid =.

foreach y of local varlist {
qui: reg gr_logwage if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y'
qui: g aux1 = r(sd)
qui: replace sd_resid = aux1 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux aux1 yhat
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen P90 = pctile(Resid),p(90)
bys year: egen P75 = pctile(Resid),p(75)
bys year: egen P50 = pctile(Resid),p(50)
bys year: egen P25 = pctile(Resid),p(25)
bys year: egen P10 = pctile(Resid),p(10)
 
gen p90_10 = P90-P10
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 

collapse (mean) mean_sdresid_no_age_adjust=sd_resid,by(year)
save "$path/Data/Aux Data/Wages_Salaries_NoAge.dta",replace 

**************************************************************************
* 3) Wages & Salaries with ages 30-54

/*
Wages & Salaries with ages 30-54: Restrict the sample to the people at age in [30,54], and do the same as above.
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


// Keep only data of Survey Research Component of PSID
drop if id>3000000 //(1,312,278 observations deleted)
*drop if id_68 <3000 //(682,346 observations deleted)

replace relhd = 1 if relhd == 10
keep if relhd == 1
keep if gender == 1

drop if age < 30
drop if age > 54

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
sort id year //Check2
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
// Keep if positive wages
keep if wage >0

// Drop percentiles
egen ptile = xtile(wage), by(year) n(100)
tab ptile 
drop if ptile == 100
drop if ptile == 1

// Gen log wages

gen logwage= ln(wage)
sort id year
bys id: g gr_logwage = (logwage[_n] - logwage[_n-2]) 

save "$path/Data/data_cleaned_pt2.dta", replace

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
save "$path/Data/lu_unique_ids2.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt2.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
tsset year 
tsfill, full
save "$path/Data/lu_unique_years2.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids2.dta"
save "$path/Data/year_id_shell2.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell2.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt2.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])
order id year gr_logwage_v2 gr_logwage logwage
  
drop gr_logwage  
rename  gr_logwage_v2 gr_logwage
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final2.dta", replace 

erase "$path/Data/data_cleaned_pt2.dta"
erase "$path/Data/lu_unique_years2.dta"
erase "$path/Data/lu_unique_ids2.dta"
erase "$path/Data/year_id_shell2.dta"

************************* Collapse for plots *****************************

g sd_resid = .
g Resid =.
g skewness_resid =.
g kurtosis_resid =.

foreach y of local varlist {
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y', detail
qui: g aux1 = r(sd)
qui: g aux2 = r(skewness)
qui: g aux3 = r(kurtosis)
qui: replace sd_resid = aux1 if year == `y'
qui: replace skewness_resid = aux2 if year == `y'
qui: replace kurtosis_resid = aux3 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux1 yhat aux2 aux3
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen mean_skewresid = mean(skewness_resid)
bys year: egen mean_kurtosisresid = mean(kurtosis_resid)
bys year: egen P90 = pctile(Resid),p(90)
bys year: egen P75 = pctile(Resid),p(75)
bys year: egen P50 = pctile(Resid),p(50)
bys year: egen P25 = pctile(Resid),p(25)
bys year: egen P10 = pctile(Resid),p(10)
 
gen p90_10 = P90-P10
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 
collapse (mean) mean_sdresid_30_54=sd_resid skew_30_54=mean_skewresid   kurtosis_30_54=mean_kurtosisresid  ,by(year)
save "$path/Data/Aux Data/Wages_Salaries_3054.dta",replace 

**************************************************************************
* 4) Total Labor Income (Dynan et al.)

/*
Total Labor Income (Dynan et al.): Take the log of the total labor income (inc) for both years, take the difference, regress on a quadratic in age, save the residuals, save the standard deviation of the residuals.
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

tabstat inc, by(year)

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
sort id year //Check3
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
// Keep if positive total income
keep if totinc_gross >0

drop if farm>0 & year>1993

// Drop percentiles
egen ptile = xtile(totinc_gross), by(year) n(100)
tab ptile 
drop if ptile == 100
drop if ptile == 1

// Gen log total income

gen logwage= ln(totinc_gross)
sort id year
bys id: gen gr_logwage = (logwage[_n] - logwage[_n-2]) 

save "$path/Data/data_cleaned_pt3.dta",replace

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
save "$path/Data/lu_unique_ids3.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt3.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
tsset year 
tsfill, full
save "$path/Data/lu_unique_years3.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids3.dta"
save "$path/Data/year_id_shell3.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell3.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt3.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])
order id year gr_logwage_v2 gr_logwage logwage
  
drop gr_logwage  
rename  gr_logwage_v2 gr_logwage
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final3.dta", replace 

erase "$path/Data/data_cleaned_pt3.dta"
erase "$path/Data/lu_unique_years3.dta"
erase "$path/Data/lu_unique_ids3.dta"
erase "$path/Data/year_id_shell3.dta"

************************* Collapse for plots *****************************

use "$path/Data/data_cleaned_final3.dta", replace 
 
g sd_resid = .
g Resid =.
g skewness_resid =.
g kurtosis_resid =.

foreach y of local varlist {
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y', detail
qui: g aux1 = r(sd)
qui: g aux2 = r(skewness)
qui: g aux3 = r(kurtosis)
qui: replace sd_resid = aux1 if year == `y'
qui: replace skewness_resid = aux2 if year == `y'
qui: replace kurtosis_resid = aux3 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux1 yhat aux2 aux3
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen mean_skewresid = mean(skewness_resid)
bys year: egen mean_kurtosisresid = mean(kurtosis_resid)
bys year: egen P90 = pctile(Resid),p(90)
bys year: egen P75 = pctile(Resid),p(75)
bys year: egen P50 = pctile(Resid),p(50)
bys year: egen P25 = pctile(Resid),p(25)
bys year: egen P10 = pctile(Resid),p(10)
 
gen p90_10 = P90-P10
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 

collapse (mean) mean_sdresid_gross_income=mean_sdresid   skeness_total_income=mean_skewresid  kurtosis_total_income=mean_kurtosisresid   ,by(year)
save "$path/Data/Aux Data/Total_Labor_Income.dta",replace 

**************************************************************************
* 5) Total Labor Income excluding farm & business income

/*
Total Labor Income excluding farm & business income: Take the log of the Total Labor Income excluding farm & business income for both years, take the difference, regress on a quadratic in age, save the residuals, save the standard deviation of the residuals.
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
sort id year //Check4
bys id: gen diff_age = age[_n] - age[_n-1]
tab diff_age
drop if diff_age < 0
 
// Keep if positive total income
keep if totinc_net >0

*drop if inc >0 & year >1993

// Drop percentiles
egen ptile = xtile(totinc_net), by(year) n(100)
tab ptile 
drop if ptile == 100
drop if ptile == 1

// Gen log total income

gen logwage= ln(totinc_net)
sort id year
bys id: gen gr_logwage = (logwage[_n] - logwage[_n-2]) 

save "$path/Data/data_cleaned_pt4.dta",replace

// Unique List of IDs
bys id: gen n=_n
keep if n==1
drop year gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
save "$path/Data/lu_unique_ids4.dta", replace
 
// Unique List of Years 
clear
use "$path/Data/data_cleaned_pt4.dta"
bys year: gen n=_n
keep if n==1
drop id gr_logwage logwage wave age gender acc_bus farm acc_farm bus wage acc_wage inc acc_inc relhd obs diff_age ptile n
tsset year 
tsfill, full
save "$path/Data/lu_unique_years4.dta", replace

// Create Shell With All Potential ID/Year Combinations 
cross using "$path/Data/lu_unique_ids4.dta"
save "$path/Data/year_id_shell4.dta", replace

// Fix issues
clear 
use "$path/Data/year_id_shell4.dta"

// Join in Data from Previous Analysis:
merge 1:1  year id using "$path/Data/data_cleaned_pt4.dta"
 
// Create Labor Income Variable (as in Dynan et al.)
gen Dynan_labor_measurement=0
replace Dynan_labor_measurement=bus if year>1992
egen Dynan_labor_income=rowtotal(inc Dynan_labor_measurement)
bys id: gen gr_loglaborincome_v2 = (Dynan_labor_income[_n] - Dynan_labor_income[_n-2])
 
// Create New Field Pulling Wage From 2 Years Prior
order id year gr_logwage logwage
sort id year   
bys id: g gr_logwage_v2 = (logwage[_n] - logwage[_n-2])
order id year gr_logwage_v2 gr_logwage logwage
  
drop gr_logwage  
rename  gr_logwage_v2 gr_logwage
drop if gr_logwage == .
  
save "$path/Data/data_cleaned_final4.dta", replace 

erase "$path/Data/data_cleaned_pt4.dta"
erase "$path/Data/lu_unique_years4.dta"
erase "$path/Data/lu_unique_ids4.dta"
erase "$path/Data/year_id_shell4.dta"

************************* Collapse for plots *****************************

g sd_resid = .
g Resid =.

local varlist2 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1999 2001 2003 2005 2007

foreach y of local varlist2 {
*Base case
qui: reg gr_logwage age c.age#c.age if year == `y'
qui: predict yhat, resid
qui: su yhat if year == `y'
qui: g aux1 = r(sd)
qui: replace sd_resid = aux1 if year == `y'
qui: replace Resid = yhat if year == `y'
qui: drop aux aux1 yhat
}

bys year: egen mean_sdresid = mean(sd_resid)
bys year: egen P90 = pctile(Resid),p(90)
bys year: egen P75 = pctile(Resid),p(75)
bys year: egen P50 = pctile(Resid),p(50)
bys year: egen P25 = pctile(Resid),p(25)
bys year: egen P10 = pctile(Resid),p(10)
 
gen p90_10 = P90-P10
 
 	la var mean_sdresid "Sd of age-adjusted change in log wages"
 	la var P90 "P90 "
 	la var P75 "P75 "
    la var P50 "P50 "
 	la var P25 "P25 "
    la var P10 "P10 "
    la var p90_10 "P90_P10 "
 

collapse (mean) mean_sdresid_net_income=sd_resid,by(year)
save "$path/Data/Aux Data/Total_Net_Income.dta",replace 

**************************************************************************
****************** Delete no longer need databases ***********************
**************************************************************************

erase "$path/Data/data_cleaned_final2.dta"
erase "$path/Data/data_cleaned_final3.dta"
erase "$path/Data/data_cleaned_final4.dta"
