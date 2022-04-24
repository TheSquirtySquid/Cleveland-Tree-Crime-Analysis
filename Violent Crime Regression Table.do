***Title and Setup***
{
/*Ethan Deemer Cleaned Violent Regressions
//Started 3/23/22
//This Do file focuses on creating a cleaned version of the regression of tree cover persantage on cviolent crime rate.*/

clear
cd "H:\POSC Capstone"

capture log close
log using Violent_Regression.log, replace
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

drop Totalviolentcrimes2017 Totalviolentcrimes2011
}


***Renaming and Fixing Variables***
{
   rename PercentChange Tree_Cover_Change
   rename Unemploymentrate2012 Unemployment_Rate
   rename Childrenunderage6testedfor ChildElevatedLead
   rename Residentialparcelsalessingl Resid_SingleFam
}

search estout

reg Violent_Change Tree_Cover_Change, vce(bootstrap, reps (1000) bca)
estimates store m1, title(Module 1)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc, vce(bootstrap, reps (1000) bca)
estimates store m2, title(Module 2)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012, vce(bootstrap, reps (1000) bca)
estimates store m3, title(Module 3)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012, vce(bootstrap, reps (1000) bca)
estimates store m4, title(Module 4)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012, vce(bootstrap, reps (1000) bca)
estimates store m5, title(Module 5)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate, vce(bootstrap, reps (1000) bca)
estimates store m6, title(Module 6)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam, vce(bootstrap, reps (1000) bca)
estimates store m7, title(Module 7)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017, vce(bootstrap, reps (1000) bca)
estimates store m8, title(Module 8)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent, vce(bootstrap, reps (1000) bca)
estimates store m9, title(Module 9)

reg Violent_Change Tree_Cover_Change Personswith9th12thgradeeduc Medianhouseholdincome2012 Povertyrate2012 Totalpopulation2012 Unemployment_Rate Resid_SingleFam Vacantparcelspercent2017 Occupiedhousingunitspercent TCPossibleArea, vce(bootstrap, reps (1000) bca)
estimates store m10, title(Module 10)

estout m1 m2 m3 m4 m5 m6 m7 m8 m9 m10, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons constant) stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

