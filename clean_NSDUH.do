**********************************************************************************************************
*** Data Cleaning NSDUH                                                                                ***
*** References to NSDUH 2017 Codebook page numbers                                                     ***
**********************************************************************************************************
*** clean_NSDUH version 1 November 2022
*** Assumes data files NSDUH_*Year*.dta saved in $temp
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
*** mrjfmctd - CONTD TO USE MJ DESPITE PRBS W/ FAM/FRNDS*/

*** Questions in "Quotations" are from the codebook 


******************************************************
*** Demographics                                   ***
******************************************************
** speakengl - English Fluency - "How well do you speak English?" (CodeBook p545 (586))
tab speakengl, mi

replace speakengl = 5 if speakengl >= 5   
* Don't know, refused, etc

label define englishFluency 1 "Very well" 2 "Well" 3 "Not well" 4 "Not at all" 5 "Unknown"
label values speakengl englishFluency
label var speakengl "Respondent's English Fluency"

tab speakengl, mi

**create and label boolean (dummy indicator) version
** 1 if fluent - can speak English well or very well, 0 otherwise
gen speakengl_bool = 1
replace speakengl_bool = 0 if speakengl >= 3  

label define englishFluency_bool 0 "Otherwise" 1 "Well or Very Well" 
label values speakengl_bool englishFluency_bool
label var speakengl_bool "Respondent's English Fluency"

tab speakengl_bool

* creating 4 dummies for English fluency
gen english_well = 0
replace english_well = 1 if speakengl == 1 | speakengl == 2

gen english_poor = 0
replace english_poor = 1 if speakengl == 3

gen english_no = 0
replace english_no = 1 if speakengl == 4

gen english_NR = 0
replace english_NR = 1 if speakengl == 5


******************************************************
*** Insurance coverage (CodeBook p565 (606))       ***
******************************************************
** Medicare - 
tab medicare, mi

replace medicare = 3 if medicare > 2   
* Don't know, refused, etc

label define medicareCoverage 1 "Yes" 2 "No" 3 "Unknown"
label values medicare medicareCoverage
label var medicare "Respondent's Medicare Coverage"

tab medicare, mi

**create and label boolean (dummy indicator) version
** 1 if covered by Medicare, 0 otherwise

gen medicare_bool = 0
**assign values for other responses
replace medicare_bool = 1 if medicare == 1

label define medicareCoverage_bool 0 "Otherwise" 1 "Yes" 
label values medicare_bool medicareCoverage_bool
label var medicare_bool "Respondent's Medicare Coverage"

tab medicare_bool, mi

* creating non-response dummy
gen medicare_NR = 0
replace medicare_NR = 1 if medicare == 3

********************************************************
** Medicaid or CHIP - Is [SAMPLE MEMBER A] covered by Medicaid? Is [SAMPLE MEMBER A] currently covered by [CHIPFILL]?
********************************************************
tab caidchip, mi

replace caidchip = 3 if caidchip >  2   
* Don't know, refused, etc

label define medicaidchipCoverage 1 "Yes" 2 "No" 3 "Unknown"
label values caidchip medicaidchipCoverage
label var caidchip "Respondent's Medicaid/CHIP Coverage"

tab caidchip, mi

**create and label boolean (dummy indicator) version
** 1 if covered by Medicaid or CHIP, 0 otherwise

gen caidchip_bool = 0
**assign values for other responses
replace caidchip_bool = 1 if caidchip == 1

label define medicaidchipCoverage_bool 0 "Otherwise" 1 "Yes" 
label values caidchip_bool medicaidchipCoverage_bool
label var caidchip_bool "Respondent's Medicaid/CHIP Coverage"

tab caidchip_bool, mi

* creating non-response dummy
gen caidchip_NR = 0
replace caidchip_NR = 1 if caidchip == 3

********************************************************
** Private Insurance - "Is [SAMPLE MEMBER A] currently covered by private health insurance?"
********************************************************
tab prvhltin, mi

**create and label new variable for cleaned data
rename prvhltin private_insurance
replace private_insurance = 3 if private_insurance > 2   
* Don't know, refused, etc

