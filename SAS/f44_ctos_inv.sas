* ============================================================================;
* Clean Form 44 - Medications
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename meds "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Med History\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F44VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit"
		5="6 week HRT/4 week CaD call";

	VALUE F44VCLOF
		0="No"
		1="Yes";

	VALUE F44EXPCF
		0="No"
		1="Yes";

	VALUE CORTF
		0="No"
		1="Yes";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f44_ctos_inv;
 LENGTH MEDNDC $ 11 ;
  INFILE meds(f44_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F44DAYS F44VTYP F44VY F44VCLO F44EXPC MEDNDC $ ADULTDY ADULTY CORT 
        TCCODE $   ;


  LABEL 
		ID= "WHI Participant Common ID"
		F44DAYS= "F44 Days since randomization/enrollment"
		F44VTYP= "Visit Type"
		F44VY= "F44 Visit year or number"
		F44VCLO= "Closest to visit within visit type and year"
		F44EXPC= "Expected for visit"
		MEDNDC= "F44 Medication National Drug Code (NDC)"
		ADULTDY= "F44 Adult duration of medication use (days)"
		ADULTY= "F44 Adult duration of medication use (years)"
		CORT= "F44 Oral daily use of a glucocorticosteroid"
		TCCODE= "F44 Medication Therapeutic Class Code";

  FORMAT	F44VTYP F44VTYPF. F44VCLO F44VCLOF. F44EXPC F44EXPCF. CORT CORTF. ;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f44;
	format id days;
	set whisf.f44_ctos_inv;	

	* Create time (days) variable;
	rename f44days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f38;
	tables id*days / noprint out = keylist;
run;
proc print data = keylist;
	where count >= 2;
run;

* There are no duplicates;

