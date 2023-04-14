clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code solves QUESTION 2 on the Econ 8186: Homework #1
*Author: Johanna Torres Chain & Angelo Hermeto Mendes
*Class: Econ 8502: Wages and Employment, Applied Job Search Models

**************************************************************************

cd "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 1/"

*global path "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 1/"

run "00_Generate Data CPS.do"

*use "$path/Data/cps_rawdata.dta", clear
use "Data/cps_rawdata.dta", clear

**************************************************************************
************************* Create the sample ******************************
**************************************************************************

drop educ

keep if year==2012 
keep if age>=25 & age<=60 //Keep if age is between 25 and 60, inclusive.

//Drop individuals with missing data on incwage,usual weekly hours, weeks worked, age, education, and gender. Keep if state is missing.

drop if missing(incwage, uhrsworkly, wkswork1, age, educ99, sex)

//Note: uhrsworkly = 999 = NIU (Not in universe)

drop if incwage<2000 //Drop if INCWAGE is less than $2,000 (2012 dollars).

gen hwage=incwage/(wkswork1*uhrsworkly) //Hourly wage
gen y_hrswork = wkswork1*uhrsworkly // Annual hours

drop if hwage>500 //Drop if hourly wage > $500
drop if y_hrswork<50 //Drop if annual hours < 50 hrs

//Generate dummies/variables
tab sex, generate(gender)
drop gender2
rename gender1 gender //Male=1

gen educ=.
replace educ=1 if educ99<=09 //Less than highschool
replace educ=2 if educ99==10 //High school graduate
replace educ=3 if educ99>=11 & educ99<=14 //Some college
replace educ=4 if educ99==15 //College degree
replace educ=5 if educ99>=16 //Graduate education
drop educ99

save "Data/data_base.dta", replace

**************************************************************************
************************* Summary statistics *****************************
**************************************************************************

***************** For the raw data

use "Data/cps_rawdata.dta", clear

tabstat age wkswork1 uhrsworkly incwage  [aweight=asecwt] , stat(n mean median sd min max skewness kurtosis iqr)  col(stat) long 

asdoc tabstat age wkswork1 uhrsworkly incwage [aweight=asecwt], stat(N mean median sd min max skewness kurtosis iqr) col(stat) long save(summary_statistics.doc) title(Summary Statistics Raw Data) replace

asdoc tab educ99  [aweight=asecwt], save(summary_statistics.doc) fhr(\b) title(Educational Level label append nocf
asdoc tab sex  [aweight=asecwt],  save(summary_statistics.doc) fhr(\b) title(Gender) label append nocf

***************** For the clean data

use "Data/data_base.dta", clear

tabstat age wkswork1 uhrsworkly incwage  [aweight=asecwt] , stat(n mean median sd min max skewness kurtosis iqr)  col(stat) long 

asdoc tabstat age wkswork1 uhrsworkly incwage [aweight=asecwt], stat(N mean median sd min max skewness kurtosis iqr) col(stat) long save(summary_statistics2.doc) title(Summary Statistics Raw Data) replace

asdoc tab educ  [aweight=asecwt], save(summary_statistics2.doc) fhr(\b) title(Educational Level label append nocf
asdoc tab gender  [aweight=asecwt],  save(summary_statistics2.doc) fhr(\b) title(Gender) label append nocf

**************************************************************************
*********************** MINCER wage regression ***************************
**************************************************************************

* Dependent variable (log income)
gen y=ln(incwage)

* Regression:
svyset [pweight=asecwt]
svy: regress y i.age i.sex i.statefip i.educ

*Age Premium
scalar age_premium= _b[55.age]
display "The Seniority Gap is " age_premium 
//The Seniority Gap is .60273083
 
*Gender Gap
scalar gender_gap= -_b[2.sex]
display "The Gender Gap is " gender_gap
//The Gender Gap is .41574597
 
*College Premium
scalar college_premium=_b[4.educ]-_b[2.educ]
display "The college premium Gap is " college_premium
//The college premium Gap is .58384675
 
regress y i.statefip [aweight=asecwt]

*Average Incomes For Lowest and Highest States

*1) Lowest (Idaho)
scalar worst_state_log_wage=_b[16.statefip]+_b[_cons]
display "The mean log-wage of Idaho is " worst_state_log_wage

*2) Highest (DC)
scalar best_state_log_wage=_b[11.statefip]+_b[_cons]
display "The mean log-wage of DC is " best_state_log_wage

