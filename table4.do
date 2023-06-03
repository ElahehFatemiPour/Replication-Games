     
 
 use "$cleandata/dhs", replace

 tostring v012, gen(age)

 * under 18 at reform: if we use this, everything changes
     gen post=.
     replace post=1 if age_reform<18
     replace post=0 if age_reform>=18

 * country-cohort indicators
 tostring age_reform, gen(age_reform_s)
 gen country_age=country+age_reform_s

 gen intensity_m_post=intensity_main*post

 reghdfe m_b18 intensity_m_post, absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("m_b18_full") replace keep(intensity_m_post)
 
 foreach i in v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post, absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_full") append keep(intensity_m_post)
 } 

 foreach i in m_b18 v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post if urban=="1", absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_urban") append keep(intensity_m_post)
 } 

 foreach i in m_b18 v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post if urban=="0", absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_rural") append keep(intensity_m_post)
 } 
 
 foreach i in m_b18 v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post if minage_fem_pc_95==4, absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_preban16") append keep(intensity_m_post)
 } 

 foreach i in m_b18 v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post if minage_fem_pc_95==3, absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_preban14") append keep(intensity_m_post)
 } 

 foreach i in m_b18 v511 v212 edu_year emp{
 	reghdfe `i' intensity_m_post if minage_fem_pc_95==1, absorb(region country_age) cluster(region)
 	outreg2 using "$output/baseline.xls", stat(coef se) nocons bdec(4) ///
			sdec(3) ctitle("`i'_nopreban") append keep(intensity_m_post)
 } 

