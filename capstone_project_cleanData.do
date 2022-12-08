**********************************************************************************************************
*** Data Cleaning NSDUH 2017, 2019, 2020                                                               ***
**********************************************************************************************************
*** capstone_project_cleanData version 1 - November 2022
*** uses clean_NSDUH 
*** Assumes clean_NSDUH saved in $temp 
*** Assumes data files NSDUH_*Year*.dta saved in $temp
*** Logs in $temp/capstone_project_cleanData.log
*** Creates $temp/NSDUH_*Year*_clean.dta
*** Combined clean data file $temp/NSDUH.dta
***
*** Project builds on project from PUBL 607 Spring 2021 which included data cleaned by classmates including
*** Shadi and Tangur Ringoir
***
*** Variables Cleaned:
/** Demographics:
*** speakengl - Respondent's English Fluency
*** medicare - Respondent's Medicare Coverage
*** caidchip - Respondent's Medicaid/CHIP Coverage
*** prvhltin - Respondent's Private Health Insurance Coverage
*** health - Respondent's Overall Health Status (Self Reported)
*** sexident - Respondent's Sexual Identity
*** irmarit - Marital Status
*** service - Military Service
*** eduhighcat - Education Level
*** WRKSTATWK2 - Work Situation in the last week 
*** POVERTY3 - Family income relative to poverty thersholds
***
*** NEWRACE2
***/
/** Alcohol Use
*** alcever: did individual ever drink alcohol?
*** alctry: age at which individual first drank alcohol
*** alcmdays: # of days individual drank alcohol in the past month
*** alcydays: # of days individual drank alcohol in the past year
*** aldaypmo: average # of days per month individual drank alcohol in past year
*** ALCUS30D: usual # of drinks on a drinking day (in past month)
*** ALCBNG30D: # of days individual had >= 4 (>= 5 if male) drinks in past month*/
/** Alcohol Abuse
*** alclottm - SPENT MONTH/MORE GETTING/DRNKG ALC PAST 12 MOS
*** alcgtovr - MONTH+ SPENT GETTING OVER ALC EFFECTS PST 12 MOS
*** alclimit - SET LIMITS ON ALCOHOL USE PAST 12 MONTHS
*** alcndmor - NEEDED MORE ALC TO GET SAME EFFECT PST 12 MOS
*** alcsefx - DRNKG SAME AMT ALC HAD LESS EFFECT PAST 12 MOS
*** alccutdn - WANT/TRY TO CUT DOWN/STOP DRNKG PAST 12 MOS
*** alccutev - ABLE TO CUT/STOP DRNKG EVERY TIME PAST 12 MOS
*** ALCCUT1X1 - CUT DOWN OR STOP DRNKG AT LEAST ONCE PAST 12 MOS
*** ALCWD2SX1 - HAD 2+ ALC WITHDRAWAL SYMPTOMS PST 12 MOS
*** alcwdsmt - HAD 2+ ALC WDRAW SYM AT SAME TIME PST 12 MOS
*** alcemopb - ALC CAUSE PRBS WITH EMOT/NERVES PAST 12 MOS
*** alcemctd - CONTD TO DRINK ALC DESPITE EMOT PRBS
*** alcphlpb - ANY PHYS PRBS CAUSED/WORSND BY ALC PST 12 MOS
*** alcphctd - CONTD TO DRINK ALC DESPITE PHYS PRBS
*** alclsact  - LESS ACTIVITIES B/C OF ALC USE PAST 12 MOS
*** alcserpb - ALC CAUSE SERS PRBS AT HOME/WORK/SCH PST 12 MOS
*** alcpdang  - DRNK ALC AND DO DANGEROUS ACTIVITIES PST 12 MOS
*** alclawtr - DRNK ALC CAUSE PRBS WITH LAW PAST 12 MOS
*** alcfmfpb - DRNK ALC CAUSE PRBS W/FAMILY/FRIENDS PST 12 MOS
*** alcfmctd -  CONTD TO DRINK ALC DESPITE PRBS W/ FAM/FRNDS
*** alckplmt - ABLE TO KEEP LIMITS OR DRANK MORE PAST 12 MOS
***/
/** Marijuana Use
*** mjever - EVER USED MARIJUANA/HASHISH
*** mjage - AGE WHEN FIRST USED MARIJUANA/HASHISH
*** mrjmdays - # OF DAYS USED MARIJUANA IN PAST MONTH
*** mrjydays - # OF DAYS USED MARIJUANA IN PAST YEAR
***/ 
/** Time since last use 
*** alcrec - TIME SINCE LAST DRANK ALCOHOLIC BEVERAGE
*** mjrec -  TIME SINCE LAST USED MARIJUANA/HASHISH
***/
/** Marijuana Abuse
*** mrjlottm - SPENT MONTH/MORE GETTING/USING MJ PAST 12 MOS
*** mrjgtovr - MONTH+ SPENT GETTING OVER MJ EFFECTS PST 12 MOS
*** mrjlimit - SET LIMITS ON MARIJUANA USE PAST 12 MONTHS
*** mrjkplmt - ABLE TO KEEP LIMITS OR USE MORE MJ PAST 12 MOS
*** mrjndmor - NEEDED MORE MJ TO GET SAME EFFECT PST 12 MOS
*** mrjlsefx - USING SAME AMT MJ HAD LESS EFFECT PAST 12 MOS
*** mrjcutdn - WANT/TRY TO CUT DOWN/STOP USING MJ PST 12 MOS
*** mrjcutev - ABLE TO CUT/STOP USING MJ EVERY TIME PST 12 MOS
*** mrjemopb - MJ CAUSE PRBS WITH EMOT/NERVES PAST 12 MOS
*** mrjemctd - CONTD USING MARIJUANA DESPITE EMOT PRBS
*** mrjphlpb - ANY PHYS PRBS CAUSED/WORSND BY MJ PST 12 MOS
*** mrjphctd - CONTD TO USE MARIJUANA DESPITE PHYS PRBS
*** mrjlsact - LESS ACTIVITIES B/C OF MJ USE PAST 12 MOS
*** mrjserpb - MJ CAUSE SERS PRBS AT HOME/WORK/SCH PST 12 MOS
*** mrjdang - USING MJ AND DO DANGEROUS ACTIVITIES PST 12 MOS
*** mrjlawtr - USING MJ CAUSE PRBS WITH LAW PAST 12 MOS
*** mrjfmfpb - USING MJ CAUSE PRBS W/FAMILY/FRIENDS PST 12 MOS
*** mrjfmctd - CONTD TO USE MJ DESPITE PRBS W/ FAM/FRNDS
***/
/** Variables Created:
*** year - year of data file (2017, 2019, 2020)
*** postPandemic - indicator variable, 1 if 2020 data
*** white - "NonHispanic White"
*** black - "NonHispanic Black/African American"
*** native - "NonHispanic Native American/Alaskan Native"
*** pacific - "NonHispanic Native Hawaiian/Other Pacific Islander"
*** asian - "NonHispanic Asian"
*** mix - "NonHispanic more than one race"
*** hispanic - "Hispanic"
*** female - indicator variable, 1 if female 
*** reportid - new id that concatinates QUESTID2 with the year of the report */
*** 
*** Questions in "Quotations" are from the codebook ***

