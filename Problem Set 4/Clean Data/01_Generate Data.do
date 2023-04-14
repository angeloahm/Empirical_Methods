clear
set more off
set scheme plotplain, permanently

**************************************************************************

*This code generates the RAW PSID data
*Author: Johanna Torres Chain & Angelo Hermeto Mendes

**************************************************************************

*cd "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

*global path "/Users/johanatch/Library/CloudStorage/GoogleDrive-torre750@umn.edu/My Drive/Empirical Methods/Homework 2"

do "$path/Data/Original Data/J316158.do"
do "$path/Data/Original Data/J316158_formats.do"

gen id2=1000000+_n
gen id=(ER30001)*1000+ER30002

la var id "Individual Identification"

**************************************************************************
*********************** Preparing for reshape ****************************
**************************************************************************

/* Variables: 	id_68	age	gender	wage	aac_wage	inc	acc_inc	farm	acc_farm	bus	acc_bus relhd*/

* 1968 Interview number

rename V1230 id_681970
rename V1932 id_681971
rename V2533 id_681972
rename V3085 id_681973
rename V3497 id_681974
rename V3909 id_681975
rename V4423 id_681976
rename V5336 id_681977
rename V5835 id_681978
rename V6446 id_681979
rename V7050 id_681980
rename V7642 id_681981
rename V8335 id_681982
rename V8943 id_681983
rename V10400 id_681984
rename V11581 id_681985
rename V12988 id_681986
rename V14090 id_681987
rename V15105 id_681988
rename V16605 id_681989
rename V18021 id_681990
rename V19321 id_681991
rename V20621 id_681992
rename V22400 id_681993
rename ER2005G id_681994
rename ER5005G id_681995
rename ER7005G id_681996
rename ER10005G id_681997
rename ER13019 id_681999
rename ER17022 id_682001
rename ER21009 id_682003
rename ER25009 id_682005
rename ER36009 id_682007

* Age of HH head

rename V1239 age1970
rename V1942 age1971
rename V2542 age1972
rename V3095 age1973
rename V3508 age1974
rename V3921 age1975
rename V4436 age1976
rename V5350 age1977
rename V5850 age1978
rename V6462 age1979
rename V7067 age1980
rename V7658 age1981
rename V8352 age1982
rename V8961 age1983
rename V10419 age1984
rename V11606 age1985
rename V13011 age1986
rename V14114 age1987
rename V15130 age1988
rename V16631 age1989
rename V18049 age1990
rename V19349 age1991
rename V20651 age1992
rename V22406 age1993
rename ER2007 age1994
rename ER5006 age1995
rename ER7006 age1996
rename ER10009 age1997
rename ER13010 age1999
rename ER17013 age2001
rename ER21017 age2003
rename ER25017 age2005
rename ER36017 age2007

* Sex of HH head

rename V1240 gender1970
rename V1943 gender1971
rename V2543 gender1972
rename V3096 gender1973
rename V3509 gender1974
rename V3922 gender1975
rename V4437 gender1976
rename V5351 gender1977
rename V5851 gender1978
rename V6463 gender1979
rename V7068 gender1980
rename V7659 gender1981
rename V8353 gender1982
rename V8962 gender1983
rename V10420 gender1984
rename V11607 gender1985
rename V13012 gender1986
rename V14115 gender1987
rename V15131 gender1988
rename V16632 gender1989
rename V18050 gender1990
rename V19350 gender1991
rename V20652 gender1992
rename V22407 gender1993
rename ER2008 gender1994
rename ER5007 gender1995
rename ER7007 gender1996
rename ER10010 gender1997
rename ER13011 gender1999
rename ER17014 gender2001
rename ER21018 gender2003
rename ER25018 gender2005
rename ER36018 gender2007

* Wages and Salaries