**************************************************************************
******************* Expanded MINCER wage regression **********************
**************************************************************************

regress y i.age i.educ i.sex i.age##i.educ i.sex##i.educ i.age#i.sex i.statefip [pweight=asecwt]

*1) Age Premium for gender and education level

**** Females
scalar high_school_female_age_prem=_b[55.age] + _b[55.age#2.sex] + _b[55.age#2.educ]
scalar some_college_female_age_prem=_b[55.age] + _b[55.age#2.sex] + _b[55.age#3.educ]
scalar college_female_age_prem=_b[55.age] + _b[55.age#2.sex] + _b[55.age#4.educ]
scalar grad_female_age_prem=_b[55.age] + _b[55.age#2.sex] + _b[55.age#5.educ]
scalar no_educ_female_age_prem=_b[55.age] + _b[55.age#2.sex]

display "The Seniority Gap for Women and No High Shool is "  no_educ_female_age_prem
display "The Seniority Gap for Women and High Shool is " high_school_female_age_prem
display "The Seniority Gap for Women and some College is " some_college_female_age_prem
display "The Seniority Gap for Women and College is " college_female_age_prem
display "The Seniority Gap for Women and Graduates is " grad_female_age_prem

**** Males
scalar high_school_male_age_prem=_b[55.age] + _b[55.age#2.educ]
scalar some_college_male_age_prem=_b[55.age] + _b[55.age#3.educ]
scalar college_male_age_prem=_b[55.age] + _b[55.age#4.educ]
scalar grad_male_age_prem=_b[55.age] + _b[55.age#5.educ]
scalar no_educ_male_age_prem=_b[55.age]

display "The Seniority Gap for Men and No High Shool is "  no_educ_male_age_prem
display "The Seniority Gap for Men and High Shool is " high_school_male_age_prem
display "The Seniority Gap for Men and some College is " some_college_male_age_prem
display "The Seniority Gap for Men and College is " college_male_age_prem
display "The Seniority Gap for Men and Graduates is " grad_male_age_prem

*2) Average gender gap and the gender gap for college graduates at ages 30, 40, and 50.

**** Average gender gap

regress y i.sex i.statefip  [pweight=asecwt]
scalar avg_gender_gap=-_b[2.sex]
display "The Average Gender Gap " avg_gender_gap

**** Gender gap for college graduates at ages 30, 40, and 50.

qui regress y i.age i.educ i.sex i.age##i.educ i.sex##i.educ i.age#i.sex i.statefip [pweight=asecwt]

scalar gender_gap_college_age_30= -_b[2.sex] -_b[30.age#2.sex] -_b[2.sex#4.educ]
scalar gender_gap_college_age_40= -_b[2.sex] -_b[40.age#2.sex] -_b[2.sex#4.educ]
scalar gender_gap_college_age_50= -_b[2.sex] -_b[50.age#2.sex] -_b[2.sex#4.educ]
	
display "The Gender Gap for College graduates at age 30 " gender_gap_college_age_30
display "The Gender Gap for College graduates at age 40 " gender_gap_college_age_40
display "The Gender Gap for College graduates at age 50 " gender_gap_college_age_50
	
*3) The college premium, separately for each gender, at age 45.

**** Females at the age of 45
scalar college_premium_female_age_45 =_b[4.educ]-_b[2.educ] +_b[45.age#4.educ]-_b[45.age#2.educ] + _b[2.sex#4.educ]-_b[2.sex#2.educ]

**** Males
scalar college_premium_male_age_45 =_b[4.educ]-_b[2.educ] +_b[45.age#4.educ]-_b[45.age#2.educ]
	
display "The Female College premium at age 45 " college_premium_female_age_45
display "The male College premium at age 45 "college_premium_male_age_45

*4) Name of the states with lowest and highes average log wage and the wage level in each (based on state dummy).

regress y i.statefip [aweight=asecwt]

*4.1) Lowest (Idaho)
scalar worst_state_avg_wage=exp(_b[16.statefip]+_b[_cons])
display "The mean wage of Idaho is " worst_state_avg_wage

*4.2) Highest (DC)
scalar best_state_avg_wage=exp(_b[11.statefip]+_b[_cons])
display "The mean wage of DC is " best_state_avg_wage

