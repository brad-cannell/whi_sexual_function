* ============================================================================;
* Clean Demographics and Study Membership Form
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename demo "\\Mac\Dropbox\WHI Data\1. From WHI Website\All WHI Datasets\
Demographics\data";

libname whisf "\\Mac\Dropbox\Research\WHI\MS3226 - Sexual function\
whi_sexual_function\data";

options fmtsearch = (whisf);


* Create formats;
PROC FORMAT library = whisf;

	VALUE CTPPTF
		0="No"
		1="Yes";

	VALUE HRTPPTF
		0="No"
		1="Yes";

	VALUE DMPPTF
		0="No"
		1="Yes";

	VALUE CADPPTF
		0="No"
		1="Yes";

	VALUE OSPPTF
		0="No"
		1="Yes";

	VALUE AGERF
		1="<50-59"
		2="60-69"
		3="70-79+";

	VALUE AGESTRATF
		1="50 to 54"
		2="55 to 59"
		3="60 to 69"
		4="70 to 79";

	VALUE REGIONF
		1="Northeast"
		2="South"
		3="Midwest"
		4="West";

	VALUE ETHNICF
		1="American Indian or Alaskan Native"
		2="Asian or Pacific Islander"
		3="Black or African-American"
		4="Hispanic/Latino"
		5="White (not of Hispanic origin)"
		8="Other";

	VALUE LANGF
		1="English"
		2="Spanish";

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

	VALUE HRTARMF
		0="Not randomized to HRT"
		1="E-alone intervention"
		2="E-alone control"
		3="E+P intervention"
		4="E+P control";

	VALUE DMARMF
		0="Not randomized to DM"
		1="Intervention"
		2="Control";

	VALUE CADARMF
		0="Not randomized to CaD"
		1="Intervention"
		2="Control";

	VALUE BMDFLAGF
		0="No"
		1="Yes";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.dem_ctos_inv;
  INFILE demo(dem_ctos_inv) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID CTPPT HRTPPT DMPPT CADPPT OSPPT AGE AGER AGESTRAT REGION 
        ETHNIC LANG EDUC INCOME HRTARM DMARM CADARM CADDAYS BMDFLAG;


  LABEL ID       = "WHI Participant Common ID"
		CTPPT    = "CT Participant"
		HRTPPT   = "HRT Participant"
		DMPPT    = "DM Participant"
		CADPPT   = "CAD Participant"
		OSPPT    = "OS Participant"
		AGE      = "Age at screening"
		AGER     = "Age group at screening"
		AGESTRAT = "Age stratum at randomization or enrollment"
		REGION   = "U.S. Region"
		ETHNIC   = "Ethnicity"
		LANG     = "Preferred Language"
		EDUC     = "Education"
		INCOME   = "Family Income"
		HRTARM   = "HRT Arm"
		DMARM    = "DM Arm"
		CADARM   = "CaD Arm"
		CADDAYS  = "Days since CT randomization to CAD randomization"
		BMDFLAG  = "BMD study";

  FORMAT CTPPT    CTPPTF. 
  		 HRTPPT   HRTPPTF. 
  		 DMPPT    DMPPTF. 
  		 CADPPT   CADPPTF. 
  		 OSPPT    OSPPTF. 
  		 AGER     AGERF. 
  		 AGESTRAT AGESTRATF. 
  		 REGION   REGIONF. 
  		 ETHNIC   ETHNICF. 
  		 LANG     LANGF. 
  		 EDUC     EDUCF. 
  		 INCOME   INCOMEF. 
  		 HRTARM   HRTARMF. 
  		 DMARM    DMARMF. 
  		 CADARM   CADARMF. 
  		 BMDFLAG  BMDFLAGF.
  		 ;
RUN;


* ============================================================================;
* Data management
* ============================================================================;
proc format library = whisf;
	value race_eth	1 = "White"
					2 = "AA"
					3 = "Hispanic"
					4 = "Other";
	value edu4cat	1 = "<HS"
					2 = "HS Grad"
					3 = "Some College or Tech School"
					4 = "College Grad";
	value inc5cat	1 = "20,000 or less"
					2 = "20-34,999"
					3 = "35-49,999"
					4 = "50-74,999"
					5 = "75,000+";
	value ctos		1 = "CT"
					2 = "OS";
run;

data whisf.demo;
	format id days;
	set whisf.dem_ctos_inv;
	
	* Collapse categories;
	* Race / Ethnicity;
	* Update 2017-09-19: Erika doesn't want these groups. I will keep the 
	* original coding for this variable. It can be recoded later in R if need
	* be.;
	* if ethnic in (1, 2, 8) then race_eth = 4; /*Other*/
	* else if ethnic = 3 then race_eth = 2;     /*AA*/
	* else if ethnic = 4 then race_eth = 3;     /*Hispanic*/
	* else if ethnic = 5 then race_eth = 1;     /*White*/
	
	* Education;
	if educ in (1:4) then edu4cat = 1;       /*<HS*/
	else if educ = 5 then edu4cat = 2;       /*HS Grad*/
	else if educ in (6:7) then edu4cat = 3;  /*Some College or Tech School*/
	else if educ in (8:11) then edu4cat = 4; /*College Grad*/
	
	* Income;
	if income in (1:2) then inc5cat = 1;      /*20,000 or less*/
	else if income = 3 then inc5cat = 2;      /*20-34,999*/
	else if income = 4 then inc5cat = 3;      /*35-49,999*/
	else if income = 5 then inc5cat = 4;      /*50-74,999*/
	else if income in (6:8) then inc5cat = 5; /*75,000+*/
	else inc5cat = .;
	
	* Create CT/OS variable;
	if ctppt = 1 & osppt = 0 then ctos = 1;      /*CT*/
	else if ctppt = 0 & osppt = 1 then ctos = 2; /*OS*/

	* Create time (days) variable;
	days = 0;
	
	* Apply formats;
	format edu4cat edu4cat. inc5cat inc5cat.;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.demo;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
