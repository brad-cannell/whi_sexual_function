* ============================================================================;
* Preprocessing Data for Analysis
* 2017-03-18
* Individual form data sets were previously cleaned and duplicates (by id, 
* days) were removed.
* Individual form data sets were previously merged by id and days in the
* program merge_forms.
* Drug class from Erika (2017-03-09): 581600
* Final data set should always be named analysis with no number. All 
* intermediate data sets will be analysis with sequential numbering.

* Update 2017-04-26: Not using this file anymore. Just keeping it around for 
* reference. Subset the variables in merge_forms.sas. All other processing
* done in R.
* ============================================================================;

* Setup libraries;
libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);


* ============================================================================;
* Subset variables of interest
* ============================================================================;
data whisf.analysis1;
	set whisf.merged (keep = id days CTPPT HRTPPT DMPPT CADPPT OSPPT AGE AGER
		LANG HRTARM DMARM CADARM race_eth edu4cat inc5cat
		ctos HORM HORMNW DIAB HYST marital OSTEOPOR CVD ARTHRIT HYPT PAD
		BRCA_F30 OVRYCA ENDO_F30 CERVCA PARITY SMOKNOW TEXPWK SMOKING ALCSWK
		married sex incont vagdry genhel lifequal pshtdep nightswt hotflash 
		verbab phyab sexactiv satfrqsx satsex lifequal f60caff f60alc f60alcwk 
		bmi atrophy TCCODE livalor livaln);
run;

proc contents data = whisf.analysis1;
	ods select attributes;
run;
* 2,448,638 observations and 58 variables;




* ============================================================================;
* Filling data across years
* Time-invariant variables (race, trial component, ever had...)
* Time-stable variables (education)
* ============================================================================;
* Put age in first obs per id;
proc sort data = whisf.analysis1;
	by id descending age;
run;

* Carryforward age in days and time-invariant variables;
* Can't do income here because it's time varying;
* Use DOW loop method; 
data whisf.analysis1;
	do until(last.id);
		set whisf.analysis1;
		age_days = age * 365.25;
		by id;
		if age_days ^= . then age_days2 = age_days;
		if race_eth ^= . then race_eth2 = race_eth;  
		if edu4cat  ^= . then edu4cat2 = edu4cat;   
		output;
	end;	
run;

* Add days to age and replace age with new values;
* Replace time-invariant variables with carried forward versions;
data whisf.analysis1 (drop = age_days age_days2 age2 race_eth2 edu4cat2);
	set whisf.analysis1;
	age_days2 = age_days2 + days;
	age2      = round(age_days2 / 365.25);
	age       = age2;
	race_eth  = race_eth2;
	edu4cat   = edu4cat2;
run;

proc sort data = whisf.analysis1;
	by id days;
run;

* LOCF income;
data whisf.analysis1;
	do until(last.id);
		set whisf.analysis1;
		by id;
		if inc5cat ^= . then inc5cat2 = inc5cat;   
		output;
	end;	
run;

* Replace income with carried forward version;
data whisf.analysis1 (drop = inc5cat2);
	set whisf.analysis1;
	inc5cat = inc5cat2;
run;

* Data check;
proc means data = whisf.analysis1;
	var age;
run;
* Range = (45, 90);

* ============================================================================;
* Creating Stata file to finish data cleaning in Stata.
* Eventually, I'd like to come back and finish doing it in SAS, but because
* so much more coding is already complete in Stata, it just make sense to 
* finish there.
* Exported "whisf.analysis1"
* ============================================================================;




* ============================================================================;
* Create variables: obs, finalobs, finalage, numobs, finalyears
* ============================================================================;
* Create tag for first and last observation by id;
proc sort data = whisf.analysis1;
	by id days;
run;

data whisf.analysis2;
	set whisf.analysis1;
	by id;
	first_obs = first.id;
	last_0bs  = last.id;
run;

* Creating a observation number variable;
data whisf.analysis2;
	format obs;
	set whisf.analysis2;
	obs + 1;
	by id;
	if first.id = 1 then obs = 1;
run;
			
