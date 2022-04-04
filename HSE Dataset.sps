* Encoding: UTF-8.

dataset close all.
GET FILE="C:\Users\Shaun\Desktop\Airway obstruction\Datasets\hse10ai.sav"
/keep pserial sex age htok htval hifev1 hifvc fev1fvc wt_spiro origin qualspiro nuroutc sha urban imd2007 
cigsta3 condr ag16g10 lfoutc lungsurg lungeye lunghrt lunghosp pregntj copd cluster psu wt_nurse symas 
fev1fvccat1 fev1fvccat2 wt_int usespiro grader qadone eqv3 topqual3
asthma copdd copd fleus frefl coufam frcof cigsta3 numsmok smokyrs startsmk cigdyal bmival wemwbs lastfort
everkidd docinfo2 illsm1 illsm2  illsm3 illsm4 illsm5 illsm6 omsysval diabete2
medbi01 medbi02 medbi03 medbi04 medbi05 medbi06 medbi07 medbi08 medbi09 medbi10 
psu cluster expsm givupsk limitill longill limitact estht soc2000b nssec3 nssec5 genhelf genhelf2 bmivg5 medcnjd cholval mrc
lstyrsob sobup sobag solev sobhouse sobdress
cholval cholval1 hdlval hdlval1 medtyp3.
missing values all ().
exe.
select if nuroutc=81 & age>=40 & htok=1 & any(asthma,1,2,3).
exe.
* Refusals for spirometry data.
RECODE lfoutc  ( 7 THRU 7 =1) (8  THRU 9 =2)  (6 =3) (10 =3) (4 thru 5=4) (1 thru 3=5)  (97  thru 99 = -99) (else= copy)  INTO lfoutnew.
miss val lfoutnew (-99 thru -1).
VAR LAB lfoutnew 'Lung Function into new categories'.
val labels lfoutnew
1 ' Refused '
2 ' Ineligible '
3 ' Other not attempted '
4 'Attempted but poor quality '
5 ' Adequate quality spirometry obtained'.
exe.
select if lfoutnew=5.
EXECUTE.
compute ethnic=-1.
if any(origin,1,2,3) ethnic=1.
if any(origin,12,13,14) ethnic=2.
if origin=15 ethnic=4.
if any(origin,8,9,10,11) ethnic=5.
if any(origin,4,5,6,7,16) ethnic=5.
val labels ethnic
1 "White"
2 "Black"
3 "NEAsia"
4 "SEAsia"
5 "Mixed/other".
select if range(ethnic,1,5).
exe.
compute packyrs=-5.
if (cigsta3=2) packyrs=(numsmok/20)*smokyrs.
if (cigsta3=1) packyrs=(cigdyal/20)*(age-startsmk).
if (cigsta3=3) packyrs=0.
exe.
compute packgrp=-1.
if range(packyrs,0,0.9999) packgrp=1.
if range(packyrs,1.0000,19.9999) packgrp=2.
if range(packyrs,20,49.9999) packgrp=3.
if range(packyrs,50,199.9999) packgrp=4.
if cigsta3=2 & any(numsmok,-8,-9) packgrp=-1.
if cigsta3=2 & any(smokyrs,-8,-9) packgrp=-1.
var label packgrp "Pack year smoked".
val labels packgrp
-1 "missing"
1 "0"
2 "1-19"
3 "20-49"
4 "50+".
EXECUTE.
compute bmicat52=-8.
if bmivg5=1 bmicat52=-8.
if bmivg5=2 bmicat52=1.
if bmivg5=3 bmicat52=2.
if bmivg5=4 bmicat52=3.
if bmivg5=5 bmicat52=4.
exe.
val labels bmicat52
-8 "missing"
1 "normal"
2 "overweight"
3 "obese"
4 "morbidly obese".
EXECUTE.

