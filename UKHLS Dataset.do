***********************************
******* UKHLS dataset
***********************************.

*Wave 1 interview.
use "C:\Users\Shaun\Desktop\Airway obstruction\Datasets\a_indresp.dta", clear
keep pidp a_jbnssec3_dv a_jbstat a_jlnssec3_dv 
sort pidp
save "C:\Temp\File0.dta", replace

use "C:\Users\Shaun\Desktop\Airway obstruction\Datasets\b_indresp_ns.dta", clear
keep pidp 
gen NURSE=1
sort pidp
save "C:\Temp\b_nurse.dta",replace

* Wave 2 interview.
* Aged 16+ with a cross-sectional weight (no proxies).
* 54597
use "C:\Users\Shaun\Desktop\Airway obstruction\Datasets\b_indresp.dta", clear
keep pidp b_psu b_strata b_agegr5_dv b_adstatus b_health  b_hcondno1 b_hcondno2 b_hcondno3 b_hcondno4 ///
b_hcondno5 b_hcondno6 b_hcondno7 b_hcondno8 ///
b_smever b_smnow b_ncigs b_smcigs b_smncigs b_aglquit b_smagbg b_sampst b_urban_dv b_sex b_dvage  b_sf1 b_indinus_xw ///
b_gor_dv b_jbnssec3_dv b_jbstat b_jlnssec3_dv b_sf1 b_scsf1 b_scsf2a b_ivfio 
count
generate urban2=-1
replace urban2=1 if b_urban_dv==1
replace urban2=2 if b_urban_dv==2
label define urbanlbl 1 "urban" 2 "rural"
label values urban2 urbanlbl
*Productive cases & take out proxy (50,645).
keep if b_adstatus==5
keep if b_dvage>=16
generate b_ag16g10=0
replace b_ag16g10=1 if inrange(b_dvage,16,24)
replace b_ag16g10=2 if inrange(b_dvage,25,34)
replace b_ag16g10=3 if inrange(b_dvage,35,44)
replace b_ag16g10=4 if inrange(b_dvage,45,54)
replace b_ag16g10=5 if inrange(b_dvage,55,64)
replace b_ag16g10=6 if inrange(b_dvage,65,74)
replace b_ag16g10=7 if inrange(b_dvage,75,124)
label define agelbl 1 "16-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65-74" 7 "75+"
label values b_ag16g10 agelbl
*Sample status.
keep if b_sampst==1
*Cross-sectional weight at Wave 2.
keep if b_indinus_xw>0 & b_indinus_xw!=.
sort pidp
merge 1:1 pidp using "C:\Temp\File0.dta"
keep if (_merge==1|_merge==3)
drop _merge
replace b_jbnssec3_dv=1 if (b_jbnssec3_dv<0 & a_jbnssec3_dv==1)
replace b_jbnssec3_dv=2 if (b_jbnssec3_dv<0 & a_jbnssec3_dv==2)
replace b_jbnssec3_dv=3 if (b_jbnssec3_dv<0 & a_jbnssec3_dv==3)
* Smoking: Pack-years.
* Smoking history module.
* Ever smoked (smever) (IF smever==1);(yes=28,052; no=22,643).
* Do you smoke now (smnow): based on smever=yes (yes=10,759); (no=17,289).
* Number of cigarettes a day (ncigs) (IF smever==1 & smnow==1): those smoking now (10,730).
* Ever smoked regularly (smcigs): (IF smever==1 & smnow==2)(11,843 = regularly)
* number of cigarettes smoked in past (smncigs)(11,805): (IF smever==1 & smnow==2  & smcigs==1)
* age stopped smoking (IF smever==1 & smnow==2  & smcigs==1).
* age first started smoking (if smever==1)
generate b_cigsta3=-8
replace b_cigsta3=1 if (b_smever==1 & b_smnow==1)
replace b_cigsta3=2 if (b_smever==1 & b_smnow==2 & b_smcigs==1)
replace b_cigsta3=3 if (b_smever==2)|(b_smever==1 & b_smnow==2 & inrange(b_smcigs,2,3))
label define smokelbl -8 "missing" 1 "current smoker" 2 "ex-smoker" 3 "never regular smoker"
label values b_cigsta3 smokelbl
generate packyrs=-5
* those who were regular smokers.
replace packyrs = (b_smncigs/20)*(b_aglquit - b_smagbg) if ///
(b_smever==1 & b_smnow==2 & b_smcigs==1) & (b_smncigs>=0) & (b_aglquit>= b_smagbg) 
* those who smoke now.
replace packyrs =(b_ncigs/20)*(b_dvage - b_smagbg) if (b_smever==1 & b_smnow==1) & (b_ncigs>=0)
replace packyrs = 0 if (b_smever==2)
replace packyrs = 0 if (b_smever==1 & b_smnow==2 & (b_smcigs==2|b_smcigs==3))
replace packyrs = (b_smncigs/20)*(b_aglquit - b_smagbg) if (b_smever==1 & b_smnow==2 & b_smcigs==1) ///
& (b_smncigs>=0) & (b_aglquit>= b_smagbg) 

