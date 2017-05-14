* ============================================================================;
* Clean Form 38 - Daily Life
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename psysoc "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Psychosocial\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F38VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit"
		5="6 week HRT/4 week CaD call"
		6="Diet Intervention"
		7="Interim 33/33D"
		8="Amendment 33/33D";

	VALUE F38VCLOF
		0="No"
		1="Yes";

	VALUE F38EXPCF
		0="No"
		1="Yes";

	VALUE LIFEQUALF
		0="Worst"
		1="1"
		2="2"
		3="3"
		4="4"
		5="Halfway"
		6="6"
		7="7"
		8="8"
		9="9"
		10="Best";

	VALUE SATLIFEF
		0="Dissatisfied"
		1="1"
		2="2"
		3="3"
		4="4"
		5="Halfway"
		6="6"
		7="7"
		8="8"
		9="9"
		10="Satisfied";

	VALUE GENHELF
		1="Excellent"
		2="Very good"
		3="Good"
		4="Fair"
		5="Poor";

	VALUE HLTHC1YF
		1="Much better now than 1 year ago"
		2="Somewhat better now than 1 year ago"
		3="About the same time"
		4="Somewhat worse now than 1 year ago"
		5="Much worse than 1 year ago";

	VALUE VIGACTF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE MODACTF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE LIFTGROCF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE STAIRSF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE STAIRF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE BENDINGF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE WALK1MF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE WALKBLKSF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE WALK1BLKF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE BATHINGF
		1="Yes, limited a lot"
		2="Yes, limited a little"
		3="No, not limited at all";

	VALUE INTSOCF
		1="Not at all"
		2="Slightly"
		3="Moderately"
		4="Quite a bit"
		5="Extremely";

	VALUE BODPAINF
		0="None"
		2="Very mild"
		3="Mild"
		4="Moderate"
		5="Severe";

	VALUE PAININTF
		1="Not at all"
		2="A little bit"
		3="Moderately"
		4="Quite a bit"
		5="Extremely";

	VALUE LESSWRKPF
		0="No"
		1="Yes";

	VALUE LESSACCPF
		0="No"
		1="Yes";

	VALUE LESSKNDPF
		0="No"
		1="Yes";

	VALUE WRKDIFFPF
		0="No"
		1="Yes";

	VALUE LESSWRKEF
		0="No"
		1="Yes";

	VALUE LESSACCEF
		0="No"
		1="Yes";

	VALUE LESSCAREF
		0="No"
		1="Yes";

	VALUE SICKEASYF
		1="Definitely true"
		2="Mostly true"
		3="Not sure"
		4="Mostly false"
		5="Definitely false";

	VALUE HLTHYANYF
		1="Definitely true"
		2="Mostly true"
		3="Not sure"
		4="Mostly false"
		5="Definitely false";

	VALUE HLTHWORSF
		1="Definitely true"
		2="Mostly true"
		3="Not sure"
		4="Mostly false"
		5="Definitely false";

	VALUE HLTHEXCLF
		1="Definitely true"
		2="Mostly true"
		3="Not sure"
		4="Mostly false"
		5="Definitely false";

	VALUE INTSOC2F
		1="All of the time"
		2="Most of the time"
		3="Some of the time"
		4="A little bit of the time"
		5="None of the time";

	VALUE FULLPEPF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE NERVOUSF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE DWNDUMPSF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE CALMF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE ENERGYF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE FELTBLUEF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE WORNOUTF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE HAPPYF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE TIREDF
		1="All of the time"
		2="Most of the time"
		3="A good bit of the time"
		4="Some of the time"
		5="A little bit of the time"
		6="None of the time";

	VALUE EATF
		1="Without help (can feed self completely)"
		2="With some help (help cutting, etc.)"
		3="Completely unable to feed self";

	VALUE DRESSF
		1="Without help (can pick clothes, dress)"
		2="With some help"
		3="Unable to dress and undress self";

	VALUE INOUTBEDF
		1="Without any help or aids"
		2="With some help (from a person or device)"
		3="Totally dependent on someone else";

	VALUE SHOWERF
		1="Without help"
		2="With some help (help in/out, tub attach)"
		3="Completely unable to bathe self";

	VALUE BLOATINGF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE CONSTIPF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE NIGHTSWTF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE ACHESF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE BRSTTENF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HOTFLASHF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE DIARRHEAF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE MOODSWNGF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE NAUSEAF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE DIZZYF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE TIRED2F
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE FORGETF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HUNGRYF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HEARTRACF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE TREMORSF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HEARTBRNF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE RESTLESSF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE LOWBACKPF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE NECKPAINF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE SKINDRYF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HEADACHEF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE CLUMSYF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE TRBSEEF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE VAGITCHF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE CONCENF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE JNTPAINF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE NOHUNGERF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE HEARLOSSF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE SWELLHNDF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE VAGDRYF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE UPSTOMF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE URINPAINF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE COUGHF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE VAGDISF
		0="Symptom did not occur"
		1="Symptom was mild"
		2="Symptom was moderate"
		3="Symptom was severe";

	VALUE SPOUSDIEF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE SPOUSILLF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE FRIENDIEF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE MONPROBF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE DIVORCEF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE FRNDIVF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE CHILCONF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE MAJACCF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE FRNJOBF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE PHYABF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE VERBABF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE PETDIEF
		0="No"
		1="Yes and upset me: Not too much"
		2="Yes and upset me: Moderately"
		3="Yes and upset me: Very much";

	VALUE FELTDEPF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE RESTSLPF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE ENJLIFF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE CRYSPELLF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE FELTSADF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE PEOPDISF
		0="Rarely or none of the time"
		1="Some or a little of the time"
		2="Occasionally or a moderate amount"
		3="Most or all of the time";

	VALUE SAD2WKF
		0="No"
		1="Yes";

	VALUE SAD2YRSF
		0="No"
		1="Yes";

	VALUE SADMUCHF
		0="No"
		1="Yes";

	VALUE MEDSLEEPF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE FALLSLPF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE NAPF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE TRBSLEEPF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE WAKENGHTF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE UPEARLYF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE BACKSLPF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week";

	VALUE SNOREF
		1="No, not in past 4 weeks"
		2="Yes, less than once a week"
		3="Yes 1 or 2 times a week"
		4="Yes, 3 or 4 times a week"
		5="Yes, 5 or more times a week"
		9="Don't know";

	VALUE QUALSLPF
		1="Very restless"
		2="Restless"
		3="Average quality"
		4="Sound or restful"
		5="Very sound or restful";

	VALUE HRSSLPF
		1="5 or less hours"
		2="6 hours"
		3="7 hours"
		4="8 hours"
		5="9 hours"
		6="10 or more hours";

	VALUE INCONTF
		0="No"
		1="Yes";

	VALUE FRQINCONF
		1="Not once during past year"
		2="Less than once a month"
		3="More than once a month"
		4="One or more times a week"
		5="Daily";

	VALUE NOINCONF
		0="No"
		1="Yes";

	VALUE CGHINCONF
		0="No"
		1="Yes";

	VALUE TOINCONF
		0="No"
		1="Yes";

	VALUE SLPINCONF
		0="No"
		1="Yes";

	VALUE OTHINCONF
		0="No"
		1="Yes";

	VALUE LEAKAMTF
		1="None"
		2="Barely noticeable on underpants"
		3="Soaked underpants"
		4="Soaked through to outer clothing";

	VALUE NOPRTCTF
		0="No"
		1="Yes";

	VALUE MINIPADF
		0="No"
		1="Yes";

	VALUE MENSPADF
		0="No"
		1="Yes";

	VALUE DIAPERF
		0="No"
		1="Yes";

	VALUE OTHPRTCTF
		0="No"
		1="Yes";

	VALUE INCONLMTF
		1="Never"
		2="Almost never"
		3="Sometimes"
		4="Fairly often"
		5="Very often";

	VALUE INCONDISF
		1="Not at all disturbing"
		2="A little disturbing"
		3="Somewhat disturbing"
		4="Very disturbing"
		5="Extremely disturbing";

	VALUE MARRIEDF
		0="No"
		1="Yes";

	VALUE SEXACTIVF
		0="No"
		1="Yes"
		9="Don't want to answer";

	VALUE SATSEXF
		1="Very unsatisfied"
		2="A little unsatisfied"
		3="Somewhat satisfied"
		4="Very satisfied"
		9="Don't want to answer";

	VALUE SATFRQSXF
		1="Less often"
		2="Satisfied with current frequency"
		3="More often"
		9="Don't want to answer";

	VALUE SEXWORRYF
		1="Not at all worried"
		2="A little worried"
		3="Somewhat worried"
		4="Very worried"
		9="Don't want to answer";

