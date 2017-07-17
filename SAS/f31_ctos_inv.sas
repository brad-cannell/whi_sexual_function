* ============================================================================;
* Clean Form 31 - Reproductive History
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename medhist "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Med History\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F31CONTF
		1="Phone"
		2="Mail"
		3="Visit"
		8="Other";

	VALUE MENARCHEF
		1="9 or less"
		2="10"
		3="11"
		4="12"
		5="13"
		6="14"
		7="15"
		8="16"
		9="17 or older";

	VALUE MENSREGF
		0="No"
		1="Yes"
		2="Sometimes regular, sometimes irregular";

	VALUE MENSREGAF
		1="9 or less"
		2="10"
		3="11"
		4="12"
		5="13"
		6="14"
		7="15"
		8="16"
		9="17 or older";

	VALUE MENSWO1YF
		0="No"
		1="Yes";

	VALUE MENSWODF
		1="Less than 12 months"
		2="12 to 23 months"
		3="24 months to 48 months"
		4="More than 4 years";

	VALUE MENPSYMPF
		0="No"
		1="Yes";

	VALUE PREGF
		0="No"
		1="Yes";

	VALUE PREGNUMF
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE PREG6MF
		0="No"
		1="Yes";

	VALUE PREG6MNF
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE PREG6MAFF
		1="Less than 20"
		2="20-24"
		3="25-29"
		4="30-34"
		5="35-39"
		6="40-44"
		7="45 or older";

	VALUE PREG6MALF
		1="Less than 20"
		2="20-24"
		3="25-29"
		4="30-34"
		5="35-39"
		6="40-44"
		7="45 or older";

	VALUE BRTHLIVNF
		0="None"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE BRTHSTLNF
		0="None"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE MISCARYNF
		0="None"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE ECTPREGF
		0="None"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE NOCNCEIVF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE NOCNCVDRF
		0="No"
		1="Yes";

	VALUE NOCNCVRF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE NOCNCVHRF
		0="No"
		1="Yes";

	VALUE NOCNCVUTF
		0="No"
		1="Yes";

	VALUE NOCNCVENF
		0="No"
		1="Yes";

	VALUE NOCNCVOTF
		0="No"
		1="Yes";

	VALUE NOCNCVPTF
		0="No"
		1="Yes";

	VALUE NOCNCVDKF
		0="No"
		1="Yes";

	VALUE BRSTFEEDF
		0="No"
		1="Yes";

	VALUE BRSTFDNF
		1="1"
		2="2"
		3="3"
		4="4"
		5="5"
		6="6"
		7="7"
		8="8 or more";

	VALUE BRSTFDAFF
		1="Less than 20"
		2="20-24"
		3="25-29"
		4="30-34"
		5="35-39"
		6="40-44"
		7="45 or older";

	VALUE BRSTFDALF
		1="Less than 20"
		2="20-24"
		3="25-29"
		4="30-34"
		5="35-39"
		6="40-44"
		7="45 or older";

	VALUE BRSTFDMF
		1="1-3 months"
		2="4-6 months"
		3="7-12 months"
		4="13-23 months"
		5="2-4 years (24-48 months)"
		6="More than 4 years";

	VALUE OOPHF
		0="No"
		1="Yes, one was taken out"
		2="Yes, both were taken out"
		3="Yes, unknown number taken out"
		4="Yes, part of an ovary was taken out"
		9="Don't know";

	VALUE OOPHAF
		1="Less than 30"
		2="30-34"
		3="35-39"
		4="40-44"
		5="45-49"
		6="50-54"
		7="55-59"
		8="60 or older";

	VALUE TUBTIEDF
		0="No"
		1="Yes";

	VALUE TUBTIEDAF
		1="Less than 30"
		2="30-34"
		3="35-39"
		4="40-44"
		5="45 or older";

	VALUE NEDLASPF
		0="No"
		1="Yes";

	VALUE NEDLASPAF
		1="1"
		2="2"
		3="3"
		4="4 or more";

	VALUE BRSTBIOPF
		0="No"
		1="Yes";

	VALUE BRSTBIONF
		1="1"
		2="2"
		3="3"
		4="4 or more";

	VALUE BRSTAUGF
		0="No"
		1="Yes";

	VALUE BRSTAUGAF
		1="Less than 30"
		2="30-34"
		3="35-39"
		4="40-44"
		5="45-49"
		6="50-54"
		7="55 or older";

	VALUE BRSTAUGSF
		1="Right breast"
		2="Left breast"
		3="Both breasts";

	VALUE BRSTIMPF
		1="Silicone or silicone gel-filled"
		2="Saline-filled"
		8="Other"
		9="Don't know";

	VALUE BRSTOPOTF
		0="No"
		1="Yes";

	VALUE BRSTPREMF
		0="No"
		1="Yes";

	VALUE BRST1REMF
		0="No"
		1="Yes";

	VALUE BRST2REMF
		0="No"
		1="Yes";

	VALUE BRSTREMOF
		0="No"
		1="Yes";

	VALUE GRAVIDF
		0="Never pregnant"
		1="1"
		2="2-4"
		3="5+";

	VALUE PARITYF
		-1="Never pregnant"
		0="Never had term pregnancy"
		1="1"
		2="2"
		3="3"
		4="4"
		5="5+";

	VALUE FULLTRMRF
		0="No"
		1="Yes";

	VALUE NUMLIVERF
		-1="Never pregnant"
		0="None"
		1="1"
		2="2 - 4"
		3="5+";

	VALUE ABORTIONF
		0="Pregnant, never had an abortion"
		1="One or more abortions";

	VALUE AGEFBIRF
		0="Never had term pregnancy"
		1="< 20"
		2="20-29"
		3="30+";

	VALUE BOOPHF
		0="No"
		1="Yes";

	VALUE BRSTFDMOF
		0="Never breastfed"
		1="1-6 months"
		2="7-12 Months"
		3="13-23 Months"
		4="24+ Months";

	VALUE BRSTDISF
		0="No"
		1="Yes, 1 biopsy"
		2="Yes, 2+ biopsies";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f31_ctos_inv;
  INFILE medhist(f31_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F31DAYS F31CONT MENARCHE MENSREG MENSREGA MENOPSEA MENSWO1Y MENSWOD ANYMENSA 
        MENPSYMP MENPSYAF MENPSYAL PREG PREGNUM PREG6M PREG6MN PREG6MAF PREG6MAL BRTHLIVN 
        BRTHSTLN MISCARYN ECTPREG NOCNCEIV NOCNCVDR NOCNCVR NOCNCVHR NOCNCVUT NOCNCVEN NOCNCVOT 
        NOCNCVPT NOCNCVDK BRSTFEED BRSTFDN BRSTFDAF BRSTFDAL BRSTFDM OOPH OOPHA TUBTIED 
        TUBTIEDA NEDLASP NEDLASPA BRSTBIOP BRSTBION BRSTAUG BRSTAUGA BRSTAUGS BRSTIMP BRSTOPOT 
        BRSTPREM BRST1REM BRST2REM BRSTREMO GRAVID PARITY FULLTRMR NUMLIVER ABORTION AGEFBIR 
        BOOPH BRSTFDMO BRSTDIS MENO  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F31DAYS= "F31 Days since randomization/enrollment"
		F31CONT= "Contact type"
		MENARCHE= "Age at first period"
		MENSREG= "Were periods regular"
		MENSREGA= "Age at first regular period"
		MENOPSEA= "Age at last regular period"
		MENSWO1Y= "One year without period"
		MENSWOD= "Time between first and last period"
		ANYMENSA= "Age at last bleeding"
		MENPSYMP= "Hot flashes or night sweats"
		MENPSYAF= "Age at first hot flash"
		MENPSYAL= "Age at last hot flash"
		PREG= "Ever been pregnant"
		PREGNUM= "How many times pregnant"
		PREG6M= "Ever have full-term pregnancy"
		PREG6MN= "How many times term pregnancy"
		PREG6MAF= "Age at first term pregnancy"
		PREG6MAL= "Age at last term pregnancy"
		BRTHLIVN= "How many live births"
		BRTHSTLN= "How many still births"
		MISCARYN= "How many miscarriages"
		ECTPREG= "How many tubal pregnancies"
		NOCNCEIV= "Tried becoming pregnant > 1 yr"
		NOCNCVDR= "Saw doctor because you didn't"
		NOCNCVR= "Reason found for non-pregnancy"
		NOCNCVHR= "Hormones or ovulation"
		NOCNCVUT= "Tubes or uterus"
		NOCNCVEN= "Endometriosis"
		NOCNCVOT= "Other problem with you"
		NOCNCVPT= "Problem with partner"
		NOCNCVDK= "Don't know reason"
		BRSTFEED= "Breastfeed at least one month"
		BRSTFDN= "How many children breastfed"
		BRSTFDAF= "How old when first breastfed"
		BRSTFDAL= "How old when last breastfed"
		BRSTFDM= "How many months total"
		OOPH= "One or both ovaries removed"
		OOPHA= "Age when ovaries removed"
		TUBTIED= "Ever had tubes tied"
		TUBTIEDA= "Age when tubes tied"
		NEDLASP= "Needle aspiration ever"
		NEDLASPA= "How many aspirations"
		BRSTBIOP= "Breast biopsy ever"
		BRSTBION= "How many breast biopsies"
		BRSTAUG= "Operation to increase breast"
		BRSTAUGA= "How old at breast augmentation"
		BRSTAUGS= "Which breast increased"
		BRSTIMP= "What type of implant"
		BRSTOPOT= "Any other breast operations"
		BRSTPREM= "Removal of part of breast"
		BRST1REM= "Removal of one breast"
		BRST2REM= "Removal of both breasts"
		BRSTREMO= "Other breast operation"
		GRAVID= "Number of Pregnancies"
		PARITY= "Number of Term Pregnancies"
		FULLTRMR= "Full term pregnancy ever"
		NUMLIVER= "Number of Live Births"
		ABORTION= "Any Induced Abortions"
		AGEFBIR= "Age at First Birth"
		BOOPH= "Bilateral Oophorectomy"
		BRSTFDMO= "Number of months breastfed"
		BRSTDIS= "Breast Disease"
		MENO= "Age at menopause";

  FORMAT	F31CONT F31CONTF. MENARCHE MENARCHEF. MENSREG MENSREGF. MENSREGA MENSREGAF. MENSWO1Y MENSWO1YF. MENSWOD MENSWODF. 
	MENPSYMP MENPSYMPF. PREG PREGF. PREGNUM PREGNUMF. PREG6M PREG6MF. PREG6MN PREG6MNF. 
	PREG6MAF PREG6MAFF. PREG6MAL PREG6MALF. BRTHLIVN BRTHLIVNF. BRTHSTLN BRTHSTLNF. MISCARYN MISCARYNF. 
	ECTPREG ECTPREGF. NOCNCEIV NOCNCEIVF. NOCNCVDR NOCNCVDRF. NOCNCVR NOCNCVRF. NOCNCVHR NOCNCVHRF. 
	NOCNCVUT NOCNCVUTF. NOCNCVEN NOCNCVENF. NOCNCVOT NOCNCVOTF. NOCNCVPT NOCNCVPTF. NOCNCVDK NOCNCVDKF. 
	BRSTFEED BRSTFEEDF. BRSTFDN BRSTFDNF. BRSTFDAF BRSTFDAFF. BRSTFDAL BRSTFDALF. BRSTFDM BRSTFDMF. 
	OOPH OOPHF. OOPHA OOPHAF. TUBTIED TUBTIEDF. TUBTIEDA TUBTIEDAF. NEDLASP NEDLASPF. 
	NEDLASPA NEDLASPAF. BRSTBIOP BRSTBIOPF. BRSTBION BRSTBIONF. BRSTAUG BRSTAUGF. BRSTAUGA BRSTAUGAF. 
	BRSTAUGS BRSTAUGSF. BRSTIMP BRSTIMPF. BRSTOPOT BRSTOPOTF. BRSTPREM BRSTPREMF. BRST1REM BRST1REMF. 
	BRST2REM BRST2REMF. BRSTREMO BRSTREMOF. GRAVID GRAVIDF. PARITY PARITYF. FULLTRMR FULLTRMRF. 
	NUMLIVER NUMLIVERF. ABORTION ABORTIONF. AGEFBIR AGEFBIRF. BOOPH BOOPHF. BRSTFDMO BRSTFDMOF. 
	BRSTDIS BRSTDISF. ;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f31;
	format id days;
	set whisf.f31_ctos_inv;

	* Create time (days) variable;
	rename f31days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f31;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;