sort pidp
merge 1:1 pidp using "C:\Temp\b_nurse.dta"
keep if _merge==1|_merge==3
replace NURSE=0 if NURSE==.
*Long-standing illness.
*Limiting long-standing illness.
*Self-rated health.
generate genhelf2a=-1
replace genhelf2a=0 if inrange(b_sf1,1,4)
replace genhelf2a=1 if b_sf1==5
sort pidp
keep pidp b_health b_ag16g10 b_sex b_dvage b_cigsta3 b_gor_dv packyrs b_urban_dv ///
b_jbnssec3_dv b_jbstat b_jlnssec3_dv a_jlnssec3_dv ///
b_psu b_strata b_sf1 b_scsf1 b_scsf2a b_ivfio genhelf2a urban2
save "C:\Temp\Temp_W2INTERVIEW.dta",replace

*Nurse visit at Wave 2.
use "C:\Users\Shaun\Desktop\Airway obstruction\Datasets\b_indresp_ns.dta", clear
keep pidp b_ethnic b_smever b_smnow ///
b_htok b_height b_lfout ///
b_hcond1_dv-b_hcond17_dv ///
b_ncigs b_smcigs b_smncigs   ///
b_htfevfvc b_fev1lln b_fev1pred b_fevzsc b_fev1cat1 b_fev1cat2 b_fvclln b_fvcpred b_fvczsc b_fvccat1 b_fvccat2 b_fev1fvclln /// 
b_fev1fvcp b_fev1fvczsc b_fev1fvccat1 b_fev1fvccat2 b_htfvc b_htfev b_htpef b_htfevfvc b_fev1lln  ///
b_bmival b_bmivg5 b_indnsus_lw b_indnsus_xw b_fev1fvccat1 b_omsysval b_region b_age b_medbi01-b_medbi21 b_medtyp3

* Cardiovascular disease.
generate cardio2 = (b_hcond4_dv==1)|(b_hcond5_dv==1)|(b_hcond6_dv==1)|(b_hcond7_dv==1)
* Respiratory medicine.
generate respmed2=0
replace respmed2=1 if inrange(b_medbi01,30101,31000)
replace respmed2=1 if inrange(b_medbi02,30101,31000)
replace respmed2=1 if inrange(b_medbi03,30101,31000)
replace respmed2=1 if inrange(b_medbi04,30101,31000)
replace respmed2=1 if inrange(b_medbi05,30101,31000)
replace respmed2=1 if inrange(b_medbi06,30101,31000)
replace respmed2=1 if inrange(b_medbi07,30101,31000)
replace respmed2=1 if inrange(b_medbi08,30101,31000)
replace respmed2=1 if inrange(b_medbi09,30101,31000)
replace respmed2=1 if inrange(b_medbi10,30101,31000)
replace respmed2=1 if inrange(b_medbi11,30101,31000)
replace respmed2=1 if inrange(b_medbi12,30101,31000)
replace respmed2=1 if inrange(b_medbi13,30101,31000)
replace respmed2=1 if inrange(b_medbi14,30101,31000)
replace respmed2=1 if inrange(b_medbi15,30101,31000)
replace respmed2=1 if inrange(b_medbi16,30101,31000)
replace respmed2=1 if inrange(b_medbi17,30101,31000)
replace respmed2=1 if inrange(b_medbi18,30101,31000)
replace respmed2=1 if inrange(b_medbi19,30101,31000)
replace respmed2=1 if inrange(b_medbi20,30101,31000)
replace respmed2=1 if inrange(b_medbi21,30101,31000)

* Merge with the Wave 2 Interview.
sort pidp
merge 1:1 pidp using "C:\Temp\Temp_W2INTERVIEW.dta"
keep if (_merge==1|_merge==3)