label define private_insuranceCoverage 1 "Yes" 2 "No" 3 "Unknown"
label values private_insurance private_insuranceCoverage
label var private_insurance "Respondent's Private Health Insurance Coverage"

tab private_insurance, mi

**create and label boolean (dummy indicator) version
** 1 if covered by private insurance, 0 otherwise

gen private_insurance_bool = 1
replace private_insurance_bool = 0 if private_insurance >= 2

label define private_insuranceCoverage_bool 0 "Otherwise" 1 "Yes"
label values private_insurance_bool private_insuranceCoverage_bool 
label var private_insurance_bool "Respondent's Private Health Insurance Coverage"

tab private_insurance_bool, mi

* creating non-response dummy
gen private_insurance_NR = 0
replace private_insurance_NR = 1 if private_insurance == 3

******************************************************
** Overall Health Status (CodeBook p544 (585))
** "This question is about your overall health. Would you say your health in general is excellent, very good, good, fair, or poor?"
******************************************************
tab health, mi

replace health = 6 if health > 5   
* Don't know, refused, etc

label define healthLabel 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor" 6 "Unknown"
label values health healthLabel
label var health "Self Reported Overall Health Status"

tab health, mi

** create and label boolean (dummy indicator) version
** 1 if healthy - reported excellent, very good, or good, 0 otherwise

gen health_bool = 1
replace health_bool = 0 if health >= 4

label define healthLabel_bool 0 "Otherwise" 1 "Healthy"
label values health_bool healthLabel_bool
label var health_bool "Self Reported Overall Health Status"

tab health_bool, mi

* creating non-response dummy
gen health_NR = 0
replace health_NR = 1 if health == 6

******************************************************
** Sexual Identity (CodeBook p545 (586))
** "Which one of the following do you consider yourself to be?"
******************************************************
tab sexident, mi

replace sexident = 4 if sexident >  3   
* Don't know, refused, etc

label define sexual_identityLabel 1 "Heterosexual" 2 "Homosexual" 3 "Bisexual" 4 "Unknown"
label values sexident sexual_identityLabel
label var sexident "Sexual Identity"

tab sexident, mi

* creating an LGBT dummy
gen LGBT = 0
replace LGBT = 1 if sexident == 2 | sexident == 3
label define LGBT_label 0 "Heterosexual or Unknown" 1 "Homosexual or Bisexual"
label values LGBT LGBT_label

* creating non-response dummy
gen LGBT_NR = 0
replace LGBT_NR = 1 if sexident == 4

******************************************************
*** Marital Status (CodeBook p547 (588))           ***
******************************************************
tab irmarit, mi

rename irmarit marital_status
replace marital_status = 4 if marital_status == 99

label define marital_statusLabel 1 "Married" 2 "Widowed" 3 "Divorced or Separated" 4 "Never Been Married"
label values marital_status marital_statusLabel
label var marital_status "Marital Status"

** 1 indicates have been married before at some point - currently married, widowed, divorced, separated, 0 indicates never been married (skipped or unknown/refused seem to be NOT included in orginal variable)
gen marital_bool = 1
replace marital_bool = 0 if marital_status >= 4 

label define marital_boolLabel 0 "Never Been Married" 1 "Have Been or Currently Married"
label values marital_bool marital_boolLabel
label var marital_bool "Marital Status"

tab marital_bool, mi

******************************************************
*** Military Service (CodeBook p542 (583))         ***
******************************************************
tab service, mi

** create and label variable for cleaned data - boolean (dummy indicator) variable by nature of question, using boolean label to emphasize 
gen military_service_bool = 0
replace military_service_bool = 1 if service == 1

label define military_serviceLabel 0 "Otherwise" 1 "Have Served"
label values military_service_bool military_serviceLabel
label var military_service_bool "Ever Been in the US Armed Forces"

tab military_service_bool, mi

* creating non-response dummy
gen service_NR = 0
replace service_NR = 1 if service == 85
* I assume LEGITIMATE SKIP means they didn't serve (likely too young)

******************************************************
** Education Categories (CodeBook p549 (590))      ***
******************************************************
tab eduhighcat, mi 
**tab IREDUHIGHST2, mi    //CodeBook p547 (588) more granularity

