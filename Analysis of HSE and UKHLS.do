***********************************************************
***Estimating population prevalence of potential airflow obstruction using
***different spirometric criteriaL a pooled cross-sectional analysis of 
***persons aged 40-95 years in England and Wales
** BMJ Open 2014:4;e005685.
***********************************************************

*The analytical sample comprised 7879 participants (5936 and 1943 from UKHLS and HSE, respectively) 
*aged 40–95 years, who resided in England and Wales, 
*did not report diagnosed asthma, had valid values of height and ethnicity and provided good-quality spirometry. 

use "C:\Temp\W2_UKHLS.dta",clear
append using "C:\Temp\HSE_2010_Data.dta"
label define samplelbl 1 "HSE" 2 "UKHLS"
label values sample samplelbl
tab1 sample

*Exclude asthma (main analysis)
keep if (sample==2 & b_hcond1_dv==0)|(sample==1 & asthma==3)
count

qui: summarize wt_spiro2 if (sample==1)
replace wt_spiro2 = wt_spiro2/r(mean) if (sample==1)
qui: summarize wt_spiro2 if (sample==2)
replace wt_spiro2 = wt_spiro2/r(mean) if (sample==2)
rename MRC2 mrc2

generate GOLD = inrange(FTgrade,1,3)
generate LLN = inrange(LLNgrade,1,2)

* Unweighted counts
recode ag16g10 (3=4)
tab1 sex ag16g10 smoke2 packgrp2 nssec32


*******************************************
*Table S1: variables by sample (HSE/UKHLS)
*******************************************

svyset [pweight=wt_spiro2],psu(point2)

tab1 sample
svy: tab sex sample, col
svy: tab ag16g10 sample, col
svy: mean age 
estat sd
svy:mean age if sample==1
estat sd
svy:mean age if sample==2
estat sd
svy: tab smoke2 sample, col
svy: tab packgrp2 sample if inrange(packgrp2,1,4), col
svy: tab nssec32 sample, col
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2
estat sd
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2 if sample==1
estat sd
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2 if sample==2
estat sd

************************************************
*Table 1: Prevalence
*Diagnosed COPD; FT; FT stage; LLN; LLN stage
***********************************************

* Diagnosed COPD.
svy: mean copd2
svy: mean copd2,over(sex)
svy: mean copd2,over(ag16g10)
svy: mean copd2,over(smoke2)
svy: mean copd2 if inrange(packgrp2,1,4),over(packgrp2)
svy: mean copd2,over(nssec32)

* FT (binary)
svy: mean GOLD
svy: mean GOLD,over(sex)
svy: mean GOLD,over(ag16g10)
svy: mean GOLD,over(smoke2)
svy: mean GOLD if inrange(packgrp2,1,4),over(packgrp2)
svy: mean GOLD,over(nssec32)

* LLN (binary)
svy: mean LLN
svy: mean LLN,over(sex)
svy: mean LLN,over(ag16g10)
svy: mean LLN,over(smoke2)
svy: mean LLN if inrange(packgrp2,1,4),over(packgrp2)
svy: mean LLN,over(nssec32)

*Severity using FTs.
generate FTmild = FTgrade==1
generate FTmoderate = FTgrade==2
generate FTsevere = FTgrade==3
svy:mean FTmild FTmoderate FTsevere
svy:mean FTmild FTmoderate FTsevere,over(sex)
svy:mean FTmild FTmoderate FTsevere,over(ag16g10)
svy:mean FTmild FTmoderate FTsevere,over(smoke2)
svy:mean FTmild FTmoderate FTsevere if inrange(packgrp2,1,4),over(packgrp2)
svy:mean FTmild FTmoderate FTsevere,over(nssec32)

*Severity using LLN.
generate LLNa = LLNgrade==1
generate LLNb = LLNgrade==2
svy:mean LLNa LLNb
svy:mean LLNa LLNb,over(sex)
svy:mean LLNa LLNb,over(ag16g10)
svy:mean LLNa LLNb,over(smoke2)
svy:mean LLNa LLNb if inrange(packgrp2,1,4),over(packgrp2)
svy:mean LLNa LLNb,over(nssec32)

***********************************************************************************
*Table 3 logistic and multinomial logistic regressions for reported diagnosed COPD
*and potential airflow obstruction using FTs and LLN spirometric criteria
***********************************************************************************

generate samptype=1
replace samptype=2 if sample==1
label define slbl 1 "UKHLS" 2 "HSE"
label values samptype slbl

