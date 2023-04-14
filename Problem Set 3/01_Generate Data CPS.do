clear
set more off

cd "/Users/johanatch/Desktop/Homework 3/"

global path: pwd 
*global path "/Users/johanatch/Desktop/Homework 3/"

* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix                   ///
  int     year         1-4      ///
  long    serial       5-9      ///
  byte    month        10-11    ///
  double  cpsid        12-25    ///
  byte    asecflag     26-26    ///
  byte    hflag        27-27    ///
  double  asecwth      28-38    ///
  double  cpi99        39-42    ///
  double  hhincome     43-50    ///
  byte    pernum       51-52    ///
  double  cpsidp       53-66    ///
  double  asecwt       67-77    ///
  byte    age          78-79    ///
  byte    sex          80-80    ///
  int     race         81-83    ///
  byte    qage         84-85    ///
  byte    qsex         86-87    ///
  byte    qrace        88-89    ///
  byte    classwkr     90-91    ///
  int     ahrsworkt    92-94    ///
  byte    wkstat       95-96    ///
  byte    qclasswk     97-97    ///
  byte    qahrsworkt   98-99    ///
  int     educ         100-102  ///
  byte    educ99       103-104  ///
  byte    qeduc        105-106  ///
  byte    classwly     107-108  ///
  byte    wkswork1     109-110  ///
  int     uhrsworkly   111-113  ///
  byte    fullpart     114-114  ///
  byte    qclasswl     115-115  ///
  byte    quhrsworkly  116-116  ///
  byte    qwkswork     117-117  ///
  double  inctot       118-126  ///
  double  incwage      127-134  ///
  double  inclongj     135-142  ///
  double  oincwage     143-150  ///
  byte    qearnwee     151-151  ///
  byte    qinclong     152-152  ///
  byte    qinclongd    153-154  ///
  byte    qoincwage    155-155  ///
  byte    qoincwaged   156-157  ///
  byte    qincwage     158-158  ///
  byte    tinclongj    159-159  ///
  byte    toincwage    160-160  ///
  double  hourwage     161-165  ///
  double  earnweek     166-173  ///
  byte    qhourwag     174-174  ///
  using `"Data/cps_00006.dat"'

replace asecwth     = asecwth     / 10000
replace cpi99       = cpi99       / 1000
replace asecwt      = asecwt      / 10000
replace hourwage    = hourwage    / 100
replace earnweek    = earnweek    / 100

format cpsid       %14.0f
format asecwth     %11.4f
format cpi99       %4.3f
format hhincome    %8.0f
format cpsidp      %14.0f
format asecwt      %11.4f
format inctot      %9.0f
format incwage     %8.0f
format inclongj    %8.0f
format oincwage    %8.0f
format hourwage    %5.2f
format earnweek    %8.2f

label var year        `"Survey year"'
label var serial      `"Household serial number"'
label var month       `"Month"'
label var cpsid       `"CPSID, household record"'
label var asecflag    `"Flag for ASEC"'
label var hflag       `"Flag for the 3/8 file 2014"'
label var asecwth     `"Annual Social and Economic Supplement Household weight"'
label var cpi99       `"CPI-U adjustment factor to 1999 dollars"'
label var hhincome    `"Total household income"'
label var pernum      `"Person number in sample unit"'
label var cpsidp      `"CPSID, person record"'
label var asecwt      `"Annual Social and Economic Supplement Weight"'
label var age         `"Age"'
label var sex         `"Sex"'
label var race        `"Race"'
label var qage        `"Data quality flag for AGE"'
label var qsex        `"Data quality flag for SEX"'
label var qrace       `"Data quality flag for RACE"'
label var classwkr    `"Class of worker "'
label var ahrsworkt   `"Hours worked last week"'
label var wkstat      `"Full or part time status"'
label var qclasswk    `"Data quality flag for CLASSWKR"'
label var qahrsworkt  `"Data quality flag for AHRSWORKT"'
label var educ        `"Educational attainment recode"'
label var educ99      `"Educational attainment, 1990"'
label var qeduc       `"Data quality flag for EDUC"'
label var classwly    `"Class of worker last year"'
label var wkswork1    `"Weeks worked last year"'
label var uhrsworkly  `"Usual hours worked per week (last yr)"'
label var fullpart    `"Worked full or part time last year"'
label var qclasswl    `"Data quality flag for CLASSWLY"'
label var quhrsworkly `"Data quality flag for UHRSWORKLY"'
label var qwkswork    `"Data quality flag for WKSWORK1 and WKSWORK2"'
label var inctot      `"Total personal income"'
label var incwage     `"Wage and salary income"'
label var inclongj    `"Earnings from longest job"'
label var oincwage    `"Earnings from other work included wage and salary earnings"'
label var qearnwee    `"Data quality flag for EARNWEEK"'
label var qinclong    `"Data quality flag for INCLONGJ [general version]"'
label var qinclongd   `"Data quality flag for INCLONGJ [detailed version]"'
label var qoincwage   `"Data quality flag for OINCWAGE [general version]"'
label var qoincwaged  `"Data quality flag for OINCWAGE [detailed version]"'
label var qincwage    `"Data quality flag for INCWAGE"'
label var tinclongj   `"Topcode Flag for INCLONGJ"'
label var toincwage   `"Topcode Flag for OINCWAGE"'
label var hourwage    `"Hourly wage"'
label var earnweek    `"Weekly earnings"'
label var qhourwag    `"Data quality flag for HOURWAGE"'

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define asecflag_lbl 1 `"ASEC"'
label define asecflag_lbl 2 `"March Basic"', add
label values asecflag asecflag_lbl

label define hflag_lbl 0 `"5/8 file"'
label define hflag_lbl 1 `"3/8 file"', add
label values hflag hflag_lbl

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"NIU"', add
label values sex sex_lbl

label define race_lbl 100 `"White"'
label define race_lbl 200 `"Black"', add
label define race_lbl 300 `"American Indian/Aleut/Eskimo"', add
label define race_lbl 650 `"Asian or Pacific Islander"', add
label define race_lbl 651 `"Asian only"', add
label define race_lbl 652 `"Hawaiian/Pacific Islander only"', add
label define race_lbl 700 `"Other (single) race, n.e.c."', add
label define race_lbl 801 `"White-Black"', add
label define race_lbl 802 `"White-American Indian"', add
label define race_lbl 803 `"White-Asian"', add
label define race_lbl 804 `"White-Hawaiian/Pacific Islander"', add
label define race_lbl 805 `"Black-American Indian"', add
label define race_lbl 806 `"Black-Asian"', add
label define race_lbl 807 `"Black-Hawaiian/Pacific Islander"', add
label define race_lbl 808 `"American Indian-Asian"', add
label define race_lbl 809 `"Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 810 `"White-Black-American Indian"', add
label define race_lbl 811 `"White-Black-Asian"', add
label define race_lbl 812 `"White-American Indian-Asian"', add
label define race_lbl 813 `"White-Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 814 `"White-Black-American Indian-Asian"', add
label define race_lbl 815 `"American Indian-Hawaiian/Pacific Islander"', add
label define race_lbl 816 `"White-Black--Hawaiian/Pacific Islander"', add
label define race_lbl 817 `"White-American Indian-Hawaiian/Pacific Islander"', add
label define race_lbl 818 `"Black-American Indian-Asian"', add
label define race_lbl 819 `"White-American Indian-Asian-Hawaiian/Pacific Islander"', add
label define race_lbl 820 `"Two or three races, unspecified"', add
label define race_lbl 830 `"Four or five races, unspecified"', add
label define race_lbl 999 `"Blank"', add
label values race race_lbl

