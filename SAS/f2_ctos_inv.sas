* ============================================================================;
* Clean Form 2 - Eligibility Screening
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename demo "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Demographics\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F2CONTF
		1="Phone"
		2="Mail"
		3="Visit"
		8="Other";

	VALUE AREA3YF
		0="No"
		1="Yes";

	VALUE OTHSTDYF
		0="No"
		1="Yes";

	VALUE EXSTDYF
		0="No"
		1="Yes";

	VALUE BRCA_F2F
		0="No"
		1="Yes";

	VALUE COLON_F2F
		0="No"
		1="Yes";

	VALUE COLON10YF
		0="No"
		1="Yes";

	VALUE ENDO_F2F
		0="No"
		1="Yes";

	VALUE ENDO10YF
		0="No"
		1="Yes";

	VALUE SKIN_F2F
		0="No"
		1="Yes";

	VALUE MELAN_F2F
		0="No"
		1="Yes";

	VALUE MELAN10YF
		0="No"
		1="Yes";

	VALUE OTHCA10YF
		0="No"
		1="Yes";

	VALUE RACEF
		1="American Indian or Alaskan Native"
		2="Asian or Pacific Islander"
		3="Black or African-American"
		4="Hispanic/Latino"
		5="White (not of Hispanic origin)"
		8="Other";

	VALUE HEARSTDYF
		1="Mailed letter"
		2="Brochure"
		3="T.V."
		4="Radio"
		5="Newspaper or Magazine"
		6="Meeting"
		7="Friend or Relative"
		8="Other";

	VALUE HORMF
		0="No"
		1="Yes";

	VALUE HORMNWF
		0="No"
		1="Yes";

	VALUE HORM3MF
		0="No"
		1="Yes";

	VALUE OSTEOBKF
		0="No"
		1="Yes";

	VALUE HORMBKF
		0="No"
		1="Yes";

	VALUE HYSTF
		0="No"
		1="Yes";

	VALUE HYST3MF
		0="No"
		1="Yes";

	VALUE HYSTAGEF
		1="Less than 30"
		2="30-34"
		3="35-39"
		4="40-44"
		5="45-49"
		6="50-54"
		7="55-59"
		8="60 or older";

	VALUE MENSELSTF
		1="Still having menstrual bleeding"
		2="Within last 6 months"
		3="7 to 12 months ago"
		4="Over 12 months ago";

	VALUE MEALOUTF
		1="Less than 10 meals each week"
		2="10 or more meals each week";

	VALUE MALDIETF
		0="No"
		1="Yes";

	VALUE LFDIETF2F
		0="No"
		1="Yes";

	VALUE DIABF
		0="No"
		1="Yes";

	VALUE DIABAGEF
		1="Less than 21"
		2="21-29"
		3="30-39"
		4="40-49"
		5="50-59"
		6="60-69"
		7="70 or older";

	VALUE DIABCOMAF
		0="No"
		1="Yes";

	VALUE DBDIETF2F
		0="No"
		1="Yes";

	VALUE INSULINF
		0="No"
		1="Yes";

	VALUE INSULINWF
		0="No"
		1="Yes";

	VALUE DIABPILLF
		0="No"
		1="Yes";

	VALUE DIABNWF
		0="No"
		1="Yes";

	VALUE DVTF
		0="No"
		1="Yes";

	VALUE DVT6MF
		0="No"
		1="Yes";

	VALUE DVTACC1MF
		0="No"
		1="Yes";

	VALUE PEF
		0="No"
		1="Yes";

	VALUE PE6MF
		0="No"
		1="Yes";

	VALUE PEACC1MF
		0="No"
		1="Yes";

	VALUE STROKEF
		0="No"
		1="Yes";

	VALUE STROKE6MF
		0="No"
		1="Yes";

	VALUE TIAF
		0="No"
		1="Yes";

	VALUE TIA6MF
		0="No"
		1="Yes";

	VALUE MIF
		0="No"
		1="Yes";

	VALUE MIAGEF
		1="Less than 40"
		2="40-49"
		3="50-59"
		4="60-69"
		5="70 or older";

	VALUE MI6MF
		0="No"
		1="Yes";

	VALUE SCANEMIAF
		0="No"
		1="Yes";

	VALUE CHF_F2F
		0="No"
		1="Yes";

	VALUE LIVERDISF
		0="No"
		1="Yes";

	VALUE BLDPROBF
		0="No"
		1="Yes";

	VALUE L15LBS6MF
		0="No"
		1="Yes";

	VALUE DIALYSISF
		0="No"
		1="Yes";

	VALUE OTHCHRONF
		0="No"
		1="Yes";

	VALUE HARDSTDYF
		0="No"
		1="Yes";

	VALUE COMECCF
		0="No"
		1="Yes";

	VALUE HELPCCF
		1="Transportation"
		2="Child care"
		3="Adult care"
		8="Other";

	VALUE INTDMF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE AVAILDMF
		0="No"
		1="Yes";

	VALUE INTHRTF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE AVAILHRTF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE TALKDOCF
		0="No"
		1="Yes"
		2="Not on hormones"
		9="Don't know";

	VALUE HRTINFDRF
		0="No"
		1="Yes";

	VALUE HELPFILLF
		0="No"
		1="Yes";

	VALUE HORMSTATF
		0="Never used hormones"
		1="Past hormone user"
		2="Current hormone user";

	VALUE AGEHYSTF
		1="< 40"
		2="40-49"
		3="50-54"
		4="55+";

	VALUE DIABTRTF
		0="No"
		1="Yes";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f2_ctos_inv;
  INFILE demo(f2_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F2DAYS F2CONT AREA3Y OTHSTDY EXSTDY BRCA_F2 COLON_F2 COLON10Y ENDO_F2 
        ENDO10Y SKIN_F2 MELAN_F2 MELAN10Y OTHCA10Y RACE HEARSTDY HORM HORMNW HORM3M 
        OSTEOBK HORMBK HYST HYST3M HYSTAGE MENSELST MEALOUT MALDIET LFDIETF2 DIAB 
        DIABAGE DIABCOMA DBDIETF2 INSULIN INSULINW DIABPILL DIABNW DVT DVT6M DVTACC1M 
        PE PE6M PEACC1M STROKE STROKE6M TIA TIA6M MI MIAGE MI6M 
        SCANEMIA CHF_F2 LIVERDIS BLDPROB L15LBS6M DIALYSIS OTHCHRON HARDSTDY COMECC HELPCC 
        INTDM AVAILDM INTHRT AVAILHRT TALKDOC HRTINFDR HELPFILL HORMSTAT AGEHYST DIABTRT  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F2DAYS= "F2 Days since randomization"
		F2CONT= "Contact type"
		AREA3Y= "Living in area for next 3 years"
		OTHSTDY= "In other research study"
		EXSTDY= "Excluded study"
		BRCA_F2= "Breast cancer ever"
		COLON_F2= "Colorectal cancer ever"
		COLON10Y= "Colorectal cancer last 10 years"
		ENDO_F2= "Endometrial cancer ever"
		ENDO10Y= "Endometrial cancer last 10 years"
		SKIN_F2= "Skin cancer ever"
		MELAN_F2= "Melanoma cancer ever"
		MELAN10Y= "Melanoma cancer last 10 years"
		OTHCA10Y= "Any other cancer than listed last 10 yrs"
		RACE= "Racial or ethnic group"
		HEARSTDY= "Reason for contacting study"
		HORM= "Female hormones ever"
		HORMNW= "Female hormones now"
		HORM3M= "Female hormones last 3 months"
		OSTEOBK= "Osteoporosis-related fracture ever"
		HORMBK= "Hormones to treat osteoporosis fracture"
		HYST= "Hysterectomy ever"
		HYST3M= "Hysterectomy last 3 months"
		HYSTAGE= "Age at hysterectomy"
		MENSELST= "Last time had any menstrual bleeding"
		MEALOUT= "10 or more meals prepared away from home"
		MALDIET= "Special malabsorption diet"
		LFDIETF2= "Special low-fiber diet"
		DIAB= "Diabetes ever"
		DIABAGE= "Age first told had diabetes"
		DIABCOMA= "Hospitalized for a diabetic coma"
		DBDIETF2= "Special diet for diabetes"
		INSULIN= "Insulin shots ever"
		INSULINW= "Insulin shots now"
		DIABPILL= "Pills for diabetes ever"
		DIABNW= "Diabetes now"
		DVT= "DVT ever"
		DVT6M= "DVT last 6 months"
		DVTACC1M= "DVT 1 month after accident"
		PE= "Pulmonary embolism ever"
		PE6M= "Pulmonary embolism last 6 months"
		PEACC1M= "Pulmonary embolism 1 mo after accident"
		STROKE= "Stroke ever"
		STROKE6M= "Stroke last 6 months"
		TIA= "TIA ever"
		TIA6M= "TIA last 6 months"
		MI= "MI ever"
		MIAGE= "Age first had MI"
		MI6M= "MI last 6 months"
		SCANEMIA= "Sickle cell anemia ever"
		CHF_F2= "Heart failure ever"
		LIVERDIS= "Liver disease ever"
		BLDPROB= "Bleeding problem ever"
		L15LBS6M= "Lost 15 lbs in the last 6 mo w/o trying"
		DIALYSIS= "Kidney dialysis for kidney failure"
		OTHCHRON= "Other long-term illness"
		HARDSTDY= "Problems make it hard to participate"
		COMECC= "Able to come to clinic"
		HELPCC= "Kind of help needed to come to clinic"
		INTDM= "Interested in DM part of study"
		AVAILDM= "Available for regular dietary meetings"
		INTHRT= "Interested in HRT part of study"
		AVAILHRT= "Consider taking only HRT from CC"
		TALKDOC= "Interested in talking to Dr. about HRT"
		HRTINFDR= "Send HRT info to Doctor"
		HELPFILL= "Need someone to help fill out forms"
		HORMSTAT= "HRT use ever"
		AGEHYST= "Hysterectomy age group"
		DIABTRT= "Diabetes treated (pills or  shots)";

  FORMAT	F2CONT F2CONTF. AREA3Y AREA3YF. OTHSTDY OTHSTDYF. EXSTDY EXSTDYF. BRCA_F2 BRCA_F2F. COLON_F2 COLON_F2F. 
	COLON10Y COLON10YF. ENDO_F2 ENDO_F2F. ENDO10Y ENDO10YF. SKIN_F2 SKIN_F2F. MELAN_F2 MELAN_F2F. 
	MELAN10Y MELAN10YF. OTHCA10Y OTHCA10YF. RACE RACEF. HEARSTDY HEARSTDYF. HORM HORMF. 
	HORMNW HORMNWF. HORM3M HORM3MF. OSTEOBK OSTEOBKF. HORMBK HORMBKF. HYST HYSTF. 
	HYST3M HYST3MF. HYSTAGE HYSTAGEF. MENSELST MENSELSTF. MEALOUT MEALOUTF. MALDIET MALDIETF. 
	LFDIETF2 LFDIETF2F. DIAB DIABF. DIABAGE DIABAGEF. DIABCOMA DIABCOMAF. DBDIETF2 DBDIETF2F. 
	INSULIN INSULINF. INSULINW INSULINWF. DIABPILL DIABPILLF. DIABNW DIABNWF. DVT DVTF. 
	DVT6M DVT6MF. DVTACC1M DVTACC1MF. PE PEF. PE6M PE6MF. PEACC1M PEACC1MF. 
	STROKE STROKEF. STROKE6M STROKE6MF. TIA TIAF. TIA6M TIA6MF. MI MIF. 
	MIAGE MIAGEF. MI6M MI6MF. SCANEMIA SCANEMIAF. CHF_F2 CHF_F2F. LIVERDIS LIVERDISF. 
	BLDPROB BLDPROBF. L15LBS6M L15LBS6MF. DIALYSIS DIALYSISF. OTHCHRON OTHCHRONF. HARDSTDY HARDSTDYF. 
	COMECC COMECCF. HELPCC HELPCCF. INTDM INTDMF. AVAILDM AVAILDMF. INTHRT INTHRTF. 
	AVAILHRT AVAILHRTF. TALKDOC TALKDOCF. HRTINFDR HRTINFDRF. HELPFILL HELPFILLF. HORMSTAT HORMSTATF. 
	AGEHYST AGEHYSTF. DIABTRT DIABTRTF. ;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f2;
	format id days;
	set whisf.f2_ctos_inv;
	
	* Collapse categories;
	* Race / Ethnicity;
	if race in (1, 2, 8) then race_eth = 4; /*Other*/
	else if race = 3 then race_eth = 2;     /*AA*/
	else if race = 4 then race_eth = 3;     /*Hispanic*/
	else if race = 5 then race_eth = 1;     /*White*/

	* Create time (days) variable;
	rename f2days = days;

	* Apply formats (created in dem_ctos_inv);
	format race_eth race_eth.;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f2;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;
