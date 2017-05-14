* ============================================================================;
* Clean Form 37 - Thoughts and Feelings
* 2017-03-04
* ============================================================================;

* Setup libraries;
filename psysoc "C:\Users\mbc0022\Dropbox\WHI Data\1. From WHI Website\
All WHI Datasets\Psychosocial\data";

libname whisf "C:\Users\mbc0022\Dropbox\Research\WHI\MS3226 - Sexual function\
whiSexualFunction\data";

options fmtsearch = (whisf);

PROC FORMAT library = whisf;

	VALUE F37VTYPF
		1="Screening"
		2="Semi-Annual visit"
		3="Annual visit"
		4="Non-Routine visit";

	VALUE F37VCLOF
		0="No"
		1="Yes";

	VALUE F37EXPCF
		0="No"
		1="Yes";

	VALUE LISTENF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE GOODADVCF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE TAKEDRF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE GOODTIMEF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE HLPPROBF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE HLPCHORSF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE SHAREF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE FUNF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE LOVEF
		1="None of the time"
		2="A little of the time"
		3="Some of the time"
		4="Most of the time"
		5="All of the time";

	VALUE LIVALNF
		0="No"
		1="Yes";

	VALUE LIVPRTF
		0="No"
		1="Yes";

	VALUE LIVCHLDF
		0="No"
		1="Yes";

	VALUE LIVSIBLF
		0="No"
		1="Yes";

	VALUE LIVRELF
		0="No"
		1="Yes";

	VALUE LIVFRNDSF
		0="No"
		1="Yes";

	VALUE LIVOTHF
		0="No"
		1="Yes";

	VALUE PETF
		0="No"
		1="Yes";

	VALUE DOGF
		0="No"
		1="Yes";

	VALUE CATF
		0="No"
		1="Yes";

	VALUE BIRDF
		0="No"
		1="Yes";

	VALUE FISHF
		0="No"
		1="Yes";

	VALUE OTHPETF
		0="No"
		1="Yes";

	VALUE RELGTIMEF
		1="Not at all in the past month"
		2="Once in the past month"
		3="2 or 3 times in the past month"
		4="Once a week"
		5="2 or 6 times a week"
		6="Every day";

	VALUE RELSTRNF
		1="None"
		2="A little"
		3="A great deal";

	VALUE CLUBF
		1="Not at all in the past month"
		2="Once in the past month"
		3="2 or 3 times in the past month"
		4="Once a week"
		5="2 or 6 times a week"
		6="Every day";

	VALUE HLPSICKF
		0="No"
		1="Yes";

	VALUE HLPSICKTF
		1="Less than once a week"
		2="1-2 times a week"
		3="3-4 times a week"
		4="5 or more times a week";

	VALUE NERVESF
		1="None"
		2="One"
		3="Some"
		4="Most"
		5="All";

	VALUE TOOMUCHF
		1="None"
		2="One"
		3="Some"
		4="Most"
		5="All";

	VALUE EXCLUDEF
		1="None"
		2="One"
		3="Some"
		4="Most"
		5="All";

	VALUE COERCEF
		1="None"
		2="One"
		3="Some"
		4="Most"
		5="All";

	VALUE EXPCTBSTF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE WRONGF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE HOPEFULF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE NOTMYWAYF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE COUNTGDF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE MOREGOODF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE KNWANGRYF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE TELLFEELF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE DISAPPNTF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE SCENEPUBF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE BOTHERF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE SUPPRESSF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE APPRVNEGF
		1="Strongly disagree"
		2="Disagree"
		3="Neutral (In-between)"
		4="Agree"
		5="Strongly agree";

	VALUE ORDERSF
		0="False"
		1="True";

	VALUE BADLUCKF
		0="False"
		1="True";

	VALUE TRUTHF
		0="False"
		1="True";

	VALUE LIEF
		0="False"
		1="True";

	VALUE HONESTF
		0="False"
		1="True";

	VALUE UNFAIRF
		0="False"
		1="True";

	VALUE NOCAREF
		0="False"
		1="True";

	VALUE TRUSTNOF
		0="False"
		1="True";

	VALUE FRNDSUSEF
		0="False"
		1="True";

	VALUE NOHELPF
		0="False"
		1="True";

	VALUE EXPERTSF
		0="False"
		1="True";

	VALUE RESPECTF
		0="False"
		1="True";

	VALUE BADSEXF
		0="False"
		1="True";

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

	VALUE WELBEINGF
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
		3="Totally dependent to person to lift self";

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

	VALUE ANXIOUSF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE RESTLSITF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE TIREEASYF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE MSCLACHEF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE STAYSLPF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE NOCONCENF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE ANNOYEDF
		0="Not at all"
		1="Several days"
		2="More than half the days";

	VALUE PANICF
		0="Not at all"
		1="Several days"
		2="More than half the days";

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

	VALUE SEXF
		1="Have never had sex"
		2="Sex with a woman or with women"
		3="Sex with a man or with men"
		4="Sex with both men and women"
		9="Prefer not to answer";

	VALUE SEX45F
		0="Never had sex"
		1="Sex with a women or with women"
		2="Sex with a man or with men"
		3="Sex with both men and women";

	VALUE CAREGIV1F
		0="No"
		1="Yes";

	VALUE CAREGIV2F
		0="No"
		1="Less than once a week"
		2="1-2 times a week"
		3="3-4 times a week"
		4="5 or more times a week";

	VALUE LIVALORF
		0="No"
		1="Yes";