clear all
capture log close
log using "$temp/capstone_project_cleanData.log", replace

**********************************************************************************************************
*** Cleaning 2017                                                                                      ***
**********************************************************************************************************
use "$temp/NSDUH_2017.DTA", clear
do "$temp/clean_NSDUH.do"
save "$temp/NSDUH_2017_clean.DTA", replace


**********************************************************************************************************
*** Cleaning 2019                                                                                      ***
**********************************************************************************************************
clear all
use "$temp/NSDUH_2019.DTA", clear
do "$temp/clean_NSDUH.do"
gen year=2019
append using "$temp/NSDUH_2017_clean.DTA"
replace year=2017 if year==.
gen postPandemic=0
save "$temp/NSDUH_2019_clean.dta", replace


**********************************************************************************************************
*** Cleaning 2020                                                                                      ***
**********************************************************************************************************
clear all
//error saying no room to add more variables when attempting to append, resetting maxvar per suggestion in error message
//moved here because doesn't work later
set maxvar 6000
use "$temp/NSDUH_2020.DTA", clear
rename SPEAKENGL MEDICARE CAIDCHIP PRVHLTIN HEALTH SEXIDENT IRMARIT SERVICE EDUHIGHCAT ALCEVER ALCTRY ALCMDAYS ALCDAYS ALDAYPMO ALCLOTTM ALCGTOVR ALCLIMIT ALCNDMOR ALCCUTDN ALCCUTEV ALCWDSMT ALCEMOPB ALCEMCTD ALCPHLPB ALCPHCTD ALCLSACT ALCSERPB ALCPDANG ALCLAWTR ALCFMFPB ALCFMCTD ALCKPLMT ALCREC ALCYDAYS ALCLSEFX MJEVER MJAGE MRJMDAYS MRJYDAYS MJREC MRJLOTTM MRJGTOVR MRJLIMIT MRJKPLMT MRJNDMOR MRJLSEFX MRJCUTDN MRJCUTEV MRJEMOPB MRJEMCTD MRJPHLPB MRJPHCTD MRJLSACT MRJSERPB MRJLAWTR MRJFMFPB MRJFMCTD MRJPDANG CATAGE INCOME GOVTPROG IRSEX, lower
 