** I don't see the need for further cleaning. I'll create an indicator for college graduates. _bool label to emphasize yes/no nature

** 1 indicates 4 year college degree, 0 otherwise
gen college_graduate_bool = 0
replace college_graduate_bool = 1 if eduhighcat == 4

label define collegeLabel 0 "Otherwise" 1 "College Graduate"
label values college_graduate_bool collegeLabel
label var college_graduate_bool "College Graduate"

tab college_graduate_bool, mi

******************************************************
** Work Situation in last Week CodeBook p555 (596) ***
******************************************************
tab WRKSTATWK2, mi

** This is very close to how I would clean it. The only difference is I would combine "Does not have a job, some other reason", BLANK, and "Legitimate Skip". Let's just do that. 
rename WRKSTATWK2 work_status
replace work_status = 9 if work_status >= 98

label define work_statusLabel 1 "Worked at full-time job, past week" 2 "Worked at part-time job, past week" 3 "Has job or volunteer worker, did not work" 4 "Unemployed/on layoff, looking for work" 5 "Disabled" 6 "Keeping house full-time" 7 "In school/training" 8 "Retired" 9 "Other"
label values work_status work_statusLabel
label var work_status "Work Situation in the Past Week"

tab work_status, mi

** We can create a boolean version in two ways - did you work outside the home last week (paid work full- or part-time, volunteered is 1, has job but didn't work and any other response 0)? or do you have a job outside the home (paid work full- or part-time, volunteered, has job but didn't work is 1, 0 otherwise)? 

** Did you work outside the home last week?
gen work_outside = 1
replace work_outside = 0 if work_status >= 3

label define work_outsideLabel 0 "No" 1 "Yes"
label values work_outside work_outsideLabel
label var work_outside "Did you work outside the home in the past week?"

tab work_outside, mi

** Last week did you have work outside the home?
gen have_work_outside = 1
replace have_work_outside = 0 if work_status >= 4

label values have_work_outside work_outsideLabel
label var have_work_outside "Last week, did you have work outside the home?"

tab have_work_outside, mi

******************************************************
** Poverty Level CodeBook p576 (617)
** family income relative to poverty thersholds
** per documentation, College Dorm residents do not have a valid value for this variable. Setting to 0 instead of missing
******************************************************
tab POVERTY3, mi 
rename POVERTY3 poverty_level
replace poverty_level = 0 if poverty_level == .

label define poverty_levelLabel 0 "College Dorm Resident - Invalid" 1 "Living in Poverty" 2 "Income Up to 2X Federal Poverty Threshold" 3 "Income More Than 2X Federal Poverty Threshold"
label values poverty_level poverty_levelLabel
label var poverty_level "Poverty Level - % of US Census Poverty Threshold"

tab poverty_level, mi

* creating a poverty dummy
gen poor = 0
replace poor = 1 if poverty_level == 1


* generating age variable
tab AGE2
gen age = 12
replace age = 13 if AGE2 == 2
replace age = 14 if AGE2 == 3
replace age = 15 if AGE2 == 4
replace age = 16 if AGE2 == 5
replace age = 17 if AGE2 == 6
replace age = 18 if AGE2 == 7
replace age = 19 if AGE2 == 8
replace age = 20 if AGE2 == 9
replace age = 21 if AGE2 == 10
replace age = 22.5 if AGE2 == 11
replace age = 24.5 if AGE2 == 12
replace age = 27.5 if AGE2 == 13
replace age = 32 if AGE2 == 14
replace age = 42 if AGE2 == 15
replace age = 57 if AGE2 == 16
replace age = 65 if AGE2 == 17

tab age


******************************************************
*** Other Helpful Variables, already cleaned       ***
******************************************************

** Age CodeBook p548 (589) 
tab catage, mi
tab CATAG2, mi 
tab CATAG3, mi 
tab CATAG6, mi 
tab CATAG7, mi 

** Income CodeBook p576 (617)
tab income, mi 
tab govtprog, mi

** Variables are also included for difficulties with basic "life functions" like hearing, dressing, errands CodeBook p545 (586)