rename V1191 wage1970
rename V1892 wage1971
rename V2493 wage1972
rename V3046 wage1973
rename V3458 wage1974
rename V3858 wage1975
rename V4373 wage1976
rename V5283 wage1977
rename V5782 wage1978
rename V6391 wage1979
rename V6981 wage1980
rename V7573 wage1981
rename V8265 wage1982
rename V8873 wage1983
rename V10256 wage1984
rename V11397 wage1985
rename V12796 wage1986
rename V13898 wage1987
rename V14913 wage1988
rename V16413 wage1989
rename V17829 wage1990
rename V19129 wage1991
rename V20429 wage1992
rename V21739 wage1993
rename ER4122 wage1994
rename ER6962 wage1995
rename ER9213 wage1996
rename ER12196 wage1997
rename ER16493 wage1999
rename ER20425 wage2001
rename ER24117 wage2003
rename ER27913 wage2005
rename ER40903 wage2007

* Accuracy wage

rename V1192 acc_wage1970
rename V1893 acc_wage1971
rename V2494 acc_wage1972
rename V3047 acc_wage1973
rename V3459 acc_wage1974
rename V3859 acc_wage1975
rename V4374 acc_wage1976
rename V5284 acc_wage1977
rename V5783 acc_wage1978
rename V6392 acc_wage1979
rename V6982 acc_wage1980
rename V7574 acc_wage1981
rename V8266 acc_wage1982
rename V8874 acc_wage1983
rename V10257 acc_wage1984
rename V11398 acc_wage1985
rename V12797 acc_wage1986
rename V13899 acc_wage1987
rename V14914 acc_wage1988
rename V16414 acc_wage1989
rename V17830 acc_wage1990
rename V19130 acc_wage1991
rename V20430 acc_wage1992
rename V21740 acc_wage1993
rename ER4123 acc_wage1994
rename ER6963 acc_wage1995
rename ER9214 acc_wage1996
rename ER12197 acc_wage1997
rename ER16494 acc_wage1999
rename ER20426 acc_wage2001
rename ER24118 acc_wage2003
rename ER27914 acc_wage2005
rename ER40904 acc_wage2007

*Tot labor income head

rename V1196 inc1970
rename V1897 inc1971
rename V2498 inc1972
rename V3051 inc1973
rename V3463 inc1974
rename V3863 inc1975
rename V5031 inc1976
rename V5627 inc1977
rename V6174 inc1978
rename V6767 inc1979
rename V7413 inc1980
rename V8066 inc1981
rename V8690 inc1982
rename V9376 inc1983
rename V11023 inc1984
rename V12372 inc1985
rename V13624 inc1986
rename V14671 inc1987
rename V16145 inc1988
rename V17534 inc1989
rename V18878 inc1990
rename V20178 inc1991
rename V21484 inc1992
rename V23323 inc1993

*Accuracy labor

rename V1197 acc_inc1970
rename V1898 acc_inc1971
rename V2499 acc_inc1972
rename V3052 acc_inc1973
rename V3464 acc_inc1974
rename V3864 acc_inc1975
rename V4378 acc_inc1976
rename V5288 acc_inc1977
rename V5787 acc_inc1978
rename V6397 acc_inc1979
rename V6987 acc_inc1980
rename V7579 acc_inc1981
rename V8271 acc_inc1982
rename V8879 acc_inc1983
rename V10262 acc_inc1984
rename V11403 acc_inc1985
rename V12802 acc_inc1986
rename V13904 acc_inc1987
rename V14919 acc_inc1988
rename V16419 acc_inc1989
rename V17835 acc_inc1990
rename V19135 acc_inc1991
rename V20435 acc_inc1992
rename V21808 acc_inc1993

* Farm income
/*Before 1976 farm income is bracketed*/

rename V4371 farm1976
rename V5281 farm1977
rename V5780 farm1978
rename V6389 farm1979
rename V6979 farm1980
rename V7571 farm1981
rename V8263 farm1982
rename V8871 farm1983
rename V10254 farm1984
rename V11395 farm1985
rename V12794 farm1986
rename V13896 farm1987
rename V14911 farm1988
rename V16411 farm1989
rename V17827 farm1990
rename V19127 farm1991
rename V20427 farm1992
rename V21733 farm1993
rename ER4117 farm1994
rename ER6957 farm1995
rename ER9208 farm1996
rename ER12065 farm1997
rename ER16448 farm1999
rename ER20420 farm2001
rename ER24105 farm2003
rename ER27908 farm2005
rename ER40898 farm2007

