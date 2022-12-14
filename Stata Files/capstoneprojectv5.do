**********************************************************************************************************
*** Capstone Project Using NSDUH 2017, 2019, 2020                                                      ***
**********************************************************************************************************
*** capstone_project version 5 - December 2022
*** uses capstone_project_cleanData which uses clean_NSDUH 
*** Assumes clean_NSDUH and capstone_project_cleanData saved in $temp 
*** Assumes combined clean data file $temp/NSDUH.dta
*** Logs in $temp/capstone_project.log
*** Creates graphs in $temp/Graphs/ 
*** 
***
* Note: Assumes $temp folder established by global variable contains cleaning and data file. Output files, including graphs also saved in $temp

clear all
capture log close

//check to be sure this is latest version
do "$temp/capstone_project_cleanData.do"
// ^ Logs in $temp/capstone_project_cleanData.log


capture log close
log using "$temp/capstone_project.log", replace
* capstone_projectv8.do (after in class presentation)
* Capstone Project
* Comparing use and impact of alcohol and marijuana
* after running do "$temp/capstone_project_cleanData.do" logged in $temp/capstone_project_cleanData.log to clean data


**********************************************************
* Create drug abuse scores
**********************************************************
/*
I'd like to combine the various use/abuse outcomes (eg need more drug to get same effect, less activities because of use, etc) into a single score. This is a very naive approach to combine as there are so many variables.
*/

//alcohol
gen alcscore = alclottm + alcgtovr + alclimit + alcndmor + alclsefx + alccutdn + alccutev  + ALCCUT1X + ALCWD2SX + alcwdsmt + alcemopb + alcemctd + alcphlpb + alcphctd + alclsact + alcserpb + alcpdang + alclawtr + alcfmfpb + alcfmctd + alcbreaklimit
codebook alcscore
tab alcscore
/* results
   alcscore |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     76,029       67.63       67.63
          1 |      9,898        8.81       76.44
          2 |      7,987        7.11       83.54
          3 |      7,224        6.43       89.97
          4 |      4,091        3.64       93.61
          5 |      2,460        2.19       95.80
          6 |      1,387        1.23       97.03
          7 |        902        0.80       97.83
          8 |        675        0.60       98.44
          9 |        467        0.42       98.85
         10 |        366        0.33       99.18
         11 |        263        0.23       99.41
         12 |        212        0.19       99.60
         13 |        177        0.16       99.76
         14 |        124        0.11       99.87
         15 |        105        0.09       99.96
         16 |         44        0.04      100.00
         17 |          1        0.00      100.00
------------+-----------------------------------
      Total |    112,412      100.00
*/
tabstat alcscore, stats(p25 p50 p75 p90 max)
/* results
   variable |       p25       p50       p75       p90       max
-------------+--------------------------------------------------
    alcscore |         0         0         2         4        17
----------------------------------------------------------------
*/
//mostly people do not have a problem - 75% score 1 or less. 90% score 4 or less, max score 17
scalar alc75 = 2
scalar alc90 = 4
scalar alcmax = 17
histogram alcscore, bin(18) title(Alcohol Use Score)
graph export "$temp/Graphs/histo-alcscore.pdf", as(pdf) replace
histogram alcscore if alcscore < alc90 + 1, bin(5) title(Alcohol Use Score)
graph export "$temp/Graphs/histo-alcscore-bottom90%.pdf", as(pdf) replace
histogram alcscore if alcscore > alc75, bin(16) title(Alcohol Use Score - 75th Percentile)
graph export "$temp/Graphs/histo-alcscore-top25%.pdf", as(pdf) replace
histogram alcscore if age >= 18 & age < 65, bin(18) title(Alcohol Use Score Ages 18-65)
graph export "$temp/Graphs/histo-alcscore-working.pdf", as(pdf) replace
histogram alcscore if alcscore > 0 & age >= 18 & age < 65, bin(18) title(Alcohol Use Score Ages 18-65)
graph export "$temp/Graphs/histo-alcscore-nonzero-working.pdf", as(pdf) replace

//marijuana
gen mjscore = mrjlottm + mrjgtovr + mrjlimit + mrjndmor + mrjlsefx + mrjcutdn + mrjcutev + mrjemopb + mrjemctd + mrjphlpb + mrjphctd + mrjlsact + mrjserpb + mrjpdang + mrjlawtr + mrjfmfpb + mrjfmctd + mrjbreaklimit
codebook mjscore
tab mjscore
/* results
    mjscore |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |    100,524       89.42       89.42
          1 |      2,841        2.53       91.95
          2 |      2,587        2.30       94.25
          3 |      2,082        1.85       96.11
          4 |      1,589        1.41       97.52
          5 |      1,093        0.97       98.49
          6 |        632        0.56       99.05
          7 |        395        0.35       99.40
          8 |        247        0.22       99.62
          9 |        136        0.12       99.75
         10 |         89        0.08       99.82
         11 |         71        0.06       99.89
         12 |         51        0.05       99.93
         13 |         63        0.06       99.99
         14 |         12        0.01      100.00
------------+-----------------------------------
      Total |    112,412      100.00
*/
tabstat mjscore, stats(p25 p50 p75 p90 max)
/* results

    variable |       p25       p50       p75       p90       max
-------------+--------------------------------------------------
     mjscore |         0         0         0         1        14
----------------------------------------------------------------
*/
//most people do not have a problem 90% score 1 or less. max score 14
scalar mj90 = 1
histogram mjscore, bin(15) title(Marijuana Use Score)
graph export "$temp/Graphs/histo-mjscore.pdf", as(pdf) replace
histogram mjscore if mjscore >mj90, bin(13) title(Marijuana Use Score - 90th Percentile)
graph export "$temp/Graphs/histo-myscore-top10%.pdf", as(pdf) replace 
histogram mjscore if age >= 18 & age < 65, bin(15) title(Marijuana Use Score Ages 18-65)
graph export "$temp/Graphs/histo-mjscore-working.pdf", as(pdf) replace
histogram mjscore if mjscore > 0 & age >= 18 & age < 65, bin(15) title(Marijuana Use Score Ages 18-65)
graph export "$temp/Graphs/histo-mjscore-nonzero-working.pdf", as(pdf) replace