* Creating an age at final observation variable;
data whisf.analysis2;
	set whisf.analysis2; 
	by id;
	if last.id = 1 then final_age = age;
run;

proc sort data = whisf.analysis2;
	by id descending final_age;
run;

data whisf.analysis2;
	do until(last.id);
		set whisf.analysis2;
		by id;
		if final_age ^= '' then final_age2 = final_age;   
		output;
	end;
	final_age = final_age2;
run;

data whisf.analysis2 (drop = final_age2);
	set whisf.analysis2;
	final_age = final_age2;
run;

	

	
* ============================================================================;
* Exposure Variable: Abuse

* Create dichotomous abuse groups (physical, verbal, any)
* Create dichotomous abuse ever (physical, verbal, any)
* Restrict to women who have a least one measure of abuse
* ============================================================================;
proc sort data = whisf.analysis2;
	by id days;
run;

* Create a dichotomous abuse variables;
data whisf.analysis3;
	set whisf.analysis2;

	phyab_d = phyab;
	if phyab_d in (1 2 3) then phyab_d = 1;

	verbab_d = verbab;
	if verbab_d in (1 2 3) then verbab_d = 1;

	if phyab_d = 1 | verbab_d = 1 then abuse_d = 1;
	else if phyab_d = 0 & verbab_d = 0 then abuse_d = 0;
run;

* Create a EVER variables;
proc sql;
	create table whisf.analysis3 as
		select *, 
               max(phyab_d) as phyab_ever,
			   max(verbab_d) as verbab_ever,
			   max(abuse_d) as abuse_ever
			from whisf.analysis3
			group by id
			order by id, days;
quit;

* How many women have no measure of abuse?;
proc sql;
	select count(*), nmiss(abuse_ever)
		from whisf.analysis3
		where obs = 1;

	select count(*)
		from whisf.analysis3
		where abuse_ever = .;
quit;
* 213 women with no meausre of abuse;
* 1,532 observations have a missing value for abuse_ever;

data whisf.analysis3;
	set whisf.analysis3;
	where abuse_ever ^= .;
run;

proc sort data = whisf.analysis3;
	by id obs;
run;

/******************************************************
213 women dropped for never having a measure of abuse.
161,595 women remain
******************************************************/




* ============================================================================;
* Create abuse status

* Create abuse status at baseline (first response about abuse) (physical, 
* verbal, any)
* Create four category abuse at baseline (none, phys only, verb only, both)
* Restrict to women who can be categorized into 4 categories
* Create four category abuse ever (none, phys only, verb only, both)
* Create abuse at baseline by age group variable
* ============================================================================;

* Create baseline physical abuse group based on individual woman's initial 
* observed status (not necissarily at observation 1).;
data whi.

proc sort data = whisf.analysis3 out = whisf.analysis4;
	by id descending phyab days;
run;

data whisf.analysis4;
	set whisf.analysis4;
	by id;
	if first.id = 1 & phyab ^= . then first_phyab_tag = 1;
	if first_phyab_tag = 1 then first_phyab = phyab;
	if first_phyab_tag = 1 then first_phyab_d = phyab_d;
run;

proc sort data = whisf.analysis4;
	by id days;
run;

* Create baseline verbal abuse group based on individual woman's initial 
* observed status (not necissarily at observation 1).;
proc sort data = whisf.analysis4;
	by id descending verbab days;
run;

data whisf.analysis4;
	set whisf.analysis4;
	by id;
	if first.id = 1 & verbab ^= . then first_verbab_tag = 1;
	if first_verbab_tag = 1 then first_verbab = verbab;
	if first_verbab_tag = 1 then first_verbab_d = verbab_d;
run;

* Create dichotomous abuse / no abuse (physical or verbal) at baseline based 
on woman's initial observed status;

* Are there any instances where the first observed value of phyab does not
* coincide with the first observed value of verbab?;
proc print data = whisf.analysis4;
	var id days phyab verbab first_phyab_tag first_verbab_tag;
	where (first_phyab_tag = 1 & first_verbab_tag ^= 1) |
		  (first_verbab_tag = 1 & first_phyab_tag ^= 1);
