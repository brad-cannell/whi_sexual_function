* ============================================================================;
* WHI Sexual Function Paper
* Multiple Imputation
* ============================================================================;
proc import
	out = whi_sf_baseline
	datafile = "\\Mac\Dropbox\Research\WHI\MS3226 - Sexual function\whi_sexual_function\data\baseline_only.xlsx"
	dbms = xlsx replace;
run;

proc print data = whi_sf_baseline (obs = 20);
run;

proc contents data = whi_sf_baseline varnum;
ods output Position = var_list;
run;

data var_list;
	set var_list (keep = Variable);
run;

* Create a variable list so I don't have to type each var name manually;
proc export
	data = var_list
	outfile = "C:\\Users\mbc0022\Desktop\var_list.xlsx"
	dbms = xlsx;
run;


* Explore missing data patterns;
* ============================================================================;
proc mi nimpute = 0 data = whi_sf_baseline;
run;


* Generate the imputations - second attempt (no _days)
* Excluding administrative variables: id, days, baseline, ctos_f
* by not including them in any of the statements below.
* ============================================================================;
proc mi 
	data = whi_sf_baseline
	out  = whi_sf_baseline_mi
	nimpute = 1
	seed = 20171027;

	* Categorical variables;
	class satisfied_f freq_satisfied_f abuse4cat_f 
		  race_eth_f edu2cat_f inc5cat_f married_f hyst_f incont_f hypt_f cvd_f
		  arthrit_f diab_f canc_f hip55_f good_health_f ssri_f night_sweats_f
		  hot_flashes_f vag_dry_f hormnw_f;
	
	* Tell SAS how I want to model the imputations;
	* https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#statug_mi_sect008.htm;
	* https://stats.idre.ucla.edu/sas/seminars/multiple-imputation-in-sas/mi_new_1/;
	
	/* Non-ordered categorical variables */
	fcs logistic(satisfied_f freq_satisfied_f race_eth_f edu2cat_f married_f 
				 hyst_f incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f
				 good_health_f ssri_f night_sweats_f hot_flashes_f vag_dry_f
				 hormnw_f / link = glogit)

	/* Ordered categorical variables */
		logistic(abuse4cat_f inc5cat_f)

	/* Continuous variables */
		regpmm(packyrs bmi pshtdep)
	;

	* Order of the variables in the var statement sets the order of 
	* imputation. Arranging by missingness in ascending order. I already
	* calculated percent missing in R.;
	var 
	age abuse4cat_f incont_f race_eth_f good_health_f hot_flashes_f vag_dry_f 
	night_sweats_f edu2cat_f pshtdep married_f satisfied_f  freq_satisfied_f  
	inc5cat_f canc_f packyrs cvd_f hypt_f hip55_f arthrit_f hyst_f bmi ssri_f 
	diab_f hormnw_f;
run;




















* Old stuff. Don't delete quite yet...