*Presence of respiratory symptoms.
*Respiratory symptoms.
*coughs first thing in the morning; for at least 3 months a year; brings up phlegm from chest most days for at 3 consecutive months.
compute symptoms=1.
if coufam<0 symptoms=-8.
if fleus<0 symptoms=-8.
if (coufam=1 & frcof=1 & frefl=1) symptoms=2.
val labels symptoms
-8 "missing"
1 "no symptoms"
2 "symptoms".
EXECUTE.
* MRC breathlessness scale.
compute MRC2 =-8. 
if any(lstyrsob,-9,-8,-1) and any(sobup,-9,-8,-1) and sobag=-8 and solev=-8 MRC2 =-1. 
if lstyrsob=1 and any(sobup,-9,-8,-1,2,3,4) and any(sobag,-8,-1,2,3) and any(solev,-8,-1,2) and any(sobhouse,-1,2) and any(sobdress,-1,2) MRC2 =0. 
if lstyrsob=2 MRC2 =1. 
if sobup=1 MRC2=2. 
if sobag=1 or solev=1 MRC2=3. 
if sobhouse=1 or sobdress=1 MRC2=5. 
recode MRC2 (-8=-1). 
execute. 
value labels MRC2 
0 "Some unspecified shortness of breath" 
1 "MRC grade 1 in last 12 months" 
2 "MRC grade 2" 
3 "MRC grade 3/4" 
5 "MRC grade 5". 
variable labels MRC2 '(D) MRC breathlessness scale'.
exe.
* Diabetes.
compute diabete2a=0.
if diabete2=1 diabete2a=1.
val labels diabete2a
0 "No"
1 "Yes".
EXECUTE.
DO REPEAT xcomp=compm1 compm2 compm3 compm4 compm5 compm6 compm7 compm8 compm9 compm10 compm11 compm12 compm13 compm14 compm15 compm17 compm18. 
COMPUTE xcomp=0. 
IF (longill<0) xcomp=-9. 
END REPEAT. 
DO REPEAT xill=illsm1 illsm2 illsm3 illsm4 illsm5 illsm6. 
IF (xill=1) compm1=1. 
IF (RANGE(xill,2,3)) compm2=1. 
IF (RANGE(xill,4,5)) compm3=1. 
IF (RANGE(xill,6,8)) compm4=1. 
IF (RANGE(xill,9,10)) compm5=1. 
IF (RANGE(xill,11,14)) compm6=1.
IF (RANGE(xill,15,21)) compm7=1. 
IF (RANGE(xill,22,25)) compm8=1. 
IF (RANGE(xill,26,29)) compm9=1. 
IF (RANGE(xill,30,33)) compm10=1. 
IF (xill=39) compm11=1. 
IF (RANGE(xill,34,36)) compm12=1. 
IF (xill=37) compm13=1. 
IF (xill=38) compm14=1. 
IF (xill=40) compm15=1. 
IF (longill = 1 & xill = 42) compm18 = 1 . 
END REPEAT. 
IF (longill = 2) compm17 = 1. 
COMPUTE compm99 = 0 . 
IF (longill = 1 & ANY(illsm1,41,42,-1,-8,-9)) compm99 = 1 . 
IF (longill<0) compm99 = -9. 
VARIABLE LABELS compm1 '(D) II Neoplasms & benign growths' 
/compm2 '(D) III Endocrine & metabolic' 
/compm3 '(D) V Mental disorders' 
/compm4 '(D) VI Nervous System' 
/compm5 '(D) VI Eye complaints' 
/compm6 '(D) VI Ear complaints' 
/compm7 '(D) VII Heart & circulatory system' 
/compm8 '(D) VIII Respiratory system' 
/compm9 '(D) IX Digestive system' 
/compm10 '(D) X Genito-urinary system' 
/compm11 '(D) XII Skin complaints' 
/compm12 '(D) XIII Musculoskeletal system' 
/compm13 '(D) I Infectious Disease' 
/compm14 '(D) IV Blood & related organs' 
/compm15 '(D) Other complaints' 
/compm17 "(D) No long-standing Illness" 
/compm18 "(D) No longer present" 
/compm99 "(D) Unclass/NLP/inadeq.describe" . 
VALUE LABELS compm1 TO compm99 0 'no condition present' 1 'has condition'. 
RECODE compm1 TO compm15 (SYSMIS=0).
exe.
var label compm8 "Respiratory Disease".
exe.
*Respiratory medicine.
*(30101; 31000).
*BNF codes.
*Chapter 3 (BNF codes).
compute genhelf2a=-1.
if genhelf2=1 genhelf2a=0.
if genhelf2=2 genhelf2a=0.
if genhelf2=3 genhelf2a=1.
val labels genhelf2a
0 "Good"
1 "Bad/very bad".
EXECUTE.
compute passive2=-1.
if expsm=0 passive2=1.
if range(expsm,1,9) passive2=2.
if range(expsm,10,109) passive2=3.
val labels passive2
1 "0"
2 "1-9"
3 "10+".
EXECUTE.
compute urban2=-1.
if urban=1 urban2=1.
if range(urban,2,3) urban2=2.
val labels urban2
1 "urban"
2 "rural".
EXECUTE.
* cardiovascular disease.
compute cardio2=0.
if range(illsm1,15,16) cardio2=1.
if range(illsm2,15,16) cardio2=1.
if range(illsm3,15,16) cardio2=1.
if range(illsm4,15,16) cardio2=1.
if range(illsm5,15,16) cardio2=1.
if range(illsm6,15,16) cardio2=1.
val labels cardio2
0 "not mentioned"
1 "mentioned".
exe.
sort cases pserial.
exe.
*no report of asthma.
*sel if asthma=3.
*exe.
save outfile = "C:\Temp\HSE_2010_DATA.sav"
/keep pserial htval hifev1 hifvc fev1fvc sex age ethnic ag16g10 wt_spiro psu copd cigsta3 
packyrs packgrp nssec3 nssec5 bmicat52 symptoms mrc2 diabete2a compm8 medtyp3 
genhelf2a passive2 expsm urban2 cardio2 asthma.

