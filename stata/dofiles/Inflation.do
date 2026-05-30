*******************************
*Belize Labour Market Analysis
*Consumer Price Index
*******************************

*Setup
clear all 
set more off

global Inflation ///
"C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis"

cd "$Inflation\data\raw"
pwd

*Import the raw dataset from excel
import excel "Inflation.xlsx", ///
sheet("cpi") ///
firstrow ///
clear

format _all %9.2f
browse

*Set the data monthly
generate months = tm(2018m1)+_n-1
browse
format %tm months
browse
tsset months

*Generate Headline Inflation
gen headline = (All_Item/L12.All_Item - 1)*100

*Generate Core Inflation
/*
Note: 	Weights of Food is 258.0, House 195.0 and Transport 153.0
		So core inflation weight is (1000-606)=394
*/

gen core = ///
(35*Alcoholic_Bev_Tobacco_Narcotics ///
+44*Clothing_Footwear ///
+51*Furnishing_Household_Equp ///
+26*Health ///
+46*Information_Comm ///
+43*Recreation_Culture ///
+25*Education ///
+65*Restaurant_Accomdation ///
+8*Insurance_Financial ///
+51*Personal_Care_Social_Protection)/394

*Generate Core_Inflation
gen core_inf = (core/L12.core - 1)*100

*Generate Graphs

twoway ///
    (line headline months, lcolor(navy) lwidth(medthick)) ///
    (line core_inf months, lcolor(maroon) lwidth(medthick)), ///
    ytitle("Percent") ///
    xtitle("") ///
    ylabel(-4(2)10, angle(horizontal)) ///
    legend(order(1 "Headline Inflation" ///
             2 "Core Inflation") ///
       rows(1) ///
       ring(0) ///
       position(12) ///
       size(medsmall) ///
       region(lstyle(none) fcolor(none))) ///
    graphregion(color(white))

twoway ///
    (line headline months if months>=tm(2019m1), lcolor(navy) lwidth(medthick)) ///
    (line core_inf months if months>=tm(2019m1), lcolor(maroon) lwidth(medthick)), ///
    ytitle("Percent") ///
    xtitle("") ///
    ylabel(-4(2)8, angle(horizontal)) ///
	text(7.5 751 "Headline Inflation", ///
    color(navy) size(medsmall)) ///
	text(5.5 768 "Core Inflation", ///
    color(maroon) size(medsmall)) ///
    legend(off) ///
    graphregion(color(white))

twoway ///
    (line headline months if months>=tm(2019m12), lcolor(navy) lwidth(medthick)) ///
    (line core_inf months if months>=tm(2019m12), lcolor(maroon) lwidth(medthick)), ///
    xscale(range(`=tm(2019m12)' (12) `=tm(2025m12)')) ///
    xlabel(`=tm(2019m12)' "2019m12" ///
           `=tm(2020m12)' "2020m12" ///
           `=tm(2021m12)' "2021m12" ///
           `=tm(2022m12)' "2022m12" ///
           `=tm(2023m12)' "2023m12" ///
           `=tm(2024m12)' "2024m12" ///
           `=tm(2025m12)' "2025m12", ///
		   angle("") labsize(small)) ///
    ytitle("Percent") ///
    xtitle("") ///
    ylabel(-4(2)8, angle(horizontal)) ///
    text(7.8 `=tm(2022m8)' "Headline Inflation", color(navy) size(medsmall)) ///
    text(5.8 `=tm(2024m1)' "Core Inflation", color(maroon) size(medsmall)) ///
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(color(white))
	
	graph save "$Inflation\output\figures\fig5A.gph", replace




