* ============================================================================;
* Clean Form 81 - Pelvic Exam
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename measur "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Measurements\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F81VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit";

	VALUE F81VCLOF
		0="No"
		1="Yes";

	VALUE F81EXPCF
		0="No"
		1="Yes";

	VALUE PELVICBYF
		1="CC staff"
		2="Other";

	VALUE PLVABNRMF
		0="No"
		1="Yes";

	VALUE ADIPOSEF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE PLVHAIRF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE DISCVLVAF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE ULCERVLVF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE GROWVLVAF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE ATROPHYF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE PLVSMTHF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE PLVPALEF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE FRIABVAGF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE BLOODVAGF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE DISCVAGF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE ULCERVAGF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE GROWVAGF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE CYSTOCELF
		0="None"
		1="Grade 1 (in vagina)"
		2="Grade 2 (to introitus)"
		3="Grade 3 (outside vagina)";

	VALUE RECTOCELF
		0="None"
		1="Grade 1 (in vagina)"
		2="Grade 2 (to introitus)"
		3="Grade 3 (outside vagina)";

	VALUE PLVCERVXF
		0="Absent"
		1="Present";

	VALUE CRVFLUSHF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE FRIABCRVF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE LESIONF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE POLYPF
		0="No"
		1="Yes, probably benign"
		2="Yes, possibly malignant";

	VALUE PLVUTERF
		0="Absent"
		1="Present"
		9="Unable to palpate";

	VALUE PROLAPSEF
		0="None"
		1="Grade 1 (in vagina)"
		2="Grade 2 (to introitus)"
		3="Grade 3 (outside vagina)";

	VALUE UTERENLRF
		0="No"
		1="Yes";

	VALUE ADNEXAEF
		0="Normal"
		1="Mass present"
		9="Unable to palpate/absent";

	VALUE MASSLOCF
		1="Right"
		2="Left"
		3="Both";

	VALUE PAPSMEARF
		0="No, not done"
		1="No, send for outside report"
		2="Yes, vaginal smear"
		3="Yes, Pap smear";

	VALUE PLVREFERF
		0="No"
		1="Yes";

	VALUE PLVFURESF
		0="Normal"
		1="Benign changes"
		2="Possibly malignant";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f81_ht_inv;
  INFILE measur(f81_ht_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F81DAYS F81VTYP F81VY F81VCLO F81EXPC PELVICDY PELVICBY PLVABNRM ADIPOSE 
        PLVHAIR DISCVLVA ULCERVLV GROWVLVA ATROPHY PLVSMTH PLVPALE FRIABVAG BLOODVAG DISCVAG 
        ULCERVAG GROWVAG CYSTOCEL RECTOCEL PLVCERVX CRVFLUSH FRIABCRV LESION POLYP PLVUTER 
        PROLAPSE UTERSIZE UTERENLR ADNEXAE MASSLOC PAPSMEAR PLVREFER PLVREFDY PLVFURES  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F81DAYS= "F81 Days since randomization"
		F81VTYP= "Visit Type"
		F81VY= "Visit year"
		F81VCLO= "Closest to visit within visit type and year"
		F81EXPC= "Expected for visit"
		PELVICDY= "Days from randomization to pelvic exam"
		PELVICBY= "Pelvic exam performed by"
		PLVABNRM= "Doctor found anything wrong"
		ADIPOSE= "Loss of adipose tissue"
		PLVHAIR= "Thinning of hair"
		DISCVLVA= "Genitalia - Abnormal discoloration"
		ULCERVLV= "Genitalia - Ulceration"
		GROWVLVA= "Genitalia - Growth"
		ATROPHY= "Atrophy"
		PLVSMTH= "Smooth"
		PLVPALE= "Pale"
		FRIABVAG= "Vagina - Friable with contact"
		BLOODVAG= "Blood present"
		DISCVAG= "Vagina - Abnormal discoloration"
		ULCERVAG= "Vagina - Ulceration"
		GROWVAG= "Vagina - Growth"
		CYSTOCEL= "Cystocele"
		RECTOCEL= "Rectocele"
		PLVCERVX= "Cervix"
		CRVFLUSH= "Flush with vaginal vault"
		FRIABCRV= "Cervix - Friable with contact"
		LESION= "Surface lesion/growth"
		POLYP= "Polyp"
		PLVUTER= "Uterus"
		PROLAPSE= "Prolapse"
		UTERSIZE= "Uterine size (weeks)"
		UTERENLR= "Enlarged since last exam"
		ADNEXAE= "Adnexae"
		MASSLOC= "Mass present"
		PAPSMEAR= "Pap smear obtained"
		PLVREFER= "Referral made for follow-up"
		PLVREFDY= "Days from randomiaztion to pelvic exam referral"
		PLVFURES= "Pelvic follow-up results";

  FORMAT	F81VTYP F81VTYPF. F81VCLO F81VCLOF. F81EXPC F81EXPCF. PELVICBY PELVICBYF. PLVABNRM PLVABNRMF. ADIPOSE ADIPOSEF. 
	PLVHAIR PLVHAIRF. DISCVLVA DISCVLVAF. ULCERVLV ULCERVLVF. GROWVLVA GROWVLVAF. ATROPHY ATROPHYF. 
	PLVSMTH PLVSMTHF. PLVPALE PLVPALEF. FRIABVAG FRIABVAGF. BLOODVAG BLOODVAGF. DISCVAG DISCVAGF. 
	ULCERVAG ULCERVAGF. GROWVAG GROWVAGF. CYSTOCEL CYSTOCELF. RECTOCEL RECTOCELF. PLVCERVX PLVCERVXF. 
	CRVFLUSH CRVFLUSHF. FRIABCRV FRIABCRVF. LESION LESIONF. POLYP POLYPF. PLVUTER PLVUTERF. 
	PROLAPSE PROLAPSEF. UTERENLR UTERENLRF. ADNEXAE ADNEXAEF. MASSLOC MASSLOCF. PAPSMEAR PAPSMEARF. 
	PLVREFER PLVREFERF. PLVFURES PLVFURESF. ;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f81;
	format id days;
	set whisf.f81_ht_inv;	

	* Create time (days) variable;
	rename f81days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f81;
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
	select id, days, f81vclo, f81expc, count(*) as dups
		from whisf.f81
		group by id, days
		having calculated dups >= 2;
		* There are 55 rows with duplicate id/days;
quit;

* Just want to keep the first observation for each set of dups;
proc contents data = whisf.f81;
	ods select attributes;
run;
* 123,002 observations;

* Order them Yes, No, Yes, No so that when there is a yes and a no, yes's are
* kept;
proc sort data = whisf.f81;
	by id days descending f81vclo;
run;

proc sort data = whisf.f81
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f81;
	ods select attributes;
run;
* 122,974 observations - expected number;

* Double check that yes's were kept;
proc sql;
	select id, days, f81vclo, f81expc
		from whisf.f81
		where (id = 125442 & days = 1108) | (id = 126620 & days = 758);
quit;
* Good;
