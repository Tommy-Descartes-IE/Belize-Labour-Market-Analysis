* Belize Labour Force Study

* Economic Growth Analysis

clear
input year gr
1980 5
1981 0.2
1982 -7.6
1983 6.1
1984 11.3
1985 -1.4
1986 7.3
1987 22
1988 10.9
1989 15.5
1990 11.2
1991 11.8
1992 12.7
1993 6.1
1994 0
1995 0.7
1996 1.1
1997 4.2
1998 3.9
1999 9.4
2000 12.2
2001 5
2002 5.4
2003 9.7
2004 4.8
2005 2.2
2006 4.5
2007 3.3
2008 -1.6
2009 -0.4
2010 1.4
2011 -0.1
2012 3.9
2013 4.1
2014 3.9
2015 2.8
2016 0
2017 -1.8
2018 0.8
2019 4.3
2020 -13.5
2021 18
2022 9.3
2023 0.5
2024 3.5
2025 2.7
end

* Declare time series
tsset year

* 5-year moving average
tssmooth ma gr_ma = gr, window(2 1 2)

* IMF-style graph
twoway ///
(line gr year, ///
    lcolor(navy) ///
    lwidth(medthick) ///
    msymbol(O) ///
    msize(small) ///
    mcolor(navy)) ///
(line gr_ma year, ///
    lcolor(maroon) ///
    lwidth(medthick) ///
    lpattern(dash)) ///
, ///
yline(0, lcolor(gs10)) ///
title("", size(medsmall)) ///
subtitle("", size(small)) ///
xtitle("") ///
ytitle("Percent", size(small)) ///
xlabel(1980(5)2025, labsize(small)) ///
ylabel(-15(5)25, angle(horizontal) labsize(small)) ///
legend(order(1 "Annual growth" 2 "5-year moving average") ///
       position(6) rows(1) ///
       region(lcolor(none)) ///
       size(small)) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
scheme(s1color) ///
note("Source: Author's calculations." ///
     "Data: IMF World Economic Outlook database.", ///
     size(vsmall))

graph export "imf_growth_chart.png", replace width(2400)


* Graph 2

* Define boom/bust periods
gen boom1 = inrange(year, 1984, 1992)
gen boom2 = inrange(year, 1998, 2003)
gen boom3 = inrange(year, 2021, 2022)

gen bust1 = inrange(year, 1981, 1982)
gen bust2 = year == 1985
gen bust3 = inrange(year, 1994, 1996)
gen bust4 = inrange(year, 2008, 2011)
gen bust5 = year == 2017
gen bust6 = year == 2020



twoway ///
(area gr year if boom1, color(navy%20) base(0)) ///
(area gr year if boom2, color(navy%20) base(0)) ///
(area gr year if boom3, color(navy%20) base(0)) ///
(area gr year if bust1, color(maroon%25) base(0)) ///
(area gr year if bust2, color(maroon%25) base(0)) ///
(area gr year if bust3, color(maroon%25) base(0)) ///
(area gr year if bust4, color(maroon%25) base(0)) ///
(area gr year if bust5, color(maroon%25) base(0)) ///
(area gr year if bust6, color(maroon%25) base(0)) ///
(line gr year, ///
    lcolor(navy) lwidth(medthick) ///
    msymbol(O) msize(small) ///
    mcolor(white) mlcolor(navy)) ///
(line gr_ma year, ///
    lcolor(maroon) lwidth(medthick) ///
    lpattern(dash)), ///