* Generate the imputations
* Excluding administrative variables: id, days, baseline, ctos_f
* by not including them in any of the statements below.
* ============================================================================;
proc mi 
	data = whi_sf_baseline
	out  = whi_sf_baseline_mi
	nimpute = 5
	seed = 20171027;

	* Categorical variables;
	class satisfied_f freq_satisfied_f abuse_d_f abuse4cat_f 
		  race_eth_f edu2cat_f inc5cat_f married_f hyst_f incont_f hypt_f cvd_f
		  arthrit_f diab_f canc_f hip55_f good_health_f ssri_f night_sweats_f
		  hot_flashes_f vag_dry_f hormnw_f canc_f_2 cvd_f_2 hypt_f_2 hip55_f_2
		  arthrit_f_2 hyst_f_2 ssri_f_2 diab_f_2 hormnw_f_2;
	
	* Tell SAS how I want to model the imputations;
	* If I leave out the "_2" and "_days" vars from the fcs statement, SAS will
	* still try to impute any missing using default methods, but we aren't
	* really concerned. We aren't going to use those variables after MI anyway;
	* https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#statug_mi_sect008.htm;
	* https://stats.idre.ucla.edu/sas/seminars/multiple-imputation-in-sas/mi_new_1/;

	fcs logistic(incont_f = satisfied_f freq_satisfied_f abuse4cat_f age 
             race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f hypt_f 
             cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep ssri_f 
             night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(race_eth_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f / link = glogit);

	fcs logistic(good_health_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs logistic(hot_flashes_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f vag_dry_f hormnw_f);

	fcs logistic(vag_dry_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f hormnw_f);

	fcs logistic(night_sweats_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(edu2cat_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs regpmm(pshtdep = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(married_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs logistic(satisfied_f = freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(freq_satisfied_f = satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(inc5cat_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(canc_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f canc_f_2 canc_f_days);

	fcs regpmm(packyrs = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f bmi hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(cvd_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f cvd_f_2 cvd_f_days);

	fcs logistic(hypt_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f hypt_f_2 hypt_f_days);

	fcs logistic(hip55_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f hip55_f_2 hip55_f_days);

	fcs logistic(arthrit_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f arthrit_f_2 arthrit_f_days);

	fcs logistic(hyst_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs regpmm(bmi = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(diab_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f diab_f_2 diab_f_days);

	fcs logistic(hormnw_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f_2 hormnw_f_days);
	;

	* Order of the variables in the var statement sets the order of 
	* imputation. Arranging by missingness in ascending order. I already
	* calculated percent missing in R.
	* Although abuse and age have no missing, we still need to include them
	* in the var statement so that they can be used in the imputation models;
	var 
	abuse_d_f abuse4cat_f age incont_f race_eth_f good_health_f hot_flashes_f 
	vag_dry_f hyst_f_2 hyst_f_days night_sweats_f diab_f_2 diab_f_days edu2cat_f 
	canc_f_2 canc_f_days hypt_f_2 hypt_f_days arthrit_f_2 arthrit_f_days pshtdep 
	married_f satisfied_f bmi_2 bmi_days freq_satisfied_f cvd_f_2 cvd_f_days 
	inc5cat_f canc_f ssri_f_2 ssri_f_days packyrs cvd_f hypt_f hip55_f_2 
	hip55_f_days hip55_f hormnw_f_2 hormnw_f_days arthrit_f hyst_f bmi ssri_f 
	packyrs_2 packyrs_days diab_f hormnw_f;
run;


* Didn't work. Drop everything that ends with _days
* ============================================================================;
proc contents data = whi_sf_baseline 
	out = contents (keep = name)
	noprint;
run;

proc sql noprint;
select name
	into :droplist separated by " "
	from contents
	where name like "%^_days" escape "^";
quit;

%put &droplist;

data whi_sf_baseline_2;
	set whi_sf_baseline (drop = &droplist);
run;


* Generate the imputations - second attempt (no _days)
* Excluding administrative variables: id, days, baseline, ctos_f
* by not including them in any of the statements below.
* ============================================================================;
proc mi 
	data = whi_sf_baseline_2
	out  = whi_sf_baseline_mi
	nimpute = 5
	seed = 20171027;

	* Categorical variables;
	class satisfied_f freq_satisfied_f abuse_d_f abuse4cat_f 
		  race_eth_f edu2cat_f inc5cat_f married_f hyst_f incont_f hypt_f cvd_f
		  arthrit_f diab_f canc_f hip55_f good_health_f ssri_f night_sweats_f
		  hot_flashes_f vag_dry_f hormnw_f canc_f_2 cvd_f_2 hypt_f_2 hip55_f_2
		  arthrit_f_2 hyst_f_2 ssri_f_2 diab_f_2 hormnw_f_2;
	
	* Tell SAS how I want to model the imputations;
	* If I leave out the "_2" and "_days" vars from the fcs statement, SAS will
	* still try to impute any missing using default methods, but we aren't
	* really concerned. We aren't going to use those variables after MI anyway;
	* https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#statug_mi_sect008.htm;
	* https://stats.idre.ucla.edu/sas/seminars/multiple-imputation-in-sas/mi_new_1/;

	fcs logistic(incont_f = satisfied_f freq_satisfied_f abuse4cat_f age 
             race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f hypt_f 
             cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep ssri_f 
             night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(race_eth_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f / link = glogit);

	fcs logistic(good_health_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs logistic(hot_flashes_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f vag_dry_f hormnw_f);

	fcs logistic(vag_dry_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f hormnw_f);

	fcs logistic(night_sweats_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(edu2cat_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs regpmm(pshtdep = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(married_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);
 
	fcs logistic(satisfied_f = freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(freq_satisfied_f = satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(inc5cat_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(canc_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f canc_f_2);

	fcs regpmm(packyrs = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f bmi hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(cvd_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f cvd_f_2);

	fcs logistic(hypt_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f hypt_f_2);

	fcs logistic(hip55_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f hip55_f_2);

	fcs logistic(arthrit_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f arthrit_f_2);

	fcs logistic(hyst_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs regpmm(bmi = satisfied_f freq_satisfied_f 
		   abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs hyst_f 
		   incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
		   ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f);

	fcs logistic(diab_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f diab_f_2);

	fcs logistic(hormnw_f = satisfied_f freq_satisfied_f 
			 abuse4cat_f age race_eth_f edu2cat_f inc5cat_f married_f packyrs bmi hyst_f 
			 incont_f hypt_f cvd_f arthrit_f diab_f canc_f hip55_f good_health_f pshtdep 
			 ssri_f night_sweats_f hot_flashes_f vag_dry_f hormnw_f_2);
	;

	* Order of the variables in the var statement sets the order of 
	* imputation. Arranging by missingness in ascending order. I already
	* calculated percent missing in R.
	* Although abuse and age have no missing, we still need to include them
	* in the var statement so that they can be used in the imputation models;
	var 
	abuse_d_f abuse4cat_f age incont_f race_eth_f good_health_f hot_flashes_f 
	vag_dry_f hyst_f_2 night_sweats_f diab_f_2 edu2cat_f 
	canc_f_2 hypt_f_2 arthrit_f_2 pshtdep 
	married_f satisfied_f bmi_2 freq_satisfied_f cvd_f_2 
	inc5cat_f canc_f ssri_f_2 packyrs cvd_f hypt_f hip55_f_2 
	hip55_f hormnw_f_2 arthrit_f hyst_f bmi ssri_f 
	packyrs_2 diab_f hormnw_f;
run;


* Still doesn't run;