* Analytical sample (n=5936).
keep if inrange(b_region,1,2)
keep if inrange(b_age,40,190)
keep if inrange(b_lfout,1,3)
*keep if (b_hcond1_dv==0)  // asthma 
keep if (b_ivfio!=.)
keep if b_htok==1
keep if b_ethnic>0
keep if b_indnsus_xw>0
generate b_ethnic2=-1
replace b_ethnic2=1 if (b_ethnic==1|b_ethnic==2|b_ethnic==4)
replace b_ethnic2=2 if (b_ethnic==14|b_ethnic==15)
replace b_ethnic2=4 if (b_ethnic==12)
replace b_ethnic2=5 if (b_ethnic==5|b_ethnic==6|b_ethnic==7|b_ethnic==8|b_ethnic==17|b_ethnic==97)
replace b_ethnic2=5 if (b_ethnic==9|b_ethnic==10|b_ethnic==11|b_ethnic==13)
label define b_ethnic2lbl 1 "White" 2 "Black" 4 "SEAsia" 5 "Mixed/Other"
label values b_ethnic2 b_ethnic2lbl
* Bronchitis/emphysema.
generate b_copd = (b_hcond8_dv==1|b_hcond11_dv==1)
keep if inrange(b_ethnic2,1,5)
*Pack-years grouped.
*6 missing values.
generate b_packgrp=-5
replace b_packgrp=1 if inrange(packyrs,0,0.9999)
replace b_packgrp=2 if inrange(packyrs,1,19.9999)
replace b_packgrp=3 if inrange(packyrs,20,49.9999)
replace b_packgrp=4 if inrange(packyrs,50,199.9999)
replace b_packgrp=-1 if packyrs==-5
label define packlbl -1 "missing" 1 "0" 2 "1-19" 3 "20-49" 4 "50+"
label values b_packgrp packlbl

* Diabetes.
generate b_diabete2a=0
replace b_diabete2a=1 if (b_hcond14_dv==1)

keep pidp b_psu b_strata b_dvage b_ag16g10 b_sex b_health b_hcond1_dv b_hcond14_dv b_lfout b_htfvc ///
b_htfev b_htfevfvc b_ethnic b_ethnic2 b_height b_bmival b_bmivg5 b_fevzsc b_fev1fvczsc b_fvczsc ///
b_indnsus_xw b_fev1fvccat1 b_cigsta3 packyrs b_urban_dv b_jbnssec3_dv ///
b_jbstat b_jlnssec3_dv a_jlnssec3_dv b_sf1 b_scsf1 b_scsf2a b_fev1fvcp b_fev1pred b_fvcpred ///
b_omsysval b_copd b_packgrp b_diabete2a respmed2 genhelf2a urban2 cardio2
sort pidp
duplicates report pidp
save "C:\Temp\W2_UKHLS_toR.dta",replace

use "C:\Temp\W2_UKHLS_toR.dta",clear
generate sex = b_sex
generate age = b_dvage
generate ethnic = b_ethnic2
rename pidp id
generate height = b_height
generate fev1 = b_htfev
generate fvc = b_htfvc 
generate fev1fvc = b_htfevfvc
generate fev075 = 0
generate fev075fvc = 0
generate fef2575 = 0
generate fef75 = 0
recode age (91/100 = 90)
sort id
duplicates report id
keep id sex age height ethnic fev1 fvc fev1fvc fev075 fev075fvc fef2575 fef75
order id sex age height ethnic fev1 fvc fev1fvc fev075 fev075fvc fef2575 fef75
export delimited using "C:\Users\Shaun\Desktop\Airway obstruction\P V.5.8.13/LF_TO_R.csv", nolabel replace

*rm()
*setwd("C:/Users/Shaun/Desktop/Airway obstruction/P V.5.8.13")
*data<-read.table("LF_TO_R.csv",header=TRUE,sep=",")
*data
*source("RFileCalculator.r")
*write.csv(output,"LF_TO_R_output.csv")

clear
insheet using "C:/Users/Shaun/Desktop/Airway obstruction/P V.5.8.13/LF_TO_R_output.csv", comma
duplicates report id

generate sex51 = sex
generate fev1fvcpercentpred =  (fev1fvc / fev1fvcpred) * 100

drop sex age height ethnic fev1 fvc fev075fvc fef2575 fef75
drop fev1fvc fev075 fev075pred fev075z fev075lln fev075fvcpred fev075fvcz fev075fvclln ///
fef2575pred fef2575z fef2575lln fef75pred fef75z fef75lln 

keep id sex51 fev1pred fev1z fev1percentpred fev1lln fvcpred fvcz fvcpercentpred ///
fvclln fev1fvcpred fev1fvcz fev1fvclln fev1fvcpercentpred

