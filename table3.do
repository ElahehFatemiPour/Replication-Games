     
     
     use "$cleandata/dhs", replace

     tempfile table3
     tempname mem1
     postfile `mem1' str200(Variable Mean Standard_deviation ten twf fif sevfiv ninty Max Min N) using `table3'
     
     foreach i in intensity_main intensity_alt{
          quietly sum `i', detail
          local N`i'=string(r(N))
          local max`i'=string(round(r(max),0.01))
          local min`i'=string(round(r(min),0.01))
          local m`i'=string(round(r(mean), 0.01))
          local sd`i'=string(round(r(sd),0.01))  
          local 10`i'=string(round(r(p10),0.01)) 
          local 25`i'=string(round(r(p25),0.01)) 
          local 50`i'=string(round(r(p50),0.01)) 
          local 75`i'=string(round(r(p75),0.01)) 
          local 90`i'=string(round(r(p90),0.01)) 
          post `mem1' ("`i'") ("`m`i''") ("`sd`i''") ("`10`i''") ("`25`i''") ("`50`i''") ("`75`i''") ("`90`i''") ("`max`i''") ("`min`i''") ("`N`i''")
          
          quietly sum `i' if urban=="1", detail
          local N`i'urban=string(r(N))
          local max`i'urban=string(round(r(max),0.01))
          local min`i'urban=string(round(r(min),0.01))
          local m`i'urban=string(round(r(mean), 0.01))
          local sd`i'urban=string(round(r(sd),0.01))  
          local 10`i'urban=string(round(r(p10),0.01)) 
          local 25`i'urban=string(round(r(p25),0.01)) 
          local 50`i'urban=string(round(r(p50),0.01)) 
          local 75`i'urban=string(round(r(p75),0.01)) 
          local 90`i'urban=string(round(r(p90),0.01)) 
          post `mem1' ("`i'urban") ("`m`i'urban'") ("`sd`i'urban'") ("`10`i'urban'") ("`25`i'urban'") ("`50`i'urban'") ("`75`i'urban'") ("`90`i'urban'") ("`max`i'urban'") ("`min`i'urban'") ("`N`i'urban'")

          quietly sum `i' if urban=="0", detail
          local N`i'rural=string(r(N))
          local max`i'rural=string(round(r(max),0.01))
          local min`i'rural=string(round(r(min),0.01))
          local m`i'rural=string(round(r(mean), 0.01))
          local sd`i'rural=string(round(r(sd),0.01))  
          local 10`i'rural=string(round(r(p10),0.01)) 
          local 25`i'rural=string(round(r(p25),0.01)) 
          local 50`i'rural=string(round(r(p50),0.01)) 
          local 75`i'rural=string(round(r(p75),0.01)) 
          local 90`i'rural=string(round(r(p90),0.01)) 
          post `mem1' ("`i'rural") ("`m`i'rural'") ("`sd`i'rural'") ("`10`i'rural'") ("`25`i'rural'") ("`50`i'rural'") ("`75`i'rural'") ("`90`i'rural'") ("`max`i'rural'") ("`min`i'rural'") ("`N`i'rural'")
     }

     postclose `mem1'
          
     use `table3', clear
     export excel using "$output/table3", replace firstrow(variables)
      