******************************************************
*** Alcohol Use                                    ***
******************************************************
//alcohol use variables begin page 17(58) of 2017 codebook
* clean alcever: did individual ever drink alcohol?


codebook alcever
* this is not a dummy (currently 1 for "yes" and 2 for "no")
* previous class didn't change this into a dummy variable
replace alcever = 0 if alcever == 2

tab alcever, mi
* 4 observations had bad data, 4 didn't know, and 5 refused to answer

* creating dummy for non-response
gen NR_alcever = 0
replace NR_alcever = 1 if alcever == 85 | alcever == 94 | alcever == 97

* previous class decided to code those as missing, but then we indirectly drop 
* those observations from the sample; instead, I coded them as zero
replace alcever = 0 if alcever == 85 | alcever == 94 | alcever == 97

label define alceverfmt 0 "No" 1 "Yes"
label value alcever alceverfmt
codebook alcever


* clean alctry: age at which individual first drank alcohol
tab alctry, mi
* code those who have never tried alcohol as zero
replace alctry = 0 if alctry == 991

* previous class used this code:
* replace alctry=. if alctry==985| alctry==994| alcever== 997 | alcever== 998
* this mixes up alctry with alcever; it also indirectly drops hundreds of 
* observations; I coded the bad data, didn't know, refused, and blank as zero 
* and created a dummy for non-response
gen NR_alctry = 0
replace NR_alctry = 1 if alctry==985 | alctry==994 | alctry==997 | alctry==998 
replace alctry = 0 if alctry==985 | alctry==994 | alctry==997 | alctry==998

label define alctryfmt 0 "Never-user or non-response"
label value alctry alctryfmt
tab alctry, mi


* clean alcmdays: # of days individual drank alcohol in the past month
tab alcmdays, mi
* no missing observations, but all non-users are coded as 5
replace alcmdays = 0 if alcmdays == 5
label define alcmdaysfmt 0 "Never-user or no past month use" 1 "1-2 days" 2 "3-5 days" 3 "6-19 days" 4 "20-30 days"
label value alcmdays alcmdaysfmt
codebook alcmdays


* clean alcydays: # of days individual drank alcohol in the past year
codebook alcydays
* similar situation to alcmdays; no missing values, but non-users are coded as 6
replace alcydays = 0 if alcydays == 6
label define alcydaysfmt 0 "Never-user or no past year use" 1 "1-11 days" 2 "12-49 days" 3 "50-99 days" 4 "100-299 days" 5 "300-365 days"
label value alcydays alcydaysfmt
tab alcydays, mi


* clean aldaypmo: avg # of days per month individual drank alcohol in past year


/*tab aldaypmo, mi
* similar situation to alctry; code non-users in past year and never-users as 0
replace aldaypmo = 0 if aldaypmo == 93 | aldaypmo == 91

* previous class indirectly dropped thousands of observations by coding bad 
* data, didn't know, refused, blank, and two categories of skip as missing; I 
* again coded those as zero and created a dummy for non-response
gen NR_aldaypmo = 0
replace NR_aldaypmo = 1 if aldaypmo==85 | aldaypmo==94 | aldaypmo==97 | aldaypmo==98 | aldaypmo==89 | aldaypmo==99
replace aldaypmo = 0 if aldaypmo==85 | aldaypmo==94 | aldaypmo==97 | aldaypmo==98 | aldaypmo==89 | aldaypmo==99

label define aldaypmofmt 0 "Never-user/no past month use/non-response"
label value aldaypmo aldaypmofmt
tab aldaypmo, mi */

* clean ALCUS30D: usual # of drinks on a drinking day (in past month)
tab ALCUS30D, mi
* similar situation to alctry and aldaypmo; code non-users in past month and
* never-users as 0
replace ALCUS30D = 0 if ALCUS30D == 993 | ALCUS30D == 991

* previous class indirectly dropped over a thousand observations by coding 
* non-response categories as missing; I again coded those as zero and created a 
* dummy for non-response
gen NR_ALCUS30D = 0
replace NR_ALCUS30D = 1 if ALCUS30D==975 | ALCUS30D==985 | ALCUS30D==994 | ALCUS30D==997 | ALCUS30D==998
replace ALCUS30D = 0 if ALCUS30D==975 | ALCUS30D==985 | ALCUS30D==994 | ALCUS30D==997 | ALCUS30D==998