run;

proc print data = whisf.analysis4;
	where id = 100055;
run;

proc print data = whisf.analysis4 (obs = 25);
	var id days phyab first_phyab_tag first_phyab first_phyab_d verbab first_verbab_tag first_verbab first_verbab_d;
run;

* Distribute value of phyab at first observation to all observations;
create table whisf.analysis4 as
proc sql outobs = 25;
	
		select *, 
		       max(first_phyab) as first_phyab,
			   
			from whisf.analysis4;
quit;


by id, sort: egen firstphyab = max(cond(firstphyabobs==1, phyab, .))
			la variable firstphyab "Reported phyab @ first recoded measure"
			order firstphyab, before(verbab)


						
		* Dichotomize firstphyab (Yes/No)
			recode	firstphyab	(0=0   "No") ///
								(1/3=1 "Yes" ) ///
								,gen(firstphyab_d)
			order firstphyab_d, before(verbab)
								
			count if firstphyabobs==1 
			* 161,588
			count if firstphyabobs==1 & obs==1 
			* 2,473
				* Can only be one "1" per id.
				* 161,588 women have a first observation for phyab
					* Not necissarily at observation 1
			tab phyab_d if firstphyabobs==1
				/*At their first measure of physical abuse, 2,104 (1.3%) 
				report experiencing physical abuse*/
				
	***********************************************************************
	
	/*Create baseline verbal abuse group based individual woman's initial
	observed status (not necissarily at observation 1).*/
		sort id days
		* Tag the first observation for each person with an observed value for verbab
		by id (days), sort: gen byte firstverbabobs = sum(inrange(verbab, 0, 4)) == 1 ///
		& sum(inrange(verbab[_n - 1], ., .)) == 0
		la variable firstverbabobs "Tag first observed value of verbab"
		order firstverbabobs, before(abuse_d)
	
		/*Create baseline verbab group based on fist observed value (not 
		necissarily at observation 1).*/
			by id, sort: egen firstverbab = max(cond(firstverbabobs==1, verbab, .))
			la variable firstverbab "Reported verbab @ first recoded measure"
			order firstverbab, before(abuse_d)
						
		* Dichotomize firstverbab (Yes/No)
			recode	firstverbab	(0=0   "No") ///
								(1/3=1 "Yes" ) ///
								,gen(firstverbab_d)
			order firstverbab_d, before(abuse_d)
								
			count if firstverbabobs==1 
			* 161,591
			count if firstverbabobs==1 & obs==1 
			* 2,473
				* Can only be one "1" per id.
				* 161,591 women have a first observation for phyab
					* Not necissarily at observation 1
			tab verbab_d if firstverbabobs==1
				/*At their first measure of verbal abuse, 17,983 (11.13%) 
				report experiencing verbal abuse*/
				
	***********************************************************************
	
	/* Create dichotomous abuse / no abuse (physical or verbal) at baseline
	based on woman's initial observed status*/
	
	* Create dummy variable used to tag first observed abuse (phys or verb)
		gen dummy=1 if firstverbabobs==1 | firstphyabobs==1
		
	* Tag the first observation for each woman with an observed value for verbab OR phyab
		by id (days), sort: gen byte firstabobs = sum(dummy==1) == 1 ///
		& sum(inrange(dummy[_n - 1], ., .)) == 0
		la variable firstabobs "Tag first observed value of any abuse"
		order firstabobs, before(raceeth)
		
	/*Create baseline abuse group based on fist observed value (not 
		necissarily at observation 1).*/
			gen firstab=1 if (firstabobs==1 & phyab_d==1) | ///
							 (firstabobs==1 & verbab_d==1)
				replace firstab=0 if (firstabobs==1 & phyab==0) & ///
									 (firstabobs==1 & verbab==0)
			order firstab, before(raceeth)
							 
				by id: carryforward firstab, replace
				sort id ndays
				by id: carryforward firstab, replace
				sort id days
			la variable firstab "Reported abuse @ first recoded measure"
	
			count if firstabobs==1 
			* 161,595
			count if firstabobs==1 & obs==1 
			* 2,476
				* Can only be one "1" per id.
				* 161,595 women have a first observation for abuse of either type
					* Not necissarily at obs 1
			tab firstab if firstabobs==1
				/*At their first measure of abuse, 18,352 (11.38%) 
				report experiencing abuse*/
				
	* Drop variables that we will no longer need
		drop dummy
		
	***********************************************************************
	
	/* Create categorical variable (no abuse, verbal only, physical only, 
	physical and verbal) based on woman's initial observed status*/	
	
		gen abuse4cat=.
		replace abuse4cat=0 if firstab==0 & firstabobs==1 
		* No abuse group
		replace abuse4cat=1 if verbab_d==1 & phyab_d==0 & firstabobs==1 
		* Verbal only
		replace abuse4cat=2 if phyab_d==1 & verbab_d==0 & firstabobs==1 
		* Physical only
		replace abuse4cat=3 if phyab_d==1 & verbab_d==1 & firstabobs==1 
		* Physical and verbal
		la define abuse4cat 0 "No abuse" 1 "Verbal only" 2 "Physical only" 3 "Verb and Phys"
		la values abuse4cat abuse4cat
		
		tab abuse4cat if firstabobs==1, missing
			/*For the remaining 389 women, we don't know what category to put
			them in because they are missing a response for physical or verbal.
			We may be able to say that they were verbally abused, but we
			cannot say that they were "only" verbally abused. We don't know.*/
		
		order abuse4cat, before(raceeth)
		
		by id: carryforward abuse4cat, replace
			sort id ndays
		by id: carryforward abuse4cat, replace
			sort id days
		la variable abuse4cat "Abuse group @ first recoded measure"
		
		drop if abuse4cat==.
			* 1,585 observations deleted
		
		
		/******************************************************
		372 women who's abuse status could not be categorized
		were dropped.
		161,223 women remain.
		******************************************************/
	
	
		tab abuse4cat if firstabobs==1
				/*At their first measure of abuse (yes or no):
					142,961 (88.86%) women report no abuse
					16,215 (10.06%) women reoprt verbal abuse only
					402 (0.25%) women report physical abuse only
					1,680 (1.04%) women report verbal and physical abuse
					*/
					
	*Create a 4-level abuse ever variable
		gen x1 = 2 if phyab > 0 & phyab < .
		replace x1 = 0 if phyab == 0
		by id: egen x2 = max(x1)

		gen abuse4cat_ever = verbab_ever + x2
		drop x1 x2
		order abuse4cat_ever, after(abuse4cat)
		
		tab abuse4cat_ever if firstabobs==1, missing
			* 130,627 (81%) never report abuse
			* 26,724 (16.57%) experience verbal abuse only at some point during follow-up
			* 677 (0.42%) experience physical abuse only at some point during follow-up
			* 3,230 (2.0%) experience verbal and physical abuse at some point during follow-up
	
	*Create groups defined by age group and abuse (No/Yes)
		gen age_abusegroup = 1 if agestrat == 1 & firstab == 0 
		* 50-59, no abuse
		replace age_abusegroup = 2 if agestrat == 1 & firstab == 1 
		* 50-59, abuse
		replace age_abusegroup = 3 if agestrat == 2 & firstab == 0 
		* 60-69, no abuse
		replace age_abusegroup = 4 if agestrat == 2 & firstab == 1 
		* 60-69, abuse
		replace age_abusegroup = 5 if agestrat == 3 & firstab == 0 
		* 70-79, no abuse
		replace age_abusegroup = 6 if agestrat == 3 & firstab == 1 
		* 70-79, abuse
		la define age_abusegroup 1 "50-59, no abuse" 2 "50-59, abuse" ///
		3 "60-69, no abuse" 4 "60-69, abuse" 5 "70-79, no abuse" ///
		6 "70-79, abuse"
		la values age_abusegroup age_abusegroup
		order age_abusegroup, after(abuse4cat_ever)
		
	*Create groups defined by age group and abuse (4 Level)
		gen age_abusegroup4 = 1 if agestrat == 1 & abuse4cat == 0 
		* 50-59, no abuse
		replace age_abusegroup4 = 2 if agestrat == 1 & abuse4cat == 1 
		* 50-59, verb
		replace age_abusegroup4 = 3 if agestrat == 1 & abuse4cat == 2 
		* 50-59, phys
		replace age_abusegroup4 = 4 if agestrat == 1 & abuse4cat == 3 
		* 50-59, both
		replace age_abusegroup4 = 5 if agestrat == 2 & abuse4cat == 0 
		* 60-69, no abuse
		replace age_abusegroup4 = 6 if agestrat == 2 & abuse4cat == 1 
		* 60-69, verb 
		replace age_abusegroup4 = 7 if agestrat == 2 & abuse4cat == 2 
		* 60-69, phys
		replace age_abusegroup4 = 8 if agestrat == 2 & abuse4cat == 3 
		* 60-69, both
		replace age_abusegroup4 = 9 if agestrat == 3 & abuse4cat == 0 
		* 70-79, no abuse
		replace age_abusegroup4 = 10 if agestrat == 3 & abuse4cat == 1 
		* 70-79, verb
		replace age_abusegroup4 = 11 if agestrat == 3 & abuse4cat == 2 
		* 70-79, phys
		replace age_abusegroup4 = 12 if agestrat == 3 & abuse4cat == 3 
		* 70-79, both
		la define age_abusegroup4 1 "50-59, no abuse" 2 "50-59, verb" ///
		3 "50-59, phys" 4 "50-59, both" 5 "60-69, no abuse" ///
		6 "60-69, verb" 7 "60-69, phys" 8 "60-69, both" ///
		9 "70-79, no abuse" 10 "70-79, verb" 11 "70-79, phys" ///
		12 "70-79, both"
		la values age_abusegroup4 age_abusegroup4
		order age_abusegroup4, after(age_abusegroup)
				
	* Create a time-varying abuse (4 category) variable (433)
		gen abuse4cat_ij = .
		replace abuse4cat_ij =0 if abuse_d==0 
		* No abuse group
		replace abuse4cat_ij =1 if verbab_d==1 & phyab_d==0 
		* Verbal only
		replace abuse4cat_ij =2 if phyab_d==1 & verbab_d==0 
		* Physical only
		replace abuse4cat_ij =3 if phyab_d==1 & verbab_d==1 
		* Physical and verbal
		la define abuse4cat_ij 0 "No abuse" 1 "Verb Only" ///
		2 "Phys Only" 3 "Both Forms"
		la values abuse4cat_ij abuse4cat_ij
	
		order abuse4cat_ij, after(abuse4cat)
		
		* Carryforward the "no's" until a "Yes"
		by id (days), sort: replace abuse4cat_ij = abuse4cat_ij[_n-1] if ///
		missing(abuse4cat_ij) & abuse4cat_ij[_n-1]==0
		
		* Replace no abuse or missing with verb only
		by id (days), sort: replace abuse4cat_ij = abuse4cat_ij[_n-1] if ///
		abuse4cat_ij[_n-1]==1 & (missing (abuse4cat_ij) | abuse4cat_ij==0)
		
		* Replace no abuse or missing with phys only
		by id (days), sort: replace abuse4cat_ij = abuse4cat_ij[_n-1] if ///
		abuse4cat_ij[_n-1]==2 & (missing (abuse4cat_ij) | abuse4cat_ij==0)
		
		* Replace verb only with both if phys only is before
		by id (days), sort: replace abuse4cat_ij = 3 if ///
		abuse4cat_ij[_n-1]==2 & abuse4cat_ij==1
		
		* Replace physab only with both if verb only is before
		by id (days), sort: replace abuse4cat_ij = 3 if ///
		abuse4cat_ij[_n-1]==1 & abuse4cat_ij==2
		
		* Replace missing, no abuse, or one form with both forms
		by id (days), sort: replace abuse4cat_ij = abuse4cat_ij[_n-1] if ///
		abuse4cat_ij[_n-1]==3
		
		* Data check
		tab abuse4cat_ij, missing
			* No = 2,471,252
			* Verb only = 400,552
			* Phys only = 9,378
			* Verb and Phys = 43,517
			* 281,048 missing
			/*The women with missing for this variable are because they had a 
			measurement for one type of abuse, but not the other, so we couldn't
			classify them. Or, because the observation fall before thier 
			first measure of abuse.*/
	
	* Save again
		compress
		* save "analysis long 5", replace
		
		
		
		

		
		
		
		