RUN;


* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f38_ctos_fu_inv;
  INFILE psysoc(f38_ctos_fu_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F38DAYS F38VTYP F38VY F38VCLO F38EXPC LIFEQUAL SATLIFE GENHEL HLTHC1Y 
        VIGACT MODACT LIFTGROC STAIRS STAIR BENDING WALK1M WALKBLKS WALK1BLK BATHING 
        INTSOC BODPAIN PAININT LESSWRKP LESSACCP LESSKNDP WRKDIFFP LESSWRKE LESSACCE LESSCARE 
        SICKEASY HLTHYANY HLTHWORS HLTHEXCL INTSOC2 FULLPEP NERVOUS DWNDUMPS CALM ENERGY 
        FELTBLUE WORNOUT HAPPY TIRED EAT DRESS INOUTBED SHOWER BLOATING CONSTIP 
        NIGHTSWT ACHES BRSTTEN HOTFLASH DIARRHEA MOODSWNG NAUSEA DIZZY TIRED2 FORGET 
        HUNGRY HEARTRAC TREMORS HEARTBRN RESTLESS LOWBACKP NECKPAIN SKINDRY HEADACHE CLUMSY 
        TRBSEE VAGITCH CONCEN JNTPAIN NOHUNGER HEARLOSS SWELLHND VAGDRY UPSTOM URINPAIN 
        COUGH VAGDIS SPOUSDIE SPOUSILL FRIENDIE MONPROB DIVORCE FRNDIV CHILCON MAJACC 
        FRNJOB PHYAB VERBAB PETDIE FELTDEP RESTSLP ENJLIF CRYSPELL FELTSAD PEOPDIS 
        SAD2WK SAD2YRS SADMUCH MEDSLEEP FALLSLP NAP TRBSLEEP WAKENGHT UPEARLY BACKSLP 
        SNORE QUALSLP HRSSLP INCONT FRQINCON NOINCON CGHINCON TOINCON SLPINCON OTHINCON 
        LEAKAMT NOPRTCT MINIPAD MENSPAD DIAPER OTHPRTCT INCONLMT INCONDIS MARRIED SEXACTIV 
        SATSEX SATFRQSX SEXWORRY ACTDLY EMOLIMIT EMOWELL ENERFAT GENHLTH LFEVENT1 LFEVENT2 
        PAIN PHYLIMIT PHYSFUN PSHTDEP SLPDSTRB SOCFUNC SYMPTOM  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F38DAYS= "F38 Days since randomization/enrollment"
		F38VTYP= "Visit Type"
		F38VY= "Visit year"
		F38VCLO= "Closest to visit within visit type and year"
		F38EXPC= "Expected for visit"
		LIFEQUAL= "Rate quality of life"
		SATLIFE= "How satisfied with quality of life"
		GENHEL= "In general, health is"
		HLTHC1Y= "Compare health to 1 year ago"
		VIGACT= "Vigorous activities"
		MODACT= "Moderate activites"
		LIFTGROC= "Lifting or carrying groceries"
		STAIRS= "Climbing several flights of stairs"
		STAIR= "Climbing one flight of stairs"
		BENDING= "Bending, kneeling, stooping"
		WALK1M= "Walking more than one mile"
		WALKBLKS= "Walking several blocks"
		WALK1BLK= "Walking one block"
		BATHING= "Bathing or dressing yourself"
		INTSOC= "Extent phys or emotional probs interfere"
		BODPAIN= "How much bodily pain"
		PAININT= "How much did pain interfere"
		LESSWRKP= "Physical/Cut down on time spent"
		LESSACCP= "Physical/Accomplished less"
		LESSKNDP= "Physical/Limited kind of work"
		WRKDIFFP= "Physical/Difficulty performing work"
		LESSWRKE= "Emotional/Cut down on time spent"
		LESSACCE= "Emotional/Accomplished less"
		LESSCARE= "Emotional/Worked less carefully"
		SICKEASY= "I get sick easier than others"
		HLTHYANY= "I am as healthy as anybody"
		HLTHWORS= "I expect my health to get worse"
		HLTHEXCL= "My health is excellent"
		INTSOC2= "Time physical/emotional probs interfere"
		FULLPEP= "Did you feel full of pep"
		NERVOUS= "Have you been a very nervous person"
		DWNDUMPS= "Felt down in the dumps"
		CALM= "Felt calm and peaceful"
		ENERGY= "Did you have a lot of energy"
		FELTBLUE= "Felt downhearted and blue"
		WORNOUT= "Did you feel worn out"
		HAPPY= "Have you been happy"
		TIRED= "Did you feel tired"
		EAT= "Can you eat"
		DRESS= "Can you dress and undress self"
		INOUTBED= "Can you get in and out of bed"
		SHOWER= "Can you take a bath or shower"
		BLOATING= "Bloating or gas"
		CONSTIP= "Constipation"
		NIGHTSWT= "Night sweats"
		ACHES= "General aches or pains"
		BRSTTEN= "Breast tenderness"
		HOTFLASH= "Hot flashes"
		DIARRHEA= "Diarrhea"
		MOODSWNG= "Mood swings"
		NAUSEA= "Nausea"
		DIZZY= "Dizziness"
		TIRED2= "Feeling tired"
		FORGET= "Forgetfulness"
		HUNGRY= "Increase appetite"
		HEARTRAC= "Heart racing or skipping beats"
		TREMORS= "Tremors"
		HEARTBRN= "Heartburn"
		RESTLESS= "Restless and fidgety"
		LOWBACKP= "Low back pain"
		NECKPAIN= "Neck pain"
		SKINDRY= "Skin dryness or scaling"
		HEADACHE= "Headaches or migraines"
		CLUMSY= "Clumsiness"
		TRBSEE= "Trouble with vision"
		VAGITCH= "Vaginal or genital irritation"
		CONCEN= "Difficulty concentrating"
		JNTPAIN= "Joint pain or stiffness"
		NOHUNGER= "Decreased appetite"
		HEARLOSS= "Hearing loss"
		SWELLHND= "Swelling of hands or feet"
		VAGDRY= "Vaginal or genital dryness"
		UPSTOM= "Upset stomach or belly pain"
		URINPAIN= "Pain or burning while urinating"
		COUGH= "Coughing or wheezing"
		VAGDIS= "Vaginal or genital discharge"
		SPOUSDIE= "Did your spouse or partner die"
		SPOUSILL= "Did your spouse have a serious illness"
		FRIENDIE= "Did a close friend die"
		MONPROB= "Have major problems with money"
		DIVORCE= "Have a divorce or break-up"
		FRNDIV= "Close friend/family have a divorce"
		CHILCON= "Have major conflict with children"
		MAJACC= "Have a major accident or disaster"
		FRNJOB= "You, family, friend lose job or retire"
		PHYAB= "Were you physically abused"
		VERBAB= "Were you verbally abused"
		PETDIE= "Did a pet die"
		FELTDEP= "You felt depressed"
		RESTSLP= "Your sleep was restless"
		ENJLIF= "You enjoyed life"
		CRYSPELL= "You had crying spells"
		FELTSAD= "You felt sad"
		PEOPDIS= "You felt people disliked you"
		SAD2WK= "Felt sad for two weeks or more"
		SAD2YRS= "Felt sad for two or more years"
		SADMUCH= "Felt sad much of past year"
		MEDSLEEP= "Did you take medication for sleep"
		FALLSLP= "Fall asleep during quiet activity"
		NAP= "Did you nap during the day"
		TRBSLEEP= "Did you have trouble failling asleep"
		WAKENGHT= "Did you wake up several times"
		UPEARLY= "Did you wake up earlier than planned"
		BACKSLP= "Have trouble getting back to sleep"
		SNORE= "Did you snore"
		QUALSLP= "Typical night's sleep"
		HRSSLP= "How many hours of sleep"
		INCONT= "Ever leaked urine"
		FRQINCON= "How often leaked urine"
		NOINCON= "No longer leak urine"
		CGHINCON= "Leak urine when cough, laugh"
		TOINCON= "Leak urine when can't get to toilet"
		SLPINCON= "Leak urine when I am sleeping"
		OTHINCON= "When leak urine, Other"
		LEAKAMT= "How much urine do you lose"
		NOPRTCT= "Leak Protect/No protection"
		MINIPAD= "Leak Protect/Mini-pad, tissue"
		MENSPAD= "Leak Protecti/Menstrual pad"
		DIAPER= "Leak Protect/Diaper, Attends"
		OTHPRTCT= "Leak Protect/Other"
		INCONLMT= "How often does leakage limit activities"
		INCONDIS= "How much does leakage bother"
		MARRIED= "Currently married or intimate"
		SEXACTIV= "Sexual activity in last year"
		SATSEX= "How satisfied sexually"
		SATFRQSX= "Satisfied with sex frequency"
		SEXWORRY= "Worried sex activity will affect healh"
		ACTDLY= "Activities of Daily Living Construct"
		EMOLIMIT= "Role limitation due to emotional problem"
		EMOWELL= "Emotional well-being"
		ENERFAT= "Energy/fatigue"
		GENHLTH= "General health construct"
		LFEVENT1= "Life event construct #1 (0,1 scoring)"
		LFEVENT2= "Life event construct #2 (0-3 scoring)"
		PAIN= "Pain construct"
		PHYLIMIT= "Role limitations due to physical health"
		PHYSFUN= "Physical functioning construct"
		PSHTDEP= "Shortened CES-D/DIS screening instrument"
		SLPDSTRB= "Sleep disturbance construct"
		SOCFUNC= "Social functioning"
		SYMPTOM= "Symptom construct";

  FORMAT	F38VTYP F38VTYPF. F38VCLO F38VCLOF. F38EXPC F38EXPCF. LIFEQUAL LIFEQUALF. SATLIFE SATLIFEF. GENHEL GENHELF. 
	HLTHC1Y HLTHC1YF. VIGACT VIGACTF. MODACT MODACTF. LIFTGROC LIFTGROCF. STAIRS STAIRSF. 
	STAIR STAIRF. BENDING BENDINGF. WALK1M WALK1MF. WALKBLKS WALKBLKSF. WALK1BLK WALK1BLKF. 
	BATHING BATHINGF. INTSOC INTSOCF. BODPAIN BODPAINF. PAININT PAININTF. LESSWRKP LESSWRKPF. 
	LESSACCP LESSACCPF. LESSKNDP LESSKNDPF. WRKDIFFP WRKDIFFPF. LESSWRKE LESSWRKEF. LESSACCE LESSACCEF. 
	LESSCARE LESSCAREF. SICKEASY SICKEASYF. HLTHYANY HLTHYANYF. HLTHWORS HLTHWORSF. HLTHEXCL HLTHEXCLF. 
	INTSOC2 INTSOC2F. FULLPEP FULLPEPF. NERVOUS NERVOUSF. DWNDUMPS DWNDUMPSF. CALM CALMF. 
	ENERGY ENERGYF. FELTBLUE FELTBLUEF. WORNOUT WORNOUTF. HAPPY HAPPYF. TIRED TIREDF. 
	EAT EATF. DRESS DRESSF. INOUTBED INOUTBEDF. SHOWER SHOWERF. BLOATING BLOATINGF. 
	CONSTIP CONSTIPF. NIGHTSWT NIGHTSWTF. ACHES ACHESF. BRSTTEN BRSTTENF. HOTFLASH HOTFLASHF. 
	DIARRHEA DIARRHEAF. MOODSWNG MOODSWNGF. NAUSEA NAUSEAF. DIZZY DIZZYF. TIRED2 TIRED2F. 
	FORGET FORGETF. HUNGRY HUNGRYF. HEARTRAC HEARTRACF. TREMORS TREMORSF. HEARTBRN HEARTBRNF. 
	RESTLESS RESTLESSF. LOWBACKP LOWBACKPF. NECKPAIN NECKPAINF. SKINDRY SKINDRYF. HEADACHE HEADACHEF. 
	CLUMSY CLUMSYF. TRBSEE TRBSEEF. VAGITCH VAGITCHF. CONCEN CONCENF. JNTPAIN JNTPAINF. 
	NOHUNGER NOHUNGERF. HEARLOSS HEARLOSSF. SWELLHND SWELLHNDF. VAGDRY VAGDRYF. UPSTOM UPSTOMF. 
	URINPAIN URINPAINF. COUGH COUGHF. VAGDIS VAGDISF. SPOUSDIE SPOUSDIEF. SPOUSILL SPOUSILLF. 
	FRIENDIE FRIENDIEF. MONPROB MONPROBF. DIVORCE DIVORCEF. FRNDIV FRNDIVF. CHILCON CHILCONF. 
	MAJACC MAJACCF. FRNJOB FRNJOBF. PHYAB PHYABF. VERBAB VERBABF. PETDIE PETDIEF. 
	FELTDEP FELTDEPF. RESTSLP RESTSLPF. ENJLIF ENJLIFF. CRYSPELL CRYSPELLF. FELTSAD FELTSADF. 
	PEOPDIS PEOPDISF. SAD2WK SAD2WKF. SAD2YRS SAD2YRSF. SADMUCH SADMUCHF. MEDSLEEP MEDSLEEPF. 
	FALLSLP FALLSLPF. NAP NAPF. TRBSLEEP TRBSLEEPF. WAKENGHT WAKENGHTF. UPEARLY UPEARLYF. 
	BACKSLP BACKSLPF. SNORE SNOREF. QUALSLP QUALSLPF. HRSSLP HRSSLPF. INCONT INCONTF. 
	FRQINCON FRQINCONF. NOINCON NOINCONF. CGHINCON CGHINCONF. TOINCON TOINCONF. SLPINCON SLPINCONF. 
	OTHINCON OTHINCONF. LEAKAMT LEAKAMTF. NOPRTCT NOPRTCTF. MINIPAD MINIPADF. MENSPAD MENSPADF. 
	DIAPER DIAPERF. OTHPRTCT OTHPRTCTF. INCONLMT INCONLMTF. INCONDIS INCONDISF. MARRIED MARRIEDF. 
	SEXACTIV SEXACTIVF. SATSEX SATSEXF. SATFRQSX SATFRQSXF. SEXWORRY SEXWORRYF. ;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f38;
	format id days;
	set whisf.f38_ctos_fu_inv;	

	* Create time (days) variable;
	rename f38days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f38;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* There are duplicates - need to take fix them;

* fvclo: For forms entered with the same visit type and year, indicates the 
* one closest to that visit's target date. Valid for forms entered with an 
* annual visit type. 0 = NO 1 = Yes;

* fexpc: This form/data was expected for this visit;

proc sql number;
	select id, days, f38vclo, f38expc, count(*) as dups
		from whisf.f38
		group by id, days
		having calculated dups >= 2;
		* There are 12 rows with duplicate id/days;
quit;

* Just want to keep the first observation for each set of dups;
proc contents data = whisf.f38;
	ods select attributes;
run;
* 156,061 observations;

* Order them Yes, No, Yes, No so that when there is a yes and a no, yes's are
* kept;
proc sort data = whisf.f38;
	by id days descending f38vclo;
run;

proc sort data = whisf.f38
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f38;
	ods select attributes;
run;
* 156,055 observations - expected number;

* Double check that yes's were kept;
proc sql;
	select id, days, f38vclo, f38expc
		from whisf.f38
		where (id = 142843 & days = 3298) | (id = 149615 & days = 2265);
quit;
* Good;