RUN;

* ============================================================================;
* Read-in data
* ============================================================================;
DATA whisf.f37_ctos_inv;
  INFILE psysoc(f37_ctos_inv.dat) LRECL = 4096 FIRSTOBS = 2 DSD DELIMITER = '09'x;
  INPUT ID F37DAYS F37VTYP F37VY F37VCLO F37EXPC LISTEN GOODADVC TAKEDR GOODTIME 
        HLPPROB HLPCHORS SHARE FUN LOVE LIVALN LIVPRT LIVCHLD LIVSIBL LIVREL 
        LIVFRNDS LIVOTH PET DOG CAT BIRD FISH OTHPET RELGTIME RELSTRN 
        CLUB HLPSICK HLPSICKT NERVES TOOMUCH EXCLUDE COERCE EXPCTBST WRONG HOPEFUL 
        NOTMYWAY COUNTGD MOREGOOD KNWANGRY TELLFEEL DISAPPNT SCENEPUB BOTHER SUPPRESS APPRVNEG 
        ORDERS BADLUCK TRUTH LIE HONEST UNFAIR NOCARE TRUSTNO FRNDSUSE NOHELP 
        EXPERTS RESPECT BADSEX LIFEQUAL SATLIFE WELBEING GENHEL HLTHC1Y VIGACT MODACT 
        LIFTGROC STAIRS STAIR BENDING WALK1M WALKBLKS WALK1BLK BATHING INTSOC BODPAIN 
        PAININT LESSWRKP LESSACCP LESSKNDP WRKDIFFP LESSWRKE LESSACCE LESSCARE SICKEASY HLTHYANY 
        HLTHWORS HLTHEXCL INTSOC2 FULLPEP NERVOUS DWNDUMPS CALM ENERGY FELTBLUE WORNOUT 
        HAPPY TIRED EAT DRESS INOUTBED SHOWER BLOATING CONSTIP NIGHTSWT ACHES 
        BRSTTEN HOTFLASH DIARRHEA MOODSWNG NAUSEA DIZZY TIRED2 FORGET HUNGRY HEARTRAC 
        TREMORS HEARTBRN RESTLESS LOWBACKP NECKPAIN SKINDRY HEADACHE CLUMSY TRBSEE VAGITCH 
        CONCEN JNTPAIN NOHUNGER HEARLOSS SWELLHND VAGDRY UPSTOM URINPAIN COUGH VAGDIS 
        ANXIOUS RESTLSIT TIREEASY MSCLACHE STAYSLP NOCONCEN ANNOYED PANIC SPOUSDIE SPOUSILL 
        FRIENDIE MONPROB DIVORCE FRNDIV CHILCON MAJACC FRNJOB PHYAB VERBAB PETDIE 
        FELTDEP RESTSLP ENJLIF CRYSPELL FELTSAD PEOPDIS SAD2WK SAD2YRS SADMUCH MEDSLEEP 
        FALLSLP NAP TRBSLEEP WAKENGHT UPEARLY BACKSLP SNORE QUALSLP HRSSLP INCONT 
        FRQINCON NOINCON CGHINCON TOINCON SLPINCON OTHINCON LEAKAMT NOPRTCT MINIPAD MENSPAD 
        DIAPER OTHPRTCT INCONLMT INCONDIS MARRIED SEXACTIV SATSEX SATFRQSX SEXWORRY SEX 
        SEX45 ACTDLY AMBEMOT CAREGIV1 CAREGIV2 EMOLIMIT EMOWELL ENERFAT HOSTIL GENHLTH 
        LFEVENT1 LFEVENT2 LIVALOR NEGEMOT OPTIMISM PAIN PHYLIMIT PHYSFUN PSHTDEP SLPDSTRB 
        SOCFUNC SOCSTRN SOCSUPP SYMPTOM  ;


  LABEL 
		ID= "WHI Participant Common ID"
		F37DAYS= "F37 Days since randomization/enrollment"
		F37VTYP= "Visit Type"
		F37VY= "Visit year"
		F37VCLO= "Closest to visit within visit type and year"
		F37EXPC= "Expected for visit"
		LISTEN= "Someone to listen when need to talk"
		GOODADVC= "Someone to give good advice"
		TAKEDR= "Someone can take to the doctor"
		GOODTIME= "Someone to have a good time with"
		HLPPROB= "Someone to help understand a problem"
		HLPCHORS= "Someone to help with daily chores"
		SHARE= "Someone to share private worries/fears"
		FUN= "Someone to do something fun with"
		LOVE= "Someone to love you/make you feel wanted"
		LIVALN= "Live alone"
		LIVPRT= "Live with husband/partner"
		LIVCHLD= "Live with children"
		LIVSIBL= "Live with brother/sister"
		LIVREL= "Live with relatives"
		LIVFRNDS= "Live with friends"
		LIVOTH= "Live with other than listed"
		PET= "Have a pet"
		DOG= "Dog"
		CAT= "Cat"
		BIRD= "Bird"
		FISH= "Fish"
		OTHPET= "Other pet"
		RELGTIME= "Times attend religious service/church"
		RELSTRN= "Religion gives strength and comfort"
		CLUB= "Attend clubs/lodges/groups last month"
		HLPSICK= "Helping sick family/friend"
		HLPSICKT= "Times helped sick family/friend"
		NERVES= "Number of people who get on nerves"
		TOOMUCH= "Number of people who ask too much"
		EXCLUDE= "Number of people who exclude you"
		COERCE= "Number of people who try to coerce"
		EXPCTBST= "Usually expect the best"
		WRONG= "Expect something that can will go wrong"
		HOPEFUL= "Always hopeful about future"
		NOTMYWAY= "Hardly ever expect things to go my way"
		COUNTGD= "Rarely count on good things happening"
		MOREGOOD= "Expect more good things than bad"
		KNWANGRY= "Usually people around know when angry"
		TELLFEEL= "Tell from facial expressions how feeling"
		DISAPPNT= "Express disappointment"
		SCENEPUB= "If angered, cause scene in public place"
		BOTHER= "After anger bothered for a long time"
		SUPPRESS= "Usually suppress anger"
		APPRVNEG= "Fear others will not approve if negative"
		ORDERS= "Take orders from someone who knew less"
		BADLUCK= "Think people make bad luck for sympathy"
		TRUTH= "Argue to convince people of truth"
		LIE= "Most people would lie to get ahead"
		HONEST= "Most people are honest due to fear"
		UNFAIR= "Most people are unfair to gain profit"
		NOCARE= "No one cares what happens to you"
		TRUSTNO= "Safer to trust nobody"
		FRNDSUSE= "Make friends because friends are useful"
		NOHELP= "People inwardly don't like to help"
		EXPERTS= "Experts often no better than I"
		RESPECT= "People demand more respect than give"
		BADSEX= "People guilty of bad sexual behavior"
		LIFEQUAL= "Rate quality of life"
		SATLIFE= "Satisfied with quality of life"
		WELBEING= "Rate current sense of well-being"
		GENHEL= "In general, health is"
		HLTHC1Y= "Compare health to 1 year ago"
		VIGACT= "Vigorous activities"
		MODACT= "Moderate activities"
		LIFTGROC= "Lifting or carrying groceries"
		STAIRS= "Climbing several flights"
		STAIR= "Climbing one flight of stairs"
		BENDING= "Bending, kneeling, stooping"
		WALK1M= "Walking more than one mile"
		WALKBLKS= "Walking several blocks"
		WALK1BLK= "Walking one block"
		BATHING= "Bathing or dressing yourself"
		INTSOC= "Phys or emotional probs interfere"
		BODPAIN= "How much body pain"
		PAININT= "How much did pain interfere"
		LESSWRKP= "Phys/cut down on time spent"
		LESSACCP= "Phys/Accomplished less"
		LESSKNDP= "Phys/limited kind of work"
		WRKDIFFP= "Phys/difficulty perform work"
		LESSWRKE= "Emot/cut down on time spent"
		LESSACCE= "Emot/Accomplished less"
		LESSCARE= "Emot/Worked less carefully"
		SICKEASY= "I get sick easier"
		HLTHYANY= "I am as healthy as anybody"
		HLTHWORS= "I expect health to get worse"
		HLTHEXCL= "My health is excellent"
		INTSOC2= "Physical or emotional problem"
		FULLPEP= "Did you feel full of pep"
		NERVOUS= "Have you been a very nervous person"
		DWNDUMPS= "Felt down in dumps"
		CALM= "Felt calm and peaceful"
		ENERGY= "Had lots of energy"
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
		ACHES= "General aches and pains"
		BRSTTEN= "Breast tenderness"
		HOTFLASH= "Hot flashes"
		DIARRHEA= "Diarrhea"
		MOODSWNG= "Mood swings"
		NAUSEA= "Nausea"
		DIZZY= "Dizziness"
		TIRED2= "Feeling tired"
		FORGET= "Forgetfulness"
		HUNGRY= "Increased appetite"
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
		URINPAIN= "Pain/burning while urinating"
		COUGH= "Coughing or wheezing"
		VAGDIS= "Vaginal or genital discharge"
		ANXIOUS= "Feeling nervous, anxious, on edge"
		RESTLSIT= "Feeling restless so hard to sit still"
		TIREEASY= "Getting tired very easily"
		MSCLACHE= "Muscle tension aches or soreness"
		STAYSLP= "Trouble falling asleep or staying asleep"
		NOCONCEN= "Trouble concentrating on things, reading"
		ANNOYED= "Becoming easily annoyed or irritable"
		PANIC= "Having an anxiety attack -- feel fear or panic"
		SPOUSDIE= "Did your spouse die"
		SPOUSILL= "Did your spouse have a serious illness"
		FRIENDIE= "Did a close friend die"
		MONPROB= "Major problems with money"
		DIVORCE= "Have a divorce or break-up"
		FRNDIV= "Close friend had a divorce"
		CHILCON= "Major conflict with children"
		MAJACC= "Major accident or disaster"
		FRNJOB= "Close friend lost job"
		PHYAB= "You were physically abused"
		VERBAB= "You were verbally abused"
		PETDIE= "Did a pet die"
		FELTDEP= "You felt depressed"
		RESTSLP= "Your sleep was restless"
		ENJLIF= "You enjoyed life"
		CRYSPELL= "You had crying spells"
		FELTSAD= "You felt sad"
		PEOPDIS= "You felt people disliked you"
		SAD2WK= "Felt sad for two weeks"
		SAD2YRS= "Felt sad two or more years"
		SADMUCH= "Felt sad much of past year"
		MEDSLEEP= "take medication for sleep"
		FALLSLP= "fall asleep during quiet activ"
		NAP= "Did you nap during the day"
		TRBSLEEP= "Did you have trouble sleeping"
		WAKENGHT= "Did you wake up several times"
		UPEARLY= "wake up earlier than planned"
		BACKSLP= "trouble getting back to sleep"
		SNORE= "Did you snore"
		QUALSLP= "Typical night's sleep"
		HRSSLP= "How many hours of sleep"
		INCONT= "Ever leaked urine"
		FRQINCON= "How often leaked urine"
		NOINCON= "No longer leak urine"
		CGHINCON= "Leak urine when cough, laugh"
		TOINCON= "Leak when can't get to toilet"
		SLPINCON= "Leak when I am sleeping"
		OTHINCON= "When leak urine, Other"
		LEAKAMT= "How much urine do you lose"
		NOPRTCT= "Leak Protect/No protection"
		MINIPAD= "Leak Protect/Mini-pad, tissue"
		MENSPAD= "Leak Protection/Menstrual pad"
		DIAPER= "Leak protect/Diaper, Attends"
		OTHPRTCT= "Leaking urine protection, Other"
		INCONLMT= "leak limit activities"
		INCONDIS= "How much does leakage bother"
		MARRIED= "Currently married or intimate"
		SEXACTIV= "Sexual activity in last year"
		SATSEX= "How satisfied sexually"
		SATFRQSX= "Satisfied with sex frequency"
		SEXWORRY= "Sexual activity affect healh"
		SEX= "Who you have had sex with"
		SEX45= "Description of adult sexual orientation"
		ACTDLY= "Activities of Daily Living Construct"
		AMBEMOT= "Ambivalence over Emotional Expressivenes"
		CAREGIV1= "Care Giving Construct #1 (0,1 scoring)"
		CAREGIV2= "Care Giving Construct #2 (0-5+ scoring)"
		EMOLIMIT= "Role Limitations Due to Emotional Problems"
		EMOWELL= "Emotional Well-being"
		ENERFAT= "Energy/Fatigue"
		HOSTIL= "Hostility Construct"
		GENHLTH= "General Health Construct"
		LFEVENT1= "Life Event Construct #1 (0,1 scoring)"
		LFEVENT2= "Life Event Construct #2 (0-3 scoring)"
		LIVALOR= "Living Alone"
		NEGEMOT= "Negative Emotional Expressiveness (NEE)"
		OPTIMISM= "Optimism Construct"
		PAIN= "Pain Construct"
		PHYLIMIT= "Role Limitations Due to Physical Health"
		PHYSFUN= "Physical Functioning Construct"
		PSHTDEP= "Shortened CES-D/DIS Screening Instrument"
		SLPDSTRB= "Sleep Disturbance Construct"
		SOCFUNC= "Social Functioning"
		SOCSTRN= "Social Strain Construct"
		SOCSUPP= "Social Support Construct"
		SYMPTOM= "Symptom Construct";

  FORMAT	F37VTYP F37VTYPF. F37VCLO F37VCLOF. F37EXPC F37EXPCF. LISTEN LISTENF. GOODADVC GOODADVCF. TAKEDR TAKEDRF. 
	GOODTIME GOODTIMEF. HLPPROB HLPPROBF. HLPCHORS HLPCHORSF. SHARE SHAREF. FUN FUNF. 
	LOVE LOVEF. LIVALN LIVALNF. LIVPRT LIVPRTF. LIVCHLD LIVCHLDF. LIVSIBL LIVSIBLF. 
	LIVREL LIVRELF. LIVFRNDS LIVFRNDSF. LIVOTH LIVOTHF. PET PETF. DOG DOGF. 
	CAT CATF. BIRD BIRDF. FISH FISHF. OTHPET OTHPETF. RELGTIME RELGTIMEF. 
	RELSTRN RELSTRNF. CLUB CLUBF. HLPSICK HLPSICKF. HLPSICKT HLPSICKTF. NERVES NERVESF. 
	TOOMUCH TOOMUCHF. EXCLUDE EXCLUDEF. COERCE COERCEF. EXPCTBST EXPCTBSTF. WRONG WRONGF. 
	HOPEFUL HOPEFULF. NOTMYWAY NOTMYWAYF. COUNTGD COUNTGDF. MOREGOOD MOREGOODF. KNWANGRY KNWANGRYF. 
	TELLFEEL TELLFEELF. DISAPPNT DISAPPNTF. SCENEPUB SCENEPUBF. BOTHER BOTHERF. SUPPRESS SUPPRESSF. 
	APPRVNEG APPRVNEGF. ORDERS ORDERSF. BADLUCK BADLUCKF. TRUTH TRUTHF. LIE LIEF. 
	HONEST HONESTF. UNFAIR UNFAIRF. NOCARE NOCAREF. TRUSTNO TRUSTNOF. FRNDSUSE FRNDSUSEF. 
	NOHELP NOHELPF. EXPERTS EXPERTSF. RESPECT RESPECTF. BADSEX BADSEXF. LIFEQUAL LIFEQUALF. 
	SATLIFE SATLIFEF. WELBEING WELBEINGF. GENHEL GENHELF. HLTHC1Y HLTHC1YF. VIGACT VIGACTF. 
	MODACT MODACTF. LIFTGROC LIFTGROCF. STAIRS STAIRSF. STAIR STAIRF. BENDING BENDINGF. 
	WALK1M WALK1MF. WALKBLKS WALKBLKSF. WALK1BLK WALK1BLKF. BATHING BATHINGF. INTSOC INTSOCF. 
	BODPAIN BODPAINF. PAININT PAININTF. LESSWRKP LESSWRKPF. LESSACCP LESSACCPF. LESSKNDP LESSKNDPF. 
	WRKDIFFP WRKDIFFPF. LESSWRKE LESSWRKEF. LESSACCE LESSACCEF. LESSCARE LESSCAREF. SICKEASY SICKEASYF. 
	HLTHYANY HLTHYANYF. HLTHWORS HLTHWORSF. HLTHEXCL HLTHEXCLF. INTSOC2 INTSOC2F. FULLPEP FULLPEPF. 
	NERVOUS NERVOUSF. DWNDUMPS DWNDUMPSF. CALM CALMF. ENERGY ENERGYF. FELTBLUE FELTBLUEF. 
	WORNOUT WORNOUTF. HAPPY HAPPYF. TIRED TIREDF. EAT EATF. DRESS DRESSF. 
	INOUTBED INOUTBEDF. SHOWER SHOWERF. BLOATING BLOATINGF. CONSTIP CONSTIPF. NIGHTSWT NIGHTSWTF. 
	ACHES ACHESF. BRSTTEN BRSTTENF. HOTFLASH HOTFLASHF. DIARRHEA DIARRHEAF. MOODSWNG MOODSWNGF. 
	NAUSEA NAUSEAF. DIZZY DIZZYF. TIRED2 TIRED2F. FORGET FORGETF. HUNGRY HUNGRYF. 
	HEARTRAC HEARTRACF. TREMORS TREMORSF. HEARTBRN HEARTBRNF. RESTLESS RESTLESSF. LOWBACKP LOWBACKPF. 
	NECKPAIN NECKPAINF. SKINDRY SKINDRYF. HEADACHE HEADACHEF. CLUMSY CLUMSYF. TRBSEE TRBSEEF. 
	VAGITCH VAGITCHF. CONCEN CONCENF. JNTPAIN JNTPAINF. NOHUNGER NOHUNGERF. HEARLOSS HEARLOSSF. 
	SWELLHND SWELLHNDF. VAGDRY VAGDRYF. UPSTOM UPSTOMF. URINPAIN URINPAINF. COUGH COUGHF. 
	VAGDIS VAGDISF. ANXIOUS ANXIOUSF. RESTLSIT RESTLSITF. TIREEASY TIREEASYF. MSCLACHE MSCLACHEF. 
	STAYSLP STAYSLPF. NOCONCEN NOCONCENF. ANNOYED ANNOYEDF. PANIC PANICF. SPOUSDIE SPOUSDIEF. 
	SPOUSILL SPOUSILLF. FRIENDIE FRIENDIEF. MONPROB MONPROBF. DIVORCE DIVORCEF. FRNDIV FRNDIVF. 
	CHILCON CHILCONF. MAJACC MAJACCF. FRNJOB FRNJOBF. PHYAB PHYABF. VERBAB VERBABF. 
	PETDIE PETDIEF. FELTDEP FELTDEPF. RESTSLP RESTSLPF. ENJLIF ENJLIFF. CRYSPELL CRYSPELLF. 
	FELTSAD FELTSADF. PEOPDIS PEOPDISF. SAD2WK SAD2WKF. SAD2YRS SAD2YRSF. SADMUCH SADMUCHF. 
	MEDSLEEP MEDSLEEPF. FALLSLP FALLSLPF. NAP NAPF. TRBSLEEP TRBSLEEPF. WAKENGHT WAKENGHTF. 
	UPEARLY UPEARLYF. BACKSLP BACKSLPF. SNORE SNOREF. QUALSLP QUALSLPF. HRSSLP HRSSLPF. 
	INCONT INCONTF. FRQINCON FRQINCONF. NOINCON NOINCONF. CGHINCON CGHINCONF. TOINCON TOINCONF. 
	SLPINCON SLPINCONF. OTHINCON OTHINCONF. LEAKAMT LEAKAMTF. NOPRTCT NOPRTCTF. MINIPAD MINIPADF. 
	MENSPAD MENSPADF. DIAPER DIAPERF. OTHPRTCT OTHPRTCTF. INCONLMT INCONLMTF. INCONDIS INCONDISF. 
	MARRIED MARRIEDF. SEXACTIV SEXACTIVF. SATSEX SATSEXF. SATFRQSX SATFRQSXF. SEXWORRY SEXWORRYF. 
	SEX SEXF. SEX45 SEX45F. CAREGIV1 CAREGIV1F. CAREGIV2 CAREGIV2F. LIVALOR LIVALORF. 
	;