dataset close all.
get file = "C:\Temp\HSE_2010_DATA.sav".
compute id=pserial.
compute height=htval.
compute fev1=hifev1.
compute fvc=hifvc.
compute fev075=0.
compute fev075fvc=0.
compute fef2575=0.
compute fef75=0.
exe.
sort cases id.
exe.
recode age (91=90) (92=90).
exe.
SAVE TRANSLATE OUTFILE='C:\Users\Shaun\Desktop\Airway obstruction\P V.5.8.13\HSE_2010_DATA_TO_R.csv'
  /TYPE=CSV
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES
/keep id sex age height ethnic fev1 fvc fev1fvc fev075 fev075fvc fef2575 fef75.

*rm()
*setwd("C:/Users/Shaun/Desktop/Airway obstruction/P V.5.8.13")
*data<-read.table("HSE_2010_DATA_TO_R.csv",header=TRUE,sep=",")
*data
*source("RFileCalculator.r")
*write.csv(output,"HSE_2010_DATA_TO_R_output.csv")

dataset close all.
GET DATA
  /TYPE=TXT
  /FILE="C:/Users/Shaun/Desktop/Airway obstruction/P V.5.8.13/HSE_2010_DATA_TO_R_output.csv"
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  V1 F3.0
  id F9.0
  sex F1.0
  age F2.0
  height F5.1
  ethnic F1.0
  fev1 F7.5
  FEV1Pred F16.14
  FEV1Z F8.2
  FEV1PercentPred F16.13
  FEV1LLN F16.14
  fvc F7.5
  FVCPred F16.14
  FVCZ F8.2
  FVCPercentPred F16.13
  FVCLLN F16.14
  fev1fvc F7.5
  FEV1FVCPred F17.15
  FEV1FVCZ F8.2
  FEV1FVCLLN F17.15
  fev075 F1.0
  FEV075Pred F16.14
  FEV075Z F17.12
  FEV075LLN F16.14
  fev075fvc F1.0
  FEV075FVCPred F17.15
  FEV075FVCZ F17.14
  FEV075FVCLLN F17.15
  fef2575 F1.0
  FEF2575Pred F16.14
  FEF2575Z F17.14
  FEF2575LLN F17.15
  fef75 F1.0
  FEF75Pred F17.15
  FEF75Z A17
  FEF75LLN A18.