//combined - adding because one might not have a problem with just alcohol or just marijuana but the combined use could be problematic. 
gen abusescore = alcscore + mjscore
codebook abusescore
tab abusescore
/*

 abusescore |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     71,557       63.66       63.66
          1 |      9,745        8.67       72.33
          2 |      8,045        7.16       79.48
          3 |      7,221        6.42       85.91
          4 |      4,555        4.05       89.96
          5 |      3,012        2.68       92.64
          6 |      2,147        1.91       94.55
          7 |      1,470        1.31       95.85
          8 |      1,145        1.02       96.87
          9 |        859        0.76       97.64
         10 |        650        0.58       98.22
         11 |        500        0.44       98.66
         12 |        373        0.33       98.99
         13 |        302        0.27       99.26
         14 |        244        0.22       99.48
         15 |        193        0.17       99.65
         16 |        135        0.12       99.77
         17 |         62        0.06       99.82
         18 |         56        0.05       99.87
         19 |         34        0.03       99.90
         20 |         18        0.02       99.92
         21 |         13        0.01       99.93
         22 |         14        0.01       99.94
         23 |         11        0.01       99.95
         24 |          9        0.01       99.96
         25 |          4        0.00       99.97
         26 |          6        0.01       99.97
         27 |         10        0.01       99.98
         28 |         13        0.01       99.99
         29 |          6        0.01      100.00
         30 |          3        0.00      100.00
------------+-----------------------------------
      Total |    112,412      100.00

*/
tabstat abusescore, stats(p25 p50 p75 p90 max)
/* results

    variable |       p25       p50       p75       p90       max
-------------+--------------------------------------------------
  abusescore |         0         0         3         5        30
----------------------------------------------------------------
*/
//most people do not have a problem - 75% score 3 or less. 90% score 5 or less max 30
scalar abuse75 = 3
scalar abuse90 = 5
scalar abusemax = 30
histogram abusescore, bin(31) title(Alcohol/Marijuana Use Score)
graph export "$temp/Graphs/histo-comboscore.pdf", as(pdf) replace
histogram abusescore if abusescore < abuse90, title(Alcohol/Marijuana Use Score)
graph export "$temp/Graphs/histo-comboscore90%.pdf", as(pdf) replace
histogram abusescore if abusescore >= abuse75, bin(28) title(Alcohol/Marijuana Use Score 75th Percentile)
graph export "$temp/Graphs/histo-comboscore-top25%%.pdf", as(pdf) replace
histogram abusescore if abusescore >= abuse90, bin(25) title(Alcohol/Marijuana Use Score 90th Percentile)
graph export "$temp/Graphs/histo-comboscore-top10%%.pdf", as(pdf) replace
histogram abusescore if age >= 18 & age < 65, bin(31) title(Alcohol/Marijuana Use Score Ages 18-65)
graph export "$temp/Graphs/histo-comboscore-working.pdf", as(pdf) replace
histogram abusescore if abusescore < abuse90 & age >= 18 & age < 65, bin(5) title(Alcohol/Marijuana Use Score Ages 18-65)
graph export "$temp/Graphs/histo-comboscore90%-working.pdf", as(pdf) replace
histogram abusescore if abusescore > 0 & age >= 18 & age < 65, bin(29) title(Alcohol/Marijuana Use Score Ages 18-65)
graph export "$temp/Graphs/histo-comboscore-nonzero-working.pdf", as(pdf) replace

********************************************************
* What does the general population look like? 
********************************************************
// let's look at this population's basic demographics, starting with race and sex
forvalues i = 0/1{
	graph hbar if female == 1, over(NEWRACE2) title(Race Group Breakdown)
	graph export "$temp/Graphs/race-if-female=`i'.pdf", as(pdf) replace
}
//to compare, having on the same graph would be much more useful
//  heavily referenced this site for how to create these graphs https://www.statalist.org/forums/forum/general-stata-discussion/general/1339382-how-to-create-a-clustered-stacked-bar-graph-across-categories-rather-than-within
//first need the number of females in each race group
//bysort NEWRACE2: egen count_race_group_female = count(female) if female == 1
bysort NEWRACE2 female : egen count_race_group_female = count(female) 
/*check sorted as expected
tab count_race_group_female
tab female NEWRACE2
*/
bysort NEWRACE2: egen count_race_group = count(NEWRACE2)
gen percent = count_race_group_female / count_race_group * 100
tab percent
egen tag=tag(NEWRACE2 female)
graph hbar (asis) percent if tag==1, over(female) over(NEWRACE2) asyvar stack title(Ratio Male to Female by Race Group)
graph export "$temp/Graphs/bar-mtof-by-race.pdf", as(pdf) replace
//^above will create graph of each race category and show ratio male to females
//can we get a graph of sex and show ratio of each race category
capture drop count_race_* percent tag
bysort female NEWRACE2: egen count_race_group_female = count(NEWRACE2)
bysort female: egen count_race_group = count(female)
gen percent = count_race_group_female / count_race_group * 100
format percent %5.1g
egen tag = tag(NEWRACE2 female)
graph bar (asis) percent if tag==1, over(NEWRACE2) over(female) asyvar stack title(Race Groups by Sex)
graph export "$temp/Graphs/stack-bar-race-sex.pdf", as(pdf) replace

//what about age and sex
capture drop count_age_* 
capture drop percent tag
bysort CATAG6 female: egen count_age_female = count(female)
bysort CATAG6: egen count_age_group = count(CATAG6)
gen percent = count_age_female / count_age_group * 100
egen tag=tag(CATAG6 female)
graph hbar (asis) percent if tag==1, over(female) over(CATAG6) asyvar stack title(Ratio Male to Female by Age Group)
graph export "$temp/Graphs/bar-mtof-by-age.pdf", as(pdf) replace

//what about sex by age group?
capture drop count_age_* percent tag
bysort female CATAG6: egen count_age_group_female = count(CATAG6)
bysort female: egen count_age_group = count(female)
gen percent = count_age_group_female / count_age_group * 100
format percent %5.1g
egen tag = tag(CATAG6 female)
graph bar (asis) percent if tag==1, over(CATAG6) over(female) asyvar stack title(Age Groups if Female?) ytitle(Percent) 
graph export "$temp/Graphs/stack-bar-age-sex.pdf", as(pdf) replace

//what about age and race-sex
capture drop count_age_* percent tag
bysort CATAG6 NEWRACE2: egen count_age_race = count(NEWRACE2)
bysort CATAG6: egen count_age_group = count(CATAG6)
gen percent = count_age_race / count_age_group * 100
egen tag = tag(CATAG6 NEWRACE2)
graph hbar (asis) percent if tag==1, over(NEWRACE2) over(CATAG6) asyvar stack title(Race Groups by Age Category)
graph export "$temp/Graphs/stack-bar-race-age.pdf", as(pdf) replace

//let's get some numbers - especially to compare later
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(alcvsmj) format(%9.3f)
/* results
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.525     0.510     0.146     0.014     0.006     0.066     0.043
  Alcohol |     0.546     0.660     0.093     0.009     0.004     0.047     0.029
Marijuana |     0.482     0.617     0.126     0.018     0.004     0.024     0.053
----------+----------------------------------------------------------------------
    Total |     0.525     0.596     0.119     0.013     0.005     0.049     0.039
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.215     0.028     0.312     0.898     0.943     0.111     0.030
  Alcohol |     0.158     0.059     0.591     0.917     0.962     0.351     0.063
Marijuana |     0.157     0.137     0.279     0.884     0.980     0.216     0.033
----------+----------------------------------------------------------------------
    Total |     0.179     0.063     0.424     0.904     0.959     0.235     0.044
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.323
  Alcohol |     0.701
Marijuana |     0.642
----------+----------
    Total |     0.549
---------------------
*/

// and working age adults only: 18-65
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if age >= 18 & age < 65, by(alcvsmj) format(%9.3f)
/* results
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.565     0.473     0.159     0.016     0.008     0.086     0.033
  Alcohol |     0.552     0.641     0.099     0.010     0.004     0.051     0.029
Marijuana |     0.481     0.626     0.128     0.017     0.004     0.026     0.051
----------+----------------------------------------------------------------------
    Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.225     0.059     0.512     0.870     0.902     0.200     0.030
  Alcohol |     0.166     0.067     0.594     0.920     0.960     0.368     0.050
Marijuana |     0.148     0.162     0.313     0.877     0.978     0.249     0.034
----------+----------------------------------------------------------------------
    Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.568
  Alcohol |     0.777
Marijuana |     0.704
----------+----------
    Total |     0.709
---------------------
*/

