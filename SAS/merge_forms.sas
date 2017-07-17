* ============================================================================;
* Merge WHI Forms
* 2017-03-04

* Individual form data sets were previously cleaned and duplicates (by id, 
* days) were removed.

* Went ahead and created the pack years variable in this file as well. Using
* SAS because the code was already written and available for SAS.
* ============================================================================;

* Setup libraries;
libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whi_sexual_function\data";

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
MS3226 - Sexual function\whi_sexual_function\SAS_reports\merged_codebook.html";
title1 WHI Abuse and Sexual Function Study;
title2 Merged Data Codebook;
proc contents data = whisf.merged position;
run;
ods html close;
title;
* 2,448,638 observations and 815 variables;




* ============================================================================;
* Create pack years of smoking variable
* This code is from the document titled "Pack Years of Smoking Algorithm"
* ============================================================================;
data whisf.merged;
	set whisf.merged;

	* INTERMEDIATE VARIABLE CREATION AND DATA EDITS;
	IF SMOKEVR = 1 AND SMOKYRS = 7 AND AGE < 61 THEN DO; 
		IF SMOKNOW = 1 THEN DO; 
			IF SMOKAGE = 1 THEN YRS = AGE - 12.5; 
				ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = AGE - ((SMOKAGE + 1)*5 + 2); 
				ELSE IF SMOKAGE = 9 THEN YRS = AGE - 50;
		END; 
		IF SMOKNOW = 0 THEN DO; 
			IF (QSMOKAGE + 1)*5 <= AGE <= (QSMOKAGE + 2)*5 - 1 THEN DO; 
				IF SMOKAGE = 1 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - 12.5; 
					ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - ((SMOKAGE + 1)*5 + 2); 
					ELSE IF SMOKAGE = 9 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - 50; 
			END; 
			ELSE IF AGE > (QSMOKAGE + 2)*5 - 1 THEN DO; 
				IF SMOKAGE = 1 THEN YRS = (QSMOKAGE + 1)*5 - 12.5; 
					ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = (QSMOKAGE + 1)*5 - ((SMOKAGE + 1)*5 + 2); 
					ELSE IF SMOKAGE = 9 THEN YRS = (QSMOKAGE + 1)*5 - 50; 
			END; 
		END; 
	END;

	ELSE IF SMOKEVR = 1 AND SMOKYRS = 7 and AGE >= 61 THEN DO; 
		IF SMOKAGE = 1 THEN YRSX = AGE - 12.5; 
			ELSE IF 2 <= SMOKAGE <= 8 THEN YRSX = AGE - ((SMOKAGE + 1)*5 + 2); 
			ELSE IF SMOKAGE = 9 THEN YRSX = AGE - 50; YRS = MAX(50,YRSX); 
	END; 
	DROP YRSX;

	ELSE IF SMOKEVR = 1 AND SMOKYRS = . AND SMOKAGE <= QSMOKAGE THEN DO; 
		IF SMOKNOW = 1 THEN DO; 
			IF SMOKAGE = 1 THEN YRS = AGE - 12.5; 
				ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = AGE - ((SMOKAGE + 1)*5 + 2); 
				ELSE IF SMOKAGE = 9 THEN YRS = AGE - 50; 
		END; 
		IF SMOKNOW = 0 THEN DO; 
			IF (QSMOKAGE + 1)*5 <= AGE <= (QSMOKAGE + 2)*5 - 1 THEN DO; 
				IF SMOKAGE = QSMOKAGE and SMOKAGE NE . THEN YRS = 2.5; 
					ELSE IF SMOKAGE = 1 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - 12.5; 
					ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - ((SMOKAGE + 1)*5 + 2); 
					ELSE IF SMOKAGE = 9 THEN YRS = ((AGE - (QSMOKAGE + 1)*5)/2 + (QSMOKAGE + 1)*5) - 50;
			END; 
			ELSE IF AGE > (QSMOKAGE + 2)*5 - 1 THEN DO; 
				IF SMOKAGE = QSMOKAGE and SMOKAGE NE . THEN YRS = 2.5; 
					ELSE IF SMOKAGE = 1 THEN YRS = (QSMOKAGE + 1)*5 - 12.5; 
					ELSE IF 2 <= SMOKAGE <= 8 THEN YRS = (QSMOKAGE + 1)*5 - ((SMOKAGE + 1)*5 + 2); 
					ELSE IF SMOKAGE = 9 THEN YRS = (QSMOKAGE + 1)*5 - 50; 
			END; 
		END; 
	END;

	ELSE IF SMOKEVR = 1 AND SMOKYRS IN(1,2,3,4,5,6) THEN DO; 
		IF SMOKYRS = 1 THEN YRS = 2.5; 
		IF SMOKYRS = 2 THEN YRS = 7; 
		IF SMOKYRS = 3 THEN YRS = 15; 
		IF SMOKYRS = 4 THEN YRS = 25; 
		IF SMOKYRS = 5 THEN YRS = 35; 
		IF SMOKYRS = 6 THEN YRS = 45; 
	END;

	* VARIABLE COMPUTATION;
	IF CIGSDAY = 1 THEN PACKYRS = 0.5/20 * YRS; 
		ELSE IF CIGSDAY = 2 THEN PACKYRS = 2.5/20 * YRS; 
		ELSE IF CIGSDAY = 3 THEN PACKYRS = 10/20 * YRS; 
		ELSE IF CIGSDAY = 4 THEN PACKYRS = 20/20 * YRS; 
		ELSE IF CIGSDAY = 5 THEN PACKYRS = 30/20 * YRS; 
		ELSE IF CIGSDAY = 6 THEN PACKYRS = 40/20 * YRS; 
		ELSE IF CIGSDAY = 7 THEN PACKYRS = 50/20 * YRS;

	* Missing; 
	IF SMOKING = 0 THEN PACKYRS = 0; 
	IF SMOKING = . THEN PACKYRS = .;
	
	IF PACKYRS = 0 THEN PACKYRSC = 0; 
		ELSE IF 0 < PACKYRS < 5 THEN PACKYRSC = 1; 
		ELSE IF 5 <= PACKYRS <20 THEN PACKYRSC = 2; 
		ELSE IF PACKYRS >= 20 THEN PACKYRSC = 3;
