* ============================================================================;
* Clean Form 60 - Food Frequency Questionnaire - Computed Nutrients
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename diet "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Diet\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F60VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit";

	VALUE F60VCLOF
		0="No"
		1="Yes";

	VALUE F60EXPCF
		0="No"
		1="Yes";

	VALUE STATUSF
		1="Energy < 600 kcal consider excluding from analyses"
		2="Energy > 5000 kcal consider excluding from analyses"
		3="600 kcal <= Energy <= 5000 kcal";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f60_ctos_inv;
  INFILE diet(f60_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F60DAYS F60VTYP F60VY F60VCLO F60EXPC STATUS F60GRAMS F60ENRGY F60ENRGYJ 
        F60CARB F60TSUGR F60GTLC F60GLAC F60DIETGI F60DIETGA F60PROT F60ANMPR F60VEGPR F60FAT 
        F60SFA F60MFA F60PFA F60TFTOT F60FRUIT F60VEG F60FIBER F60SOLFB F60INSFB F60CHOLS 
        F60WATER F60ALC F60ALCWK F60CAFF F60CBPCT F60PRPCT F60FTPCT F60SFPCT F60MFPCT F60PFPCT 
        F60VITA F60VITAIU F60VITARE F60RETIN F60THIAM F60RIBO F60NIACN F60NICNEQ F60PANTO F60VITB6 
        F60VB12 F60FOLA F60FLDEQ F60FLNAT F60FLSYN F60VITC F60VITD F60VTEIU F60ATOCO F60VITE 
        F60NATOC F60STOCO F60BTOCO F60DTOCO F60GTOCO F60VITK F60CALC F60COPPR F60IRON F60MAGN 
        F60MANGN F60PHOS F60POTAS F60SELEN F60SODUM F60ZINC F60ACARO F60BETA F60BCRYP F60LYCO 
        F60LUTZX F60PECT F60STRCH F60ADSGR F60GALAC F60GLUC F60FRUCT F60LACT F60MALT F60SUCR 
        F60ALAN F60ARGIN F60ASPRT F60CYSTN F60ISOLE F60GLUT F60GLYCN F60HISTD F60LEUCN F60LYSIN 
        F60METHN F60PHNYL F60PROLN F60SERIN F60THREO F60TRYPT F60TYROS F60VALIN F60METH F60OXALC 
        F60PHYTC F60ASH F60SF40 F60SF60 F60SF80 F60SF100 F60SF120 F60SF140 F60SF160 F60SF170 
        F60SF180 F60SF200 F60SF220 F60MF141 F60MF161 F60MF181 F60MF201 F60MF221 F60PF182 F60PF183 
        F60PF184 F60PF204 F60PF205 F60PF225 F60PF226 F60TF161 F60TF181 F60TF182 F60OMGA3 F60OMGA6 
        F60BIOCHN F60CUMST F60DAIDZ F60FRMNT F60GNISTN F60GLYCTN  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F60DAYS= "F60 Days since randomization/enrollment"
		F60VTYP= "Visit Type"
		F60VY= "Visit year"
		F60VCLO= "Closest to visit within visit type and year"
		F60EXPC= "Expected for visit"
		STATUS= "Analysis exclusion consideration status"
		F60GRAMS= "Dietary Gram Amount"
		F60ENRGY= "Dietary Energy (kcal)"
		F60ENRGYJ= "Dietary Energy (joules)"
		F60CARB= "Dietary Total Carbohydrate (g)"
		F60TSUGR= "Dietary Total Sugars (g)"
		F60GTLC= "Dietary Glycemic Load Based on Total Carb"
		F60GLAC= "Dietary Glycemic Load Based on Available Carb"
		F60DIETGI= "Dietary Glycemic Index (using total carbs)"
		F60DIETGA= "Dietary Glycemic Index (using available carbs)"
		F60PROT= "Dietary Protein (g)"
		F60ANMPR= "Dietary Animal Protein (g)"
		F60VEGPR= "Dietary Vegetable Protein (g)"
		F60FAT= "Dietary Total Fat (g)"
		F60SFA= "Dietary Total SFA (g)"
		F60MFA= "Dietary Total MFA (g)"
		F60PFA= "Dietary Total PFA (g)"
		F60TFTOT= "Dietary Total Trans Fatty Acid (g)"
		F60FRUIT= "Daily Fruit Consumption (med portion)"
		F60VEG= "Daily Vegetable Consumption (med portion)"
		F60FIBER= "Dietary Fiber (g)"
		F60SOLFB= "Water Soluble Dietary Fiber (g)"
		F60INSFB= "Insoluble Dietary Fiber (g)"
		F60CHOLS= "Dietary Cholesterol (mg)"
		F60WATER= "Dietary Water (g)"
		F60ALC= "Dietary Alcohol (g)"
		F60ALCWK= "Alcohol servings per week"
		F60CAFF= "Dietary Caffeine (mg)"
		F60CBPCT= "Percent Calories from Carbohydrates"
		F60PRPCT= "Percent Calories from Protein"
		F60FTPCT= "Percent Calories from Fat"
		F60SFPCT= "Percent Calories from SFA"
		F60MFPCT= "Percent Calories from MFA"
		F60PFPCT= "Percent Calories from PFA"
		F60VITA= "Dietary Vitamin A (RAE)"
		F60VITAIU= "Dietary Vitamin A (IU)"
		F60VITARE= "Dietary Vitamin A (mcg RE)"
		F60RETIN= "Dietary Retinol (mcg)"
		F60THIAM= "Dietary Thiamin (mg)"
		F60RIBO= "Dietary Riboflavin (mg)"
		F60NIACN= "Dietary Niacin (mg)"
		F60NICNEQ= "Dietary Niacin Equivalents (mg)"
		F60PANTO= "Dietary Pantothenic Acid (mg)"
		F60VITB6= "Dietary Vitamin B6 (mg)"
		F60VB12= "Dietary Vitamin B12 (mcg)"
		F60FOLA= "Dietary Folacin (mcg)"
		F60FLDEQ= "Dietary Folate Equivalents (mcg)"
		F60FLNAT= "Dietary Natural Folate (food folate) (mcg)"
		F60FLSYN= "Dietary Synthetic Folate (folic acid) (mcg)"
		F60VITC= "Dietary Vitamin C (mg)"
		F60VITD= "Dietary Vitamin D (mcg)"
		F60VTEIU= "Dietary Vitamin E (IU)"
		F60ATOCO= "Dietary Alpha-Tocopherol (mg)"
		F60VITE= "Dietary Total Alpha-Toc Eq (mg)"
		F60NATOC= "Dietary Natural Alpha-Tocopherol (mg)"
		F60STOCO= "Dietary Synthetic Alpha-Tocopherol (mg)"
		F60BTOCO= "Dietary Beta-Tocopherol (mg)"
		F60DTOCO= "Dietary Delta-Tocopherol (mg)"
		F60GTOCO= "Dietary Gamma-Tocopherol (mg)"
		F60VITK= "Dietary Vitamin K (NDS Value) (mcg)"
		F60CALC= "Dietary Calcium (mg)"
		F60COPPR= "Dietary Copper (mg)"
		F60IRON= "Dietary Iron (mg)"
		F60MAGN= "Dietary Magnesium (mg)"
		F60MANGN= "Dietary Manganese (mg)"
		F60PHOS= "Dietary Phosphorous (mg)"
		F60POTAS= "Dietary Potassium (mg)"
		F60SELEN= "Dietary Selenium (mcg)"
		F60SODUM= "Dietary Sodium (mg)"
		F60ZINC= "Dietary Zinc (mg)"
		F60ACARO= "Dietary Alpha-Carotene (mcg)"
		F60BETA= "Dietary Beta-Carotene (mcg)"
		F60BCRYP= "Dietary Beta-Cryptoxanthin (mcg)"
		F60LYCO= "Dietary Lycopene (mcg)"
		F60LUTZX= "Dietary Lutein+Zeaxanthin (mcg)"
		F60PECT= "Dietary Pectins (g)"
		F60STRCH= "Dietary Starch (g)"
		F60ADSGR= "Dietary Added Sugars (g)"
		F60GALAC= "Dietary Galactose (g)"
		F60GLUC= "Dietary Glucose (g)"
		F60FRUCT= "Dietary Fructose (g)"
		F60LACT= "Dietary Lactose (g)"
		F60MALT= "Dietary Maltose (g)"
		F60SUCR= "Dietary Sucrose (g)"
		F60ALAN= "Dietary Alanine (g)"
		F60ARGIN= "Dietary Arginine (g)"
		F60ASPRT= "Dietary Aspartic Acid (g)"
		F60CYSTN= "Dietary Cystine (g)"
		F60ISOLE= "Dietary Isoleucine (g)"
		F60GLUT= "Dietary Glutamic Acid (g)"
		F60GLYCN= "Dietary Glycine (g)"
		F60HISTD= "Dietary Histidine (g)"
		F60LEUCN= "Dietary Leucine (g)"
		F60LYSIN= "Dietary Lysine (g)"
		F60METHN= "Dietary Methionine (g)"
		F60PHNYL= "Dietary Phenylalanine (g)"
		F60PROLN= "Dietary Proline (g)"
		F60SERIN= "Dietary Serine (g)"
		F60THREO= "Dietary Threonine (g)"
		F60TRYPT= "Dietary Tryptophan (g)"
		F60TYROS= "Dietary Tyrosine (g)"
		F60VALIN= "Dietary Valine (g)"
		F60METH= "Dietary 3-Methylhistidine (mg)"
		F60OXALC= "Dietary Oxalic Acid (mg)"
		F60PHYTC= "Dietary Phytic Acid (mg)"
		F60ASH= "Dietary Ash (g)"
		F60SF40= "Dietary SFA 4:0 (g)"
		F60SF60= "Dietary SFA 6:0 (g)"
		F60SF80= "Dietary SFA 8:0 (g)"
		F60SF100= "Dietary SFA 10:0 (g)"
		F60SF120= "Dietary SFA 12:0 (g)"
		F60SF140= "Dietary SFA 14:0 (g)"
		F60SF160= "Dietary SFA 16:0, Palmitic Acid (g)"
		F60SF170= "Dietary SFA 17:0 (g)"
		F60SF180= "Dietary SFA 18:0, Stearic Acid (g)"
		F60SF200= "Dietary SFA 20:0 (g)"
		F60SF220= "Dietary SFA 22:0 (g)"
		F60MF141= "Dietary MFA 14:1 (g)"
		F60MF161= "Dietary MFA 16:1 (g)"
		F60MF181= "Dietary MFA 18:1, Oleic Acid (g)"
		F60MF201= "Dietary MFA 20:1 (g)"
		F60MF221= "Dietary MFA 22:1 (g)"
		F60PF182= "Dietary PFA 18:2, Linoleic Acid (g)"
		F60PF183= "Dietary PFA 18:3, Linolenic Acid (g)"
		F60PF184= "Dietary PFA 18:4 (g)"
		F60PF204= "Dietary PFA 20:4 (g)"
		F60PF205= "Dietary PFA 20:5, EPA (g)"
		F60PF225= "Dietary PFA 22:5 (g)"
		F60PF226= "Dietary PFA 22:6, dha (g)"
		F60TF161= "Dietary Trans Fatty Acid, 161T (g)"
		F60TF181= "Dietary Trans Fatty Acid, 181T (g)"
		F60TF182= "Dietary Trans Fatty Acid, 182T (g)"
		F60OMGA3= "Dietary Omega 3  (g)"
		F60OMGA6= "Dietary Omega 6 FA  (g)"
		F60BIOCHN= "Dietary Biochanin A (mg)"
		F60CUMST= "Dietary Coumestrol (mg)"
		F60DAIDZ= "Dietary Daidzein (mg)"
		F60FRMNT= "Dietary Formononetin (mg)"
		F60GNISTN= "Dietary Genistein (mg)"
		F60GLYCTN= "Dietary Glycitein (mg)";

  FORMAT	F60VTYP F60VTYPF. F60VCLO F60VCLOF. F60EXPC F60EXPCF. STATUS STATUSF. ;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f60;
	format id days;
	set whisf.f60_ctos_inv;	

	* Create time (days) variable;
	rename f60days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f60;
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
	select id, days, f60vclo, f60expc, count(*) as dups
		from whisf.f60
		group by id, days
		having calculated dups >= 2;
		* There are 8 rows with duplicate id/days;
quit;

* Just want to keep the first observation for each set of dups;
proc contents data = whisf.f60;
	ods select attributes;
run;
* 385,378 observations;

* Order them Yes, No, Yes, No so that when there is a yes and a no, yes's are
* kept;
proc sort data = whisf.f60;
	by id days descending f60vclo;
run;

proc sort data = whisf.f60
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f60;
	ods select attributes;
run;
* 385,374 observations - expected number;

* Double check that yes's were kept;
proc sql;
	select id, days, f60vclo, f60expc
		from whisf.f60
		where (id = 149072 & days = 361) | (id = 205923 & days = 1239);
quit;
* Good;