CACHE.
EXECUTE.
compute FEV1FVCPercentPred =  (fev1fvc / FEV1FVCPred) * 100.
compute pserial=id.
sort cases pserial.
exe.
save outfile = "C:\Temp\HSE_2010_LFvars.sav"
/keep pserial FEV1Pred FEV1Z FEV1PercentPred FEV1LLN FVCPred FVCZ FVCPercentPred FVCLLN 
fev1fvc FEV1FVCPred FEV1FVCZ  FEV1FVCLLN FEV1FVCPercentPred.

* HSE dataset to match UKHLS.


dataset close all.
GET FILE= "C:\Temp\HSE_2010_DATA.sav".
sort cases pserial.
match files/file=*/table = "C:\Temp\HSE_2010_LFvars.sav"/by pserial.
exe.
compute id=pserial.
compute sample=1.
exe.
* FTgrade.
compute FTgrade=-2.
if (fev1fvc >= 0.70) FTgrade=0.
if (fev1fvc < 0.70) & (FEV1PercentPred >= 80.0000) FTgrade=1.
if (fev1fvc < 0.70) & range(FEV1PercentPred,50.000,79.999) FTgrade=2.
if (fev1fvc < 0.70) & (FEV1PercentPred < 50.000) FTgrade=3.
value labels FTgrade
0 "No COPD"
1 "mild"
2 "moderate"
3 "severe".
exe.
compute LLNgrade=-2.
if (FEV1FVCZ > -1.645) LLNgrade=0.
if (FEV1FVCZ < -1.645) & (FEV1Z > -1.645) LLNgrade=1.
if (FEV1FVCZ < -1.645) & (FEV1Z < -1.645) LLNgrade=2.
val labels LLNgrade
0 "FEV1FVC > LLN"
1  "FEV1FVC < LLN but FEV1>LLN"
2  "FEV1FVC < LLN & FEV1<LLN".
EXECUTE.
compute wt_spiro2=wt_spiro.
compute point2=psu.
exe.
* Physician-diagnosed COPD.
compute copd2=0.
if copd=1 copd2=1.
var label copd2 "Physician-diagnosed COPD".
val labels copd2
0 "No"
1 "Yes".
exe.
compute smoke2=cigsta3.
compute packgrp2=packgrp.
exe.
compute nssec32=0.
if nssec3=1 nssec32=1.
if nssec3=2 nssec32=2.
if nssec3=3 nssec32=3.
if nssec3=99 nssec32=3.
if nssec3=-1 nssec32=9.
val labels nssec32 
1 "Professional"
2 "Intermediate"
3 "Routine/manual"
9 "Missing".
exe.
compute fev1percentpred2 =  FEV1PercentPred.
compute fvcpercentpred2 = FvcPercentPred.
compute fev1fvcpercentpred2 = FEV1fvcPercentPred.
exe.
compute respmed2=medtyp3.
exe.
SAVE TRANSLATE OUTFILE='C:\Temp\HSE_2010_Data.dta'
  /TYPE=STATA
  /VERSION=8
  /EDITION=SE
  /MAP
  /REPLACE
/keep id sample sex age ag16g10 FTgrade LLNgrade wt_spiro2 point2 copd2 smoke2 packgrp2 
nssec32 bmicat52 symptoms mrc2 diabete2a fev1percentpred2  fvcpercentpred2 fev1fvcpercentpred2 
compm8 respmed2 genhelf2a passive2 expsm urban2 cardio2 asthma.
































































































































































