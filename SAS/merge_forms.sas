* ============================================================================;
* Merge WHI Forms
* 2017-03-04
* Individual form data sets were previously cleaned and duplicates (by id, 
* days) were removed.
* ============================================================================;

* Setup libraries;
libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

* Merge forms by id and day;
* For now, I want to retain all observations from all datasets - even if they
* don't have a merge match. Therefore, I will do a full outer join;


* ============================================================================;
* Sort all forms by id and day
* ============================================================================;
%macro multsort(ds_list, by_list);
	/* Count number of datasets */
	%let data_cnt = %sysfunc(countw(&ds_list, ","));

	/* Count number of byvars */
	%let word_cnt = %sysfunc(countw(&by_list)); 

	/* Data Checks */
	%put &data_cnt datasets were read in;
	%put There are &word_cnt variables in the by statement;

	/* Sort datasets in loop */
	%do i = 1 %to &data_cnt;
    	%let indata  = %scan(&ds_list, &i, ",");
    	%let byvars  = %scan(&by_list, &word_cnt, ",");
    	proc sort data = &indata;
			by &by_list;
		run;

		/* Data Checks */
		proc contents data = &indata;
			ods select attributes sortedby;
		run;
	%end;
%mend;

%multsort(ds_list   = "whisf.demo, whisf.f2, whisf.f20, whisf.f30, whisf.f31,
                      whisf.f34, whisf.f35, whisf.f37, whisf.f38, whisf.f44, 
					  whisf.f60, whisf.f80, whisf.f81", 
	      by_list   = id days);

* Alternate form;
data ds_list;
	length dname $ 10;
	input  dname;
	datalines;
	whisf.demo 
	whisf.f2 
	whisf.f20
	whisf.f30
	whisf.f31
	whisf.f34
	whisf.f35
	whisf.f37
	whisf.f38
	whisf.f60
	whisf.f80
	whisf.f81
	;
run;

data _null_;
	set ds_list;
	string = catt(
		'proc sort data=', dname, '; 
			by id days; 
		run;');
	call execute(string);
run;



* ============================================================================;
* Merge forms together
* ============================================================================;
data whisf.merged;
	merge	whisf.demo 
			whisf.f2 
			whisf.f20
			whisf.f30
			whisf.f31
			whisf.f34
			whisf.f35
			whisf.f37
			whisf.f38
			whisf.f44
			whisf.f60
			whisf.f80
			whisf.f81
			;
	by id days;
run;

ods html file = "C:\Users\mbc0022\Dropbox\Research\WHI\
MS3226 - Sexual function\whiSexualFunction\SAS_reports\merged_codebook.html";
proc contents data = whisf.merged position;
	title1 WHI Abuse and Sexual Function Study;
	title2 Merged Data Codebook;
run;
ods html close;
* 2,448,638 observations and 815 variables;




* ============================================================================;
* Subset variables of interest
* ============================================================================;
data whisf.analysis_01;
	set whisf.merged (keep =
	/* Administrative and Sociodemographic */
	id days age ager race_eth edu4cat inc5cat marital married sex ctos parity

	/* Health Behavior */
	texpwk alcswk f60alc f60alcwk f60caff smoknow smoking horm hormnw tccode
	livalor livaln

	/* Health and Wellness */
	lifequal pshtdep bmi genhel hyst nightswt hotflash vagdry incont atrophy

	/* Chronic Disease */
	arthrit brca_f30 cervca endo_f30 ovryca cvd diab hypt osteopor pad

	/* Sexual Function */
	sexactiv satsex satfrqsx

	/* Abuse */
	phyab verbab);
run;

ods html;
proc contents data = whisf.analysis_01 position;
	title1 ;
run;
* 2,448,638 observations and 49 variables;