* ============================================================================;
* Creating "Baseline"
* Baseline is going to be first measure of abuse. Here's why:
* In order to do table 1, I have to have one row (or at least only tab
* the characteristics from one row) for each woman.
* Because of missing data, I can't just use obs==1 for each woman.
* It's better to use abuse status (as opposed to physfun) as the varible 
* to set baseline to because if forms my exposure groups (table 1).
* Additionally, on average, the first abuse measure occured on day -29,
* and only 610 (0.4%) women had their first measure after day zero. 
* Therefore, it actually is pretty close to being a true baseline for
* each woman.
* ============================================================================;
	
/*For women who's first measure of abuse is after day zero, I need to shift
their data to "the left" on the timeline.*/
* use "analysis long 5", clear

	codebook id
	* 161,223

	* Identify women who's first measure of abuse is after day 1:
		by id (days), sort: gen byte tag = 1 if firstabobs==1 & days > 0
		tab tag
		* 575 women have their first observed value for abuse after day 0
				
		by id: egen tag2 = max(cond(firstabobs==1 & days >0, 1, 0))

	* Create a "year 0" for these women:
		by id (days), sort: egen start_year_zero = sum(cond(tag==1, days, .)-365.35) if tag2==1
		
		by id: drop if days < start_year_zero & tag2==1
		
		by id (days), sort: replace obs = _n if tag2==1
		
	* Shift day scale over to the right on the timeline:
		by id (days), sort: egen day_zero = sum(cond(tag==1, days, .)) if tag2==1
		
		by id: gen days3 = days-day_zero if tag2==1
		
		by id: replace days = days3 if tag2==1

		drop tag tag2 start_year_zero  day_zero days3
		
		codebook id 
		* 161,223
		
		count if firstabobs==1	
		* All 161,223 women have at least one measure of abuse
		
	***********************************************************************

