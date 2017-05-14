* ============================================================================;
* Clean Form 34 - Personal Habits
* 2017-03-04
* ============================================================================;

* Setup libraries and formats;
filename psysoc "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Psychosocial\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F34CONTF
		1="Phone"
		2="Mail"
		3="Visit"
		8="Other";

	VALUE SMOKEVRF
		0="No"
		1="Yes";

	VALUE SMOKAGEF
		1="Less than 15"
		2="15-19"
		3="20-24"
		4="25-29"
		5="30-34"
		6="35-39"
		7="40-44"
		8="45-49"
		9="50 or older";

	VALUE SMOKNOWF
		0="No"
		1="Yes";

	VALUE QSMOKAGEF
		1="Less than 15"
		2="15-19"
		3="20-24"
		4="25-29"
		5="30-34"
		6="35-39"
		7="40-44"
		8="45-49"
		9="50-54"
		10="55-59"
		11="60 or older";

	VALUE QSMOKHPF
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

	VALUE SMOKYRSF
		1="Less than 5 years"
		2="5-9 years"
		3="10-19 years"
		4="20-29 years"
		5="30-39 years"
		6="40-49 years"
		7="50 or more years";

	VALUE SMOKWGTF
		0="No"
		1="Yes";

	VALUE COFFEEF
		0="No"
		1="Yes";

	VALUE CUPREGF
		0="None"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6 or more";

	VALUE ALC12DRF
		0="No"
		1="Yes";

	VALUE ALCNOWF
		0="No"
		1="Yes";

	VALUE ALCQUITF
		1="Health problems"
		2="My drinking caused non-health problems"
		8="Other";

	VALUE WGTADULTF
		1="Weight has stayed about the same"
		2="Steady gain in weight"
		3="Lost weight  as an adult and kept it off"
		4="Weight has gone up and down";

	VALUE YOYO10LBF
		1="1-3 times"
		2="4-6 times"
		3="7-10 times"
		4="11-15 times"
		5="More than 15 times";

	VALUE LCALDIETF
		0="No"
		1="Yes";

	VALUE LFATDIETF
		0="No"
		1="Yes";

	VALUE LSLTDIETF
		0="No"
		1="Yes";

	VALUE FBDIET34F
		0="No"
		1="Yes";

	VALUE DBDIET34F
		0="No"
		1="Yes";

	VALUE LACTDIETF
		0="No"
		1="Yes";

	VALUE OTHDIETF
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
		1="Less than 20 minutes"
		2="20-39 minutes"
		3="40-59 minutes"
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
		1="Less than 20 minutes"
		2="20-39 minutes"
		3="40-59 minutes"
		4="1 hour or more";

	VALUE MODEXF
		0="None"
		1="1 day per week"
		2="2 days per week"
		3="3 days per week"
		4="4 days per week"
		5="5 or more days per week";

	VALUE MODEXMINF
		1="Less than 20 minutes"
		2="20-39 minutes"
		3="40-59 minutes"
		4="1 hour or more";

	VALUE MLDEXF
		0="None"
		1="1 day per week"
		2="2 days per week"
		3="3 days per week"
		4="4 days per week"
		5="5 or more days per week";

	VALUE MLDEXMINF
		1="Less than 20 minutes"
		2="20-39 minutes"
		3="40-59 minutes"
		4="1 hour or more";

	VALUE HRDEX18F
		0="No"
		1="Yes";

	VALUE HRDEX35F
		0="No"
		1="Yes";

	VALUE HRDEX50F
		0="No"
		1="Yes";

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

	VALUE SMOKINGF
		0="Never Smoked"
		1="Past Smoker"
		2="Current Smoker";

	VALUE ALCOHOLF
		1="Non drinker"
		2="Past drinker"
		3="<1 drink per month"
		4="<1 drink per week"
		5="1 to <7 drinks per week"
		6="7+ drinks per week";

RUN;

* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f34_ctos_inv;
  INFILE psysoc(f34_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F34DAYS F34CONT SMOKEVR SMOKAGE SMOKNOW QSMOKAGE QSMOKHP CIGSDAY SMOKYRS 
        SMOKWGT COFFEE CUPREG ALC12DR ALCNOW ALCQUIT WGTADULT YOYO10LB LCALDIET LFATDIET 
        LSLTDIET FBDIET34 DBDIET34 LACTDIET OTHDIET WALK WALKMIN WALKSPD HRDEX HRDEXMIN 
        MODEX MODEXMIN MLDEX MLDEXMIN HRDEX18 HRDEX35 HRDEX50 TEPIWK LEPITOT MSEPIWK 
        XLMSEPI LMSEPI SEPIWK TMINWK MSMINWK SMINWK TEXPWK WALKEXP SMOKING HARDEXP 
        MODEXP MILDEXP AVWKEXP FFWKEXP VFWKEXP ALCSWK ALCOHOL  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F34DAYS= "F34 Days since randomization/enrollment"
		F34CONT= "Contact type"
		SMOKEVR= "Smoked at least 100 cigarettes ever"
		SMOKAGE= "Age started smoking cigarettes regularly"
		SMOKNOW= "Smoke cigarettes now"
		QSMOKAGE= "Age quit smoking regularly"
		QSMOKHP= "Quit smoking because of health problems"
		CIGSDAY= "Smoke or smoked, cigarettes/day"
		SMOKYRS= "Years a regular smoker"
		SMOKWGT= "Smoked to lose weight"
		COFFEE= "Drink coffee each day"
		CUPREG= "Number of regular cups of coffee, day"
		ALC12DR= "Drank 12 alcoholic beverages ever"
		ALCNOW= "Still drink alcohol"
		ALCQUIT= "Reasons quit drinking alcohol"
		WGTADULT= "Weight during adult life, lbs"
		YOYO10LB= "Number times weight went up/down >10 lbs"
		LCALDIET= "Low calorie diet"
		LFATDIET= "Low-fat or low cholesterol diet"
		LSLTDIET= "Low salt (low sodium) diet"
		FBDIET34= "High-fiber diet"
		DBDIET34= "Diabetic or ADA diet"
		LACTDIET= "Lactose-free (no milk/dairy foods) diet"
		OTHDIET= "Other than listed special diet"
		WALK= "Times walk for > 10 min"
		WALKMIN= "Duration of walks when >10 min"
		WALKSPD= "Walking speed when walking for >10 min"
		HRDEX= "Times per week of very hard exercise"
		HRDEXMIN= "Duration per time of very hard exercise"
		MODEX= "Times per week of moderate exercise"
		MODEXMIN= "Duration per time of moderate exercise"
		MLDEX= "Times per week of mild exercise"
		MLDEXMIN= "Duration per time of mild exercise"
		HRDEX18= "Very hard exercise 3 times/wk at age 18"
		HRDEX35= "Very hard exercise 3 times/wk at age 35"
		HRDEX50= "Very hard exercise 3 times/wk at age 50"
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
		SMOKING= "Smoking status"
		HARDEXP= "Energy expenditure from hard exercise (MET-hours/week)"
		MODEXP= "Energy expend from moderate exercise (MET-hours/week)"
		MILDEXP= "Energy expenditure from mild exercise (MET-hours/week)"
		AVWKEXP= "Energy expend from average walking (MET-hours/week)"
		FFWKEXP= "Energy expend from walking fairly fast (MET-hours/week)"
		VFWKEXP= "Energy expend from walking very fast (MET-hours/week)"
		ALCSWK= "Alcohol servings per week"
		ALCOHOL= "Alcohol intake";

  FORMAT	F34CONT F34CONTF. SMOKEVR SMOKEVRF. SMOKAGE SMOKAGEF. SMOKNOW SMOKNOWF. QSMOKAGE QSMOKAGEF. QSMOKHP QSMOKHPF. 
	CIGSDAY CIGSDAYF. SMOKYRS SMOKYRSF. SMOKWGT SMOKWGTF. COFFEE COFFEEF. CUPREG CUPREGF. 
	ALC12DR ALC12DRF. ALCNOW ALCNOWF. ALCQUIT ALCQUITF. WGTADULT WGTADULTF. YOYO10LB YOYO10LBF. 
	LCALDIET LCALDIETF. LFATDIET LFATDIETF. LSLTDIET LSLTDIETF. FBDIET34 FBDIET34F. DBDIET34 DBDIET34F. 
	LACTDIET LACTDIETF. OTHDIET OTHDIETF. WALK WALKF. WALKMIN WALKMINF. WALKSPD WALKSPDF. 
	HRDEX HRDEXF. HRDEXMIN HRDEXMINF. MODEX MODEXF. MODEXMIN MODEXMINF. MLDEX MLDEXF. 
	MLDEXMIN MLDEXMINF. HRDEX18 HRDEX18F. HRDEX35 HRDEX35F. HRDEX50 HRDEX50F. LMSEPI LMSEPIF. 
	SEPIWK SEPIWKF. SMOKING SMOKINGF. ALCOHOL ALCOHOLF. ;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f34;
	format id days;
	set whisf.f34_ctos_inv;	

	* Create time (days) variable;
	rename f34days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f34;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;
