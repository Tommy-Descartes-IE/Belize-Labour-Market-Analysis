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
(line headline months if months>=tm(2019m12), ///
    lcolor(navy) lwidth(medthick)) ///
(line core_inf months if months>=tm(2019m12), ///
    lcolor(forest_green) lwidth(medthick)), ///
xscale(range(`=tm(2019m12)' `=tm(2025m12)')) ///
xlabel(`=tm(2019m12)' "Dec-2019" ///
       `=tm(2020m12)' "Dec-2020" ///
       `=tm(2021m12)' "Dec-2021" ///
       `=tm(2022m12)' "Dec-2022" ///
       `=tm(2023m12)' "Dec-2023" ///
       `=tm(2024m12)' "Dec-2024"  ///
	   `=tm(2025m12)' "Dec-2025", ///
       labsize(vsmall)) ///
ylabel(-4(2)8, angle(horizontal) labsize(vsmall)) ///
yline(0, lcolor(gs8) lwidth(thin)) ///
xtitle("") ///
title("Panel 2: Headline and Core Inflation", color(navy) size(medium) position(11)) ///
subtitle("December year-on-year", color(navy) size(small) position(11)) ///
ytitle("") ///
text(7.6 `=tm(2022m6)' "Headline inflation", ///
     color(navy) size(small)) ///
text(5.8 `=tm(2024m1)' "Core inflation", ///
     color(forest_green) size(small)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: Statistical Institute of Belize", ///
     size(vsmall) color(gs4))
	 
graph save "$Inflation\output\figures\fig5A.gph", replace

*************
*************
*OTHER GRAPHS
*************
*************

/* 

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

*/

*SECTORAL GRAPH
*----------------------------------------------------------------------------------
*----------------------------------------------------------------------------------

*********************************************************
*Create sector contribution variables
*Formula: contribution = weight_i*inflation_i / 1000
*********************************************************

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


*Calculate Sector Inflation Rates
tsset months

gen food_inf = 100*(Food_Non_Alcoholic_Bev/L12.Food_Non_Alcoholic_Bev - 1)
gen utilities_inf = 100*(Housing_Water_Electricity/L12.Housing_Water_Electricity - 1)
gen transport_inf = 100*(Transport/L12.Transport - 1)
gen hotels_inf = 100*(Restaurant_Accomdation/L12.Restaurant_Accomdation - 1)

*Generate Headline Inflation
gen headline = (All_Item/L12.All_Item - 1)*100


*Calculate Contributions

gen c_food = 258*food_inf/1000
gen c_utilities = 195*utilities_inf/1000
gen c_transport = 153*transport_inf/1000
gen c_hotels = 65*hotels_inf/1000

*Compute the Residual
gen c_others = headline - (c_food + c_utilities + c_transport + c_hotels)

* Consistency check
summ headline c_food c_utilities c_transport c_hotels c_others

*Generate the CPI variable
*Note: Since Headline is the same as CPI we create a new variable called CPI which has the same value as headline
gen cpi  = headline


*Create a year variables

gen year = year(dofm(months))

collapse (mean) ///
headline ///
c_food ///
c_utilities ///
c_transport ///
c_hotels ///
c_others ///
cpi, by(year)

drop if year==2018


*---------------------------------------------------
* 2. Stack positive and negative contributions
*---------------------------------------------------

foreach v in c_food c_utilities c_transport c_hotels c_other {
    gen pos_`v' = cond(`v'>0, `v', 0)
    gen neg_`v' = cond(`v'<0, `v', 0)
}

gen p0 = 0
gen p1 = p0 + pos_c_food
gen p2 = p1 + pos_c_utilities
gen p3 = p2 + pos_c_transport
gen p4 = p3 + pos_c_hotels
gen p5 = p4 + pos_c_other

gen n0 = 0
gen n1 = n0 + neg_c_food
gen n2 = n1 + neg_c_utilities
gen n3 = n2 + neg_c_transport
gen n4 = n3 + neg_c_hotels
gen n5 = n4 + neg_c_other

   
*---------------------------------------------------
* 3. Contribution graph
*---------------------------------------------------

local blue   "55 96 146"
local green  "112 173 71"
local gold   "237 201 72"
local red    "192 80 77"
local gray   "191 191 191"

format cpi %4.1f

twoway ///
(rbar p0 p1 year, barw(.95) color(gold%90) lcolor(white)) ///
(rbar p1 p2 year, barw(.95) color(purple%75) lcolor(white)) ///
(rbar p2 p3 year, barw(.95) color(red%100) lcolor(white)) ///
(rbar p3 p4 year, barw(.95) color(green%80) lcolor(white)) ///
(rbar p4 p5 year, barw(.95) color(gs10%90) lcolor(white)) ///
(rbar n0 n1 year, barw(.95) color(yellow%95) lcolor(white)) ///
(rbar n1 n2 year, barw(.95) color(purple%75) lcolor(white)) ///
(rbar n2 n3 year, barw(.95) color(red%85) lcolor(white)) ///
(rbar n3 n4 year, barw(.95) color(green%80) lcolor(white)) ///
(rbar n4 n5 year, barw(.95) color(gs10%60) lcolor(white)) ///
(line cpi year, lcolor(black) lwidth(medthick)) ///
(scatter cpi year, ///
      msymbol(none) ///
      mlabel(cpi) ///
      mlabposition(12) ///
      mlabsize(small) ///
      mlabcolor(black)), ///
xlabel(2019(1)2025, labsize(vsmall)) ///
ylabel(-4(2)8, angle(horizontal) grid glcolor(gs14) labsize(vsmall)) ///
yline(0, lcolor(gs8)) ///
xtitle("") ///
ytitle("Percent (%)") ///
title("Panel 1: Sectoral Contributions to Inflation", ///
color(navy) size(medium) position(11)) ///
subtitle("(In percent, period average, year on year)", ///
color(navy) size(small) position(11)) ///
yscale(range(-6 8)) ///
legend(order(1 "Food & Beverages" ///
             2 "Utilities" ///
             3 "Transport" ///
             4 "Hotels & Restaurants" ///
             5 "Other" ///
             11 "CPI") ///
       rows(1) ///
       position(6) ///
       ring(0) ///
       size(tiny) ///
	   region(lcolor(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: Statistical Institute of Belize and author's calculations.", ///
size(vsmall) color(gs4))

graph save "$Inflation\output\figures\fig5B.gph", replace



*MERGE

graph combine ///
"$Inflation\output\figures\fig5B.gph" ///
"$Inflation\output\figures\fig5A.gph", ///
rows(1) ///
imargin(zero) ///
graphregion(color(white)) 

graph save "$Inflation\output\figures\cpi.gph", replace



