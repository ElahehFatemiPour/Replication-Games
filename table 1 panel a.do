
 /**** Table 1 Panel A ****/

 use "$rawdata/DHS/ALIR51DT/ALIR51FL.DTA", replace
      keep v000 v007
      tempfile int
      save "`int'", replace
 foreach i in BJIR61 CDIR61 EGIR61 ETIR61 GNIR62 JOIR6C KKIR42 LBIR6A MDIR51 MVIR52 NGIR6A NMIR61 NPIR61 PEIR41 SLIR61 TGIR61{
      use "`int'", replace
      append using "$rawdata/DHS/`i'DT/`i'FL.DTA", keep(v000 v007)
      duplicates drop v000 v007, force
      save "`int'", replace
 }
     use "`int'", replace
     gen year=v007
     replace year=1999 if year==99
     replace year=2011 if year==2067
     replace year=2012 if year==2068
     drop v007
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
     bysort country: gen code=_n
     reshape wide year, i(country) j(code)
     gen year1_1=year1 if year1<year2 | year2==.
     replace year1_1=year2 if year1>year2
     replace year2=year1 if year1_1!=year1 & year2!=.
     drop year1
     rename year1_1 year1
     tostring year1 year2, replace
     gen year=year1 if year2=="."
     replace year=year1+"/"+year2 if year2!="."
     destring year1, replace
     keep country year year1
 save "`int'", replace

 use "$rawdata/WORLD-MACHE/WORLD-MACHE", replace
     keep if country=="Albania" | country=="Benin" | country=="Democratic Republic of the Congo" | country=="Egypt" | country=="Ethiopia" | country=="Guinea" | country=="Jordan" | country=="Kazakhstan" | country=="Liberia" | country=="Madagascar" | country=="Maldives" | country=="Namibia" | country=="Nepal" | country=="Nigeria" | country=="Peru" | country=="Sierra Leone" | country=="Togo"
     keep country minage_fem_pc_95 minage_fem_pc_12 
 tempfile minage
 save "`minage'", replace

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
     
     merge 1:1 country using "`int'"
     gen interval=year1-reform
     drop year1 _merge

 export excel using "$output/table1panelA.xlsx", firstrow(variables) replace

