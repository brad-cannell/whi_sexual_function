* ============================================================================;
* Clean Form 35 - Personal Habits
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename psysoc "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Psychosocial\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

* Create formats;
PROC FORMAT library = whisf;

	VALUE F35VTYPF
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit";

	VALUE F35VCLOF
		0="No"
		1="Yes";

	VALUE F35EXPCF
		0="No"
		1="Yes";

	VALUE WALKF
		0="Rarely or never"
		1="1-3 times each month"
		2="1 time each week"
		3="2-3 times each week"
		4="4-6 times each week"
		5="7 or more times each week";

	VALUE WALKMINF
		1="Less than 20 min."
		2="20-39 min."
		3="40-59 min."
		4="1 hour or more";

	VALUE WALKSPDF
		2="Casual strolling or walking"
		3="Average or normal"
		4="Fairly fast"
		5="Very fast"
		9="Don't know";

	VALUE HRDEXF
		0="None"
		1="1 day per week"
		2="2 days per week"
		3="3 days per week"
		4="4 days per week"
		5="5 or more days per week";

	VALUE HRDEXMINF
		1="Less than 20 min."
		2="20-39 min."
		3="40-59 min."
		4="1 hour or more";

	VALUE MODEXF
		0="None"
		1="1 day per week"
		2="2 days per week"
		3="3 days per week"
		4="4 days per week"
		5="5 or more days per week";

	VALUE MODEXMINF
		1="Less than 20 min."
		2="20-39 min."
		3="40-59 min."
		4="1 hour or more";

	VALUE MLDEXF
		0="None"
		1="1 day per week"
		2="2 days per week"
		3="3 days per week"
		4="4 days per week"
		5="5 or more days per week";

	VALUE MLDEXMINF
		1="Less than 20 min."
		2="20-39 min."
		3="40-59 min."
		4="1 hour or more";

	VALUE BEERFREQF
		0="Never or less than once per month"
		1="1-3 per month"
		2="1 per week"
		3="2-4 per week"
		4="5-6 per week"
		5="1 per day"
		6="2-3 per day"
		7="4-5 per day"
		8="6+ per day";

	VALUE BEERSERVF
		1="Small"
		2="Medium"
		3="Large";

	VALUE WINEFREQF
		0="Never or less than once per month"
		1="1-3 per month"
		2="1 per week"
		3="2-4 per week"
		4="5-6 per week"
		5="1 per day"
		6="2-3 per day"
		7="4-5 per day"
		8="6+ per day";

	VALUE WINESERVF
		1="Small"
		2="Medium"
		3="Large";

	VALUE LIQRFREQF
		0="Never or less than once per month"
		1="1-3 per month"
		2="1 per week"
		3="2-4 per week"
		4="5-6 per week"
		5="1 per day"
		6="2-3 per day"
		7="4-5 per day"
		8="6+ per day";

	VALUE LIQRSERVF
		1="Small"
		2="Medium"
		3="Large";

	VALUE SMOKNOWF
		0="No"
		1="Yes";

	VALUE CIGSDAYF
		1="Less than 1"
		2="1-4"
		3="5-14"
		4="15-24"
		5="25-34"
		6="35-44"
		7="45 or more";

	VALUE LMSEPIF
		1="No activity"
		2="Some activity of limited duration"
		3="2 - <4 episodes per week"
		4="4 episodes per week";

	VALUE SEPIWKF
		0="0"
		1="1"
		2="2"
		3="3"
		4="4"
		6="5 or more";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f35_ct_inv;
  INFILE psysoc(f35_ct_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F35DAYS F35VTYP F35VY F35VCLO F35EXPC WALK WALKMIN WALKSPD HRDEX 
        HRDEXMIN MODEX MODEXMIN MLDEX MLDEXMIN BEERFREQ BEERSERV WINEFREQ WINESERV LIQRFREQ 
        LIQRSERV SMOKNOW CIGSDAY TEPIWK LEPITOT MSEPIWK XLMSEPI LMSEPI SEPIWK TMINWK 
        MSMINWK SMINWK TEXPWK WALKEXP AVWKEXP FFWKEXP VFWKEXP HARDEXP MODEXP MILDEXP 
        ALCSWK  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F35DAYS= "F35 Days since randomization"
		F35VTYP= "Visit Type"
		F35VY= "Visit year"
		F35VCLO= "Closest to visit within visit type and year"
		F35EXPC= "Expected for visit"
		WALK= "Times walk for > 10 min"
		WALKMIN= "Duration of walks when >10 min"
		WALKSPD= "Walking speed when walking for >10 min"
		HRDEX= "Times per week of very hard exercise"
		HRDEXMIN= "Duration per time of very hard exercise"
		MODEX= "Times per week of moderate exercise"
		MODEXMIN= "Duration per time of moderate exercise"
		MLDEX= "Times per week of mild exercise"
		MLDEXMIN= "Duration per time of mild exercise"
		BEERFREQ= "Beer - frequency"
		BEERSERV= "Beer - serving size"
		WINEFREQ= "Wine - frequency"
		WINESERV= "Wine - serving size"
		LIQRFREQ= "Liquor - frequency"
		LIQRSERV= "Liquor - serving size"
		SMOKNOW= "Do you smoke cigarettes now"
		CIGSDAY= "How many cigarettes per day"
		TEPIWK= "Episodes recreational phys activity per week"
		LEPITOT= "Episodes recreational phys activity per week >= 20 Min"
		MSEPIWK= "Episodes moderate to strenuous phys activity per week"
		XLMSEPI= "Episodes moderate to strenuous activity >= 20 min/week"
		LMSEPI= "Episodes moderate to strenuous activity >=20 min/week (categorical)"
		SEPIWK= "Strenuous activity episodes per week"
		TMINWK= "Minutes of recreational phys activity per week"
		MSMINWK= "Minutes of moderate to strenuous activity per week"
		SMINWK= "Minutes of strenuous phys activity per week"
		TEXPWK= "Total energy expend from recreational phys activity (MET-hours/week)"
		WALKEXP= "MET-hours per week from walking"
		AVWKEXP= "Energy expend from average walking (MET-hours/week)"
		FFWKEXP= "Energy expend from walking fairly fast (MET-hours/week)"
		VFWKEXP= "Energy expend from walking very fast (MET-hours/week)"
		HARDEXP= "Energy expenditure from hard exercise (MET-hours/week)"
		MODEXP= "Energy expend from moderate exercise (MET-hours/week)"
		MILDEXP= "Energy expenditure from mild exercise (MET-hours/week)"
		ALCSWK= "Alcohol servings per week";

  FORMAT	F35VTYP F35VTYPF. F35VCLO F35VCLOF. F35EXPC F35EXPCF. WALK WALKF. WALKMIN WALKMINF. WALKSPD WALKSPDF. 
	HRDEX HRDEXF. HRDEXMIN HRDEXMINF. MODEX MODEXF. MODEXMIN MODEXMINF. MLDEX MLDEXF. 
	MLDEXMIN MLDEXMINF. BEERFREQ BEERFREQF. BEERSERV BEERSERVF. WINEFREQ WINEFREQF. WINESERV WINESERVF. 
	LIQRFREQ LIQRFREQF. LIQRSERV LIQRSERVF. SMOKNOW SMOKNOWF. CIGSDAY CIGSDAYF. LMSEPI LMSEPIF. 
	SEPIWK SEPIWKF. ;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f35;
	format id days;
	set whisf.f35_ct_inv;	

	* Create time (days) variable;
	rename f35days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f35;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* There are duplicates. Do further investigation;

* fvclo: For forms entered with the same visit type and year, indicates the 
* one closest to that visit's target date. Valid for forms entered with an 
* annual visit type. 0 = NO 1 = Yes;

* fexpc: This form/data was expected for this visit;

proc sql number;
	select id, days, f35vclo, f35expc, count(*) as dups
		from whisf.f35
		group by id, days
		having calculated dups >= 2;
		* There are 42 rows with duplicate id/days;
quit;

* Whithin each duplicate, keep if fvclo = Yes;
* Can't do this because it would drop id 165515 completely (fvclo = no
* in both rows), and would keep duplicate copies of id 225129 (fvclo =
* yes in both rows.;
* So I'm just going to keep every second row;
proc contents data = whisf.f35;
	ods select attributes;
run;
* 174,326 observations;

* Order them Yes, No, Yes, No so that when there is a yes and a no, yes's are
* kept;
proc sort data = whisf.f35;
	by id days descending f35vclo;
run;

proc sort data = whisf.f35
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f35;
	ods select attributes;
run;
* 174,305 observations - expected number;

* Double check that yes's were kept;
proc sql;
	select id, days, f35vclo, f35expc
		from whisf.f35
		where (id = 121491 & days = 351) | (id = 129880 & days = 350);
quit;


	