label define qage_lbl 00 `"No change"'
label define qage_lbl 01 `"Blank to value"', add
label define qage_lbl 02 `"Value to value"', add
label define qage_lbl 03 `"Allocated"', add
label define qage_lbl 04 `"Value to allocated value"', add
label define qage_lbl 05 `"Blank to allocated value"', add
label define qage_lbl 06 `"Don't know to allocated value"', add
label define qage_lbl 07 `"Refused to allocated value"', add
label define qage_lbl 08 `"Blank to longitudinal value"', add
label define qage_lbl 09 `"Don't know to longitudinal value"', add
label define qage_lbl 10 `"Refused to longitudinal value"', add
label values qage qage_lbl

label define qsex_lbl 00 `"No change"'
label define qsex_lbl 01 `"Blank to value"', add
label define qsex_lbl 02 `"Value to value"', add
label define qsex_lbl 03 `"Allocated"', add
label define qsex_lbl 04 `"Don't know to value"', add
label define qsex_lbl 05 `"Refused to value"', add
label define qsex_lbl 06 `"Blank to allocated value"', add
label define qsex_lbl 07 `"Don't know to allocated value"', add
label define qsex_lbl 08 `"Refused to allocated value"', add
label define qsex_lbl 09 `"Blank to longitudinal value"', add
label define qsex_lbl 10 `"Don't know to longitudinal value"', add
label define qsex_lbl 11 `"Refused to longitudinal value"', add
label define qsex_lbl 12 `"Allocated by IPUMS"', add
label values qsex qsex_lbl