label define ALCUS30Dfmt 0 "Never-user/no past month use/non-response"
label values ALCUS30D ALCUS30Dfmt
tab ALCUS30D, mi


* clean ALCBNG30D: # of days >= 4 (>= 5 if male) drinks in past month
tab ALCBNG30D, mi
* similar situation to alctry, aldaypmo, and ALCUS30D; code non-users in past 
* month and never-users as 0
replace ALCBNG30D = 0 if ALCBNG30D == 93 | ALCBNG30D == 91

* previous class indirectly dropped over a thousand observations by coding 
* non-response categories as missing; I again coded those as zero and created a 
* dummy for non-response
gen NR_ALCBNG30D = 0
replace NR_ALCBNG30D = 1 if ALCBNG30D==80 | ALCBNG30D==85 | ALCBNG30D==94 | ALCBNG30D==97 | ALCBNG30D==98
replace ALCBNG30D = 0 if ALCBNG30D==80 | ALCBNG30D==85 | ALCBNG30D==94 | ALCBNG30D==97 | ALCBNG30D==98

label define ALCBNG30Dfmt 0 "Never-user/no past month use/non-response"
label values ALCBNG30D ALCBNG30Dfmt
tab ALCBNG30D, mi

*** re-label alcohol variables
label variable alcmdays "Days Used Alcohol in Past Month (RC)"
label variable alcydays "Days Used Alcohol in Past Year (RC)"
label variable alctry "Age When First Drank Alcohol"

***alcrec 
tab alcrec, mi
	//recode logically assigned values to reported values - meaning combine "Used in the past 30 days LOGICALLY ASSIGNED" and "Within the past 30 days"  
replace alcrec = 1 if alcrec == 11
replace alcrec = 2 if alcrec == 8
//replace `var' = 3 if `var' == 9
//recode never used, non-response as 0
replace alcrec = 0 if alcrec >= 85
tab alcrec, mi

***creating a "user" dummy variable - alcever include people who tried it once. I want to focus on people who are current users (not former users or experimenters). If someone has used within the last 12 months
gen alcuser = 0
replace alcuser = 1 if alcrec == 1 | alcrec == 2
label var alcuser "Used Alcohol in the last 12 months"
label values alcuser yesno
tab alcrec alcuser

**********************************************************
*** Alcohol Abuse                                      ***
**********************************************************
//substance abuse section in 2017 codebook starts 198(239)
foreach var in alclottm alcgtovr alclimit alcndmor alclsefx alccutdn alccutev ALCCUT1X ALCWD2SX alcwdsmt alcemopb alcemctd alcphlpb alcphctd alclsact alcserpb alcpdang alclawtr alcfmfpb alcfmctd {
	tab `var', mi 
	//capture non-response
	gen NR_`var' = 0
	replace NR_`var' = 1 if `var' == 85 | `var' >= 94
	label var NR_`var' "`var' non-response"
	label values NR_`var' yesno
	tab NR_`var', mi
	//recode no, no use or non-response as 0
	replace `var' = 0 if `var' >= 2
	label values `var' yesno
	tab `var', mi 
}
***ALCKPLMT
tab alckplmt, mi
//capture non-response
gen NR_alckplmt = 0
replace NR_alckplmt = 1 if alckplmt == 85 | alckplmt >= 94
tab NR_alckplmt, mi 
//recode so no use, non-response as 0
replace alckplmt = 0 if alckplmt >= 83
tab alckplmt, mi 
//because the above is confusing, creating new variable, 1 if drank more than intended, 0 otherwise
gen alcbreaklimit = 0
replace alcbreaklimit = 1 if alckplmt == 2
label values alcbreaklimit yesno
label var alcbreaklimit "Often drank more than intended"
tab alcbreaklimit, mi 