*do not conflict with Wave2 US variable names.
rename id pidp
save "C:\Temp\UKHLS_LFvars.dta", replace

* Final step.
use "C:\Temp\W2_UKHLS_toR.dta",clear
sort pidp
merge 1:1 pidp using "C:\Temp\UKHLS_LFvars.dta"
keep if (_merge==1|_merge==3)

*Analytical sample = 5,936.
*UKHLS variables have b_XXXXX.
*Correlation between the Z-scores.
pwcorr fev1z b_fevzsc
pwcorr fvcz b_fvczsc 
pwcorr fev1fvcz b_fev1fvczsc 

* Severity using FTs.
generate FTgrade=-2
replace FTgrade=0 if (b_htfevfvc >= 0.70)
replace FTgrade=1 if (b_htfevfvc < 0.70) & (b_fev1pred>=80.00)
replace FTgrade=2 if (b_htfevfvc < 0.70) & inrange(b_fev1pred,50.000,79.999)
replace FTgrade=3 if (b_htfevfvc < 0.70) & inrange(b_fev1pred,0.001,49.999)
label define FTgradelbl 0 "No_COPD" 1 "Mild" 2 "Moderate" 3 "Severe"
label values FTgrade FTgradelbl

* Severity using LLN.
generate LLNgrade=-2
replace LLNgrade=0 if (fev1fvcz > -1.645) 
replace LLNgrade=1 if (fev1fvcz < -1.645) & (fev1z > -1.645)
replace LLNgrade=2 if (fev1fvcz < -1.645) & (fev1z < -1.645)
label define LLNgradelbl 0 "No_LLN" 1 "FEV1>LLN" 2 "FEV1<LLN" 
label values LLNgrade LLNgradelbl

replace b_jbnssec3_dv=1 if (b_jbnssec3_dv==-8 & (a_jlnssec3_dv==1))
replace b_jbnssec3_dv=2 if (b_jbnssec3_dv==-8 & (a_jlnssec3_dv==2))
replace b_jbnssec3_dv=3 if (b_jbnssec3_dv==-8 & (a_jlnssec3_dv==3))
generate b_nssec32=0
replace b_nssec32=1 if (b_jbnssec3_dv==1)
replace b_nssec32=2 if (b_jbnssec3_dv==2)
replace b_nssec32=3 if (b_jbnssec3_dv==3)
replace b_nssec32=9 if (b_jbnssec3_dv==-8|b_jbnssec3_dv==-9)
label define nsseclbl 1 "Professional" 2 "Intermediate" 3 "Routine"
label values b_nssec32 nsseclbl 

generate b_bmicat52=-8
replace b_bmicat52=1 if inrange(b_bmival,18.5000,24.9999)
replace b_bmicat52=2 if inrange(b_bmival,25.0000,29.9999999)
replace b_bmicat52=3 if inrange(b_bmival,30.0000,39.9999)
replace b_bmicat52=4 if inrange(b_bmival,40.0000,139.9999)
label define BMIlbl -8 "missing" 1 "Normal" 2 "Overwt" 3 "Obese" 4 "Morbidly obese"
label values b_bmicat52 BMIlbl 

keep pidp b_sex b_dvage b_ag16g10 FTgrade b_indnsus_xw LLNgrade b_psu b_copd ///
b_cigsta3 b_packgrp b_nssec32 fev1percentpred fvcpercentpred fev1fvcpercentpred ///
b_bmicat52 b_diabete2a respmed2 genhelf2a urban2 cardio2 b_hcond1_dv

generate id = pidp
generate sex = b_sex
generate sample=2
generate age=b_dvage
generate ag16g10=b_ag16g10
generate wt_spiro2=b_indnsus_xw
generate point2=b_psu
generate copd2=b_copd
generate smoke2=b_cigsta3
generate packgrp2=b_packgrp
generate nssec32=b_nssec32
generate fev1percentpred2=fev1percentpred
generate fvcpercentpred2=fvcpercentpred
generate fev1fvcpercentpred2=fev1fvcpercentpred
generate bmicat52=b_bmicat52
generate diabete2a=b_diabete2a

keep id sample sex age ag16g10 FTgrade LLNgrade wt_spiro2 point2 copd2 smoke2 ///
packgrp2 nssec32 fev1percentpred2 fvcpercentpred2 fev1fvcpercentpred2 bmicat52 diabete2a respmed2 genhelf2a urban2 cardio2 b_hcond1_dv
save "C:\Temp\W2_UKHLS.dta",replace












 









 