********************************************************
* What do alcohol drinkers look like? Demographics (all ages)
********************************************************
//initally used alcever, switched to alcuser
histogram age if alcuser == 1 , title(Age)
graph export "$temp/Graphs/histo-alc-age.pdf", as(pdf) replace

foreach var in sexident LGBT health speakengl work_outside have_work_outside{
	graph bar if alcuser == 1, over(`var') title(`var')
	graph export "$temp/Graphs/bar-alc-`var'.pdf", as(pdf) replace
}
foreach var in marital_status eduhighcat military_service_bool income work_status{
	graph hbar if alcuser == 1, over(`var') title(`var')
	graph export "$temp/Graphs/bar-alc-`var'.pdf", as(pdf) replace
}
// so from theses graphs, people who drank alcohol are probably unmarried, heterosexual, healthy, and speak english very well, have at least some college education, have not served in the military, make 50k+, work outside the home

//more formally and detailed,
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(alcuser) nototal format(%9.3f)
/* results
alcuser |    female     white     black    native   pacific     asian       mix
--------+----------------------------------------------------------------------
     No |     0.520     0.511     0.148     0.016     0.006     0.063     0.044
    Yes |     0.529     0.650     0.101     0.011     0.004     0.041     0.036
-------------------------------------------------------------------------------

alcuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
--------+----------------------------------------------------------------------
     No |     0.212     0.031     0.308     0.894     0.944     0.108     0.030
    Yes |     0.157     0.084     0.498     0.910     0.968     0.316     0.054
-------------------------------------------------------------------------------

alcuser |  have_w~e
--------+----------
     No |     0.327
    Yes |     0.692
-------------------
*/

********************************************************
* What about marijuana users? Demographics (all ages)
********************************************************
//initally used mjever, switched to mjuser
histogram age if mjuser == 1, title(Age)
graph export "$temp/Graphs/histo-mj-age.pdf", as(pdf) replace

foreach var in sexident LGBT health speakengl work_outside have_work_outside{
	graph bar if mjuser == 1, over(`var') title(`var')
	graph export "$temp/Graphs/bar-mj-`var'.pdf", as(pdf) replace
}
foreach var in marital_status eduhighcat military_service_bool income work_status{
	graph hbar if mjuser == 1, over(`var') title(`var')
	graph export "$temp/Graphs/bar-mj-`var'.pdf", as(pdf) replace
}
//so from these graphs, people who used marijuana are probably unmarried, heterosexual, healthy, speak english very well, have at least some college education, have not served in the military, probably make 50k+, work outside the home

tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(mjuser) nototal format(%9.3f)
/* results
mjuser |    female     white     black    native   pacific     asian       mix
-------+----------------------------------------------------------------------
    No |     0.537     0.590     0.118     0.012     0.005     0.056     0.036
   Yes |     0.482     0.617     0.126     0.018     0.004     0.024     0.053
------------------------------------------------------------------------------

mjuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
-------+----------------------------------------------------------------------
    No |     0.184     0.044     0.461     0.909     0.953     0.239     0.047
   Yes |     0.157     0.137     0.279     0.884     0.980     0.216     0.033
------------------------------------------------------------------------------

mjuser |  have_w~e
-------+----------
    No |     0.526
   Yes |     0.642
------------------
*/

**********************************************************
* Compare alcohol users and marijuana users Demographics *
**********************************************************
//all ages
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(alcvsmj) nototal format(%9.3f)
/* results
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.525     0.510     0.146     0.014     0.006     0.066     0.043
  Alcohol |     0.546     0.660     0.093     0.009     0.004     0.047     0.029
Marijuana |     0.482     0.617     0.126     0.018     0.004     0.024     0.053
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.215     0.028     0.312     0.898     0.943     0.111     0.030
  Alcohol |     0.158     0.059     0.591     0.917     0.962     0.351     0.063
Marijuana |     0.157     0.137     0.279     0.884     0.980     0.216     0.033
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.323
  Alcohol |     0.701
Marijuana |     0.642
---------------------
*/

********************************************************
* Alcohol Users Substance Use/Abuse (all ages)
********************************************************
tabstat alclottm alcgtovr alclimit alcndmor alclsefx alccutdn alccutev ALCCUT1X ALCWD2SX alcwdsmt alcemopb alcemctd alcphlpb alcphctd alclsact alcserpb alcpdang alclawtr alcfmfpb alcfmctd alcbreaklimit, by(alcvsmj) nototal format(%9.3f)
/* results + interpretation?
 this suggests that marijuana users have problems with alcohol, more problems that alcohol users have. 
 People who use both would be classed as marijuana user but seems odd a marijuana user would have MORE problems with alcohol than other alcohol users. (true with and without 2020 data)
   alcvsmj |  alclottm  alcgtovr  alclimit  alcndmor  alclsefx  alccutdn  alccutev
----------+----------------------------------------------------------------------
 Non-user |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
  Alcohol |     0.098     0.012     0.280     0.049     0.060     0.215     0.188
Marijuana |     0.200     0.020     0.335     0.124     0.073     0.294     0.243
---------------------------------------------------------------------------------

  alcvsmj |  ALCCUT1X  ALCWD2SX  alcwdsmt  alcemopb  alcemctd  alcphlpb  alcphctd
----------+----------------------------------------------------------------------
 Non-user |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
  Alcohol |     0.181     0.029     0.014     0.047     0.027     0.019     0.008
Marijuana |     0.212     0.061     0.034     0.118     0.076     0.030     0.013
---------------------------------------------------------------------------------

  alcvsmj |  alclsact  alcserpb  alcpdang  alclawtr  alcfmfpb  alcfmctd  alcbre~t
----------+----------------------------------------------------------------------
 Non-user |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
  Alcohol |     0.023     0.014     0.032     0.005     0.026     0.016     0.027
Marijuana |     0.059     0.038     0.094     0.016     0.068     0.045     0.059
---------------------------------------------------------------------------------

*/

********************************************************
* Marijuana Users Substance Use/Abuse (all ages)
********************************************************
tabstat mrjlottm mrjgtovr mrjlimit mrjndmor mrjlsefx mrjcutdn mrjcutev mrjemopb mrjemctd mrjphlpb mrjphctd mrjlsact mrjserpb mrjpdang mrjlawtr mrjfmfpb mrjfmctd mrjbreaklimit, by(alcvsmj) nototal format(%9.3f)
/* results + interpretation?
  alcvsmj |  mrjlottm  mrjgtovr  mrjlimit  mrjndmor  mrjlsefx  mrjcutdn  mrjcutev
----------+----------------------------------------------------------------------
 Non-user |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
  Alcohol |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
Marijuana |     0.298     0.009     0.262     0.180     0.066     0.250     0.210
---------------------------------------------------------------------------------

  alcvsmj |  mrjemopb  mrjemctd  mrjphlpb  mrjphctd  mrjlsact  mrjserpb  mrjpdang
----------+----------------------------------------------------------------------
 Non-user |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
  Alcohol |     0.000     0.000     0.000     0.000     0.000     0.000     0.000
Marijuana |     0.070     0.046     0.014     0.007     0.061     0.035     0.032
---------------------------------------------------------------------------------

  alcvsmj |  mrjlawtr  mrjfmfpb  mrjfmctd  mrjbre~t
----------+----------------------------------------
 Non-user |     0.000     0.000     0.000     0.000
  Alcohol |     0.000     0.000     0.000     0.000
Marijuana |     0.015     0.042     0.032     0.051
---------------------------------------------------
It's expected that no alcohol users have marijuana problems - if use both, classed as marijuana user
*/

*************************************************************
* Impact Measures
*************************************************************
//compare work status of users and non users
tab work_status alcvsmj 
/*
Work Situation in the |    Alcohol and Marijuana Use
            Past Week |  Non-user    Alcohol  Marijuana |     Total
----------------------+---------------------------------+----------
Worked at full-time j |     9,679     32,453     12,401 |    54,533 
Worked at part-time j |     5,233      7,698      4,921 |    17,852 
Has job or volunteer  |     2,454      3,236      1,758 |     7,448 
Unemployed/on layoff, |     2,202      2,185      2,187 |     6,574 
             Disabled |     1,693      1,236        968 |     3,897 
Keeping house full-ti |     1,916      2,380        738 |     5,034 
   In school/training |     4,814      2,354      1,810 |     8,978 
              Retired |     3,476      4,670        508 |     8,654 
                Other |    22,246      5,679      4,410 |    32,335 
----------------------+---------------------------------+----------
                Total |    53,713     61,891     29,701 |   145,305 
*/
//work numbers really low for non-users - think due to including people to young and old to work
// to make life easier, and because it's a requirement, Let's keep only observations where 18 <= age < 65
/* to check keep work as expected
tab work_status alcvsmj if age >= 18 & age < 65

Work Situation in the |    Alcohol and Marijuana Use
            Past Week |  Non-user    Alcohol  Marijuana |     Total
----------------------+---------------------------------+----------
Worked at full-time j |     9,040     31,656     12,134 |    52,830 
Worked at part-time j |     3,295      6,382      3,921 |    13,598 
Has job or volunteer  |     1,574      2,772      1,431 |     5,777 
Unemployed/on layoff, |     1,436      1,973      1,761 |     5,170 
             Disabled |     1,465      1,149        930 |     3,544 
Keeping house full-ti |     1,845      2,358        728 |     4,931 
   In school/training |     1,350      1,623      1,102 |     4,075 
              Retired |       427        861        220 |     1,508 
                Other |     4,066      3,753      2,612 |    10,431 
----------------------+---------------------------------+----------
                Total |    24,498     52,527     24,839 |   101,864 
*/
keep if age >= 18 & age < 65
tab work_status alcvsmj
/*
                 %  | Non-user | Alcohol | Marijuana
Full Time           |   36.9   |  60.3   |  48.9
Full Time/Part time |   50.4   |  72.4   |  64.6
Unemployed          |    5.9   |   3.8   |   7.1
Disabled            |    6.0   |   2.2   |   3.7
*/
//This seems more comparable but I'm surprised that Non-users are still the lowest category
tab health_bool alcvsmj
/*
         % | Non-user | Alcohol | Marijuana
Healthy    |   87     |   92    |   87.7
Otherwise  |   13     |    8    |   12.3

      Self |
  Reported |
   Overall |
    Health |    Alcohol and Marijuana Use
    Status |  Non-user    Alcohol  Marijuana |     Total
-----------+---------------------------------+----------
 Otherwise |     3,181      4,194      3,047 |    10,422 
   Healthy |    21,317     48,333     21,792 |    91,442 
-----------+---------------------------------+----------
     Total |    24,498     52,527     24,839 |   101,864 


*/

/*to calculate percentages for slides for PUBL 607
tab alcvsmj
/* results
Alcohol and |
  Marijuana |
        Use |      Freq.     Percent        Cum.
------------+-----------------------------------
   Non-user |     24,498       24.05       24.05
    Alcohol |     52,527       51.57       75.62
  Marijuana |     24,839       24.38      100.00
------------+-----------------------------------
      Total |    101,864      100.00
*/
count if abusescore >= 1 & alcvsmj == 0		//0
count if abusescore >= 1 & alcvsmj == 1		//26,088
count if alcscore >= 1 & alcvsmj == 1 		//26,088
count if abusescore >= 1 & alcvsmj == 2		//19,586
count if mjscore >= 1 & alcvsmj == 2		//12,418
tab alcvsmj
/* results
Alcohol and |
  Marijuana |
        Use |      Freq.     Percent        Cum.
------------+-----------------------------------
   Non-user |     24,498       24.05       24.05
    Alcohol |     52,527       51.57       75.62
  Marijuana |     24,839       24.38      100.00
------------+-----------------------------------
      Total |    101,864      100.00
*/
count if abusescore >= 3 & alcvsmj == 0		//0
count if abusescore >= 3 & alcvsmj == 1		//12,183
count if alcscore >= 3 & alcvsmj == 1  		//12,183
count if abusescore >= 3 & alcvsmj == 2		//13,651
count if mjscore >= 3 & alcvsmj == 2		//6502
*/

*************************************************************
* Regressions "Are people who Y more likely to have characteristic X?"
*************************************************************
estimates drop _all
//regress alcohol ab/use on demographics
foreach var in alclottm alcgtovr alclimit alcndmor alclsefx alccutdn alccutev ALCCUT1X ALCWD2SX alcwdsmt alcemopb alcemctd alcphlpb alcphctd alclsact alcserpb alcpdang alclawtr alcfmfpb alcfmctd alcbreaklimit{
	regress `var' alcmdays alcydays alctry female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
	estimates store reg_`var'
	estadd scalar nobs_`var' = e(N)
	estadd scalar r2_`var' = e(r2)
}
/* alc-`var' r2 values
** **alclottm 0.1498
** alcgtovr 0.0089
** **alclimit 0.1883
** alcndmor 0.0811
** alclsefx 0.0407
** **alccutdn 0.1684
** alccutev 0.1212
** ALCCUT1X 0.0941 (2020 only?)
** ALCWD2SX 0.0441 (2020 only?)
** alcwdsmt 0.0283
** alcemopb 0.0732
** alcemctd 0.0582
** alcphlpb 0.0164
** alcphctd 0.0126
** alclsact 0.0410
** alcserpb 0.0274
** alcpdang 0.0604
** alclawtr 0.0151
** alcfmfpb 0.0414
** alcfmctd 0.0353
** alcbreaklimit 0.0490
*/
//Without 2020: Most explainitory value (highest R2):  alclimit 0.1850, alccutdn 0.1653, alclottm  0.1482,
//Most explainitory value (highest R2): alclimit 0.1882, alccutdn 0.1684, alclottm 0.1498
foreach var in alclimit alccutdn alclottm {
	tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(`var') format(%9.3f)
	estout reg_`var' using "$temp/Graphs/`var'-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
}

/* results
Summary statistics: mean
  by categories of: alclimit (SET LIMITS ON ALCOHOL USE PAST 12 MONTHS)


alclimit |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.553     0.589     0.123     0.013     0.005     0.056     0.035
     Yes |     0.488     0.623     0.113     0.014     0.004     0.043     0.038
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

alclimit |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.179     0.081     0.522     0.894     0.944     0.282     0.040
     Yes |     0.165     0.113     0.454     0.910     0.971     0.352     0.045
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

alclimit |  have_w~e
---------+----------
      No |     0.690
     Yes |     0.769
---------+----------
   Total |     0.709
--------------------

Summary statistics: mean
  by categories of: alccutdn (WANT/TRY TO CUT DOWN/STOP DRNKG PAST 12 MOS)

alccutdn |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.551     0.598     0.119     0.012     0.005     0.056     0.036
     Yes |     0.483     0.592     0.126     0.017     0.006     0.040     0.036
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

alccutdn |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.174     0.083     0.518     0.898     0.948     0.290     0.041
     Yes |     0.183     0.110     0.454     0.898     0.962     0.335     0.042
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

alccutdn |  have_w~e
---------+----------
      No |     0.697
     Yes |     0.759
---------+----------
   Total |     0.709
--------------------

Summary statistics: mean
  by categories of: alclottm (SPENT MONTH/MORE GETTING/DRNKG ALC PAST 12 MOS)

alclottm |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.545     0.592     0.123     0.013     0.005     0.055     0.035
     Yes |     0.474     0.638     0.099     0.015     0.005     0.035     0.043
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

alclottm |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.177     0.083     0.522     0.898     0.947     0.300     0.041
     Yes |     0.164     0.133     0.369     0.896     0.973     0.288     0.044
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

alclottm |  have_w~e
---------+----------
      No |     0.703
     Yes |     0.756
---------+----------
   Total |     0.709
--------------------

*/
//regress marijuana ab/use on demographics
foreach var in mrjlottm mrjgtovr mrjlimit mrjndmor mrjlsefx mrjcutdn mrjcutev mrjemopb mrjemctd mrjphlpb mrjphctd mrjlsact mrjserpb mrjpdang mrjlawtr mrjfmfpb mrjfmctd mrjbreaklimit{
	regress `var' mrjmdays mrjydays mjage female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
	estimates store reg_`var'
	estadd scalar nobs_`var' = e(N)
	estadd scalar r2_`var' = e(r2)
}
/* mrj-`var' r2 values
** **mrjlottm  0.4401
** mrjgtovr  0.0073
** **mrjlimit  0.2649
** **mrjndmor  0.2516
** mrjlsefx  0.0685
** mrjcutdn  0.2467
** mrjcutev  0.1975
** mrjemopb  0.0725
** mrjemctd  0.0554
** mrjphlpb  0.0135
** mrjphctd  0.0090
** mrjlsact  0.0713
** mrjserpb  0.0355
** mrjpdang  0.0337
** mrjlawtr  0.0149
** mrjfmfpb  0.0371
** mrjfmctd  0.0326
** mrjbreaklimit   0.0746
**
*/
//Without 2020: Most explainitory value (highest R2): mrjlottm 0.4492, mrjlimit 0.2639,  mrjcutdn  0.2493, mrjndmor 0.2477, mrjcutev 0.2022 
//Most explainitory value (highest R2): mrjlottm  0.4401, mrjlimit  0.2649, mrjndmor  0.2516, mrjcutdn  0.2466
foreach var in mrjlottm mrjlimit mrjndmor {
	tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, by(`var') format(%9.3f)
	estout reg_`var' using "$temp/Graphs/`var'-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
}
/* results

Summary statistics: mean
  by categories of: mrjlottm (SPENT MONTH/MORE GETTING/USING MJ PAST 12 MOS)

mrjlottm |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.547     0.598     0.118     0.013     0.005     0.056     0.033
     Yes |     0.411     0.580     0.149     0.022     0.004     0.020     0.066
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

mrjlottm |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.177     0.080     0.530     0.901     0.948     0.311     0.042
     Yes |     0.160     0.203     0.202     0.859     0.982     0.146     0.032
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

mrjlottm |  have_w~e
---------+----------
      No |     0.712
     Yes |     0.670
---------+----------
   Total |     0.709
--------------------

Summary statistics: mean
  by categories of: mrjlimit (SET LIMITS ON MARIJUANA USE PAST 12 MONTHS)

mrjlimit |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.544     0.600     0.118     0.013     0.005     0.055     0.034
     Yes |     0.434     0.553     0.166     0.022     0.003     0.024     0.061
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

mrjlimit |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.176     0.082     0.524     0.900     0.948     0.307     0.042
     Yes |     0.171     0.192     0.229     0.864     0.980     0.171     0.030
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

mrjlimit |  have_w~e
---------+----------
      No |     0.712
     Yes |     0.666
---------+----------
   Total |     0.709
--------------------

Summary statistics: mean
  by categories of: mrjndmor (NEEDED MORE MJ TO GET SAME EFFECT PST 12 MOS)

mrjndmor |    female     white     black    native   pacific     asian       mix
---------+----------------------------------------------------------------------
      No |     0.543     0.597     0.121     0.013     0.005     0.054     0.034
     Yes |     0.417     0.602     0.119     0.021     0.004     0.026     0.066
---------+----------------------------------------------------------------------
   Total |     0.538     0.597     0.121     0.013     0.005     0.053     0.036
--------------------------------------------------------------------------------

mrjndmor |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
---------+----------------------------------------------------------------------
      No |     0.176     0.083     0.520     0.899     0.949     0.305     0.042
     Yes |     0.162     0.214     0.190     0.859     0.983     0.163     0.028
---------+----------------------------------------------------------------------
   Total |     0.176     0.088     0.506     0.898     0.950     0.299     0.041
--------------------------------------------------------------------------------

mrjndmor |  have_w~e
---------+----------
      No |     0.711
     Yes |     0.657
---------+----------
   Total |     0.709
--------------------
*/
//given demographics can we predict if you use alcohol, marijuana or neither?
regress alcvsmj alcmdays alcydays alctry mrjmdays mrjydays mjage female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
estimates store reg_alcvsmj
estadd scalar nobs_alcvsmj = e(N)
estadd scalar r2_alcvsmj = e(r2)
estout reg_alcvsmj using "$temp/Graphs/alcvsmj-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
//  R-squared = 0.7579 --> This we may be able to predict with some accuracy. 
//let's look at residuals - or not because it doesn't make much sense
capture drop yhat
predict yhat if e(sample)
capture drop residuals
gen residuals = abusescore - yhat
histogram residuals, title(Drug Use Prediciton Residual)
graph export "$temp/Graphs/histo-alcvsmjuse-residuals.pdf", as(pdf) replace
scatter residuals yhat, title(Drug Use Prediciton Residual) 
graph export "$temp/Graphs/scatter-alcvsmjuse-residuals.pdf", as(pdf) replace
//this is puzzeling - only values of alcvsmj are 0, 1, 2 so not sure how a residual of 20 makes sense. Maybe because trying to use a continuous regression on a categorical variable? */

//given demographics can we predict if you have an alcohol 'problem' using abuse score
regress alcscore alcmdays alcydays alctry female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
estimates store reg_alcscore
estadd scalar nobs_alcscore = e(N)
estadd scalar r2_alcscore = e(r2)
estout reg_alcscore using "$temp/Graphs/alcscore-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
//^ R-squared = 0.2728 and almost all variables significant |t| >= 1.96

//given demographics can we predict if you have an marijuana 'problem' using abuse score
regress mjscore mrjmdays mrjydays mjage female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
estimates store reg_mjscore
estadd scalar nobs_mjscore = e(N)
estadd scalar r2_mjscore = e(r2)
estout reg_mjscore using "$temp/Graphs/mjscore-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
//^R-squared = 0.3934 almost all variables significant |t| >= 1.96

//given demographics can we predict if you have a 'problem' using either alcohol or marijuana using combo abuse score
regress abusescore alcmdays alcydays alctry mrjmdays mrjydays mjage female i.NEWRACE2 LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside, robust
estimates store reg_abusescore
estadd scalar nobs_abusescore = e(N)
estadd scalar r2_abusescore = e(r2)
estout reg_abusescore using "$temp/Graphs/abusescore-reg.txt", replace cells((b(star fmt(3)) ci_l ci_u)) stats (N r2) label legend varlabels(_cons Constant)
//R-squared         =     0.3549 (almost) all variable significant
//probably not. Different to pre-2020 with R-squared = .6003 with all ages let's look at residuals

capture drop yhat
predict yhat if e(sample)
capture drop residuals
gen residuals = abusescore - yhat
histogram residuals, title(Abuse Score Residual)
graph export "$temp/Graphs/histo-abusescore-residuals.pdf", as(pdf) replace
scatter residuals yhat, title(Abuse Score Residual) 
graph export "$temp/Graphs/scatter-abusescore-residuals.pdf", as(pdf) replace
//most values close to 0, suggests that there is little difference between observed data and prediction which suggests regression does a good job of predicting. This may be misleading as most people had a score of 0 or 1. */


*************************************************************
* What about the people who DO have a use problem?
*************************************************************
/*Use 75 percentilie as cut off - meaning the 25% who have higher use score than everyone else*/
//alcohol
codebook alcscore
/* >2 is cutoff
           percentiles:        10%       25%       50%       75%       90%
                                 0         0         0         2         4
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcscore > alc75, by(alcuser) nototal format(%9.3f)
/* results
alcuser |    female     white     black    native   pacific     asian       mix
--------+----------------------------------------------------------------------
    Yes |     0.482     0.609     0.116     0.017     0.005     0.040     0.038
-------------------------------------------------------------------------------

alcuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
--------+----------------------------------------------------------------------
    Yes |     0.174     0.120     0.420     0.897     0.967     0.327     0.041
-------------------------------------------------------------------------------

alcuser |  have_w~e
--------+----------
    Yes |     0.755
-------------------
*/
graph bar female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcscore > alc75, over(alcuser) title(Demographics of 75th Percentile of Alcohol Abuse Score)
graph export "$temp/Graphs/bar-demo-75palcscore.pdf", as(pdf) replace

//marijuana
codebook mjscore
/* >1 is cutoff (90 percentile)
           percentiles:        10%       25%       50%       75%       90%
                                 0         0         0         0         1
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if mjscore > mj90, by(mjuser) nototal format(%9.3f)
/* results
mjuser |    female     white     black    native   pacific     asian       mix
-------+----------------------------------------------------------------------
   Yes |     0.428     0.560     0.161     0.023     0.004     0.022     0.063
------------------------------------------------------------------------------

mjuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
-------+----------------------------------------------------------------------
   Yes |     0.166     0.188     0.214     0.863     0.980     0.162     0.029
------------------------------------------------------------------------------

mjuser |  have_w~e
-------+----------
   Yes |     0.663
------------------
*/
graph bar female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if mjscore > mj90, over(mjuser) title(Demographics of 90th Percentile of Marijuana Score)
graph export "$temp/Graphs/bar-demo-90pmjscore.pdf", as(pdf) replace

//comboscore
codebook abusescore
/* >3 is cutoff
           percentiles:        10%       25%       50%       75%       90%
                                 0         0         0         3         5
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if abusescore >= abuse75, by(alcvsmj) format(%9.3f)
/* results

  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
  Alcohol |     0.471     0.599     0.113     0.016     0.006     0.049     0.033
Marijuana |     0.454     0.596     0.136     0.022     0.004     0.024     0.055
----------+----------------------------------------------------------------------
    Total |     0.461     0.597     0.127     0.020     0.005     0.034     0.047
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
  Alcohol |     0.184     0.088     0.513     0.892     0.954     0.339     0.053
Marijuana |     0.162     0.184     0.242     0.879     0.981     0.235     0.031
----------+----------------------------------------------------------------------
    Total |     0.171     0.147     0.347     0.884     0.971     0.275     0.039
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
  Alcohol |     0.763
Marijuana |     0.704
----------+----------
    Total |     0.727
---------------------

*/
graph bar female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if abusescore >= abuse75, over(alcvsmj) title(Demographics of 75th Percentile of Combo Abuse Score)
graph export "$temp/Graphs/bar-demo-75pcombo-abusescore.pdf", as(pdf) replace

tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcscore >= alc75 | mjscore >= mj90, by(alcvsmj) nototal format(%9.3f)
/* results 
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
  Alcohol |     0.490     0.598     0.114     0.014     0.006     0.052     0.031
Marijuana |     0.455     0.603     0.136     0.021     0.004     0.024     0.054
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
  Alcohol |     0.185     0.079     0.530     0.905     0.955     0.354     0.048
Marijuana |     0.158     0.177     0.260     0.877     0.983     0.236     0.031
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
  Alcohol |     0.773
Marijuana |     0.702
---------------------

*/

///Because I think it's significant (instictively) - What if you want to limit and you can't?
//alcbreaklimit == 1 & alclimit == 1
tab alcbreaklimit alclimit
// count alcbreaklimit == 1 & alclimit == 1 is 3,169 (code doesn't actually work)
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcbreaklimit == 1 & alclimit == 1, by(alcuser) nototal format(%9.3f)
/* results
alcuser |    female     white     black    native   pacific     asian       mix
--------+----------------------------------------------------------------------
    Yes |     0.473     0.668     0.095     0.022     0.006     0.031     0.042
-------------------------------------------------------------------------------

alcuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
--------+----------------------------------------------------------------------
    Yes |     0.137     0.134     0.430     0.886     0.982     0.367     0.049
-------------------------------------------------------------------------------

alcuser |  have_w~e
--------+----------
    Yes |     0.748
-------------------
*/

**********************************************************
* 2019 vs 2020
**********************************************************
//characterize "users" in 2019
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcscore > 1 & year == 2019, by(alcuser) nototal format(%9.3f)
/* results
alcuser |    female     white     black    native   pacific     asian       mix
--------+----------------------------------------------------------------------
    Yes |     0.482     0.579     0.129     0.016     0.006     0.044     0.039
-------------------------------------------------------------------------------

alcuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
--------+----------------------------------------------------------------------
    Yes |     0.188     0.117     0.430     0.895     0.969     0.290     0.041
-------------------------------------------------------------------------------

alcuser |  have_w~e
--------+----------
    Yes |     0.767
-------------------
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if mjscore > 1 & year == 2019, by(mjuser) nototal format(%9.3f)
/* results
mjuser |    female     white     black    native   pacific     asian       mix
-------+----------------------------------------------------------------------
   Yes |     0.420     0.528     0.172     0.021     0.006     0.023     0.062
------------------------------------------------------------------------------

mjuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
-------+----------------------------------------------------------------------
   Yes |     0.188     0.190     0.208     0.860     0.984     0.138     0.024
------------------------------------------------------------------------------

mjuser |  have_w~e
-------+----------
   Yes |     0.682
------------------
*/

//characterize "users" in 2020
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if alcscore > 1 & year == 2020, by(alcuser) nototal format(%9.3f)
/* results
alcuser |    female     white     black    native   pacific     asian       mix
--------+----------------------------------------------------------------------
    Yes |     0.524     0.677     0.090     0.009     0.004     0.043     0.040
-------------------------------------------------------------------------------

alcuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
--------+----------------------------------------------------------------------
    Yes |     0.137     0.148     0.461     0.916     0.958     0.437     0.041
-------------------------------------------------------------------------------

alcuser |  have_w~e
--------+----------
    Yes |     0.746
-------------------
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if mjscore > 1 & year == 2020, by(mjuser) nototal format(%9.3f)
/* results

mjuser |    female     white     black    native   pacific     asian       mix
-------+----------------------------------------------------------------------
   Yes |     0.482     0.629     0.117     0.014     0.002     0.026     0.070
------------------------------------------------------------------------------

mjuser |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
-------+----------------------------------------------------------------------
   Yes |     0.142     0.252     0.241     0.861     0.955     0.239     0.032
------------------------------------------------------------------------------

mjuser |  have_w~e
-------+----------
   Yes |     0.623
------------------

*/

//what about percent of users vs whole pop?
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if year == 2019, by(alcvsmj) format(%9.3f)
/* results

  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.558     0.445     0.172     0.017     0.009     0.083     0.032
  Alcohol |     0.548     0.620     0.107     0.010     0.004     0.050     0.029
Marijuana |     0.476     0.600     0.140     0.017     0.005     0.027     0.051
----------+----------------------------------------------------------------------
    Total |     0.532     0.573     0.131     0.013     0.006     0.052     0.035
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.241     0.061     0.497     0.868     0.898     0.176     0.028
  Alcohol |     0.180     0.068     0.583     0.917     0.962     0.337     0.049
Marijuana |     0.160     0.167     0.311     0.870     0.988     0.223     0.033
----------+----------------------------------------------------------------------
    Total |     0.190     0.092     0.492     0.893     0.953     0.269     0.040
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.569
  Alcohol |     0.786
Marijuana |     0.717
----------+----------
    Total |     0.716
---------------------
*/
tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if year == 2020, by(alcvsmj) format(%9.3f)
/* results
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.558     0.535     0.124     0.012     0.007     0.096     0.035
  Alcohol |     0.574     0.683     0.079     0.007     0.004     0.058     0.032
Marijuana |     0.528     0.680     0.096     0.010     0.002     0.028     0.056
----------+----------------------------------------------------------------------
    Total |     0.559     0.647     0.094     0.009     0.005     0.060     0.038
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.189     0.063     0.520     0.887     0.903     0.278     0.026
  Alcohol |     0.138     0.081     0.608     0.933     0.945     0.473     0.049
Marijuana |     0.127     0.200     0.341     0.882     0.942     0.344     0.031
----------+----------------------------------------------------------------------
    Total |     0.148     0.106     0.521     0.909     0.934     0.394     0.039
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.557
  Alcohol |     0.754
Marijuana |     0.669
----------+----------
    Total |     0.685
---------------------
*/
//what about percent of users who have problem versus all users, versus whole pop?
levelsof year, local(levels)
foreach l of local levels{
	tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if year == `l', by(alcvsmj) format(%9.3f)
}
/*results
2017
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.576     0.462     0.168     0.019     0.007     0.081     0.032
  Alcohol |     0.542     0.635     0.104     0.011     0.004     0.048     0.029
Marijuana |     0.454     0.618     0.136     0.023     0.004     0.023     0.049
----------+----------------------------------------------------------------------
    Total |     0.530     0.590     0.127     0.016     0.005     0.050     0.034
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.231     0.053     0.521     0.862     0.905     0.176     0.036
  Alcohol |     0.169     0.059     0.596     0.916     0.966     0.335     0.051
Marijuana |     0.147     0.131     0.296     0.882     0.992     0.215     0.036
----------+----------------------------------------------------------------------
    Total |     0.179     0.074     0.510     0.895     0.957     0.270     0.044
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.574
  Alcohol |     0.782
Marijuana |     0.713
----------+----------
    Total |     0.717
---------------------

2019
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.558     0.445     0.172     0.017     0.009     0.083     0.032
  Alcohol |     0.548     0.620     0.107     0.010     0.004     0.050     0.029
Marijuana |     0.476     0.600     0.140     0.017     0.005     0.027     0.051
----------+----------------------------------------------------------------------
    Total |     0.532     0.573     0.131     0.013     0.006     0.052     0.035
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.241     0.061     0.497     0.868     0.898     0.176     0.028
  Alcohol |     0.180     0.068     0.583     0.917     0.962     0.337     0.049
Marijuana |     0.160     0.167     0.311     0.870     0.988     0.223     0.033
----------+----------------------------------------------------------------------
    Total |     0.190     0.092     0.492     0.893     0.953     0.269     0.040
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.569
  Alcohol |     0.786
Marijuana |     0.717
----------+----------
    Total |     0.716
---------------------

2020
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
 Non-user |     0.558     0.535     0.124     0.012     0.007     0.096     0.035
  Alcohol |     0.574     0.683     0.079     0.007     0.004     0.058     0.032
Marijuana |     0.528     0.680     0.096     0.010     0.002     0.028     0.056
----------+----------------------------------------------------------------------
    Total |     0.559     0.647     0.094     0.009     0.005     0.060     0.038
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
 Non-user |     0.189     0.063     0.520     0.887     0.903     0.278     0.026
  Alcohol |     0.138     0.081     0.608     0.933     0.945     0.473     0.049
Marijuana |     0.127     0.200     0.341     0.882     0.942     0.344     0.031
----------+----------------------------------------------------------------------
    Total |     0.148     0.106     0.521     0.909     0.934     0.394     0.039
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
 Non-user |     0.557
  Alcohol |     0.754
Marijuana |     0.669
----------+----------
    Total |     0.685
---------------------
*/
tab year
/* results
       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2017 |     38,837       38.13       38.13
       2019 |     38,841       38.13       76.26
       2020 |     24,186       23.74      100.00
------------+-----------------------------------
      Total |    101,864      100.00

*/
tab alcvsmj year
/* results
   Alcohol |
       and |
 Marijuana |               year
       Use |      2017       2019       2020 |     Total
-----------+---------------------------------+----------
  Non-user |     9,253      9,416      5,829 |    24,498 
   Alcohol |    20,762     19,431     12,334 |    52,527 
 Marijuana |     8,822      9,994      6,023 |    24,839 
-----------+---------------------------------+----------
     Total |    38,837     38,841     24,186 |   101,864 
or as percentages
  Alcohol |
       and |
 Marijuana |               year
       Use |      2017       2019       2020 |     Total
-----------+---------------------------------+----------
  Non-user |     23.83      24.24      24.10 |     24.05 
   Alcohol |     53.46      50.03      51.00 |     51.57 
 Marijuana |     22.72      25.73      24.90 |     24.38 
-----------+---------------------------------+----------
     Total |       100        100        100 |       100 
*/
//use looks fairly steady year on year - did not see significant spike in use in 2020 as one might expect due to pandemic. perhaps more people didn't use but more users had 'problems' (for lack of better phrasing)?
levelsof year, local(levels)
foreach l of local levels{
	tabstat female white black native pacific asian mix hispanic LGBT marital_bool health_bool speakengl_bool college_graduate_bool military_service_bool have_work_outside if abusescore >= abuse75 & year == `l', by(alcvsmj) format(%9.3f) save
	matrix mj`l' = r(Stat2)
	matrix alc`l' = r(Stat1)
	}
/* results
2017
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
  Alcohol |     0.447     0.589     0.119     0.019     0.005     0.045     0.030
Marijuana |     0.436     0.578     0.151     0.029     0.003     0.020     0.055
----------+----------------------------------------------------------------------
    Total |     0.441     0.583     0.138     0.025     0.004     0.030     0.045
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
  Alcohol |     0.192     0.071     0.507     0.889     0.957     0.307     0.054
Marijuana |     0.164     0.144     0.224     0.880     0.992     0.201     0.033
----------+----------------------------------------------------------------------
    Total |     0.175     0.114     0.341     0.884     0.978     0.245     0.042
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
  Alcohol |     0.761
Marijuana |     0.704
----------+----------
    Total |     0.728
---------------------

2019
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
  Alcohol |     0.465     0.571     0.121     0.015     0.007     0.047     0.035
Marijuana |     0.441     0.568     0.145     0.022     0.007     0.027     0.055
----------+----------------------------------------------------------------------
    Total |     0.450     0.569     0.136     0.020     0.007     0.034     0.048
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
  Alcohol |     0.204     0.090     0.499     0.877     0.950     0.299     0.050
Marijuana |     0.176     0.186     0.235     0.874     0.986     0.212     0.027
----------+----------------------------------------------------------------------
    Total |     0.186     0.151     0.332     0.875     0.973     0.244     0.036
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
  Alcohol |     0.776
Marijuana |     0.721
----------+----------
    Total |     0.741
---------------------

2020
  alcvsmj |    female     white     black    native   pacific     asian       mix
----------+----------------------------------------------------------------------
  Alcohol |     0.524     0.662     0.089     0.010     0.007     0.056     0.036
Marijuana |     0.504     0.671     0.099     0.012     0.001     0.026     0.057
----------+----------------------------------------------------------------------
    Total |     0.511     0.668     0.095     0.011     0.003     0.038     0.049
---------------------------------------------------------------------------------

  alcvsmj |  hispanic      LGBT  marita~l  health~l  speak~ol  colleg~l  milita~l
----------+----------------------------------------------------------------------
  Alcohol |     0.140     0.115     0.548     0.924     0.955     0.460     0.058
Marijuana |     0.134     0.241     0.281     0.885     0.956     0.326     0.032
----------+----------------------------------------------------------------------
    Total |     0.136     0.193     0.383     0.900     0.956     0.377     0.042
---------------------------------------------------------------------------------

  alcvsmj |  have_w~e
----------+----------
  Alcohol |     0.747
Marijuana |     0.675
----------+----------
    Total |     0.702
---------------------
*/

/*there does seem to be increases in use in some categories - college educated 2019-2020 especially
percent change = (new - old)/old
as percentages
  Alcohol |
       and |
 Marijuana |               year
       Use |      2017       2019       2020 |     Total
-----------+---------------------------------+----------
  Non-user |     23.83      24.24      24.10 |     24.05 
   Alcohol |     53.46      50.03      51.00 |     51.57 
 Marijuana |     22.72      25.73      24.90 |     24.38 
-----------+---------------------------------+----------
     Total |       100        100        100 |       100 

           |  2017-2019	 |  2019-2020
-----------+---------------------------
  Non-user |      1.72      -0.58       
   Alcohol |     -6.42       1.94       
 Marijuana |     13.25      -3.23 

 large increase in Marijuana users 2017-2019 but use overall flat 2019-2020
 
*/

//what about those with highest abusescore?
tab alcvsmj year if abusescore >= abuse75 
/* results
   Alcohol |
       and |
 Marijuana |               year
       Use |      2017       2019       2020 |     Total
-----------+---------------------------------+----------
   Alcohol |     7,229      6,928      4,037 |    18,194 
 Marijuana |     5,964      6,698      3,847 |    16,509 
-----------+---------------------------------+----------
     Total |    13,193     13,626      7,884 |    34,703 
or as percentages
   Alcohol |
       and |
 Marijuana |               year
       Use |      2017       2019       2020 |     Total
-----------+---------------------------------+----------
   Alcohol |     54.79      50.84      51.20 |    18,194 
 Marijuana |     45.21      49.16      48.80 |    16,509 
-----------+---------------------------------+----------
     
           |  2017-2019	 |  2019-2020
-----------+---------------------------      
   Alcohol |     -7.21       0.71       
 Marijuana |      8.74      -0.73 

 so alcohol misuse decreased and marijuana increased 2017-2019 but both remained flat 2019-2020
*/

//https://www.stata.com/support/faqs/data-management/element-by-element-operations-on-matrices/
matrix delta1719 = J(2,15,0)		//change 2017 to 2019 (2017denom)
matrix delta1920 = J(2,15,0)		//change 2019 to 2020 (2020 denom)
forvalues i = 1/15{
	matrix delta1719[1,`i'] = (alc2019[1,`i'] - alc2017[1,`i']) / alc2017[1,`i']
	matrix delta1719[2,`i'] = (mj2019[1,`i'] - mj2017[1,`i']) / mj2017[1,`i']
}
forvalues i = 1/15{
	matrix delta1920[1,`i'] = (alc2020[1,`i'] - alc2019[1,`i']) / alc2019[1,`i']
	matrix delta1920[2,`i'] = (mj2020[1,`i'] - mj2019[1,`i']) / mj2019[1,`i']
}
matrix list delta1719
/* results
  alcvsmj |    female       white        black      native      pacific        asian       
----------+-----------------------------------------------------------------------------
  Alcohol |   .03738386  -.03636765    *.079005   *-.1874042   *.41172225   *.05806098
Marijuana |   .02690203   -.0224764  -.02550708  *-.21787867   *.44162437   *.321489

  alcvsmj |      mix        hispanic       LGBT      marita~l     health~l     speak~ol  
  Alcohol |  *.18718701    .02708492   *.21812081   -.00738702   -.00164328   -.00714903
Marijuana |  .01090025   *.08649581    *.27997163   *.08001825   -.01057485    -.0044498

  alcvsmj |    colleg~l     milita~l     have_w~e         
  Alcohol |  -.00448047  *-.05552504   -.00048384
Marijuana |    .0239063  *-.10958495    .01480511

* indicates change > 5% either direction
*/
matrix list delta1920
/* results
  alcvsmj |    female         white        black       native        pacific      asian       
----------+--------------------------------------------------------------------------------
  Alcohol |   *.07170103   *.17494634   *-.28039723  *-.29794852  *-.17924417   .00976465
Marijuana |   *.14197865   *.1567072    *-.3321572  *-.45088481  *-.64153886    .03348536

  alcvsmj |      mix       hispanic      LGBT          marita~l    health~l    speak~ol
  Alcohol |    .0004321   *-.29913471   *.28871336   *.06913097   .02677238  -.00115404
Marijuana |   *.11855357  *-.22432385   *.29431931   *.11623661   .01147743  -.02883669

  alcvsmj |    colleg~l    milita~l    have_w~e 
  Alcohol |   *.51154412   .01734406  -.01786261
Marijuana |   *.57205842   .02366002  -.05507945

* indicates chage > 5% either direction
*/
/*
so the percentages of population using steady 19-20, percentge of users misusing steady but within demographic categories changes in who is misusing - eg 7% more female misusers in 2020 compared to 2019
*/
save "$temp/NSDUH.dta", replace
capture log close
dadjoke
//Thank you, Thank you, He's here all week ;)