/*For women who's first measure of abuse is before day zero, I need to shift
their data to "the right" on the timeline.*/

	* Identify women who's first measure of absue is before day 0
		by id (days), sort: gen byte tag1 = 1 if firstabobs==1 & day < 0
		count if tag1==1	
		/*148,729 women have their first observed measure of abuse 
		before day zero*/
		tabstat days if tag1==1, stats(n mean p50 sd)
		/*In this group of women, the first measure of abuse occurs,
		on average, about 36 days before day zero. The median number
		of days is 26 and the standard deviation is 39 days.*/
		
		by id: egen tag2 = max(cond(tag1==1, 1, 0))
			
	* Create a "year 0" for these women:
		by id (days), sort: egen start_year_zero = sum(cond(tag1==1, days, .)-365) if tag2==1
		
		by id: drop if days < start_year_zero & tag2==1
		
		by id (days), sort: replace obs = _n if tag2==1
		
	* Shift day scale over to the left on the timeline:
		by id (days), sort: egen day_zero = sum(cond(tag1==1, days, .)) if tag2==1
		
		by id: gen days3 = days-day_zero if tag2==1
		
		by id: replace days = days3 if tag2==1

		drop tag1 tag2 start_year_zero  day_zero days3
		
		codebook id 
		* 161,223
		
		count if firstabobs==1	
		* All 161,223 women have at least one measure of abuse
		
		count if firstabobs==1 & days==0 
		* Day 0 is now the first measure of abuse
	
	* Save (At this point, it can only be used for the physical function paper)
	* save "m1852 1", replace	
	
	***********************************************************************

