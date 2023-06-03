 
 /**** 1. DHS data ****/

 ** append data **
 use "$rawdata/DHS/ALIR51DT/ALIR51FL.DTA", replace
     keep caseid v000 v025 v139 v101 v012 v714 v133 v501 v212 v511 v106 v732 v010 v508 v005 v741
     tempfile dhsdata
     save "`dhsdata'", replace
 foreach i in BJIR61 CDIR61 EGIR61 ETIR61 GNIR62 LBIR6A MDIR51 MVIR52 NGIR6A NMIR61 NPIR61 PEIR41 SLIR61 TGIR61{
     use "`dhsdata'", replace
     append using "$rawdata/DHS/`i'DT/`i'FL.DTA", keep(v000 v025 v139 v101 v012 v714 v133 v501 v212 v511 v106 v732 v010 v508 v005 v741)
     save "`dhsdata'", replace
 }
 foreach i in JOIR6C KKIR42{
     use "`dhsdata'", replace
     append using "$rawdata/DHS/`i'DT/`i'FL.DTA", keep(v000 v025 v139 v101 v012 v714 v133 v501 v212 v511 v106 v732 v010 v508 v005)
     save "`dhsdata'", replace
 }

     gen country=""
     replace country = "Albania" if v000 == "AL5"
     replace country = "Benin" if v000 == "BJ6"
     replace country = "Democratic Republic of the Congo" if v000 == "CD6" 
     replace country = "Egypt" if v000 == "EG6" 
     replace country = "Ethiopia" if v000 == "ET6" 
     replace country = "Guinea" if v000 == "GN6" 
     replace country = "Jordan" if v000 == "JO6" 
     replace country = "Kazakhstan" if v000 == "KK3" 
     replace country = "Liberia" if v000 == "LB6" 
     replace country = "Madagascar" if v000 == "MD5"  
     replace country = "Maldives" if v000 == "MV5"   
     replace country = "Namibia" if v000 == "NM6"  
     replace country = "Nigeria" if v000 == "NG6"  
     replace country = "Nepal" if v000 == "NP6" 
     replace country = "Peru" if v000 == "PE4"  
     replace country = "Sierra Leone" if v000 == "SL6"
     replace country = "Togo" if v000 == "TG6"

 ** data clean **
     * wrong coding of year in raw data
     replace v508=v508-56 if country=="Nepal"
     replace v010=v010-56 if country=="Nepal"

     * married before 18
     gen m_b18=.
     replace m_b18=1 if v511<18
     replace m_b18=0 if v511>=18

     * employment status
     gen emp=.
     replace emp = 1 if v714 == 1
     replace emp = 0 if v714 == 0 

     * sub-national region
     tostring v101, gen(rawregion)
     replace v025=0 if v025==2
     tostring v025, gen(urban)

     gen region=v000+rawregion+urban

     * wrong year of birth/marriage
     gen year_birth=v010
     replace year_birth=1900+year_birth if year_birth<100

     gen year_marriage=v508
     replace year_marriage=1900+year_marriage if year_marriage<100

     * years of schooling
     gen edu_year=v133
     replace edu_year=. if edu_year==98 | edu_year==99

     * generate weight
     gen wt=v005/1000000

 save "$cleandata/dhs", replace
   

 /**** 2. MACHE ****/

 use "$rawdata/WORLD-MACHE/WORLD-MACHE", replace
     keep if country=="Albania" | country=="Benin" | country=="Democratic Republic of the Congo" | country=="Egypt" | country=="Ethiopia" | country=="Guinea" | country=="Jordan" | country=="Kazakhstan" | country=="Liberia" | country=="Madagascar" | country=="Maldives" | country=="Namibia" | country=="Nepal" | country=="Nigeria" | country=="Peru" | country=="Sierra Leone" | country=="Togo"
     keep country minage_fem_pc_95 minage_fem_pc_12 
     tempfile minage
     save "`minage'", replace

 * 17 countries with year of reform
 use "$rawdata/WORLD-MACHE/WORLD-MACHE", replace
     keep if country=="Albania" | country=="Benin" | country=="Democratic Republic of the Congo" | country=="Egypt" | country=="Ethiopia" | country=="Guinea" | country=="Jordan" | country=="Kazakhstan" | country=="Liberia" | country=="Madagascar" | country=="Maldives" | country=="Namibia" | country=="Nepal" | country=="Nigeria" | country=="Peru" | country=="Sierra Leone" | country=="Togo"
     keep country minage_fem_pc_*
     forval i=95/99{
          rename minage_fem_pc_`i' minage_fem_pc19`i'
     }
     forval i=0/9{
          rename minage_fem_pc_0`i' minage_fem_pc200`i'
     }
     forval i=10/12{
          rename minage_fem_pc_`i' minage_fem_pc20`i'
     }
     reshape long minage_fem_pc, i(country) j(year)
     codebook minage_fem_pc
     keep if minage_fem_pc==5
     bysort country: egen reform=min(year)
     duplicates drop country, force
     keep country reform
     merge 1:1 country using "`minage'"
     drop _merge
 save "$cleandata/minage_pc", replace

 
 /**** 3. merge two datasets ****/

 use "$cleandata/dhs", replace
     merge m:1 country using "$cleandata/minage_pc"
     drop _merge
 save "$cleandata/dhs", replace
 
 /**** 4. construct intensity: intensity of child marriage is calculated using the untreated group:
 individuals who are between 18 and 49 at the time of the reform and experienced child marriages ****/
     
 use "$cleandata/dhs", replace
     
     * limit our sample to age at interview between 15 and 49
     keep if v012>=15 & v012<=49

     * age at reform
     gen age_reform=reform-year_birth

     * preban cohort: between 18 and 49 at the time of reform 
     gen preban_c50=.
     replace preban_c50=1 if age_reform>=18 & age_reform<50 & m_b18==1
     replace preban_c50=0 if preban_c50==.

     * age difference: 18 - marriage age
     gen age_diff=18-v511 if preban_c50==1
     replace age_diff=0 if age_diff==.

     * pre-ban cohort size
     gen preban_c=0
     replace preban_c=1 if age_reform>=18 & age_reform<50
     bysort region: egen coh_size=sum(preban_c)
     
     * intensity
     bysort region: egen intensity_main=sum((preban_c50*age_diff)/coh_size)
     bysort region: egen intensity_alt=sum(preban_c50/coh_size)

 save "$cleandata/dhs", replace
     

** our previous misunderstanding:
** prevalence of child marriage in the treated cohort (under 18 at the year of reform) before the reform
** should be the prevalence of child marriage in the untreated cohort (above at the year of reform) before the reform
 
*use "$cleandata/dhs", replace
     
     *keep if v012>=15 & v012<=49

     * age at reform
     *gen age_reform=reform-year_birth

     * under 18 at reform
     *gen un18_reform=.
     *replace un18_reform=1 if age_reform<18
     *replace un18_reform=0 if age_reform>=18

     * 18 - marriage age
     *gen age_diff=18-v511 if preban_c50==1
     *replace age_diff=0 if age_diff==.

     * dummy: married before 18 (conditional on under 18 at the year of reform & married before the reform)
     *gen m_b18_preban=.
     *replace m_b18_preban=1 if m_b18==1 & un18_reform==1 & year_marriage<reform
     *replace m_b18_preban=0 if m_b18!=1 & un18_reform==1

     * pre-ban cohort size
     *bysort region: egen coh_size=sum(un18_reform)
     
     * intensity
     *bysort region: egen intensity_main=sum((m_b18_preban*age_diff)/coh_size)
     *bysort region: egen intensity_alt=sum(m_b18_preban/coh_size)
