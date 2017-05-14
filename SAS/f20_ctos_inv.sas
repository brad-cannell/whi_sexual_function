* ============================================================================;
* Clean Form 20 - Personal Information
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename demo "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Demographics\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F20CONTF
		1="Phone"
		2="Mail"
		3="Visit"
		8="Other";

	VALUE EDUCF
		1="Didn't go to school"
		2="Grade school (1-4 years)"
		3="Grade school (5-8 years)"
		4="Some high school (9-11 years)"
		5="High school diploma or GED"
		6="Vocational or training school"
		7="Some college or Associate Degree"
		8="College graduate or Baccalaureate Degree"
		9="Some post-graduate or professional"
		10="Master's Degree"
		11="Doctoral Degree (Ph.D,M.D.,J.D.,etc.)";

	VALUE NOTWRKF
		0="No"
		1="Yes";

	VALUE RETIREDF
		0="No"
		1="Yes";

	VALUE HOMEMKRF
		0="No"
		1="Yes";

	VALUE EMPLOYEDF
		0="No"
		1="Yes";

	VALUE DISABLEDF
		0="No"
		1="Yes";

	VALUE OTHWRKF
		0="No"
		1="Yes";

	VALUE JOBHMMKRF
		0="No"
		1="Yes";

	VALUE JOBMANGRF
		0="No"
		1="Yes";

	VALUE JOBTECHF
		0="No"
		1="Yes";

	VALUE JOBSERVF
		0="No"
		1="Yes";

	VALUE JOBLABORF
		0="No"
		1="Yes";

	VALUE JOBOTHF
		0="No"
		1="Yes";

	VALUE MARITALF
		1="Never married"
		2="Divorced or separated"
		3="Widowed"
		4="Presently married"
		5="Marriage-like relationship";

	VALUE PEDUCF
		1="Didn't go to school"
		2="Grade school (1-4 years)"
		3="Grade school (5-8 years)"
		4="Some high school (9-11 years)"
		5="High school diploma or GED"
		6="Vocational or training school"
		7="Some college or Associate Degree"
		8="College graduate or Baccalaureate Degree"
		9="Some post-graduate or professional"
		10="Master's Degree"
		11="Doctoral Degree (Ph.D,M.D.,J.D.,etc.)";

	VALUE PNOTWRKF
		0="No"
		1="Yes";

	VALUE PRETIREDF
		0="No"
		1="Yes";

	VALUE PHOMEMKRF
		0="No"
		1="Yes";

	VALUE PEMPLOYF
		0="No"
		1="Yes";

	VALUE PDISABLEF
		0="No"
		1="Yes";

	VALUE POTHWRKF
		0="No"
		1="Yes";

	VALUE PMAINJOBF
		1="Homemaker, raising children, other"
		2="Managerial, professional specialty"
		3="Technical, sales, administrative support"
		4="Service"
		5="Operator, fabricator, and laborers"
		8="Other";

	VALUE INCOMEF
		1="Less than $10,000"
		2="$10,000 to $19,999"
		3="$20,000 to $34,999"
		4="$35,000 to $49,999"
		5="$50,000 to $74,999"
		6="$75,000 to $99,999"
		7="$100,000 to $149,999"
		8="$150,000 or more"
		9="Don't know";

	VALUE CAREPROVF
		0="No"
		1="Yes";

	VALUE MAMMOF
		0="No"
		1="Yes";

	VALUE PAPSMEARF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE ABNPAP3YF
		0="No"
		1="Yes";

	VALUE CERVDYSF
		0="No"
		1="Yes";

	VALUE ENDOASPF
		0="No"
		1="Yes";

	VALUE HMOINSF
		0="No"
		1="Yes";

	VALUE OTHPRVINF
		0="No"
		1="Yes";

	VALUE MEDICAREF
		0="No"
		1="Yes";

	VALUE MEDICAIDF
		0="No"
		1="Yes";

	VALUE MLTRYINSF
		0="No"
		1="Yes";

	VALUE NOINSF
		0="No"
		1="Yes";

	VALUE PAYOTHF
		0="No"
		1="Yes";

	VALUE USSERVEF
		0="No"
		1="Yes";

	VALUE VAMEDCTRF
		0="No"
		1="Yes";

	VALUE MAINJOBF
		1="Managerial / Professional"
		2="Technical / Sales / Admin"
		3="Service / Labor"
		4="Homemaker only";

	VALUE NOMAM2YRF
		0="Mammogram within 2 years"
		1="No mammogram within 2 years";

	VALUE NOPAP3YRF
		0="Pap within 3 years"
		1="No pap within 3 years";

	VALUE TIMELSTSF
		0="No"
		1="Yes";

	VALUE ANYINSF
		0="No"
		1="Yes";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f20_ctos_inv;
  INFILE demo(f20_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT id f20days f20cont educ notwrk retired homemkr employed disabled othwrk 
        jobhmmkr jobmangr jobtech jobserv joblabor joboth marital peduc pnotwrk pretired 
        phomemkr pemploy pdisable pothwrk pmainjob income careprov lstvisdy mammo lstmamdy 
        papsmear lstpapdy abnpap3y cervdys endoasp lstaspdy hmoins othprvin medicare medicaid 
        mltryins noins payoth usserve vamedctr mainjob nomam2yr nopap3yr timelast timelsts 
        anyins  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F20DAYS= "F20 Days since randomization/enrollment"
		F20CONT= "Contact type"
		EDUC= "Highest grade finished in school"
		NOTWRK= "Currently not working"
		RETIRED= "Currently retired"
		HOMEMKR= "Currently homemaker"
		EMPLOYED= "Currently employed (full- or part-time)"
		DISABLED= "Currently disabled"
		OTHWRK= "Other current job status"
		JOBHMMKR= "Job as homemaker"
		JOBMANGR= "Job as managerial, professional"
		JOBTECH= "Job as technical, sales, admin support"
		JOBSERV= "Job as service"
		JOBLABOR= "Job as operator, fabricator, laborer"
		JOBOTH= "Job as other than listed"
		MARITAL= "Marital status"
		PEDUC= "Partner highest level of education"
		PNOTWRK= "Partner currently not working"
		PRETIRED= "Partner currently retired"
		PHOMEMKR= "Partner currently homemaker"
		PEMPLOY= "Partner currently employed"
		PDISABLE= "Partner currently disabled"
		POTHWRK= "Partner currently other job"
		PMAINJOB= "Partner's main job"
		INCOME= "Total family income (before taxes)"
		CAREPROV= "Current Health Care Provider"
		LSTVISDY= "Days from rand to last visit"
		MAMMO= "Mammogram ever"
		LSTMAMDY= "Days from rand to last mammogram"
		PAPSMEAR= "Pap smear ever"
		LSTPAPDY= "Days from rand to last pap smear"
		ABNPAP3Y= "Abnormal Pap smear last 3 years"
		CERVDYS= "Cervical dysplasia ever"
		ENDOASP= "Endometrial aspiration ever"
		LSTASPDY= "Days from rand to last aspiration"
		HMOINS= "Pre-paid private insurance"
		OTHPRVIN= "Private insurance (other than pre-paid)"
		MEDICARE= "Medicare"
		MEDICAID= "Medicaid"
		MLTRYINS= "Military or VA insurance"
		NOINS= "No insurance"
		PAYOTH= "Other insurance than listed"
		USSERVE= "Served in US armed forces"
		VAMEDCTR= "Used a VA medical center ever"
		MAINJOB= "Occupation"
		NOMAM2YR= "No mammogram in last 2 years"
		NOPAP3YR= "No pap smear in last 3 years"
		TIMELAST= "Time Since Last Medical Visit (months)"
		TIMELSTS= "Last Medical Visit within 1 Year"
		ANYINS= "Any Insurance";

  FORMAT	F20CONT F20CONTF. EDUC EDUCF. NOTWRK NOTWRKF. RETIRED RETIREDF. HOMEMKR HOMEMKRF. EMPLOYED EMPLOYEDF. 
	DISABLED DISABLEDF. OTHWRK OTHWRKF. JOBHMMKR JOBHMMKRF. JOBMANGR JOBMANGRF. JOBTECH JOBTECHF. 
	JOBSERV JOBSERVF. JOBLABOR JOBLABORF. JOBOTH JOBOTHF. MARITAL MARITALF. PEDUC PEDUCF. 
	PNOTWRK PNOTWRKF. PRETIRED PRETIREDF. PHOMEMKR PHOMEMKRF. PEMPLOY PEMPLOYF. PDISABLE PDISABLEF. 
	POTHWRK POTHWRKF. PMAINJOB PMAINJOBF. INCOME INCOMEF. CAREPROV CAREPROVF. MAMMO MAMMOF. 
	PAPSMEAR PAPSMEARF. ABNPAP3Y ABNPAP3YF. CERVDYS CERVDYSF. ENDOASP ENDOASPF. HMOINS HMOINSF. 
	OTHPRVIN OTHPRVINF. MEDICARE MEDICAREF. MEDICAID MEDICAIDF. MLTRYINS MLTRYINSF. NOINS NOINSF. 
	PAYOTH PAYOTHF. USSERVE USSERVEF. VAMEDCTR VAMEDCTRF. MAINJOB MAINJOBF. NOMAM2YR NOMAM2YRF. 
	NOPAP3YR NOPAP3YRF. TIMELSTS TIMELSTSF. ANYINS ANYINSF. ;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f20;
	format id days;
	set whisf.f20_ctos_inv;
	
	* Collapse categories;
	if educ in (1:4) then edu4cat = 1;       /*<HS*/
	else if educ = 5 then edu4cat = 2;       /*HS Grad*/
	else if educ in (6:7) then edu4cat = 3;  /*Some College or Tech School*/
	else if educ in (8:11) then edu4cat = 4; /*College Grad*/
	
	* Income;
	if income in (1:2) then inc5cat_f20 = 1;      /*20,000 or less*/
	else if income = 3 then inc5cat_f20 = 2;      /*20-34,999*/
	else if income = 4 then inc5cat_f20 = 3;      /*35-49,999*/
	else if income = 5 then inc5cat_f20 = 4;      /*50-74,999*/
	else if income in (6:8) then inc5cat_f20 = 5; /*75,000+*/
	else inc5cat_f20 = .;

	* Create time (days) variable;
	rename f20days = days;

	* Apply formats (created in dem_ctos_inv);
	format edu4cat edu4cat. inc5cat_f20 inc5cat.;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f20;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;











