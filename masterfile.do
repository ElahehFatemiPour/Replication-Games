 
 ** preparation
 clear all
 
 cap log close

 set more off

 cd "~" 
 
 global root="~" 
 global dofiles= "$root/dofiles"
 global rawdata= "$root/rawdata"
 global cleandata= "$root/cleandata"
 global tempdata= "$root/tempdata"
 global output= "$root/output"

 ** data cleaning
 do "$dofiles/data_clean.do"

 ** table 1 & 2
 do "$dofiles/table 1 panel a.do"
 do "$dofiles/table 1 & 2.do" 

 ** table 3
 do "$dofiles/table3.do"

 ** figure 3
 do "$dofiles/figure3.do"

 ** table 4
 do "$dofiles/table4.do"