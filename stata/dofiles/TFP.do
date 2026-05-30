********************************************************************************
*Belize Growth Decomposition
********************************************************************************

*SETUP

/* 
VARIABLE: rgdp 		------ Real GDP Constant Prices
		: labour	------ Employed Labour Force
		: hc		------ Human Capital Index (PWT)
		: gfcf		------ Gross Fixed Capital Formation
*/

********************************************************************************
*Import Raw Data
********************************************************************************


*Import the data
clear all
set more off

global project "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis\data\raw"


import excel "$project\tfp.xlsx", sheet("Sheet1") firstrow
browse

tsset year

*Estimate Capital Stock (Perpetual Inventory Method)
gen grgdp = (rgdp/L.rgdp)-1
summ grgdp if year>=1981

*Set the depreciation parameter of 
scalar delta = 0.05
scalar g = 0.042

*Recursive Capital accumulation
gen capital=.

replace capital = gfcf/(g+delta) if year==1980 /*This initializes the capital variable*/

forvalues i = 12/54 {
replace capital = (1-delta)*capital[`i'-1] + gfcf[`i'] in `i'
}

browse

*LOG VARIABLES
gen lny = ln(rgdp)
gen lnk = ln(capital)
gen lnl = ln(labour)
gen lnh = ln(hc)

*Generate Growth Rates
gen gy = 100*(lny-L.lny)
gen gk = 100*(lnk-L.lnk)
gen gl = 100*(lnl-L.lnl)
gen gh = 100*(lnh-L.lnh)

*ESTIMATE FACTOR SHARES
scalar alpha = 0.54 /*Labour Share is estimated at 46% */

*GROWTH ACCOUNTING DECOMPOSITION
gen contrib_k = alpha*gk

gen contrib_l = (1-alpha)*gl

gen contrib_h = (1-alpha)*gh

*ESTIMATE Total Factor Productivity Growth
gen tfp = gy - contrib_k - contrib_l - contrib_h

*Develop TFP Index
gen tfp_level = rgdp / ((capital^alpha)*((hc*labour)^(1-alpha)))

gen lntfp = ln(tfp_level)
gen gtfp = 100*(lntfp-L.lntfp)

*Verify Decomposition
gen check = contrib_k + contrib_l + contrib_h + tfp

corr gy check

*Drop years before 1990
drop if year <=1980

*CREATE CONTRIBUTION GRAPH
graph bar contrib_k contrib_l contrib_h tfp, ///
over(year,label(angle(90))) ///
bargap(-50) ///
stack ///
ylabel(-10(5)15,angle(horizontal) grid) ///
ytitle("Percentage points") ///
title("Belize: Growth Accounting Decomposition") ///
subtitle("Contributions to Real GDP Growth") ///
legend(order(1 "Physical Capital" 2 "Labour" 3 "Human Capital" 4 "TFP") row(1)) ///
graphregion(color(white))


*Export data from Stata
export excel year  contrib_k contrib_l contrib_h tfp using "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize_TFP.xls", sheet("Belize_TFP") firstrow(variables)

*Creat 5 year averages instead

*Create 5-year periods
gen period=.

replace period=1 if inrange(year,1981,1984)
replace period=2 if inrange(year,1985,1989)
replace period=3 if inrange(year,1990,1994)
replace period=4 if inrange(year,1995,1999)
replace period=5 if inrange(year,2000,2004)
replace period=6 if inrange(year,2005,2009)
replace period=7 if inrange(year,2010,2014)
replace period=8 if inrange(year,2015,2019)
replace period=9 if inrange(year,2020,2023)


label define periodlbl ///
1 "1981-84" ///
2 "1985-89" ///
3 "1990-94" ///
4 "1995-99" ///
5 "2000-04" ///
6 "2005-09" ///
7 "2010-14" ///
8 "2015-19" ///
9 "2020-23" 

label values period periodlbl

collapse (mean) contrib_k contrib_l contrib_h tfp gy, by(period)

graph bar contrib_k contrib_l contrib_h tfp, ///
over(period,label(labsize(small))) ///
stack ///
bargap(-70) ///
bar(1,color(navy%85) lcolor(white)) ///
bar(2,color(maroon%80) lcolor(white)) ///
bar(3,color(forest_green%85) lcolor(white)) ///
bar(4,color(orange%85) lcolor(white)) ///
ylabel(-4(1)9,angle(horizontal) grid glcolor(gs14)) ///
ytitle("Percent Points") ///
title("",color(navy) size(medium)) ///
subtitle("") ///
legend(order(1 "Physical Capital" 2 "Labour" 3 "Human Capital" 4 "TFP") ///
rows(1) size(vsmall) position(6) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(margin(zero) color(white)) ///
plotregion(color(white)) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.",size(vsmall))

*GRAPH2
gen zero = 0
gen y1 = contrib_k
gen y2 = y1 + contrib_l
gen y3 = y2 + contrib_h
gen y4 = y3 + tfp

twoway ///
(rbar zero y1 period, barw(.90) color(navy%85) lcolor(white)) ///
(rbar y1 y2 period, barw(.90) color(maroon%80) lcolor(white)) ///
(rbar y2 y3 period, barw(.90) color(forest_green%85) lcolor(white)) ///
(rbar y3 y4 period, barw(.90) color(orange%85) lcolor(white)) ///
(line gy period, lcolor(black) lwidth(medthick)), ///
xlabel(1 "1981-84" 2 "1985-89" 3 "1990-94" 4 "1995-99" ///
5 "2000-04" 6 "2005-09" 7 "2010-14" 8 "2015-19" 9 "2020-23", ///
labsize(small)) ///
ylabel(-4(1)9, angle(horizontal) grid glcolor(gs14)) ///
ytitle("Percent Points") ///
xtitle("") ///
legend(order(1 "Physical Capital" 2 "Labour" 3 "Human Capital" 4 "TFP") ///
rows(1) size(vsmall) position(6) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(margin(zero) color(white)) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", size(vsmall))

*GRAPH3

* Positive and negative components
foreach v in contrib_k contrib_l contrib_h tfp {
    gen pos_`v' = cond(`v'>0, `v', 0)
    gen neg_`v' = cond(`v'<0, `v', 0)
}

* Positive stacks
gen p0 = 0
gen p1 = p0 + pos_contrib_k
gen p2 = p1 + pos_contrib_l
gen p3 = p2 + pos_contrib_h
gen p4 = p3 + pos_tfp

* Negative stacks
gen n0 = 0
gen n1 = n0 + neg_contrib_k
gen n2 = n1 + neg_contrib_l
gen n3 = n2 + neg_contrib_h
gen n4 = n3 + neg_tfp

twoway ///
(rbar p0 p1 period, barw(.9) color(navy%95) lcolor(white)) ///
(rbar p1 p2 period, barw(.9) color(maroon%90) lcolor(white)) ///
(rbar p2 p3 period, barw(.9) color(forest_green%95) lcolor(white)) ///
(rbar p3 p4 period, barw(.9) color(orange%95) lcolor(white)) ///
(rbar n0 n1 period, barw(.9) color(navy%95) lcolor(white)) ///
(rbar n1 n2 period, barw(.9) color(maroon%90) lcolor(white)) ///
(rbar n2 n3 period, barw(.9) color(forest_green%95) lcolor(white)) ///
(rbar n3 n4 period, barw(.9) color(orange%95) lcolor(white)) ///
(line gy period, lcolor(black) lwidth(medthick)), ///
xlabel(1 "1981-84" 2 "1985-89" 3 "1990-94" 4 "1995-99" ///
5 "2000-04" 6 "2005-09" 7 "2010-14" 8 "2015-19" 9 "2020-23", ///
labsize(small)) ///
ylabel(-4(1)9, angle(horizontal) grid glcolor(gs14)) ///
yline(0, lcolor(gs8)) ///
xtitle("") ///
ytitle("Percentage") ///
legend(order(1 "Physical Capital" 2 "Labour" 3 "Human Capital" 4 "TFP" 9 "Growth") ///
rows(1) size(vsmall) position(6) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
xsize(8) ///
ysize(4) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", size(vsmall))

graph save "$project\output\figures\fig3.gph", replace



/***********************************************************************************************/
/***********************************************************************************************/
*LABOUR PRODUCTIVITY
/***********************************************************************************************/
/***********************************************************************************************/


generate labour1 = labour*1000
generate gdp_m = rgdp*1000000
gen labour_productivity = gdp_m/labour1

gen lp_growth = 100*(labour_productivity - L.labour_productivity)/L.labour_productivity

tsset year

tssmooth ma lp_ma = labour1, window(2 1 2)

twoway ///
(line labour1 year, lcolor(gs10)) ///
(line lp_ma year, lcolor(navy) lwidth(medthick))

tsline labour_productivity
tsline lp_growth gtfp

*========================================================*
* BELIZE: LABOUR PRODUCTIVITY VS TFP GROWTH
* Federal Reserve / IMF Style Figure
*========================================================*

global project1 "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis"

cd "$project1"
pwd


twoway ///
(line lp_growth year, ///
    lcolor(navy*0.9) ///
    lwidth(medthick) ///
    lpattern(solid)) ///
    (line gtfp year, ///
    lcolor(forest_green*0.9) ///
    lwidth(medthick) ///
    lpattern(solid)), ///
xlabel(1980(5)2025, labsize(medsmall)) ///
ylabel(-20(5)15, ///
angle(horizontal) ///
labsize(medsmall) ///
grid glcolor(gs14) glwidth(vthin)) ///
title("", ///
size(large) ///
color(navy)) ///
subtitle("", ///
size(medium) ///
color(gs6)) ///
xtitle("") ///
ytitle("Percent", ///
size(medium)) ///
text(13 2017 "Labour Productivity", ///
color(navy) size(medsmall)) ///
text(2 2018 "TFP Growth", ///
color(forest_green) size(medsmall)) ///
yline(0, lcolor(gs8) lwidth(thin)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
bgcolor(white) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", ///
size(vsmall) color(gs6))

graph save "$project1\output\figures\fig4.gph", replace
graph export "output\figures\fig4.png", replace width(3000)



/*
Title - Belize: Labour Productivity and TFP
Subtitle - Annual Percentage Growth
*/

*INCLUDE COVID-19
*========================================================*
* BELIZE: LABOUR PRODUCTIVITY AND TFP GROWTH
* Federal Reserve / IMF Style Figure
*========================================================*

twoway ///
(rarea 20 -20 year if year>=2020 & year<=2021, ///
    color(gs13%35) lcolor(none)) ///
(line lp_growth year, ///
    lcolor(navy*0.9) ///
    lwidth(medthick) ///
    lpattern(solid)) ///
(line gtfp year, ///
    lcolor(forest_green*0.9) ///
    lwidth(medthick) ///
    lpattern(solid)), ///
xlabel(1980(5)2025, ///
    labsize(medsmall)) ///
ylabel(-20(5)20, ///
    angle(horizontal) ///
    labsize(medsmall) ///
    grid ///
    glcolor(gs14) ///
    glwidth(vthin)) ///
title("Belize: Labour Productivity and TFP Growth", ///
    size(large) ///
    color(navy)) ///
subtitle("Annual percentage growth", ///
    size(medium) ///
    color(gs6)) ///
xtitle("") ///
ytitle("Percent", ///
    size(medium)) ///
text(13 2016 "Labour productivity", ///
    color(navy) ///
    size(medsmall)) ///
text(2 2017 "TFP growth", ///
    color(forest_green) ///
    size(medsmall)) ///
text(18 2020 "COVID-19", size(small)) ///
yline(0, ///
    lcolor(gs8) ///
    lwidth(thin)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
bgcolor(white) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", ///
    size(vsmall) ///
    color(gs6))

	
	
*******************************************************************
twoway ///
(rarea 20 -20 year if year>=2020 & year<=2021, ///
    color(gs13%35) lcolor(none)) ///
(line lp_growth year, ///
    lcolor(navy*0.9) ///
    lwidth(medthick)) ///
(line gtfp year, ///
    lcolor(forest_green*0.9) ///
    lwidth(medthick)), ///
xlabel(1980(5)2025, labsize(medsmall)) ///
ylabel(-20(5)20, angle(horizontal) grid glcolor(gs14)) ///
title("Belize: Labour Productivity and TFP Growth", ///
    size(large) color(navy)) ///
subtitle("Annual percentage growth", size(medium)) ///
xtitle("") ///
ytitle("Percent") ///
yline(0, lcolor(gs8)) ///
legend(order(2 "Labour productivity" 3 "TFP growth") ///
    rows(1) size(vsmall) position(6) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", ///
    size(vsmall))

*******************************************************************
gen ytop =20
gen ybottom =-20

twoway ///
(rarea ytop ybottom year if year>=2020 & year<=2021, color(gs13) lcolor(none)) ///
(line lp_growth year, lcolor(navy) lwidth(medthick)) ///
(line gtfp year, lcolor(maroon) lwidth(medthick)), ///
xlabel(1980(5)2025, labsize(medsmall)) ///
ylabel(-20(5)20, angle(horizontal) grid glcolor(gs14)) ///
title("Belize: Labour Productivity and TFP Growth", size(large) color(navy)) ///
subtitle("Annual percentage growth", size(medium)) ///
xtitle("") ///
ytitle("Percent") ///
yline(0, lcolor(gs8)) ///
legend(order(2 "Labour productivity" 3 "TFP growth") rows(1) size(vsmall) position(6) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", size(vsmall))

*---------------------------------------------------
* Fed-style productivity graph
*---------------------------------------------------

gen ytop = 15
gen ybottom = -15

twoway ///
(rarea ytop ybottom year if year>=2020 & year<=2021, ///
    color(gs14) lcolor(none)) ///
(line lp_growth year, ///
    lcolor(navy) lwidth(medthick)) ///
(line gtfp year, ///
    lcolor(forest_green) lwidth(medthick)), ///
xlabel(1980(5)2025, labsize(medsmall)) ///
ylabel(-15(5)15, angle(horizontal) grid glcolor(gs14)) ///
yline(0, lcolor(gs8) lwidth(thin)) ///
title("", ///
    size(medium) color(black)) ///
subtitle("", size(small) color(black)) ///
xtitle("") ///
ytitle("Percentage Point", size(medsmall)) ///
text(13 2017 "Labour productivity", color(navy) size(small)) ///
text(2 2017 "TFP growth", color(forest_green) size(small)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: Author's calculations using SIB, ILOSTAT and Penn World Table data.", ///
    size(vsmall) color(gs6))



