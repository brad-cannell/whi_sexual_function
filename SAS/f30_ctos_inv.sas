* ============================================================================;
* Clean Form 30 - Medical History
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename medhist "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Med History\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F30CONTF
		1="Phone"
		2="Mail"
		3="Visit"
		8="Other";

	VALUE HOSP2YF
		0="No"
		1="Yes";

	VALUE GLAUCOMAF
		0="No"
		1="Yes";

	VALUE CATARACTF
		0="No"
		1="Yes";

	VALUE HICHOLRPF
		0="No"
		1="Yes";

	VALUE ASTHMAF
		0="No"
		1="Yes";

	VALUE EMPHYSEMF
		0="No"
		1="Yes";

	VALUE KIDNEYSTF
		0="No"
		1="Yes";

	VALUE HIBLDCAF
		0="No"
		1="Yes";

	VALUE STOMULCRF
		0="No"
		1="Yes";

	VALUE DIVERTICF
		0="No"
		1="Yes";

	VALUE COLITISF
		0="No"
		1="Yes";

	VALUE LUPUSF
		0="No"
		1="Yes";

	VALUE PANCREATF
		0="No"
		1="Yes";

	VALUE OSTEOPORF
		0="No"
		1="Yes";

	VALUE HIPREPF
		0="No"
		1="Yes";

	VALUE OTHJREPF
		0="No"
		1="Yes";

	VALUE INTESTRMF
		0="No"
		1="Yes";

	VALUE MIGRAINEF
		0="No"
		1="Yes";

	VALUE ALZHEIMF
		0="No"
		1="Yes";

	VALUE MSF
		0="No"
		1="Yes";

	VALUE PARKINSF
		0="No"
		1="Yes";

	VALUE ALSF
		0="No"
		1="Yes";

	VALUE NACONDF
		0="No"
		1="Yes";

	VALUE CVDF
		0="No"
		1="Yes";

	VALUE CARDRESTF
		0="No"
		1="Yes";

	VALUE CHF_F30F
		0="No"
		1="Yes";

	VALUE CARDCATHF
		0="No"
		1="Yes";

	VALUE CABGF
		0="No"
		1="Yes";

	VALUE PTCAF
		0="No"
		1="Yes";

	VALUE CAROTIDF
		0="No"
		1="Yes";

	VALUE ATRIALFBF
		0="No"
		1="Yes";

	VALUE AORTICANF
		0="No"
		1="Yes";

	VALUE NACVDF
		0="No"
		1="Yes";

	VALUE ARTHRITF
		0="No"
		1="Yes";

	VALUE RHEUMATF
		1="Rheumatoid Arthritis"
		8="Other/Don't Know";

	VALUE GALLBSF
		0="No"
		1="Yes";

	VALUE GALLBSNWF
		0="No"
		1="Yes";

	VALUE GALLSTRMF
		0="No"
		1="Yes";

	VALUE GALLBLRMF
		0="No"
		1="Yes";

	VALUE THYROIDF
		0="No"
		1="Yes";

	VALUE GOITERF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE GOITERNWF
		0="No"
		1="Yes";

	VALUE NODULEF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE NODULENWF
		0="No"
		1="Yes";

	VALUE OVRTHYF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE OVRTHYNWF
		0="No"
		1="Yes";

	VALUE UNDTHYF
		0="No"
		1="Yes"
		9="Don't know";

	VALUE UNDTHYNWF
		0="No"
		1="Yes";

	VALUE HYPTF
		0="No"
		1="Yes";

	VALUE HYPTAGEF
		1="Less than 20"
		2="20-29"
		3="30-39"
		4="40-49"
		5="50-59"
		6="60-69"
		7="70 or older";

	VALUE HYPTPILLF
		0="No"
		1="Yes";

	VALUE HYPTPILNF
		0="No"
		1="Yes";

	VALUE ANGINAF
		0="No"
		1="Yes";

	VALUE ANGNPILNF
		0="No"
		1="Yes";

	VALUE PADF
		0="No"
		1="Yes";

	VALUE PADANGGRF
		0="No"
		1="Yes";

	VALUE PADANGPF
		0="No"
		1="Yes";

	VALUE PADSURGF
		0="No"
		1="Yes";

	VALUE COLNSCPYF
		0="No"
		1="Yes";

	VALUE COLNSCDTF
		1="Less than 5 years ago"
		2="5 or more years ago";

	VALUE PCOLONRMF
		0="No"
		1="Yes";

	VALUE HEMOCCULF
		0="No"
		1="Yes";

	VALUE HEMOCCDTF
		1="Less than 5 years ago"
		2="5 or more years ago";

	VALUE CANC_F30F
		0="No"
		1="Yes";

	VALUE BRCA_F30F
		0="No"
		1="Yes";

	VALUE BRCA55F
		1="Less than 55"
		2="55 or older";

	VALUE OVRYCAF
		0="No"
		1="Yes";

	VALUE OVRYCA55F
		1="Less than 55"
		2="55 or older";

	VALUE ENDO_F30F
		0="No"
		1="Yes";

	VALUE ENDOCA55F
		1="Less than 55"
		2="55 or older";

	VALUE COLN_F30F
		0="No"
		1="Yes";

	VALUE COLOCA55F
		1="Less than 55"
		2="55 or older";

	VALUE THYRCAF
		0="No"
		1="Yes";

	VALUE THYRCA55F
		1="Less than 55"
		2="55 or older";

	VALUE CERVCAF
		0="No"
		1="Yes";

	VALUE SKINCAF
		0="No"
		1="Yes";

	VALUE MELN_F30F
		0="No"
		1="Yes";

	VALUE LIVERCAF
		0="No"
		1="Yes";

	VALUE LUNGCAF
		0="No"
		1="Yes";

	VALUE BRAINCAF
		0="No"
		1="Yes";

	VALUE BONECAF
		0="No"
		1="Yes";

	VALUE STOMCAF
		0="No"
		1="Yes";

	VALUE LEUKCAF
		0="No"
		1="Yes";

	VALUE BLADCAF
		0="No"
		1="Yes";

	VALUE LYMPHCAF
		0="No"
		1="Yes";

	VALUE HODGCAF
		0="No"
		1="Yes";

	VALUE OTHCAF
		0="No"
		1="Yes";

	VALUE NUMFALLSF
		0="None"
		1="1 time"
		2="2 times"
		3="3 or more times";

	VALUE FAINTEDF
		0="No"
		1="Yes";

	VALUE BKBONEF
		0="No"
		1="Yes";

	VALUE BKHIPF
		0="No"
		1="Yes";

	VALUE BKHIP55F
		1="Less than 55"
		2="55 or older";

	VALUE BKBACKF
		0="No"
		1="Yes";

	VALUE BKBACK55F
		1="Less than 55"
		2="55 or older";

	VALUE BKUARMF
		0="No"
		1="Yes";

	VALUE BKUARM55F
		1="Less than 55"
		2="55 or older";

	VALUE BKLARMF
		0="No"
		1="Yes";

	VALUE BKLARM55F
		1="Less than 55"
		2="55 or older";

	VALUE BKHANDF
		0="No"
		1="Yes";

	VALUE BKHAND55F
		1="Less than 55"
		2="55 or older";

	VALUE BKLLEGF
		0="No"
		1="Yes";

	VALUE BKLLEG55F
		1="Less than 55"
		2="55 or older";

	VALUE BKFOOTF
		0="No"
		1="Yes";

	VALUE BKFOOT55F
		1="Less than 55"
		2="55 or older";

	VALUE BKOTHBF
		0="No"
		1="Yes";

	VALUE BKOTHB55F
		1="Less than 55"
		2="55 or older";

	VALUE HTNTRTF
		0="Never hypertensive"
		1="Untreated hypertensive"
		2="Treated hypertensive";

	VALUE HIP55F
		0="No"
		1="Yes";

	VALUE FRACT55F
		0="No"
		1="Yes";

	VALUE REVASCF
		0="No"
		1="Yes";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f30_ctos_inv;
  INFILE medhist(f30_ctos_inv) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F30DAYS F30CONT HOSP2Y GLAUCOMA CATARACT HICHOLRP ASTHMA EMPHYSEM KIDNEYST 
        HIBLDCA STOMULCR DIVERTIC COLITIS LUPUS PANCREAT OSTEOPOR HIPREP OTHJREP INTESTRM 
        MIGRAINE ALZHEIM MS PARKINS ALS NACOND CVD CARDREST CHF_F30 CARDCATH 
        CABG PTCA CAROTID ATRIALFB AORTICAN NACVD ARTHRIT RHEUMAT GALLBS GALLBSNW 
        GALLSTRM GALLBLRM THYROID GOITER GOITERNW NODULE NODULENW OVRTHY OVRTHYNW UNDTHY 
        UNDTHYNW HYPT HYPTAGE HYPTPILL HYPTPILN ANGINA ANGNPILN PAD PADANGGR PADANGP 
        PADSURG COLNSCPY COLNSCDT PCOLONRM HEMOCCUL HEMOCCDT CANC_F30 BRCA_F30 BRCA55 OVRYCA 
        OVRYCA55 ENDO_F30 ENDOCA55 COLN_F30 COLOCA55 THYRCA THYRCA55 CERVCA SKINCA MELN_F30 
        LIVERCA LUNGCA BRAINCA BONECA STOMCA LEUKCA BLADCA LYMPHCA HODGCA OTHCA 
        NUMFALLS FAINTED BKBONE BKHIP BKHIP55 BKBACK BKBACK55 BKUARM BKUARM55 BKLARM 
        BKLARM55 BKHAND BKHAND55 BKLLEG BKLLEG55 BKFOOT BKFOOT55 BKOTHB BKOTHB55 HTNTRT 
        HIP55 FRACT55 REVASC  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F30DAYS= "F30 Days since randomization/enrollment"
		F30CONT= "Contact type"
		HOSP2Y= "Hospitalized overnight last two years"
		GLAUCOMA= "Glaucoma ever"
		CATARACT= "Cataract ever"
		HICHOLRP= "High cholesterol requiring pills ever"
		ASTHMA= "Asthma ever"
		EMPHYSEM= "Emphysema ever"
		KIDNEYST= "Kidney or bladder stones ever"
		HIBLDCA= "High blood calcium"
		STOMULCR= "Stomach of duodenal ulcer ever"
		DIVERTIC= "Diverticulitis ever"
		COLITIS= "Ulcerative colitis ever"
		LUPUS= "Lupus ever"
		PANCREAT= "Pancreatitis ever"
		OSTEOPOR= "Osteoporosis ever"
		HIPREP= "Hip replacement ever"
		OTHJREP= "Other joint replacement ever"
		INTESTRM= "Part of intestines removed ever"
		MIGRAINE= "Migraine headaches ever"
		ALZHEIM= "Alzheimer's disease ever"
		MS= "MS ever"
		PARKINS= "Parkinson's disease ever"
		ALS= "ALS ever"
		NACOND= "None of listed medical conditions ever"
		CVD= "Cardiovascular disease ever"
		CARDREST= "Cardiac arrest ever"
		CHF_F30= "Congestive heart failure ever"
		CARDCATH= "Cardiac catheterization ever"
		CABG= "Coronary bypass surgery ever"
		PTCA= "Angioplasty of coronary arteries ever"
		CAROTID= "Carotid endarterectomy/angioplasty ever"
		ATRIALFB= "Atrial fibrillation ever"
		AORTICAN= "Aortic aneurysm ever"
		NACVD= "None of the listed CVD conditions ever"
		ARTHRIT= "Arthritis ever"
		RHEUMAT= "Rheumatoid arthritis ever"
		GALLBS= "Gallbladder disease or gallstones ever"
		GALLBSNW= "Gallbladder disease or gallstones now"
		GALLSTRM= "Gallstones removed"
		GALLBLRM= "Gallbladder removed"
		THYROID= "Thyroid gland problem ever"
		GOITER= "Goiter ever"
		GOITERNW= "Goiter now"
		NODULE= "Thyroid nodule ever"
		NODULENW= "Thyroid nodule now"
		OVRTHY= "Overactive thyroid ever"
		OVRTHYNW= "Overactive thyroid now"
		UNDTHY= "Underactive thyroid ever"
		UNDTHYNW= "Underactive thyroid now"
		HYPT= "Hypertension ever"
		HYPTAGE= "Age told of hypertension"
		HYPTPILL= "Pills for hypertension ever"
		HYPTPILN= "Pills for hypertension now"
		ANGINA= "Angina ever"
		ANGNPILN= "Pills for angina now"
		PAD= "Peripheral arterial disease ever"
		PADANGGR= "Angiography for PAD ever"
		PADANGP= "Angioplasty for PAD ever"
		PADSURG= "Surgery to improve flow to legs for PAD"
		COLNSCPY= "Colonoscopy ever"
		COLNSCDT= "Date of last colonoscopy"
		PCOLONRM= "Polyps of colon removed"
		HEMOCCUL= "Hemoccult test ever"
		HEMOCCDT= "Date of last hemoccult test"
		CANC_F30= "Cancer ever"
		BRCA_F30= "Breast cancer ever"
		BRCA55= "Breast cancer 55 or older"
		OVRYCA= "Ovarian cancer ever"
		OVRYCA55= "Ovarian cancer 55 or older"
		ENDO_F30= "Endometrial cancer ever"
		ENDOCA55= "Endometrium cancer 55 or older"
		COLN_F30= "Colorectal cancer ever"
		COLOCA55= "Colorectal cancer 55 or older"
		THYRCA= "Thyroid cancer ever"
		THYRCA55= "Thyroid cancer 55 or older"
		CERVCA= "Cervix cancer ever"
		SKINCA= "Skin cancer (not melanoma) ever"
		MELN_F30= "Melanoma cancer ever"
		LIVERCA= "Liver cancer ever"
		LUNGCA= "Lung cancer ever"
		BRAINCA= "Brain cancer ever"
		BONECA= "Bone cancer ever"
		STOMCA= "Stomach cancer ever"
		LEUKCA= "Leukemia cancer ever"
		BLADCA= "Bladder cancer ever"
		LYMPHCA= "Lymphoma cancer ever"
		HODGCA= "Hodgkin's cancer ever"
		OTHCA= "Other cancer than listed ever"
		NUMFALLS= "Times fell down last 12 months"
		FAINTED= "Fainted last 12 months"
		BKBONE= "Broke bone ever"
		BKHIP= "Broke hip ever"
		BKHIP55= "Broke hip first time 55 or older"
		BKBACK= "Broke spine ever"
		BKBACK55= "Broke spine first time 55 or older"
		BKUARM= "Broke upper arm ever"
		BKUARM55= "Broke upper arm first time 55 or older"
		BKLARM= "Broke lower arm ever"
		BKLARM55= "Broke lower arm first time 55 or older"
		BKHAND= "Broke hand ever"
		BKHAND55= "Broke hand first time 55 or older"
		BKLLEG= "Broke lower leg ever"
		BKLLEG55= "Broke lower leg first time 55 or older"
		BKFOOT= "Broke foot ever"
		BKFOOT55= "Broke foot first time 55 or older"
		BKOTHB= "Broke other bone ever"
		BKOTHB55= "Broke other bone first time 55 or older"
		HTNTRT= "Hypertension"
		HIP55= "Hip fracture age 55 or older"
		FRACT55= "Fracture at Age 55+"
		REVASC= "CABG/PTCA Ever";

  FORMAT	F30CONT F30CONTF. HOSP2Y HOSP2YF. GLAUCOMA GLAUCOMAF. CATARACT CATARACTF. HICHOLRP HICHOLRPF. ASTHMA ASTHMAF. 
	EMPHYSEM EMPHYSEMF. KIDNEYST KIDNEYSTF. HIBLDCA HIBLDCAF. STOMULCR STOMULCRF. DIVERTIC DIVERTICF. 
	COLITIS COLITISF. LUPUS LUPUSF. PANCREAT PANCREATF. OSTEOPOR OSTEOPORF. HIPREP HIPREPF. 
	OTHJREP OTHJREPF. INTESTRM INTESTRMF. MIGRAINE MIGRAINEF. ALZHEIM ALZHEIMF. MS MSF. 
	PARKINS PARKINSF. ALS ALSF. NACOND NACONDF. CVD CVDF. CARDREST CARDRESTF. 
	CHF_F30 CHF_F30F. CARDCATH CARDCATHF. CABG CABGF. PTCA PTCAF. CAROTID CAROTIDF. 
	ATRIALFB ATRIALFBF. AORTICAN AORTICANF. NACVD NACVDF. ARTHRIT ARTHRITF. RHEUMAT RHEUMATF. 
	GALLBS GALLBSF. GALLBSNW GALLBSNWF. GALLSTRM GALLSTRMF. GALLBLRM GALLBLRMF. THYROID THYROIDF. 
	GOITER GOITERF. GOITERNW GOITERNWF. NODULE NODULEF. NODULENW NODULENWF. OVRTHY OVRTHYF. 
	OVRTHYNW OVRTHYNWF. UNDTHY UNDTHYF. UNDTHYNW UNDTHYNWF. HYPT HYPTF. HYPTAGE HYPTAGEF. 
	HYPTPILL HYPTPILLF. HYPTPILN HYPTPILNF. ANGINA ANGINAF. ANGNPILN ANGNPILNF. PAD PADF. 
	PADANGGR PADANGGRF. PADANGP PADANGPF. PADSURG PADSURGF. COLNSCPY COLNSCPYF. COLNSCDT COLNSCDTF. 
	PCOLONRM PCOLONRMF. HEMOCCUL HEMOCCULF. HEMOCCDT HEMOCCDTF. CANC_F30 CANC_F30F. BRCA_F30 BRCA_F30F. 
	BRCA55 BRCA55F. OVRYCA OVRYCAF. OVRYCA55 OVRYCA55F. ENDO_F30 ENDO_F30F. ENDOCA55 ENDOCA55F. 
	COLN_F30 COLN_F30F. COLOCA55 COLOCA55F. THYRCA THYRCAF. THYRCA55 THYRCA55F. CERVCA CERVCAF. 
	SKINCA SKINCAF. MELN_F30 MELN_F30F. LIVERCA LIVERCAF. LUNGCA LUNGCAF. BRAINCA BRAINCAF. 
	BONECA BONECAF. STOMCA STOMCAF. LEUKCA LEUKCAF. BLADCA BLADCAF. LYMPHCA LYMPHCAF. 
	HODGCA HODGCAF. OTHCA OTHCAF. NUMFALLS NUMFALLSF. FAINTED FAINTEDF. BKBONE BKBONEF. 
	BKHIP BKHIPF. BKHIP55 BKHIP55F. BKBACK BKBACKF. BKBACK55 BKBACK55F. BKUARM BKUARMF. 
	BKUARM55 BKUARM55F. BKLARM BKLARMF. BKLARM55 BKLARM55F. BKHAND BKHANDF. BKHAND55 BKHAND55F. 
	BKLLEG BKLLEGF. BKLLEG55 BKLLEG55F. BKFOOT BKFOOTF. BKFOOT55 BKFOOT55F. BKOTHB BKOTHBF. 
	BKOTHB55 BKOTHB55F. HTNTRT HTNTRTF. HIP55 HIP55F. FRACT55 FRACT55F. REVASC REVASCF. 
	;

RUN;


* ============================================================================;
* Data management
* ============================================================================;
data whisf.f30;
	format id days;
	set whisf.f30_ctos_inv;

	* Create time (days) variable;
	days = 0;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f30;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* No duplicates;
