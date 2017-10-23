* ============================================================================;
* WHI Sexual Function Paper
* Means and Frequencies for Table 1
* 2017-10-20

* Note: I can impute first, then create table 1. I should come back and do
* that.
* ============================================================================;

proc import 
	out = baseline_only
	datafile = "\\Mac\Dropbox\Research\WHI\MS3226 - Sexual function\whi_sexual_function\data\baseline_only.xlsx"
	dbms = XLSX replace;
run;

proc contents data = baseline_only;
run;


ods rtf file = "\\Mac\Dropbox\Research\WHI\MS3226 - Sexual function\whi_sexual_function\SAS_reports\Stats for Table 1.rtf";

* Means for No Abuse vs. Any Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Means for No Abuse vs. Any Abuse";
footnote "&sysdate at &systime";
proc means data = baseline_only mean clm;
	class abuse_d_f;
	var packyrs pshtdep;
	ods output summary = means_2cat;
run;


* Percentages for No Abuse vs. Any Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Percentages for No Abuse vs. Any Abuse";
footnote "&sysdate at &systime";
proc surveyfreq data = baseline_only;
	tables abuse_d_f * (age_group_f race_eth_f edu2cat_f inc5cat_f married_f
           ctos_f bmi4cat_f hyst_f incont_f hypt_f cvd_f arthrit_f 
           diab_combined_f canc_f hip55_f good_health_f ssri_f night_sweats_f 
           hot_flashes_f vag_dry_f hormnw_f) 
		   / row cl chisq;
	ods output crosstabs = freqs_2cat;
run;


* Means for 4-category Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Means for 4-category Abuse";
footnote "&sysdate at &systime";
proc means data = baseline_only mean clm;
	class abuse4cat_f;
	var packyrs pshtdep;
	ods output summary = means_4cat;
run;


* Percentages for 4-category Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Percentages for 4-category Abuse";
footnote "&sysdate at &systime";
proc surveyfreq data = baseline_only;
	tables abuse4cat_f * (age_group_f race_eth_f edu2cat_f inc5cat_f married_f
           ctos_f bmi4cat_f hyst_f incont_f hypt_f cvd_f arthrit_f 
           diab_combined_f canc_f hip55_f good_health_f ssri_f night_sweats_f 
           hot_flashes_f vag_dry_f hormnw_f) 
		   / row cl chisq;
	ods output crosstabs = freqs_4cat;
run;

ods rtf close;


* ============================================================================;
* Run again in a more Word friendly format for making Table 1
* ============================================================================;

ods rtf file = "\\Mac\Dropbox\Research\WHI\MS3226 - Sexual function\whi_sexual_function\SAS_reports\Stats for Table 1 Word.rtf";

* Means for No Abuse vs. Any Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Means for No Abuse vs. Any Abuse";
footnote "&sysdate at &systime";
proc sql;
select abuse, variable, mean, lcl, ucl, 
	   cat(put(mean, 4.2), ' (', put(lcl, 4.2), ' - ', put(ucl, 4.2), ')') as 
       mean_95
	from
	(
	select abuse_d_f as abuse, VName_packyrs as variable, 
       	   packyrs_Mean as mean, packyrs_LCLM as lcl, 
       	   packyrs_UCLM as ucl
		from means_2cat

	union

	select abuse_d_f as abuse, VName_pshtdep as variable, 
       	   pshtdep_Mean as mean, pshtdep_LCLM as lcl, 
       	   pshtdep_UCLM as ucl
		from means_2cat
	)
	order by variable;
quit;


* Percentages for No Abuse vs. Any Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Percentages for No Abuse vs. Any Abuse";
footnote "&sysdate at &systime";
data freqs_2cat_word;
	set freqs_2cat
	/* Only keep the stats and characteristics of interest */
	(keep = RowPercent RowLowerCL RowUpperCL F_:); 
	/* Drop "Total" rows, they are unneeded */
	if F_abuse_d_f ^= "Total";
	/* Put all characteristics in an array */
	array characteristic_vars F_:;
	do over characteristic_vars;
		/* Create a new variable, characteristic, that records the */
		/* characteristic variable's name */
		/* Create a new variable, category, that records the category each */
		/* percent (CI) is assoiciated with */
		if characteristic_vars ^= "" then do;
			characteristic = vname(characteristic_vars);
			category = characteristic_vars;
		end;
	end;
	/* Create a combined percent and confidence interval string */
	percent_95 = cat(
		put(rowpercent, 4.2), 
		' (', 
		put(RowLowerCL, 4.2), 
		' - ', 
		put(RowUpperCL, 4.2),
		')'
	);
run;

proc print data = freqs_2cat_word;
	var F_abuse_d_f characteristic category percent_95;
run;


* Means for 4-category Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Means for 4-category Abuse";
footnote "&sysdate at &systime";
proc sql;
select abuse, variable, mean, lcl, ucl, 
	   cat(put(mean, 4.2), ' (', put(lcl, 4.2), ' - ', put(ucl, 4.2), ')') as 
       mean_95
	from
	(
	select abuse4cat_f as abuse, VName_packyrs as variable, 
       	   packyrs_Mean as mean, packyrs_LCLM as lcl, 
       	   packyrs_UCLM as ucl
		from means_4cat

	union

	select abuse4cat_f as abuse, VName_pshtdep as variable, 
       	   pshtdep_Mean as mean, pshtdep_LCLM as lcl, 
       	   pshtdep_UCLM as ucl
		from means_4cat
	)
	order by variable;
quit;


* Percentages for 4-category Abuse;
* ============================================================================;
title1 "WHI Sexual Function Analysis";
title2 "Percentages for 4-category Abuse";
footnote "&sysdate at &systime";
data freqs_4cat_word;
	set freqs_4cat
	/* Only keep the stats and characteristics of interest */
	(keep = RowPercent RowLowerCL RowUpperCL F_:); 
	/* Drop "Total" rows, they are unneeded */
	if F_abuse4cat_f ^= "Total";
	/* Put all characteristics in an array */
	array characteristic_vars F_:;
	do over characteristic_vars;
		/* Create a new variable, characteristic, that records the */
		/* characteristic variable's name */
		/* Create a new variable, category, that records the category each */
		/* percent (CI) is assoiciated with */
		if characteristic_vars ^= "" then do;
			characteristic = vname(characteristic_vars);
			category = characteristic_vars;
		end;
	end;
	/* Create a combined percent and confidence interval string */
	percent_95 = cat(
		put(rowpercent, 4.2), 
		' (', 
		put(RowLowerCL, 4.2), 
		' - ', 
		put(RowUpperCL, 4.2),
		')'
	);
run;

proc print data = freqs_4cat_word;
	var F_abuse4cat_f characteristic category percent_95;
run;

ods rtf close;
