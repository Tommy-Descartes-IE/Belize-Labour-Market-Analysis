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