label define qrace_lbl 00 `"No change / not allocated"'
label define qrace_lbl 04 `"Allocated-no method specified"', add
label define qrace_lbl 10 `"Value to value"', add
label define qrace_lbl 11 `"Blank to value"', add
label define qrace_lbl 12 `"Don't know to value"', add
label define qrace_lbl 13 `"Refused to value"', add
label define qrace_lbl 20 `"Value to longitudinal value"', add
label define qrace_lbl 21 `"Blank to longitudinal value"', add
label define qrace_lbl 22 `"Don't know to longitudinal value"', add
label define qrace_lbl 23 `"Refused to longitudinal value"', add
label define qrace_lbl 30 `"Value to allocated value long"', add
label define qrace_lbl 31 `"Blank to allocated value long"', add
label define qrace_lbl 32 `"Don't know to allocated value long"', add
label define qrace_lbl 33 `"Refused to allocated value long"', add
label define qrace_lbl 40 `"Value to allocated value"', add
label define qrace_lbl 41 `"Blank to allocated value"', add
label define qrace_lbl 42 `"Don't know to allocated value"', add
label define qrace_lbl 43 `"Refused to allocated value"', add
label define qrace_lbl 50 `"Value to blank"', add
label define qrace_lbl 52 `"Don't know to blank"', add
label define qrace_lbl 53 `"Refused to blank"', add
label values qrace qrace_lbl

label define classwkr_lbl 00 `"NIU"'
label define classwkr_lbl 10 `"Self-employed"', add
label define classwkr_lbl 13 `"Self-employed, not incorporated"', add
label define classwkr_lbl 14 `"Self-employed, incorporated"', add
label define classwkr_lbl 20 `"Works for wages or salary"', add
label define classwkr_lbl 21 `"Wage/salary, private"', add
label define classwkr_lbl 22 `"Private, for profit"', add
label define classwkr_lbl 23 `"Private, nonprofit"', add
label define classwkr_lbl 24 `"Wage/salary, government"', add
label define classwkr_lbl 25 `"Federal government employee"', add
label define classwkr_lbl 26 `"Armed forces"', add
label define classwkr_lbl 27 `"State government employee"', add
label define classwkr_lbl 28 `"Local government employee"', add
label define classwkr_lbl 29 `"Unpaid family worker"', add
label define classwkr_lbl 99 `"Missing/Unknown"', add
label values classwkr classwkr_lbl