* Carryforward all year 0 data to fill in missing values in day 0
* use "m1852 1", clear
	
	* Drop all observations that occur before day -365
	drop if days < -365	
	* 673 obs deleted
		
	/*
	All measures of covariates that remain were measured within a 
	year of day 0.
	
	I am considering this to be a valid measure of cooccurance.
	Carryforward any covariate that was measured before day 0 if 
	day zero is currently missing.
	
	For now, just do this for depression and sexual function
	*/
			
		foreach var of varlist sexactiv satsex satfrqsx pshtdep {
			by id (days), sort: replace `var' = `var'[_n-1] if missing(`var') & days<=0
				}
				
	* Anything that can validly be carried foward to day 0 has, drop before day 0
		drop if days < 0
		* 149,386 observations deleted
		
	* Now that there is a new baseline, I need to reset other "time" variables
		replace age_years = round(age_years, 1.0)
		rename age_years age
		
		by id: replace obs = _n
		
		by id: replace ndays = -days
		
		codebook days	
		* Range= (0,4262)
		
		forvalues i = 1/20 {
			display `i'*365
				}
		
		recode	days	(0/365=0) ///
					(366/730=1) ///
					(731/1095=2) ///
					(1094/1460=3) ///
					(1461/1825=4) ///
					(1826/2190=5) ///
					(2191/2555=6) ///
					(2556/2920=7) ///
					(2921/3285=8) ///
					(3286/3650=9) ///
					(3651/4015=10) ///
					(4016/4380=11) ///
					(4381/4745=12) ///
					(4746/5110=13) ///
					(5111/5475=14) ///
					(5476/5840=15) ///
					(5841/6205=16) ///
					(6206/6570=17) ///
					(6571/6935=18) ///
					(6936/7300=19) ///
					,gen(years2)
					/*I changed the time interval from 1-17 to 1-18. The
					year leading up to day 0 should be year zero and days
					0 to 365 are each woman's first year of follow-up.
						
					Change it back because of the way "intervals" are set 
					up on the life table*/
		
		order years2, after(years_r)
		replace years = round(years2, 1.0)
		drop years_r years2
				
		codebook id age
		* 161,223 women aged 49 to 90
		
		* resetting "final" time variables
		replace numobs = obs if finalobs==1
		replace finalyears = years if finalobs==1
		
	* Save
	save "/Users/bradcannell/Desktop/whi_sf1", replace
	
	
	
	
	
	
	
	
	
* ============================================================================;
* Data reduction

* Keep only baseline observations
* Keep only women who were sexaully active in the past year
* Keep only women who have a depression score
* ============================================================================;
* use "/Users/bradcannell/Dropbox/Research/WHI/Sexual function/whi_sf1.dta", clear
use "C:\Users\mbc0022\Dropbox\Research\WHI\Sexual function\data\whi_sf1.dta", clear

keep if days == 0 
* 360,895 observations deleted

tab sexactiv, missing

* Recode 9 to missing
replace sexactiv = . if sexactiv == 9
*5,773 real changes made

* Update 2017-01-17: Erika wants me to do a cross tab of sexually active by abuse
tab sexactiv firstab

keep if sexactiv == 1
* 78,255 observations deleted
* 82,968 women remain

tab satsex, missing
tab satfrqsx, missing

* Recode 9 to missing
replace satsex = . if satsex == 9
* 3,063 real changes made
replace satfrqsx = . if satfrqsx == 9
* 3,639 real changes made

* Drop satsex since it has the least amount of missing
keep if satsex != .
* 3,214 observations deleted
* 79,754 women remain

tabstat pshtdep, stats(n mean)

keep if pshtdep != .
* 1,433 observations deleted
* 78,321 women remain	

/*
All women remaining in the data set have a common baseline - thier first measure
of abuse.

All women have a baseline measure of abuse.

All women were sexually active in the past year.

All women have a sexual satisfaction measure.

All women have a depression score.
*/

* Save data
save "/Users/bradcannell/Desktop/whi_sf2", replace

* Export for R
export delimited id firstab satsex satfrqsx pshtdep using "/Users/bradcannell/Desktop/whi_sf.csv", replace


/*******************************************************************************
Sexual function paper stuff ends here. Keeping the stuff below "just in case"
*******************************************************************************/
