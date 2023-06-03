 
 use "$cleandata/dhs", replace
 //use "dhs.dta", clear
 
 drop if  v106 == 8

 **** Married variable - make 1,0 *****
 
 
 gen m_status = 1 if v501 == 1 
 replace m_status = 0 if v501 != 1

 
 
 
tabstat v012 m_status m_b18 v212 v133 emp, by(country) stat(mean) format(%9.2f) 


**urban/rural**
 drop urban //because urban is a string and we need integer here
 gen urban = 1 if v025 == 1
 replace urban = 0 if v025 != 1
 
**** Married before 16******
 
 gen m_age16 = 1 if v511 < 16 
 replace m_age16 = 0 if v511 >= 16
 
 
**** Married before 14******
 
 gen m_age14 = 1 if v511 < 14
 replace m_age14 = 0 if v511 >= 14
 
****no edu***
 
 gen no_ed = 1 if v106 == 0
 replace no_ed = 0 if v106 != 0
 
 ***primary
 
 gen primary = 1 if v106 == 1
 replace primary = 0 if v106 != 1
 
***Seondary  
gen secondary = 1 if v106 == 2
replace secondary = 0 if v106 != 2
 
***Higher 
gen higher = 1 if v106 == 3
replace higher = 0 if v106 != 3
 


***** not paid
gen no_paid = 1 if v741 == 0
replace no_paid =0 if v741 != 0


***** Cash only

gen cash = 1 if v741 == 1
replace cash =0 if v741 != 1

***cash and kind

gen c_k = 1 if v741 == 2
replace c_k =0 if v741 != 2


***kind only***
gen kind = 1 if v741 == 3
replace kind =0 if v741 != 3

** all year

gen all_year = 1 if v732 == 1
replace all_year = 0 if v732 != 1

** seasonally 

gen season = 1 if v732 == 2
replace season = 0 if v732 != 2

**occasionally 

gen occ = 1 if v732 == 3
replace occ = 0 if v732 != 3

 
 
**Table 2***

format v012 urban m_status m_b18 m_age16 m_age14 v212 v133 no_ed primary secondary higher emp cash c_k kind no_paid all_year season occ %9.2fc

**Full sample 
summarize v012 urban m_status m_b18 m_age16 m_age14 v212 v133 no_ed primary secondary higher emp cash c_k kind no_paid all_year season occ, format

***Urban 

summarize v012 urban m_status m_b18 m_age16 m_age14 v212 v133 no_ed primary secondary higher emp cash c_k kind no_paid all_year season occ if urban == 1, format
 
*** Rural 

summarize v012 urban m_status m_b18 m_age16 m_age14 v212 v133 no_ed primary secondary higher emp cash c_k kind no_paid all_year season occ if urban == 0, format



***tabstat v012 m_status m_age v212 v133 emp, by(country) stat(mean) format(%9.2f) 


**egen totalbyyear = total(!missing(income) & !missing(fincome))