RUN;




* ============================================================================;
* Data management
* ============================================================================;
data whisf.f37;
	format id days;
	set whisf.f37_ctos_inv;	

	* Create time (days) variable;
	rename f37days = days;

run;


* ============================================================================;
* Duplicates
* Make sure id and day uniquely identifies each observation for merging
* ============================================================================;
proc freq data = whisf.f37;
	tables id*days / noprint out = keylist;
run;
proc print;
	where count >= 2;
run;

* There is one duplicate - need to fix;

* fvclo: For forms entered with the same visit type and year, indicates the 
* one closest to that visit's target date. Valid for forms entered with an 
* annual visit type. 0 = NO 1 = Yes;

* fexpc: This form/data was expected for this visit;

proc sql number;
	select id, days, f37vclo, f37expc, count(*) as dups
		from whisf.f37
		group by id, days
		having calculated dups >= 2;
		* There are 2 rows with duplicate id/days;
quit;

* Just want to keep the first observation for each set of dups;
proc contents data = whisf.f37;
	ods select attributes;
run;
* 218,571 observations;

proc sort data = whisf.f37
	dupout = dups /* For double-checking */
	nodupkey;     /* Drops duplicates */
	by id days;
run;

proc contents data = whisf.f37;
	ods select attributes;
run;
* 218,570 observations - expected number;
