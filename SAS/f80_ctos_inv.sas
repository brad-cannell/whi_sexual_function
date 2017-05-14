* ============================================================================;
* Clean Form 80 - Physical Measurements
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename measur "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Measurements\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F80VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit";

	VALUE F80VCLOF
		0="No"
		1="Yes";

	VALUE F80EXPCF
		0="No"
		1="Yes";

	VALUE WHEXPECTF
		0="No"
		1="Yes";

	VALUE SYSTOLF
		1="<=120"
		2="120 - 140"
		3=">140";

	VALUE DIASTOLF
		1="<90"
		2=">=90";

	VALUE BMICF
		1="Underweight (< 18.5)"
		2="Normal (18.5 - 24.9)"
		3="Overweight (25.0 - 29.9)"
		4="Obesity I (30.0 - 34.9)"
		5="Obesity II (35.0 - 39.9)"
		6="Extreme Obesity III (>= 40)";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f80_ctos_inv;
  INFILE measur(f80_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F80DAYS F80VTYP F80VY F80VCLO F80EXPC PULSE30 SYSTBP1 DIASBP1 SYSTBP2 
        DIASBP2 HEIGHT WEIGHT WAIST HIP WHEXPECT SYST SYSTOL DIAS DIASTOL 
        BMI BMIC WHR  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F80DAYS= "F80 Days since randomization/enrollment"
		F80VTYP= "Visit Type"
		F80VY= "Visit year"
		F80VCLO= "Closest to visit within visit type and year"
		F80EXPC= "Expected for visit"
		PULSE30= "Resting pulse in 30 seconds"
		SYSTBP1= "Systolic blood pressure (1st reading)"
		DIASBP1= "Diastolic blood pressure (1st reading)"
		SYSTBP2= "Systolic blood pressure (2nd reading)"
		DIASBP2= "Diastolic blood pressure (2nd reading)"
		HEIGHT= "Height, cm"
		WEIGHT= "Weight, kg"
		WAIST= "Waist, cm"
		HIP= "Hip, cm"
		WHEXPECT= "Waist and Hip measurement expected"
		SYST= "Systolic BP"
		SYSTOL= "Systolic BP"
		DIAS= "Diastolic BP"
		DIASTOL= "Diastolic BP"
		BMI= "Body-mass Index (BMI), kg/m2"
		BMIC= "Body-mass Index (BMI), kg/m2"
		WHR= "Waist/Hip Ratio (WHR)";

  FORMAT	F80VTYP F80VTYPF. F80VCLO F80VCLOF. F80EXPC F80EXPCF. WHEXPECT WHEXPECTF. SYSTOL SYSTOLF. DIASTOL DIASTOLF. 
	BMIC BMICF. ;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f80;
	format id days;
	set whisf.f80_ctos_inv;	

	* Create time (days) variable;
	rename f80days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f80;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* There are duplicates - need to fix;

* fvclo: For forms entered with the same visit type and year, indicates the 
* one closest to that visit's target date. Valid for forms entered with an 
* annual visit type. 0 = NO 1 = Yes;

* fexpc: This form/data was expected for this visit;

proc sql number;
	select id, days, f80vclo, f80expc, count(*) as dups
		from whisf.f80
		group by id, days
		having calculated dups >= 2;
		* There are 52 rows with duplicate id/days;
quit;

* Just want to keep the first observation for each set of dups;
proc contents data = whisf.f80;
	ods select attributes;
run;
* 679,883 observations;

* Order them Yes, No, Yes, No so that when there is a yes and a no, yes's are
* kept;
proc sort data = whisf.f80;
	by id days descending f80vclo;
run;

proc sort data = whisf.f80
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f80;
	ods select attributes;
run;
* 679,857 observations - expected number;

* Double check that yes's were kept;
proc sql;
	select id, days, f80vclo, f80expc
		from whisf.f80
		where (id = 104763 & days = 359) | (id = 105132 & days = 741);
quit;
* Good;