*diagnosed COPD.
preserve
keep if packgrp2>=0
keep if inrange(nssec32,1,3)
svy:logit copd2 ib2.sex##i.ag16g10 i.packgrp2 i.nssec32 i.samptype,or
testparm 1.sex
testparm i.ag16g10
testparm i.packgrp2
testparm i.nssec32
test 5.ag16g10 6.ag16g10 7.ag16g10
testparm sex#ag16g10
margins sex#ag16g10
restore


*FTgrade.
preserve
keep if packgrp2>=0
keep if inrange(nssec32,1,3)
svy: mlogit FTgrade ib2.sex i.ag16g10 i.packgrp2 i.nssec32 ib1.samptype,rrr baseoutcome(0)
test [Mild]5.ag16g10 [Mild]6.ag16g10 [Mild]7.ag16g10
test [Moderate]5.ag16g10 [Moderate]6.ag16g10 [Moderate]7.ag16g10
test [Severe]5.ag16g10 [Severe]6.ag16g10 [Severe]7.ag16g10
test [Mild]2.packgrp2 [Mild]3.packgrp2 [Mild]4.packgrp2
test [Moderate]2.packgrp2 [Moderate]3.packgrp2 [Moderate]4.packgrp2
test [Severe]2.packgrp2 [Severe]3.packgrp2 [Severe]4.packgrp2
test [Mild]2.nssec32 [Mild]3.nssec32
test [Moderate]2.nssec32 [Moderate]3.nssec32
test [Severe]2.nssec32 [Severe]3.nssec32
restore

*LLngrade
preserve
keep if packgrp2>=0
keep if inrange(nssec32,1,3)
svy: mlogit LLNgrade ib2.sex i.ag16g10 i.packgrp2 i.nssec32 ib1.samptype,rrr baseoutcome(0)
test [FEV1_LLN]5.ag16g10 [FEV1_LLN]6.ag16g10 [FEV1_LLN]7.ag16g10
test [_eq_3]5.ag16g10 [_eq_3]6.ag16g10 [_eq_3]7.ag16g10
test [FEV1_LLN]2.packgrp2 [FEV1_LLN]3.packgrp2 [FEV1_LLN]4.packgrp2
test [_eq_3]2.packgrp2 [_eq_3]3.packgrp2 [_eq_3]4.packgrp2
test [FEV1_LLN]2.nssec32 [FEV1_LLN]3.nssec32
test [_eq_3]2.nssec32 [_eq_3]3.nssec32
restore

****************************************************************************
*Table 4 multinomial logistic regressions for combined outcome variable based 
*on diagnosed COPD and potential airflow obstruction using FTs and LLN
*spirometric criteria 
*****************************************************************************

*FT.
generate outcome=0
replace outcome=1 if (copd2==0) & FTgrade==0
replace outcome=2 if (copd2==1) & FTgrade==0
replace outcome=3 if (copd2==0) & inrange(FTgrade,1,3)
replace outcome=4 if (copd2==1) & inrange(FTgrade,1,3)

*LLN.
generate outcome4=0
replace outcome4=1 if (copd2==0) & LLNgrade==0
replace outcome4=2 if (copd2==1) & LLNgrade==0
replace outcome4=3 if (copd2==0) & inrange(LLNgrade,1,3)
replace outcome4=4 if (copd2==1) & inrange(LLNgrade,1,3)

*FT.
preserve
keep if (packgrp2>=0)
keep if inrange(nssec32,1,3)
svy:mlogit outcome ib2.sex i.ag16g10 i.packgrp2 i.nssec32 ib1.samptype,rrr baseoutcome(1)
test [2]5.ag16g10 [2]6.ag16g10 [2]7.ag16g10
test [2]2.packgrp2 [2]3.packgrp2 [2]4.packgrp2
test [2]2.nssec32 [2]3.nssec32 
test [3]5.ag16g10 [3]6.ag16g10 [3]7.ag16g10
test [3]2.packgrp2 [3]3.packgrp2 [3]4.packgrp2
test [3]2.nssec32 [3]3.nssec32 
test [4]5.ag16g10 [4]6.ag16g10 [4]7.ag16g10
test [4]2.packgrp2 [4]3.packgrp2 [4]4.packgrp2
test [4]2.nssec32 [4]3.nssec32 
restore

