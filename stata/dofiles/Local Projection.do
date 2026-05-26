*Local Projection Method

*Clear
clear all

*Input the TFP calculations

input year	contrib_k	contrib_l	contrib_h	tfp
1991	4	1	1	5
1992	4	1	1	6
1993	4	1	1	0
1994	2	0	1	-3
1995	3	0	1	-3
1996	2	2	1	-3
1997	2	4	1	-2
1998	2	2	1	0
1999	3	3	1	3
2000	4	2	1	4
2001	3	2	0	-1
2002	3	-1	0	3
2003	2	2	0	5
2004	1	2	0	0
2005	2	2	0	-2
2006	2	2	0	1
2007	2	4	0	-3
2008	3	1	0	-6
2009	1	1	0	-3
2010	0	1	0	-1
2011	0	1	-1	-1
2012	0	1	-1	4
2013	1	1	-1	3
2014	1	2	-1	2
2015	1	2	-1	1
2016	2	2	0	-4
2017	1	1	0	-4
2018	1	3	0	-3
2019	1	2	0	1
2020	1	-1	0	-14
2021	2	2	0	14
2022	2	3	0	4
2023	2	1	0	-4
end


tsset year

*Disaggregate Labour contribution into male and female
scalar f_share = 0.45

gen female_labour = contrib_l

gen g_rgdp=100*(ln(rgdp)-ln(L.rgdp))
gen d_flfpr=female_lfpr-L.female_lfpr
gen g_inv=100*(ln(gfcf)-ln(L.gfcf))
gen g_hc=100*(ln(hc)-ln(L.hc))

forvalues h=0/5 {
    gen y`h'=F`h'.g_rgdp

    reg y`h' d_flfpr L.g_rgdp L.d_flfpr g_inv g_hc, robust

    matrix b=e(b)
    matrix V=e(V)

    gen irf`h'=b[1,"d_flfpr"] in 1
    gen se`h'=sqrt(V[1,1]) in 1
}