do "$temp/clean_NSDUH.do"
//in 2020 file QUESTID is long, in previous years string, converting in order to append data successfully
tostring QUESTID, replace

append using "$temp/NSDUH_2019_clean.DTA"
replace year=2020 if year==.
replace postPandemic=1 if postPandemic==.
save "$temp/NSDUH_2020_clean.dta", replace


**********************************************************************************************************
*** Create Demographic Indicator Variables                                                             ***
**********************************************************************************************************
gen white = 0
replace white = 1 if NEWRACE2 == 1
label variable white "NonHispanic White"
label values white yesno
gen black = 0
replace black = 1 if NEWRACE2 == 2
label variable black "NonHispanic Black/African American"
label values black yesno
gen native = 0
replace native = 1 if NEWRACE2 == 3
label variable native "NonHispanic Native American/Alaskan Native"
label values native yesno
gen pacific = 0
replace pacific = 1 if NEWRACE2 == 4
label variable pacific "NonHispanic Native Hawaiian/Other Pacific Islander"
label values pacific yesno
gen asian = 0
replace asian = 1 if NEWRACE2 == 5
label variable asian "NonHispanic Asian"
label values asian yesno
gen mix = 0
replace mix = 1 if NEWRACE2 == 6
label variable mix "NonHispanic more than one race"
label values mix yesno
gen hispanic = 0
replace hispanic = 1 if NEWRACE2 == 7
label variable hispanic "Hispanic"
label values hispanic yesno

label define races 1 "White" 2 "Black/African American" 3 "Native American/Alaskan Native" 4 "Native Hawaiian/Other Pacific Islander" 5 "Asian" 6 "More that one race, NonHispanic" 7 "Hispanic"
label values NEWRACE2 races

gen female = 0
replace female = 1 if irsex == 2
label variable female "Female Indicator"
label define sexlabel 0 "Male" 1 "Female"
label values female sexlabel
tab female

***unique identifer
//Codebook indicates that IDs might be reused year to year. since there are multiple years of data, need to check for duplicate ids
duplicates report QUESTID2
//there are duplicates. let's create a new id that concatinates the questid with the year of the report
egen reportid = concat(QUESTID2 year)
//and to confirm we have unique ids
duplicates report reportid

save "$temp/NSDUH.dta", replace
//clear all
//capture log close