* Accuracy farm

rename ER4118 acc_farm1994
rename ER6958 acc_farm1995
rename ER9209 acc_farm1996
rename ER12066 acc_farm1997
rename ER16449 acc_farm1999
rename ER20421 acc_farm2001
rename ER24106 acc_farm2003
rename ER27909 acc_farm2005
rename ER40899 acc_farm2007

* Business Income
/*Before 1976 business income is bracketed*/ 

rename V4372 bus1976
rename V5282 bus1977
rename V5781 bus1978
rename V6390 bus1979
rename V6980 bus1980
rename V7572 bus1981
rename V8264 bus1982
rename V8872 bus1983
rename V10255 bus1984
rename V11396 bus1985
rename V12795 bus1986
rename V13897 bus1987
rename V14912 bus1988
rename V16412 bus1989
rename V17828 bus1990
rename V19128 bus1991
rename V20428 bus1992
rename V21738 bus1993
rename ER4119 bus1994
rename ER6959 bus1995
rename ER9210 bus1996
rename ER12193 bus1997
rename ER16490 bus1999
rename ER20422 bus2001
rename ER24109 bus2003
rename ER27910 bus2005
rename ER40900 bus2007

* Accuracy business

rename ER4115 acc_bus1994
rename ER6955 acc_bus1995
rename ER9206 acc_bus1996
rename ER12068 acc_bus1997
rename ER16451 acc_bus1999
rename ER20418 acc_bus2001
rename ER24108 acc_bus2003
rename ER27906 acc_bus2005
rename ER40896 acc_bus2007

* Tot.Income Exl Farm and Business HH

/*
rename ER4140 excfarmbus1994
rename ER6980 excfarmbus1995
rename ER9231 excfarmbus1996
rename ER12080 excfarmbus1997
rename ER16463 excfarmbus1999
rename ER20443 excfarmbus2001
rename ER24116 excfarmbus2003
rename ER27931 excfarmbus2005
rename ER40921 excfarmbus2007
*/

rename ER4140 inc1994
rename ER6980 inc1995
rename ER9231 inc1996
rename ER12080 inc1997
rename ER16463 inc1999
rename ER20443 inc2001
rename ER24116 inc2003
rename ER27931 inc2005
rename ER40921 inc2007

* Relationship to HH head

rename ER30045 relhd1970
rename ER30069 relhd1971
rename ER30093 relhd1972
rename ER30119 relhd1973
rename ER30140 relhd1974
rename ER30162 relhd1975
rename ER30190 relhd1976
rename ER30219 relhd1977
rename ER30248 relhd1978
rename ER30285 relhd1979
rename ER30315 relhd1980
rename ER30345 relhd1981
rename ER30375 relhd1982
rename ER30401 relhd1983
rename ER30431 relhd1984
rename ER30465 relhd1985
rename ER30500 relhd1986
rename ER30537 relhd1987
rename ER30572 relhd1988
rename ER30608 relhd1989
rename ER30644 relhd1990
rename ER30691 relhd1991
rename ER30735 relhd1992
rename ER30808 relhd1993
rename ER33103 relhd1994
rename ER33203 relhd1995
rename ER33303 relhd1996
rename ER33403 relhd1997
rename ER33503 relhd1999
rename ER33603 relhd2001
rename ER33703 relhd2003
rename ER33803 relhd2005
rename ER33903 relhd2007

**************************************************************************
******************************* Reshape **********************************
**************************************************************************

keep id id_68* age*	gender*	wage* acc_wage*	inc* acc_inc* farm*	acc_farm* bus* acc_bus* relhd*
order id id_68* age* gender* wage* acc_wage* inc* acc_inc* farm* acc_farm* bus* acc_bus* relhd*
sort id

reshape long id_68 age gender wage acc_wage inc acc_inc farm acc_farm bus acc_bus excfarmbus relhd, i(id) j(wave)

save "$path/Data/main_database.dta",replace
/* 2.206.149 observations = 66,853 * 33 waves*/