label define wkstat_lbl 10 `"Full-time schedules"'
label define wkstat_lbl 11 `"Full-time hours (35+), usually full-time"', add
label define wkstat_lbl 12 `"Part-time for non-economic reasons, usually full-time"', add
label define wkstat_lbl 13 `"Not at work, usually full-time"', add
label define wkstat_lbl 14 `"Full-time hours, usually part-time for economic reasons"', add
label define wkstat_lbl 15 `"Full-time hours, usually part-time for non-economic reasons"', add
label define wkstat_lbl 20 `"Part-time for economic reasons"', add
label define wkstat_lbl 21 `"Part-time for economic reasons, usually full-time"', add
label define wkstat_lbl 22 `"Part-time hours, usually part-time for economic reasons"', add
label define wkstat_lbl 40 `"Part-time for non-economic reasons, usually part-time"', add
label define wkstat_lbl 41 `"Part-time hours, usually part-time for non-economic reasons"', add
label define wkstat_lbl 42 `"Not at work, usually part-time"', add
label define wkstat_lbl 50 `"Unemployed, seeking full-time work"', add
label define wkstat_lbl 60 `"Unemployed, seeking part-time work"', add
label define wkstat_lbl 99 `"NIU, blank, or not in labor force"', add
label values wkstat wkstat_lbl

label define qclasswk_lbl 0 `"No change or children or armed forces"'
label define qclasswk_lbl 1 `"Value to blank"', add
label define qclasswk_lbl 2 `"Blank to value"', add
label define qclasswk_lbl 3 `"Value to value"', add
label define qclasswk_lbl 4 `"Allocated"', add
label define qclasswk_lbl 5 `"Value to allocated value"', add
label define qclasswk_lbl 6 `"Blank to allocated value"', add
label define qclasswk_lbl 7 `"Value to longitudinal value"', add
label define qclasswk_lbl 8 `"Blank to longitudinal value"', add
label values qclasswk qclasswk_lbl

label define qahrsworkt_lbl 00 `"No change or children or armed forces"'
label define qahrsworkt_lbl 04 `"Allocated - no method specified"', add
label define qahrsworkt_lbl 10 `"Value to value"', add
label define qahrsworkt_lbl 11 `"Blank to value"', add
label define qahrsworkt_lbl 12 `"Don't know to value"', add
label define qahrsworkt_lbl 13 `"Refused to value"', add
label define qahrsworkt_lbl 21 `"Blank to longitudinal value"', add
label define qahrsworkt_lbl 22 `"Don't know to longitudinal value"', add
label define qahrsworkt_lbl 23 `"Refused to longitudinal value"', add
label define qahrsworkt_lbl 40 `"Value to allocated value"', add
label define qahrsworkt_lbl 41 `"Blank to allocated value"', add
label define qahrsworkt_lbl 42 `"Don't know to allocated value"', add
label define qahrsworkt_lbl 43 `"Refused to allocated value"', add
label define qahrsworkt_lbl 50 `"Value to blank"', add
label define qahrsworkt_lbl 52 `"Don't know to blank"', add
label values qahrsworkt qahrsworkt_lbl

label define educ_lbl 000 `"NIU or no schooling"'
label define educ_lbl 001 `"NIU or blank"', add
label define educ_lbl 002 `"None or preschool"', add
label define educ_lbl 010 `"Grades 1, 2, 3, or 4"', add
label define educ_lbl 011 `"Grade 1"', add
label define educ_lbl 012 `"Grade 2"', add
label define educ_lbl 013 `"Grade 3"', add
label define educ_lbl 014 `"Grade 4"', add
label define educ_lbl 020 `"Grades 5 or 6"', add
label define educ_lbl 021 `"Grade 5"', add
label define educ_lbl 022 `"Grade 6"', add
label define educ_lbl 030 `"Grades 7 or 8"', add
label define educ_lbl 031 `"Grade 7"', add
label define educ_lbl 032 `"Grade 8"', add
label define educ_lbl 040 `"Grade 9"', add
label define educ_lbl 050 `"Grade 10"', add
label define educ_lbl 060 `"Grade 11"', add
label define educ_lbl 070 `"Grade 12"', add
label define educ_lbl 071 `"12th grade, no diploma"', add
label define educ_lbl 072 `"12th grade, diploma unclear"', add
label define educ_lbl 073 `"High school diploma or equivalent"', add
label define educ_lbl 080 `"1 year of college"', add
label define educ_lbl 081 `"Some college but no degree"', add
label define educ_lbl 090 `"2 years of college"', add
label define educ_lbl 091 `"Associate's degree, occupational/vocational program"', add
label define educ_lbl 092 `"Associate's degree, academic program"', add
label define educ_lbl 100 `"3 years of college"', add
label define educ_lbl 110 `"4 years of college"', add
label define educ_lbl 111 `"Bachelor's degree"', add
label define educ_lbl 120 `"5+ years of college"', add
label define educ_lbl 121 `"5 years of college"', add
label define educ_lbl 122 `"6+ years of college"', add
label define educ_lbl 123 `"Master's degree"', add
label define educ_lbl 124 `"Professional school degree"', add
label define educ_lbl 125 `"Doctorate degree"', add
label define educ_lbl 999 `"Missing/Unknown"', add
label values educ educ_lbl

label define educ99_lbl 00 `"NIU"'
label define educ99_lbl 01 `"No school completed"', add
label define educ99_lbl 04 `"1st-4th grade"', add
label define educ99_lbl 05 `"5th-8th grade"', add
label define educ99_lbl 06 `"9th grade"', add
label define educ99_lbl 07 `"10th grade"', add
label define educ99_lbl 08 `"11th grade"', add
label define educ99_lbl 09 `"12th grade, no diploma"', add
label define educ99_lbl 10 `"High school graduate, or GED"', add
label define educ99_lbl 11 `"Some college, no degree"', add
label define educ99_lbl 12 `"Associate degree, type of program not specified"', add
label define educ99_lbl 13 `"Associate degree, occupational program"', add
label define educ99_lbl 14 `"Associate degree, academic program"', add
label define educ99_lbl 15 `"Bachelors degree"', add
label define educ99_lbl 16 `"Masters degree"', add
label define educ99_lbl 17 `"Professional degree"', add
label define educ99_lbl 18 `"Doctorate degree"', add
label values educ99 educ99_lbl

