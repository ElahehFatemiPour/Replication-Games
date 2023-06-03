     
     use "$cleandata/dhs", replace
     
     twoway (kdensity intensity_main, lc(black)) (kdensity intensity_alt, lc(black) lp(dash) ), ///
     xscale(r(0 4) titlegap(0.25)) xlabel(0(0.25)4) ///
     graphr(color(white)) yti("Density") xti("Intensity") title(Full Sample) ///
     legend(order(1 "Intensity (main)" 2 "Intensity (alternative)"))
     graph export "$output/kdensity_full.png", as(png) replace

     twoway (kdensity intensity_main if urban=="1", lc(black)) (kdensity intensity_alt if urban=="1", lc(black) lp(dash) ), ///
     xscale(r(0 4) titlegap(0.25)) xlabel(0(0.25)4) ///
     graphr(color(white)) yti("Density") xti("Intensity") title(Urban) ///
     legend(order(1 "Intensity (main)" 2 "Intensity (alternative)"))
     graph export "$output/kdensity_urban.png", as(png) replace

     twoway (kdensity intensity_main if urban=="0", lc(black)) (kdensity intensity_alt if urban=="0", lc(black) lp(dash) ), ///
     xscale(r(0 4) titlegap(0.25)) xlabel(0(0.25)4) ///
     graphr(color(white)) yti("Density") xti("Intensity") title(Rural) ///
     legend(order(1 "Intensity (main)" 2 "Intensity (alternative)"))
     graph export "$output/kdensity_rural.png", as(png) replace