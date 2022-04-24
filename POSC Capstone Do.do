***Title and Setup***
{
/*Ethan Deemer POSC Capstone
//Started 3/23/22
//This Do file covers the quantitative analysis work need to show a corrollary link between crime rates and green space (specifically tree cover) in the city of Cleveland, Ohio.*/

clear
cd "H:\POSC Capstone"
//Set as directory holding attached files

capture log close
log using POSC_Capstone.log, replace
}


***Creating dta files and merging datasets***
{
import excel "H:\POSC Capstone\Neighboorhood Crime and Demographic.xlsx", sheet("Sheet1") cellrange(A1:N35) firstrow clear
save Neighboorhood_Crime.dta, replace

clear

import excel "H:\POSC Capstone\Cleveland Neighborhood Tree Cover.xlsx", sheet("ClevelandSPA_UTC_acres") cellrange(A1:AP35) firstrow clear
save Neighboorhood_Tree.dta, replace

clear

use Neighboorhood_Tree

merge m:1 Neighborhood using Neighboorhood_Crime.dta, update replace
}


***Creating Percent Change Variables***
{
gen Violent_Change = (Totalviolentcrimes2017-Totalviolentcrimes2011)/Totalviolentcrimes2011
gen Property_Change = (Totalpropertycrimes2017-Totalpropertycrimes2011)/Totalpropertycrimes2011

drop Totalviolentcrimes2017 Totalpropertycrimes2017 Totalviolentcrimes2011 Totalpropertycrimes2011
}


***Renaming and Fixing Variables***
{
   rename PercentChange Tree_Cover_Change
   rename Unemploymentrate2012 Unemployment_Rate
   rename Childrenunderage6testedfor ChildElevatedLead
   rename Residentialparcelsalessingl Resid_SingleFam
}

***Scatter Plot***
{
twoway (scatter Violent_Change Tree_Cover_Change), ytitle(Percent Change in Violent Crime Rate) xtitle(Percent Change in Tree Cover) title(Tree Cover and Violent Crime Rate) || lfit Violent_Change Tree_Cover_Change
graph export "Violent Crime Scatter.png", width(600) height(450) replace

twoway (scatter Property_Change Tree_Cover_Change), ytitle(Percent Change in Property Crime Rate) xtitle(Percent Change in Tree Cover) title(Tree Cover and Property Crime Rate) || lfit Property_Change Tree_Cover_Change
graph export "Property Crime Scatter.png", width(600) height(450) replace
}


***Variable Summary***
{
    summarize Tree_Cover_Change Violent_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, sep(1)
}


**Crime as y Regressions***
{
reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, robust

reg Property_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, robust
}


***Tree Cover as y Regressions***
{
reg Tree_Cover_Change Violent_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, robust

reg Tree_Cover_Change Property_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, robust
}


***Bootstrapping***
{
correlate Violent_Change Tree_Cover_Change
return list
bootstrap r(rho), reps(1000) bca: cor Violent_Change Tree_Cover_Change
estat bootstrap, all

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, vce(bootstrap, reps (1000) bca)
estat bootstrap, all

reg Property_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, vce(bootstrap, reps (1000) bca)
estat bootstrap, all
}

***Creating comprehensive regression table***
{
clear
do "Violent Crime Regression Table"
}