label define qeduc_lbl 00 `"No change"'
label define qeduc_lbl 01 `"Allocated"', add
label define qeduc_lbl 02 `"Value to blank"', add
label define qeduc_lbl 03 `"Blank to allocated value"', add
label define qeduc_lbl 04 `"Don't know to allocated value"', add
label define qeduc_lbl 05 `"Refused to allocated value"', add
label define qeduc_lbl 06 `"Blank to longitudinal value"', add
label define qeduc_lbl 07 `"Don't know to longitudinal value"', add
label define qeduc_lbl 08 `"Refused to longitudinal value"', add
label define qeduc_lbl 09 `"Don't know to blank"', add
label define qeduc_lbl 10 `"Refused to blank"', add
label values qeduc qeduc_lbl

label define classwly_lbl 00 `"NIU"'
label define classwly_lbl 10 `"Self-employed"', add
label define classwly_lbl 13 `"Self-employed, not incorporated"', add
label define classwly_lbl 14 `"Self-employed, incorporated"', add
label define classwly_lbl 20 `"Works for wages or salary"', add
label define classwly_lbl 22 `"Wage/salary, private"', add
label define classwly_lbl 24 `"Wage/salary, government"', add
label define classwly_lbl 25 `"Federal government employee"', add
label define classwly_lbl 27 `"State government employee"', add
label define classwly_lbl 28 `"Local government employee"', add
label define classwly_lbl 29 `"Unpaid family worker"', add
label define classwly_lbl 99 `"Missing/Unknown"', add
label values classwly classwly_lbl

label define fullpart_lbl 0 `"NIU"'
label define fullpart_lbl 1 `"Full-time"', add
label define fullpart_lbl 2 `"Part-time"', add
label define fullpart_lbl 9 `"Unknown"', add
label values fullpart fullpart_lbl

label define qclasswl_lbl 0 `"No change or children or armed forces"'
label define qclasswl_lbl 1 `"Allocated"', add
label values qclasswl qclasswl_lbl

label define quhrsworkly_lbl 0 `"Not allocated"'
label define quhrsworkly_lbl 1 `"Allocated"', add
label values quhrsworkly quhrsworkly_lbl

label define qwkswork_lbl 0 `"No change or children"'
label define qwkswork_lbl 1 `"Allocated"', add
label values qwkswork qwkswork_lbl

label define qearnwee_lbl 0 `"Not allocated"'
label define qearnwee_lbl 4 `"Allocated"', add
label values qearnwee qearnwee_lbl

label define qinclong_lbl 0 `"No change"'
label define qinclong_lbl 1 `"Income amount allocated"', add
label define qinclong_lbl 2 `"Income type allocated"', add
label define qinclong_lbl 3 `"Income amount and income type allocated"', add
label values qinclong qinclong_lbl

label define qinclongd_lbl 00 `"No change"'
label define qinclongd_lbl 10 `"Income amount allocated"', add
label define qinclongd_lbl 11 `"Level 1 statistical match (value with ranges)"', add
label define qinclongd_lbl 12 `"Level 2 statistical match (value with ranges)"', add
label define qinclongd_lbl 13 `"Level 3 statistical match (value with ranges)"', add
label define qinclongd_lbl 14 `"Level 101 statistical match (value without ranges, recipiency, _yn)"', add
label define qinclongd_lbl 15 `"Level 102 statistical match (value without ranges, recipiency, _yn)"', add
label define qinclongd_lbl 16 `"Level 103 statistical match (value without ranges, recipiency, _yn)"', add
label define qinclongd_lbl 17 `"Level 104 statistical match (age, sex)"', add
label define qinclongd_lbl 18 `"Level 105 statistical match (all donors can match to all recipients)"', add
label define qinclongd_lbl 20 `"Income type allocated"', add
label define qinclongd_lbl 30 `"Income amount and income type allocated"', add
label values qinclongd qinclongd_lbl

label define qoincwage_lbl 0 `"No allocation"'
label define qoincwage_lbl 1 `"Income amount allocated"', add
label define qoincwage_lbl 2 `"Recipiency type allocated"', add
label define qoincwage_lbl 3 `"Income amount  and recipiency type allocated"', add
label values qoincwage qoincwage_lbl

label define qoincwaged_lbl 00 `"No allocation"'
label define qoincwaged_lbl 10 `"Income amount allocated"', add
label define qoincwaged_lbl 11 `"Level 1 statistical match (value with ranges)"', add
label define qoincwaged_lbl 12 `"Level 2 statistical match (value with ranges)"', add
label define qoincwaged_lbl 13 `"Level 3 statistical match (value with ranges)"', add
label define qoincwaged_lbl 14 `"Level 101 statistical match (value without ranges, recipiency, _yn)"', add
label define qoincwaged_lbl 15 `"Level 102 statistical match (value without ranges, recipiency, _yn)"', add
label define qoincwaged_lbl 16 `"Level 103 statistical match (value without ranges, recipiency, _yn)"', add
label define qoincwaged_lbl 17 `"Level 104 statistical match (age, sex)"', add
label define qoincwaged_lbl 18 `"Level 105 statistical match (all donors can match to all recipients)"', add
label define qoincwaged_lbl 20 `"Recipiency type allocated"', add
label define qoincwaged_lbl 30 `"Income amount  and recipiency type allocated"', add
label values qoincwaged qoincwaged_lbl

label define qincwage_lbl 0 `"No allocation"'
label define qincwage_lbl 1 `"Income amount allocated"', add
label define qincwage_lbl 2 `"Recipiency type allocated"', add
label define qincwage_lbl 3 `"Income amount  and recipiency type allocated"', add
label values qincwage qincwage_lbl

label define tinclongj_lbl 0 `"Not topcoded"'
label define tinclongj_lbl 1 `"Topcoded"', add
label values tinclongj tinclongj_lbl

label define toincwage_lbl 0 `"Not topcoded"'
label define toincwage_lbl 1 `"Topcoded"', add
label values toincwage toincwage_lbl

label define qhourwag_lbl 0 `"No change or children or armed forces"'
label define qhourwag_lbl 1 `"Value to blank"', add
label define qhourwag_lbl 2 `"Blank to value"', add
label define qhourwag_lbl 3 `"Value to value"', add
label define qhourwag_lbl 4 `"Allocated"', add
label values qhourwag qhourwag_lbl

save "$path/Data/cps_rawdata.dta", replace