*LLN.
preserve
keep if (packgrp2>=0)
keep if inrange(nssec32,1,3)
svy:mlogit outcome4 ib2.sex i.ag16g10 i.packgrp2 i.nssec32 ib1.samptype,rrr baseoutcome(1)
test [2]5.ag16g10 [2]6.ag16g10 [2]7.ag16g10
test [2]2.packgrp2 [2]3.packgrp2 [2]4.packgrp2
test [2]2.nssec32 [2]3.nssec32 
test [3]5.ag16g10 [3]6.ag16g10 [3]7.ag16g10
test [3]2.packgrp2 [3]3.packgrp2 [3]4.packgrp2
test [3]2.nssec32 [3]3.nssec32 
test [4]5.ag16g10 [4]6.ag16g10 [4]7.ag16g10
test [4]2.packgrp2 [4]3.packgrp2 [4]4.packgrp2
test [4]2.nssec32 [4]3.nssec32 
restore


***********************
*Table 2.
***********************

generate BTS = inrange(FTgrade,2,3)

*Analysis 1 (FT: LLN as reference standard).
svy:tab GOLD LLN if (ag16g10==4|ag16g10==5),count

*Analysis 2 (FT: LLN as reference standard).
svy:tab GOLD LLN if (ag16g10==6|ag16g10==7),count

*Analysis 3 (LLN: FT as reference standard).
svy:tab LLN GOLD if (ag16g10==4|ag16g10==5),count

*Analysis 4 (FT as reference standard).
svy:tab LLN GOLD if (ag16g10==6|ag16g10==7),count

*Analysis 5 (BTS: LLN as reference standard).
svy:tab BTS LLN if (ag16g10==4|ag16g10==5),count

*Analysis 6 (BTS: LLN as reference standard).
svy:tab BTS LLN if (ag16g10==6|ag16g10==7),count

*Analysis 7 (LLN: BTS as reference standard).
svy:tab LLN BTS if (ag16g10==4|ag16g10==5),count

*Analysis 8 (LLN as reference standard).
svy:tab LLN BTS if (ag16g10==6|ag16g10==7),count

***********************************************
*Table S2: variables by outcome: exclude asthma
************************************************

*all participants
svy:mean copd2
svy:tab sex
svy:tab ag16g10
svy:mean age
estat sd
svy:tab smoke2
svy:tab packgrp2 if inrange(packgrp2,1,4)
svy:tab nssec32

*diagnosed COPD.
preserve
svy:tab copd2
svy:tab sex copd2,col 
svy:tab ag16g10 copd2,col 
svy:mean age,over(copd2)
estat sd
svy:tab smoke2 copd2,col
svy:tab packgrp2 copd2 if inrange(packgrp2,1,4), col 
svy:tab nssec32 copd2,col 
restore

*FT
preserve
svy:tab FTgrade
svy:tab sex FTgrade,col 
svy:tab ag16g10 FTgrade,col 
svy:mean age,over(FTgrade)
estat sd
svy:tab smoke2 FTgrade,col
svy:tab packgrp2 FTgrade if inrange(packgrp2,1,4), col 
svy:tab nssec32 FTgrade,col 
restore

*LLN
preserve
svy:tab LLNgrade
svy:tab sex LLNgrade,col 
svy:tab ag16g10 LLNgrade,col 
svy:mean age,over(LLNgrade)
estat sd
svy:tab smoke2 LLNgrade,col
svy:tab packgrp2 LLNgrade if inrange(packgrp2,1,4), col 
svy:tab nssec32 LLNgrade,col 
restore

***********************************************
*Table S3: variables by outcome: exclude asthma
************************************************

* MRC dyspnoea.
recode mrc2 (5=3)
mvencode mrc2, mv(-1)
mvdecode mrc2,mv(-1)
mvdecode mrc2,mv(0)

*BMI.
recode bmicat52 (4=3)
mvdecode bmicat52, mv(-8)


*all participants
svy:tab sample
svy:tab passive2 if passive2>0  /* HSE only */
svy:mean expsm                  /* HSE only */
estat sd  
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2
estat sd
*comorbidities
svy:tab compm8 
svy:tab symptoms if symptoms>=0
svy:tab respmed2
svy:tab cardio2
svy:tab diabete2a
svy:tab genhelf2a if genhelf2a>=0
svy:tab mrc2
svy:tab urban2 if urban2>=0
svy:tab bmicat52

