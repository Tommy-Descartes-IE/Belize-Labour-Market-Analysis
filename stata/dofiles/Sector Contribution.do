*Sector Contribution

*Set the Working Directory

clear all
set more off

global project "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis"
cd "$project\data\raw"
pwd
dir

*Import the raw dataset from excel
import excel "gdp_contribution.xlsx", sheet("Real GDP") firstrow

*STEP 1: GENERATE BRAOD SECTOR SHARES
gen s_primary = 100*PrimaryIndustries/GrossDomesticProduct
gen s_secondary = 100*SecondaryIndustries/GrossDomesticProduct
gen s_tertiary = 100*TertiaryIndustries/GrossDomesticProduct
gen s_taxes = 100*TaxesandSubsidies/GrossDomesticProduct

* Check that components add to 100
gen check = s_primary+s_secondary+s_tertiary+s_taxes

*FIGURE 1: Primary, Secondary, Tertiary and TaxesandSubsidies/GrossDomesticProduct

graph bar s_primary s_secondary s_tertiary s_taxes, ///
over(Year, label(angle(45) labsize(vsmall))) ///
stack ///
bar(1,color(forest_green%85) lcolor(white)) ///
bar(2,color(gs8%85) lcolor(white)) ///
bar(3,color(navy%80) lcolor(white)) ///
bar(4,color(gold%80) lcolor(white)) ///
ylabel(0(20)100, angle(horizontal) grid glcolor(gs14)) ///
ytitle("Share of Real GDP (%)") ///
title("Belize: Structural Transformation of the Economy", ///
color(navy) size(medium)) ///
subtitle("Primary, Secondary and Tertiary Sector Shares, 1980-2024") ///
legend(order(1 "Primary" 2 "Secondary" 3 "Tertiary" 4 "Taxes less subsidies") ///
rows(1) size(vsmall) position(6) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: SIB and author's calculations.", size(vsmall))

*FIGURE 2: Composition of Tertiary Sector
gen s_wholesale = 100*WholesaleandRetailTrade/GrossDomesticProduct
gen s_tourism   = 100*AccomodationandFoodServices/GrossDomesticProduct
gen s_transport = 100*Transport/GrossDomesticProduct
gen s_ict       = 100*InformationandCommunication/GrossDomesticProduct
gen s_finance   = 100*FinancialandInsuranceServices/GrossDomesticProduct
gen s_public    = 100*Publicadministrationanddefenc/GrossDomesticProduct
gen s_admin     = 100*Adminstrativeandsupportservic/GrossDomesticProduct

twoway ///
(line s_wholesale Year, lcolor(navy) lwidth(medthick)) ///
(line s_tourism Year, lcolor(maroon) lwidth(medthick)) ///
(line s_transport Year, lcolor(eltblue) lwidth(medthick)) ///
(line s_ict Year, lcolor(purple) lwidth(medthick)) ///
(line s_finance Year, lcolor(orange) lwidth(medthick)) ///
(line s_public Year, lcolor(forest_green) lwidth(medthick)) ///
(line s_admin Year, lcolor(gs8) lwidth(medthick)), ///
ylabel(0(5)25, angle(horizontal) grid glcolor(gs14)) ///
xlabel(1980(5)2024, angle(45) labsize(small)) ///
xtitle("") ///
ytitle("Share of Real GDP (%)") ///
title("Belize: Composition of the Services Economy", ///
color(navy) size(medium)) ///
subtitle("Selected tertiary sector shares, 1980-2024") ///
legend(order(1 "Wholesale & Retail" 2 "Tourism" 3 "Transport" ///
4 "ICT" 5 "Finance" 6 "Public Administration" ///
7 "Administrative Support") ///
rows(2) size(vsmall) position(6) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: SIB and author's calculations.", size(vsmall))


twoway ///
(line s_wholesale Year, lcolor(navy) lwidth(medthick)) ///
(line s_tourism Year, lcolor(maroon) lwidth(medthick)) ///
(line s_finance Year, lcolor(orange) lwidth(medthick)) ///
(line s_admin Year, lcolor(gs8) lwidth(medthick)) ///
(line s_ict Year, lcolor(purple) lwidth(medthick)), ///
ylabel(0(5)25, angle(horizontal) grid glcolor(gs14)) ///
xlabel(1980(5)2024, angle(45) labsize(small)) ///
xtitle("") ///
ytitle("Share of Real GDP (%)") ///
title("Belize: Evolution of Key Service Sectors", ///
color(navy) size(medium)) ///
subtitle("Wholesale, tourism, finance, ICT and administrative services") ///
legend(order(1 "Wholesale & Retail" 2 "Tourism" 3 "Finance" ///
4 "Administrative Support" 5 "ICT") ///
rows(1) size(vsmall) position(6) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: SIB and author's calculations.", size(vsmall))


*---------------------------------------------------------------------------------

*---------------------------------------------------
* Create sector shares
*---------------------------------------------------
clear all

set more off

global project "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis"
cd "$project\data\raw"
pwd
dir

*Import the raw dataset from excel
import excel "gdp_contribution.xlsx", sheet("Real GDP") firstrow



gen s_primary   = 100*PrimaryIndustries/GrossDomesticProduct
gen s_secondary = 100*SecondaryIndustries/GrossDomesticProduct
gen s_wholesale = 100*WholesaleandRetailTrade/GrossDomesticProduct
gen s_transport = 100*Transport/GrossDomesticProduct
gen s_public    = 100*Publicadministrationanddefenc/GrossDomesticProduct
gen s_tourism   = 100*AccomodationandFoodServices/GrossDomesticProduct
gen s_admin     = 100*Adminstrativeandsupportservic/GrossDomesticProduct
gen s_taxes     = 100*TaxesandSubsidies/GrossDomesticProduct

gen s_other = ///
100*TertiaryIndustries/GrossDomesticProduct ///
- s_wholesale ///
- s_transport ///
- s_public ///
- s_tourism ///
- s_admin


gen total = ///
s_primary+s_secondary+s_wholesale+s_transport+ ///
s_public+s_tourism+s_admin+s_taxes+s_other

summ total

*---------------------------------------------------
* Create 5-year periods
*---------------------------------------------------

gen period5=.
replace period5=1 if inrange(Year,1980,1984)
replace period5=2 if inrange(Year,1985,1989)
replace period5=3 if inrange(Year,1990,1994)
replace period5=4 if inrange(Year,1995,1999)
replace period5=5 if inrange(Year,2000,2004)
replace period5=6 if inrange(Year,2005,2009)
replace period5=7 if inrange(Year,2010,2014)
replace period5=8 if inrange(Year,2015,2019)
replace period5=9 if inrange(Year,2020,2024)

label define p5 ///
1 "1980-84" 2 "1985-89" 3 "1990-94" ///
4 "1995-99" 5 "2000-04" 6 "2005-09" ///
7 "2010-14" 8 "2015-19" 9 "2020-24"

label values period5 p5

*---------------------------------------------------
* Collapse to 5-year averages
*---------------------------------------------------

collapse (mean) s_primary s_secondary s_wholesale s_transport ///
s_public s_tourism s_admin s_taxes s_other, by(period5)

*---------------------------------------------------
* 100% stacked bar chart
*---------------------------------------------------

graph bar s_primary s_secondary s_wholesale s_transport ///
s_public s_tourism s_admin s_taxes s_other, ///
over(period5,label(labsize(small))) ///
stack ///
bargap(-60) ///
bar(1,color("70 110 145") lcolor(white)) ///
bar(2,color("116 140 82") lcolor(white)) ///
bar(3,color("140 140 140") lcolor(white)) ///
bar(4,color("145 190 220") lcolor(white)) ///
bar(5,color("125 150 145") lcolor(white)) ///
bar(6,color("170 95 95") lcolor(white)) ///
bar(7,color("155 90 170") lcolor(white)) ///
bar(8,color("230 195 40") lcolor(white)) ///
bar(9,color("220 150 95") lcolor(white)) ///
ylabel(0(20)100,angle(horizontal) grid glcolor(gs14)) ///
ytitle("Share of Real GDP (%)") ///
title("", ///
color(navy) size(medium)) ///
subtitle("") ///
legend(order(1 "Primary Sector" 2 "Secondary Sector" ///
3 "Wholesale & Retail" 4 "Transport" ///
5 "Public Administration" 6 "Accommodation & Food" ///
7 "Administrative Services" 8 "Taxes less subsidies" ///
9 "Other Services") ///
rows(3) size(vsmall) position(6) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: SIB and author's calculations.",size(vsmall))

graph bar s_primary s_secondary s_wholesale s_transport ///
s_public s_tourism s_admin s_taxes s_other, ///
over(period5,label(labsize(small))) ///
stack ///
asyvars ///
bargap(-30) ///
bar(1,color("70 110 145") lcolor(white)) ///
bar(2,color("116 140 82") lcolor(white)) ///
bar(3,color("140 140 140") lcolor(white)) ///
bar(4,color("145 190 220") lcolor(white)) ///
bar(5,color("125 150 145") lcolor(white)) ///
bar(6,color("170 95 95") lcolor(white)) ///
bar(7,color("155 90 170") lcolor(white)) ///
bar(8,color("230 195 40") lcolor(white)) ///
bar(9,color("210 150 95") lcolor(white)) ///
ylabel(0(20)100,angle(horizontal) grid glcolor(gs13)) ///
ytitle("Share of Real GDP (%)") ///
legend(rows(3) size(vsmall) region(lstyle(none))) ///
graphregion(color(white)) ///
plotregion(color(white))

gen x = period5
gen zero = 0
gen y1 = s_primary
gen y2 = y1 + s_secondary
gen y3 = y2 + s_wholesale
gen y4 = y3 + s_transport
gen y5 = y4 + s_public
gen y6 = y5 + s_tourism
gen y7 = y6 + s_admin
gen y8 = y7 + s_taxes
gen y9 = y8 + s_other

twoway ///
(rbar zero y1 x, barw(.90) color("70 110 145") lcolor(white)) ///
(rbar y1 y2 x, barw(.90) color("116 140 82") lcolor(white)) ///
(rbar y2 y3 x, barw(.90) color("140 140 140") lcolor(white)) ///
(rbar y3 y4 x, barw(.90) color("145 190 220") lcolor(white)) ///
(rbar y4 y5 x, barw(.90) color("125 150 145") lcolor(white)) ///
(rbar y5 y6 x, barw(.90) color("170 95 95") lcolor(white)) ///
(rbar y6 y7 x, barw(.90) color("155 90 170") lcolor(white)) ///
(rbar y7 y8 x, barw(.90) color("230 195 40") lcolor(white)) ///
(rbar y8 y9 x, barw(.90) color("210 150 95") lcolor(white)), ///
xlabel(1 "1980-84" 2 "1985-89" 3 "1990-94" 4 "1995-99" ///
5 "2000-04" 6 "2005-09" 7 "2010-14" 8 "2015-19" 9 "2020-24", ///
labsize(small)) ///
ylabel(0(20)100,angle(horizontal) grid glcolor(gs13)) ///
ytitle("Share of Real GDP (%)") ///
xtitle("") ///
legend(order(1 "Primary Sector" 2 "Secondary Sector" 3 "Wholesale & Retail" ///
4 "Transport" 5 "Public Administration" 6 "Accommodation & Food" ///
7 "Administrative Services" 8 "Taxes less subsidies" 9 "Other Services") ///
rows(3) size(vsmall) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white))


***********************************************************************************
*Set the Working Directory

clear all
set more off

global project "C:\Users\desca\Documents\Island Economics\Consultancy\Belize-Labour-Assessment\Data\Belize-Labour-Market-Analysis"
cd "$project\data\raw"
pwd
dir

*Import the raw dataset from excel
import excel "gdp_contribution.xlsx", sheet("Real GDP") firstrow

tsset Year

* Contributions to real GDP growth
gen c_primary   = 100*(PrimaryIndustries - L.PrimaryIndustries)/L.GrossDomesticProduct
gen c_secondary = 100*(SecondaryIndustries - L.SecondaryIndustries)/L.GrossDomesticProduct
gen c_wholesale = 100*(WholesaleandRetailTrade - L.WholesaleandRetailTrade)/L.GrossDomesticProduct
gen c_transport = 100*(Transport - L.Transport)/L.GrossDomesticProduct
gen c_public    = 100*(Publicadministrationanddefenc - L.Publicadministrationanddefenc)/L.GrossDomesticProduct
gen c_tourism   = 100*(AccomodationandFoodServices - L.AccomodationandFoodServices)/L.GrossDomesticProduct
gen c_admin     = 100*(Adminstrativeandsupportservic - L.Adminstrativeandsupportservic)/L.GrossDomesticProduct
gen c_taxes     = 100*(TaxesandSubsidies - L.TaxesandSubsidies)/L.GrossDomesticProduct

***
gen other = TertiaryIndustries - WholesaleandRetailTrade - Transport - Publicadministrationanddefenc - AccomodationandFoodServices - Adminstrativeandsupportservic
gen c_other = 100*(other - L.other)/L.GrossDomesticProduct


* GDP growth line
gen gdp_growth = 100*(GrossDomesticProduct - L.GrossDomesticProduct)/L.GrossDomesticProduct

gen period5=.

replace period5=1 if inrange(Year,1981,1985)
replace period5=2 if inrange(Year,1986,1990)
replace period5=3 if inrange(Year,1991,1995)
replace period5=4 if inrange(Year,1996,2000)
replace period5=5 if inrange(Year,2001,2005)
replace period5=6 if inrange(Year,2006,2010)
replace period5=7 if inrange(Year,2011,2015)
replace period5=8 if inrange(Year,2016,2020)
replace period5=9 if inrange(Year,2021,2024)

label define p5 ///
1 "1981-85" ///
2 "1986-90" ///
3 "1991-95" ///
4 "1996-00" ///
5 "2001-05" ///
6 "2006-10" ///
7 "2011-15" ///
8 "2016-20" ///
9 "2021-24"

label values period5 p5

collapse (mean) ///
c_primary c_secondary c_wholesale c_transport c_public ///
c_tourism c_admin c_taxes c_other gdp_growth, ///
by(period5)


gen zero=0

gen p1 = c_primary
gen p2 = p1 + c_secondary
gen p3 = p2 + c_wholesale
gen p4 = p3 + c_transport
gen p5s = p4 + c_public
gen p6 = p5s + c_tourism
gen p7 = p6 + c_admin
gen p8 = p7 + c_taxes
gen p9 = p8 + c_other

twoway ///
(rbar zero p1 period5, barw(.9) color("70 110 145") lcolor(white)) ///
(rbar p1 p2 period5, barw(.9) color("116 140 82") lcolor(white)) ///
(rbar p2 p3 period5, barw(.9) color("140 140 140") lcolor(white)) ///
(rbar p3 p4 period5, barw(.9) color("145 190 220") lcolor(white)) ///
(rbar p4 p5s period5, barw(.9) color("125 150 145") lcolor(white)) ///
(rbar p5s p6 period5, barw(.9) color("170 95 95") lcolor(white)) ///
(rbar p6 p7 period5, barw(.9) color("155 90 170") lcolor(white)) ///
(rbar p7 p8 period5, barw(.9) color("230 195 40") lcolor(white)) ///
(rbar p8 p9 period5, barw(.9) color("210 150 95") lcolor(white)) ///
(line gdp_growth period5, lcolor(black) lwidth(medthick)), ///
xlabel(1 "1981-85" 2 "1986-90" 3 "1991-95" ///
4 "1996-00" 5 "2001-05" 6 "2006-10" ///
7 "2011-15" 8 "2016-20" 9 "2021-24", labsize(small)) ///
ylabel(-3(3)9, angle(horizontal) grid glcolor(gs14)) ///
xtitle("") ///
ytitle("Percentage points") ///
title("Sectoral Contributions to Real GDP Growth", color(navy) size(medium) position(11)) ///
subtitle("Five-year average contribution, percentage points") ///
legend(order(1 "Primary Sector" 2 "Secondary Sector" ///
3 "Wholesale & Retail" 4 "Transport" ///
5 "Public Administration" 6 "Accommodation & Food" ///
7 "Administrative Services" 8 "Taxes less subsidies" ///
9 "Other Services" 10 "GDP growth") ///
rows(3) size(vsmall) position(6) region(lstyle(none) fcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
note("Source: SIB and author's calculations.", size(vsmall))