yline(0, lcolor(gs10)) ///
title("") ///
subtitle("") ///
xtitle("") ///
ytitle("Percent") ///
xlabel(1980(5)2025) ///
ylabel(-15(5)25, angle(horizontal)) ///
legend(order(10 "Annual growth" 11 "5-year moving average" ///
             1 "Boom episodes" 4 "Bust episodes") ///
       position(6) rows(2) region(lcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
scheme(s1color) ///
note("Source: Author's calculations." ///
     "Data: IMF World Economic Outlook database." ///
     "Shaded areas identify selected boom and bust episodes.", ///
     size(vsmall))
	 
*========================================================*
* Real GDP Per Capita Convergence and Income Thresholds  *
*========================================================*

clear
input yr blz cos dom mau
1991 10136.62399 11973.92811 7045.354575 10504.2517
1992 10575.9294 12866.66323 7609.456252 11056.90371
1993 10853.38346 13615.88204 7978.144401 11187.00348
1994 10522.36207 14111.32438 8201.514007 11317.67782
1995 10342.89425 14289.5748 8538.873002 11651.77581
1996 10240.50624 13840.78502 8901.429685 12408.98063
1997 10138.33955 14352.5182 9616.908389 13076.95604
1998 10207.66596 13918.01665 10194.7911 14190.89948
1999 10636.3974 13700.02524 10518.40631 14441.33241
2000 11317.47535 13666.16831 10666.64368 15160.95853
2001 11231.16885 13878.00388 10886.69996 15392.1033
2002 11595.06699 13996.00923 11099.18089 16170.41572
2003 11651.36377 14341.09313 10496.26272 16158.25459
2004 11336.33049 14662.31725 10611.5263 16983.82345
2005 11110.42326 14966.41777 11533.43587 16256.354
2006 10693.18408 15829.28514 12432.2729 17084.2088
2007 11818.01356 16735.53184 13219.09182 18720.6748
2008 10978.9113 17085.97347 13269.10309 18367.58971
2009 9836.38728 16990.478 13653.46488 18053.57703
2010 10178.5952 17808.31148 14507.50451 17819.27476
2011 10695.86718 18235.70266 14493.37382 18028.66328
2012 10628.1085 19029.06482 14751.38549 19755.51362
2013 11024.3239 19188.64974 15146.23732 22269.51703
2014 11362.04124 19650.35081 16039.90039 23518.52426
2015 11833.90946 20470.28531 17504.8047 25589.24782
2016 11877.79988 21316.43983 18635.36948 27053.04882
2017 11740.87669 21691.00496 18977.3333 28289.0926
2018 11015.38471 21910.9313 20039.69994 29192.44389
2019 11208.10234 22169.80006 20828.58921 30033.16276
2020 9545.961387 21157.50654 19178.84796 25104.90206
2021 11340.36903 22320.32879 20958.23463 25356.67701
2022 11979.46149 22516.83682 21983.59575 24072.95133
2023 11807.98083 23745.78715 22794.44158 26729.549
2024 12098.05174 24652.65375 23475.95213 27929.71386
end

*-----------------------------*
* Income Threshold Bands
*-----------------------------*

gen low      = 0
gen lowmid   = 1145
gen upmid    = 4515
gen high     = 14005
gen ymax     = 32000

*-----------------------------*
* IMF / World Bank Style Graph
*-----------------------------*

twoway ///
(rarea lowmid low yr, ///
    color(red%8) lcolor(none)) ///
(rarea upmid lowmid yr, ///
    color(orange%10) lcolor(none)) ///
(rarea high upmid yr, ///
    color(navy%8) lcolor(none)) ///
(rarea ymax high yr, ///
    color(green%8) lcolor(none)) ///
(line blz yr, ///
    lcolor(navy) ///
    lwidth(thick) ///
    msymbol(O) ///
    msize(small) ///
    mcolor(white) ///
    mlcolor(navy)) ///
(line cos yr, ///
    lcolor(gs6) ///
    lwidth(thick)) ///
(line dom yr, ///
    lcolor(maroon) ///
    lwidth(thick)) ///
(line mau yr, ///
    lcolor(red%45) ///
    lwidth(thick)) ///
(function y = 14006, ///
    range(1991 2024) ///
    lpattern(dash) ///
    lcolor(black)), ///
title("") ///
subtitle("") ///
xtitle("") ///
ytitle("Constant International Dollars") ///
xlabel(1991(1)2024, labsize(small) angle(vertical)) ///
ylabel(0(5000)30000, angle(horizontal) labsize(small)) ///
text(700 1993 "Low income", ///
     color(red) size(vsmall)) ///
text(2800 1993 "Lower middle income", ///
     color(orange) size(vsmall)) ///
text(9000 1993 "Upper middle income", ///
     color(navy) size(vsmall)) ///
text(14500 1993 "High income", ///
     color(green) size(vsmall)) ///
legend(order(5 "Belize" ///
             6 "Costa Rica" ///
             7 "Dominican Republic" ///
             8 "Mauritius" ///
             9 "High-income threshold") ///
       rows(2) ///
       position(6) ///
       size(small) ///
       region(lcolor(none))) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
scheme(s1color) ///
note("Source: World Development Indicators." ///
     "Income thresholds based on World Bank income classifications." ///
	 "GNI per capita, PPP (constant 2021 international $)", ///
     size(vsmall))

graph export "belize_middle_income_trap.png", ///
    replace width(3000)