*by copd
svy:tab sample copd2,col
svy:tab passive2 copd2 if passive2>0, col  /* HSE only */
svy:mean expsm,over(copd2)                /* HSE only */
estat sd  
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2,over(copd2)
estat sd
*comorbidities
svy:tab compm8 copd2,col 
svy:tab symptoms copd2 if symptoms>=0, col
svy:tab respmed2 copd2, col
svy:tab cardio2 copd2, col
svy:tab diabete2a copd2, col
svy:tab genhelf2a copd2 if genhelf2a>=0, col
svy:tab mrc2 copd2, col
svy:tab urban2 copd2 if urban2>=0, col
svy:tab bmicat52 copd2, col

*by FTgrade
svy:tab sample FTgrade,col
svy:tab passive2 FTgrade if passive2>0, col  /* HSE only */
svy:mean expsm,over(FTgrade)                /* HSE only */
estat sd  
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2,over(FTgrade)
estat sd
*comorbidities
svy:tab compm8 FTgrade,col 
svy:tab symptoms FTgrade if symptoms>=0, col
svy:tab respmed2 FTgrade, col
svy:tab cardio2 FTgrade, col
svy:tab diabete2a FTgrade, col
svy:tab genhelf2a FTgrade if genhelf2a>=0, col
svy:tab mrc2 FTgrade, col
svy:tab urban2 FTgrade if urban2>=0, col
svy:tab bmicat52 FTgrade, col


*by LLNgrade
svy:tab sample LLNgrade,col
svy:tab passive2 LLNgrade if passive2>0, col  /* HSE only */
svy:mean expsm,over(LLNgrade)                /* HSE only */
estat sd  
svy: mean fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2,over(LLNgrade)
estat sd
*comorbidities
svy:tab compm8 LLNgrade,col 
svy:tab symptoms LLNgrade if symptoms>=0, col
svy:tab respmed2 LLNgrade, col
svy:tab cardio2 LLNgrade, col
svy:tab diabete2a LLNgrade, col
svy:tab genhelf2a LLNgrade if genhelf2a>=0, col
svy:tab mrc2 LLNgrade, col
svy:tab urban2 LLNgrade if urban2>=0, col
svy:tab bmicat52 LLNgrade, col

***********************************
** Figure S3: including those with asthma
******************************************

use "C:\Temp\W2_UKHLS.dta",clear
append using "C:\Temp\HSE_2010_Data.dta"
label define samplelbl 1 "HSE" 2 "UKHLS"
label values sample samplelbl
*keep if (sample==2 & b_hcond1_dv==0)|(sample==1 & asthma==3)
count

qui: summarize wt_spiro2 if (sample==1)
replace wt_spiro2 = wt_spiro2/r(mean) if (sample==1)
qui: summarize wt_spiro2 if (sample==2)
replace wt_spiro2 = wt_spiro2/r(mean) if (sample==2)
generate GOLD = inrange(FTgrade,1,3)
generate LLN = inrange(LLNgrade,1,2)

generate a = (sample==2 & b_hcond1_dv==0)|(sample==1 & asthma==3)

svyset [pweight=wt_spiro2],psu(point2)

*Diagnosed COPD.
svy,subpop(a): mean copd2,over(sex)
svy: mean copd2,over(sex)
*FT.
svy,subpop(a): mean GOLD,over(sex)
svy: mean GOLD,over(sex)
*BTS.
generate BTS = inrange(FTgrade,2,3)
svy,subpop(a): mean BTS,over(sex)
svy: mean BTS,over(sex)
*LLN.
svy,subpop(a): mean LLN,over(sex)
svy: mean LLN,over(sex)


library(epiR)
# Aged 40-64 (FT: LLN as standard).
dat<-as.table(matrix(c(655.1,254.6,16.94,4702),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (FTL LLN as standard).
dat<-as.table(matrix(c(356.6,484.9,0,1408),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (LLN: FT as standard).
dat<-as.table(matrix(c(655.1,16.94,254.6,4702),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (LLN: FT as standard).
dat<-as.table(matrix(c(356.6,0,484.9,1408),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (BTS: LLN as standard).
dat<-as.table(matrix(c(341.2,64.84,330.8,4892),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (BTS: LLN as standard).
dat<-as.table(matrix(c(261.5,167.7,95.04,1726),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (LLN: BT as standard).
dat<-as.table(matrix(c(341.2,330.8,64.84,4892),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (LLN: BT as standard).
dat<-as.table(matrix(c(261.5,95.04,167.7,1726),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)





