**********************************************************
*** Marijuana Use                                      ***
**********************************************************
*** mjever
tab mjever, mi
//No coded as 2, change to 0 for dummy variable and consistency with alcohol
replace mjever = 0 if mjever == 2
//capture non-response
gen NR_mjever = 0
replace NR_mjever = 1 if mjever > 3
tab NR_mjever
//recode missing, non-response as no
replace mjever = 0 if mjever > 3
label define yesno 0 "No" 1 "Yes", replace
label values mjever yesno
tab mjever, mi

***mjage
tab mjage, mi
//code never tried as 0
replace mjage = 0 if mjage == 991
//capture non-response
gen NR_mjage = 0
replace NR_mjage = 1 if mjage > 900
replace mjage = 0 if mjage > 900
label value mjage alctryfmt
label variable mjage "Age When First Used Marijuana"
tab mjage, mi

***mrjmdays
tab mrjmdays, mi
//recode no use as 0
replace mrjmdays = 0 if mrjmdays == 5
label value mrjmdays alcmdaysfmt
label variable mrjmdays "Days Used Marijuana in Past Month"
tab mrjmdays, mi

***mrjydays
tab mrjydays, mi
//recode no use as 0
replace mrjydays = 0 if mrjydays == 6
label value mrjydays alcydaysfmt
label variable mrjydays "Days Used Marijuana in Past Year"
tab mrjydays, mi

*** mjrec
tab mjrec, mi
	//recode logically assigned values to reported values - meaning combine "Used in the past 30 days LOGICALLY ASSIGNED" and "Within the past 30 days"  
replace mjrec = 1 if mjrec == 11
replace mjrec = 2 if mjrec == 8
//replace `var' = 3 if `var' == 9
//recode never used, non-response as 0
replace mjrec = 0 if mjrec >= 85
tab mjrec, mi

***creating a "user" dummy variable - mjever include people who tried it once. I want to focus on people who are current users (not former users or experimenters). If someone has used within the last 12 months

gen mjuser = 0
replace mjuser = 1 if mjrec ==1 | mjrec == 2
label variable mjuser "Used Marijuana in the last 12 months"
label values mjuser yesno
tab mjrec mjuser

**** alcvsmj
//creating a varible to facilitate direct comparison of alcohol users and marijuana users
//1 indicates alcohol user, 2 indicates marijuana users
//if a person uses both, may be categorized as marijuana user. not ideal but as marijuana is considered more severe would rather capture that
gen alcvsmj = 0
replace alcvsmj = 1 if alcuser == 1
replace alcvsmj = 2 if mjuser == 1
label define users 0 "Non-user" 1 "Alcohol" 2 "Marijuana", replace
label values alcvsmj users
label variable alcvsmj "Alcohol and Marijuana Use"
tab alcvsmj, mi

**********************************************************
*** Marijuana Abuse                                    ***
**********************************************************
//marijuana abuse section in 2017 codebooks starts 204(245)
foreach var in mrjlottm mrjgtovr mrjlimit mrjndmor mrjlsefx mrjcutdn mrjcutev mrjemopb mrjemctd mrjphlpb mrjphctd mrjlsact mrjserpb mrjpdang mrjlawtr mrjfmfpb mrjfmctd {
	tab `var', mi 
	//capture non-response
	gen NR_`var' = 0
	replace NR_`var' = 1 if `var' == 85 | `var' >= 94
	label var NR_`var' "`var' non-response"
	label values NR_`var' yesno
	tab NR_`var', mi
	//recode no, no use or non-response as 0
	replace `var' = 0 if `var' >= 2
	label values `var' yesno
	tab `var', mi 
}
***mrjkplmt
tab mrjkplmt, mi
//capture non-response
gen NR_mrjkplmt = 0
replace NR_mrjkplmt = 1 if mrjkplmt == 85 | mrjkplmt >= 94
tab NR_mrjkplmt, mi 
//recode so no use, non-response as 0
replace mrjkplmt = 0 if mrjkplmt >= 83
tab mrjkplmt, mi 
//because the above is confusing, creating new variable, 1 if drank more than intended, 0 otherwise
gen mrjbreaklimit = 0
replace mrjbreaklimit = 1 if mrjkplmt == 2
label values mrjbreaklimit yesno
label var mrjbreaklimit "Often used more than intended"
tab mrjbreaklimit, mi