run;

* Data check - does numeric description of packyrs at first non-missing value;
* match the numeric description in the WHI codebook online?;
data check1;
	set whisf.merged;
	if missing(packyrs) = 0 then notmiss = 1;
run;

proc sort data = check1;
	by id descending notmiss days;
run;

proc sql outobs = 100;
select id, days, packyrs, notmiss
	from check1;
quit;

data check2;
	set check1;
	by id;
	if first.id = 1 & notmiss ^= . then tag = 1;
	if tag = 1 then first_packyrs = packyrs;
run;

proc sql outobs = 100;
select id, days, packyrs, notmiss, tag, first_packyrs
	from check2;
quit;

proc sort data = check2;
	by id days;
run;

proc sql outobs = 100;
select id, days, packyrs, notmiss, tag, first_packyrs
	from check2;
quit;

proc sql number;
	create table check3 as
		select id, days, packyrs, notmiss, tag, first_packyrs,
			max(first_packyrs) as xb "x at baseline"
		from check2
		group by id;
quit;

proc sql outobs = 100;
select *
	from check3
	order by id, days;
quit;

proc means data = check3;
	var xb;
	where days = 0;
run;

* Differnt than codebook online;
* Why?;

proc sql;
select count(*) "Total Day 0's"
	from check3
	where days = 0;

select count(*) "Missing at Day 0"
	from check3
	where days = 0 and packyrs is null;

select count(*) "Not missing at Day 0"
	from check3
	where days = 0 and packyrs is not null;
quit;

* There are too many day zero's because of the duplicate rows for medications.;
* Even so, the results are really similar. I think the algorithm worked fine.;
* I will double check later in R when I remove duplicate rows.;




* ============================================================================;
* Subset variables of interest
* ============================================================================;
data whisf.analysis_01;
	set whisf.merged (keep =
	/* Administrative and Sociodemographic */
	id days age ager race_eth edu4cat inc5cat marital married sex ctos parity

	/* Health Behavior */
	texpwk alcswk f60alc f60alcwk f60caff packyrs packyrsc horm hormnw tccode
	livalor livaln

	/* Health and Wellness */
	lifequal pshtdep bmi genhel hyst nightswt hotflash vagdry incont atrophy

	/* Chronic Disease */
	arthrit brca_f30 cervca endo_f30 ovryca cvd diab hypt osteopor pad
	canc_f30 hip55

	/* Sexual Function */
	sexactiv satsex satfrqsx

	/* Abuse */
	phyab verbab);
run;

ods html;
proc contents data = whisf.analysis_01 position;
run;
* 2,448,638 observations and 51 variables;
