Preprocess 05: Clean and Manage Covariates
================
2017-05-29

``` r
# Load packages
library(tidyverse)
library(data.table)
library(zoo)
library(gmodels)

# Load functions
source("../R scripts/functions.R")
```

------------------------------------------------------------------------

Cleaning covariates
===================

------------------------------------------------------------------------

-   Recode missing

-   Create factor variables

-   Distribute time-invariant variables across all observations (e.g. race)

-   Distribute "have you ever" variables (e.g. diabetes ever)

-   Carry forward relatively time-stable variables (e.g. income)

``` r
# Load data
analysis_07 <- read_rds("../data/analysis_07.rds")
check_data(analysis_07) # 1,432,448 observations and 91 variables
```

    ## 1,432,448 observations and 91 variables

``` r
dt <- as.data.table(analysis_07)
```

Distributing selected covariates across observations
----------------------------------------------------

``` r
# Variables that are either time-invariant, or considered to be nearly time-invariant in this sample
time_invariant <- c("ager", "race_eth", "edu4cat","sex", "ctos", "parity")

# Distribute time-invariant variables across all observations within id
dt[, (time_invariant) := lapply(.SD, function(x) na.omit(x)[1]), 
   .SDcols = time_invariant, 
   by = id]
```

``` r
# Check "have you ever" variables
ever_vars <- c("horm", "hyst", "arthrit", "brca_f30", "cervca", "endo_f30", "ovryca", "cvd", "diab", 
               "hypt", "osteopor", "pad")
dt[, c("id", "days", ever_vars), with = FALSE]
```

    ##              id days horm hyst arthrit brca_f30 cervca endo_f30 ovryca cvd
    ##       1: 100001  -17    1    0      NA       NA     NA       NA     NA  NA
    ##       2: 100001  -11   NA   NA      NA       NA     NA       NA     NA  NA
    ##       3: 100001   -2   NA   NA      NA       NA     NA       NA     NA  NA
    ##       4: 100001    0   NA   NA       0        0      0        0      0   0
    ##       5: 100001 1189   NA   NA      NA       NA     NA       NA     NA  NA
    ##      ---                                                                  
    ## 1432444: 299999  -41   NA   NA      NA       NA     NA       NA     NA  NA
    ## 1432445: 299999  -14   NA   NA      NA       NA     NA       NA     NA  NA
    ## 1432446: 299999   -1   NA   NA      NA       NA     NA       NA     NA  NA
    ## 1432447: 299999    0   NA   NA       1        0      0        0      0   0
    ## 1432448: 299999 1021   NA   NA      NA       NA     NA       NA     NA  NA
    ##          diab hypt osteopor pad
    ##       1:    0   NA       NA  NA
    ##       2:   NA   NA       NA  NA
    ##       3:   NA   NA       NA  NA
    ##       4:   NA    0        0   0
    ##       5:   NA   NA       NA  NA
    ##      ---                       
    ## 1432444:   NA   NA       NA  NA
    ## 1432445:   NA   NA       NA  NA
    ## 1432446:   NA   NA       NA  NA
    ## 1432447:   NA    0        0   0
    ## 1432448:   NA   NA       NA  NA

``` r
# Distribute "have you ever" variables
# If they say "no", then all previous observations should be no. If you've never had diabetes on day 100, then you didn't have diabetes on day 99.
# If they say "Yes", then all future observations should be yes. If you have diabetes on day 100, then you have ever had diabetes on day 200.
dt[, (ever_vars) := lapply(.SD, distribute_ever), 
   .SDcols = ever_vars, 
   by = id]
```

``` r
dt[, c("id", "days", ever_vars), with = FALSE]
```

    ##              id days horm hyst arthrit brca_f30 cervca endo_f30 ovryca cvd
    ##       1: 100001  -17    1    0       0        0      0        0      0   0
    ##       2: 100001  -11    1   NA       0        0      0        0      0   0
    ##       3: 100001   -2    1   NA       0        0      0        0      0   0
    ##       4: 100001    0    1   NA       0        0      0        0      0   0
    ##       5: 100001 1189    1   NA      NA       NA     NA       NA     NA  NA
    ##      ---                                                                  
    ## 1432444: 299999  -41    1   NA      NA        0      0        0      0   0
    ## 1432445: 299999  -14    1   NA      NA        0      0        0      0   0
    ## 1432446: 299999   -1    1   NA      NA        0      0        0      0   0
    ## 1432447: 299999    0    1   NA       1        0      0        0      0   0
    ## 1432448: 299999 1021    1   NA       1       NA     NA       NA     NA  NA
    ##          diab hypt osteopor pad
    ##       1:    0    0        0   0
    ##       2:   NA    0        0   0
    ##       3:   NA    0        0   0
    ##       4:   NA    0        0   0
    ##       5:   NA   NA       NA  NA
    ##      ---                       
    ## 1432444:   NA    0        0   0
    ## 1432445:   NA    0        0   0
    ## 1432446:   NA    0        0   0
    ## 1432447:   NA    0        0   0
    ## 1432448:   NA   NA       NA  NA

``` r
# Checking for 0's after 1's in the ever vars
# dt[pad == 9] # None
```

``` r
# Save progress
analysis_08 <- dt
write_rds(analysis_08, path = "../data/analysis_08.rds")
```

``` r
# Load data
analysis_08 <- read_rds("../data/analysis_08.rds")
check_data(analysis_08) # 1,432,448 observations and 91 variables
```

    ## 1,432,448 observations and 91 variables

``` r
dt <- as.data.table(analysis_08)
```

Sociodemographic covariates
---------------------------

### Age

[Age at screening](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(age)), Mean = mean(age), SD = sd(age))] # Over all observations
```

    ##    Missing     Mean       SD
    ## 1:       0 65.15421 7.521346

### Age group

[Age group at screening](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
# Rename ager
setnames(dt, "ager", "age_group")

# Create factor
dt[, age_group_f := factor(age_group, labels = c("<50-59", "60-69", "70-79+"))]

# Descriptives at first obs
dt[obs == 1, .(Women = .N), by = age_group_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    age_group_f Women Cumsum  Percent
    ## 1:      <50-59 53559  53559 33.10034
    ## 2:       60-69 72589 126148 44.86119
    ## 3:      70-79+ 35660 161808 22.03847

### Race / Ethnicity

[Ethnicity](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
# Create factor
dt[, race_eth_f := factor(race_eth, labels = c("White", "AA", "Hispanic", "Other"))]

# Descriptives at first obs
dt[obs == 1, .(Women = .N), by = race_eth_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    race_eth_f  Women Cumsum    Percent
    ## 1:      White 133541 133541 82.5305300
    ## 2:         AA  14618 148159  9.0341639
    ## 3:      Other   6752 154911  4.1728468
    ## 4:   Hispanic   6484 161395  4.0072184
    ## 5:         NA    413 161808  0.2552408

``` r
# dt %>% filter(is.na(race_eth)) %>% select(id, days, race_eth) %>% summarise(length(unique(id)))
# 413 people matches WHI documentation
```

### Education

[Edcuation](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
# Create factor
dt[, edu4cat_f := factor(edu4cat, labels = c("<HS", "HS Grad", "Some College or Tech School", "College Grad"))]

# Descriptives at first obs
dt[obs == 1][order(edu4cat_f), .(Women = .N), by = edu4cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                      edu4cat_f Women Cumsum   Percent
    ## 1:                         <HS  8644   8644  5.342134
    ## 2:                     HS Grad 27624  36268 17.072085
    ## 3: Some College or Tech School 60909  97177 37.642762
    ## 4:                College Grad 63415 160592 39.191511
    ## 5:                          NA  1216 161808  0.751508

``` r
# 1,216 missing matches WHI documentation
```

### Income

[Family income](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
# How stable is income over time?

# Take a look
# select(dt, id, days, inc5cat, inc5cat_f20)

# How often are inc5cat and inc5cat_f20 measured on the same day?
# 3,148
# On those 3,148 days, how often do inc5cat and inc5cat_f20 disagree?
# dt[!is.na(inc5cat) & !is.na(inc5cat_f20), .(id, days, inc5cat, inc5cat_f20)][inc5cat != inc5cat_f20]
# All on day zero and all agree

# Create a combined income variable
dt[!is.na(inc5cat) & !is.na(inc5cat_f20), combined := inc5cat]
dt[is.na(combined), combined := sum(inc5cat, inc5cat_f20, na.rm = TRUE), by = .(id, days)]
dt[combined == 0, combined := NA_real_]
# select(dt, id, days, inc5cat, inc5cat_f20, combined)

# Does combined change from measure to measure?
dt[!is.na(combined), length(unique(combined)) != 1, by = id][
  , .(`Women with Income` = .N, `Income change` = sum(V1))]
```

    ##    Women with Income Income change
    ## 1:            150934             0

Income is time-invariant. Will distribute across all observations.

``` r
# Drop unneeded income variables
dt[, c("inc5cat_f20", "combined") := NULL]

# Distribute across observations
dt[, inc5cat := na.omit(inc5cat)[1], by = id]

# Create factor
dt[, inc5cat_f := factor(inc5cat, labels = c("20,000 or less", "20-34,999", "35-49,999", "50-74,999",
                                             "75,000+"))]

# Descriptives at first obs
dt[days == 0][order(inc5cat_f), .(Women = .N), by = inc5cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##         inc5cat_f Women Cumsum  Percent
    ## 1: 20,000 or less 25436  25436 15.71987
    ## 2:      20-34,999 36665  62101 22.65957
    ## 3:      35-49,999 30912  93013 19.10412
    ## 4:      50-74,999 29948 122961 18.50836
    ## 5:        75,000+ 27973 150934 17.28777
    ## 6:             NA 10874 161808  6.72031

``` r
# 10,874 missing match WHI documentation for missing and don't know.
```

### Marital status

-   [Married](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf) is worded, "Are you currently married or in an intimate relationship with at least one person?"

-   [Marital](https://www.whi.org/researchers/data/WhiDataDict/f20_ctos_inv.pdf) is worded, "What is your current marital status? (Mark the one that best describes you.)":

1.  Never married
2.  Divorced or separated
3.  Widowed
4.  Presently married
5.  Marriage-like relationship

Recode the marital to 1, 2, and 3 vs. 4 & 5. Should make married and marital roughly comparible.

``` r
dt[, marital := if_else(marital %in% c(1, 2, 3), 0, 
                if_else(marital %in% c(4, 5),    1,
                NA_real_))]
# select(dt, id, days, married, marital)
```

``` r
# Carry forward married
dt[, married := na.locf(married, na.rm = FALSE), by = id]

# Carry forward marital
dt[, marital := na.locf(marital, na.rm = FALSE), by = id]
# select(dt, id, days, married, marital)
```

``` r
# Which variable has the greatest amount of missing?

cat("Number of missing values for married =", format(sum(is.na(dt$married)), big.mark = ",")) # 373,512
```

    ## Number of missing values for married = 373,512

``` r
cat("\n")
```

``` r
cat("Number of missing values for marital =", format(sum(is.na(dt$marital)), big.mark = ",")) # 263,161
```

    ## Number of missing values for marital = 263,161

Marital has fewer missing values.

We previously tried augmenting missing values in marital with data from married - when available. However, sometime there were disagreements. Trying to pick a winner in the disagreements may introduce bias. Setting disagreements to NA results in a greater number of missing than just using marital as it is. So, we'll just use marital as it is.

``` r
# Drop married and rename marital
dt$married <- NULL
setnames(dt, "marital", "married")
```

``` r
# Create factor version
dt[, married_f := factor(married, labels = c("Not married or intimate relationship", 
                                             "Married or intimate relationship"))]

# Descriptives at day 0
dt[days == 0][order(married_f), .(Women = .N), by = married_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                               married_f  Women Cumsum    Percent
    ## 1: Not married or intimate relationship  60773  60773 37.5587116
    ## 2:     Married or intimate relationship 100250 161023 61.9561456
    ## 3:                                   NA    785 161808  0.4851429

### Sexual orientation

[Regardless of whether you are currently sexually active, which response best describes who you have had sex with over your adult lifetime?](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Recode 9 to missing
dt[sex == 9, sex := NA_real_]

# Create factor
dt[, sex_f := factor(sex, labels = c("Have never had sex", "Sex with a woman or with women", 
                                     "Sex with a man or with men", "Sex with both men and women"))]

# Descriptives at day 0
dt[days == 0][order(sex_f), .(Women = .N), by = sex_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                             sex_f  Women Cumsum    Percent
    ## 1:             Have never had sex   2363   2363  1.4603728
    ## 2: Sex with a woman or with women    415   2778  0.2564768
    ## 3:     Sex with a man or with men 150650 153428 93.1041728
    ## 4:    Sex with both men and women   1628 155056  1.0061307
    ## 5:                             NA   6752 161808  4.1728468

### CTOS

[Study component](https://www.whi.org/researchers/data/WhiDataDict/dem_ctos_inv.pdf)

``` r
# Create factor version
dt[, ctos_f := factor(ctos, labels = c("CT", "OS"))]

# Descriptives at first observation
dt[obs == 1, .(Women = .N), by = ctos_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    ctos_f Women Cumsum  Percent
    ## 1:     OS 93676  93676 57.89331
    ## 2:     CT 68132 161808 42.10669

### Parity

[Number of Term Pregnancies. Computed from Form 31, questions 7, 7.6 and 7.7. Number of pregnancies lasting at least 6 months. Equals -1 if never pregnant.](https://www.whi.org/researchers/data/WhiDataDict/f31_ctos_inv.pdf)

``` r
# Recode -1 (never pregnant) to 0 (Never had term pregnancy)
dt[parity == -1, parity := 0]

# Create factor version
dt[, parity_f := factor(parity, labels = c("Never had term pregnancy", "1", "2", "3", "4", "5+"))]

# Descriptives at first observation
dt[obs == 1][order(parity_f), .(Women = .N), by = parity_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                    parity_f Women Cumsum    Percent
    ## 1: Never had term pregnancy 19131  19131 11.8232720
    ## 2:                        1 14205  33336  8.7789232
    ## 3:                        2 40271  73607 24.8881390
    ## 4:                        3 38839 112446 24.0031395
    ## 5:                        4 24557 137003 15.1766291
    ## 6:                       5+ 23759 160762 14.6834520
    ## 7:                       NA  1046 161808  0.6464452

Health behaviors
----------------

### Physical activity

[Total energy expend from recreational phys activity (MET-hours/week). Computed from Form 34, questions 6, 6.1, 6.2, 7.1, 7.2, 7.3, 7.4, 7.5, and 7.6. Total MET-hours per week. Expenditure of energy from recreational physical activity (includes walking, mild, moderate and strenuous physical activity in kcal/week/kg).](https://www.whi.org/researchers/data/WhiDataDict/f34_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(texpwk)), Mean = mean(texpwk, na.rm = TRUE), SD = sd(texpwk, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1104056 11.95094 13.50942

### Alcohol use

[Alcohol servings per week. Computed from Form 34, questions 3 and 3.1; Form 60 (FFQ), wine, beer and liquor servings. Number of servings per week of beer, wine and/or liquor based on a medium serving size which is 12oz of beer, 6oz of wine and 1.5 oz of liquor. If all three variables are missing, set to missing.](https://www.whi.org/researchers/data/WhiDataDict/f34_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(alcswk)), Mean = mean(alcswk, na.rm = TRUE), SD = sd(alcswk, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1097526 2.061918 4.393952

[Dietary Alcohol (g). Includes alcohol from beer, wine, and liquor, as well as from foods. Some foods contain alcohol due to minute amounts of alcohol in vanilla extract, almond extract etc used in baking.](https://www.whi.org/researchers/data/WhiDataDict/f60_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(f60alc)), Mean = mean(f60alc, na.rm = TRUE), SD = sd(f60alc, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1047074 4.886162 10.13778

[Form 60 (FFQ), wine, beer and liquor servings. Number of servings per week of beer, wine and/or liquor based on a medium serving size which is 12oz of beer, 6oz of wine and 1.5 oz of liquor. If all three variables are missing, set to missing.](https://www.whi.org/researchers/data/WhiDataDict/f60_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(f60alcwk)), Mean = mean(f60alcwk, na.rm = TRUE), SD = sd(f60alcwk, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1047222 2.227648 4.674783

### Caffeine use

[Dietary Caffeine (mg)](https://www.whi.org/researchers/data/WhiDataDict/f60_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(f60caff)), Mean = mean(f60caff, na.rm = TRUE), SD = sd(f60caff, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1047074 155.7876 129.7178

### Smoking status

[Do you smoke cigarettes now](https://www.whi.org/researchers/data/WhiDataDict/f35_ct_inv.pdf)

``` r
# Create factor version
dt[, smoknow_f := factor(smoknow, labels = c("No", "Yes"))]

# Tag first non-missing value
dt[!is.na(smoknow), first_smoknow := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_smoknow == 1][order(smoknow_f), .(Women = .N), by = smoknow_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    smoknow_f  Women Cumsum  Percent
    ## 1:        No 101226 101226 89.95548
    ## 2:       Yes  11303 112529 10.04452

``` r
# How many never respond?
dt[, all(is.na(first_smoknow)), by = id][, .(`Never respond` = sum(V1))][] # 49,279
```

    ##    Never respond
    ## 1:         49279

[Smoking status. Computed from Form 34, questions 1, 1.2, and 1.5. Combines questions into a three category smoking status variable (never/past/current).](https://www.whi.org/researchers/data/WhiDataDict/f34_ctos_inv.pdf)

``` r
# Create factor version
dt[, smoking_f := factor(smoking, labels = c("Never smoked", "Past smoker", "Current smoker"))]

# Tag first non-missing value
dt[!is.na(smoking), first_smoking := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_smoking == 1, .(Women = .N), by = smoking_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##         smoking_f Women Cumsum   Percent
    ## 1:   Never smoked 81430  81430 50.995103
    ## 2:    Past smoker 67110 148540 42.027279
    ## 3: Current smoker 11142 159682  6.977618

``` r
# How many never respond?
dt[, all(is.na(first_smoking)), by = id][, .(`Never respond` = sum(V1))][] # 2,126
```

    ##    Never respond
    ## 1:          2126

Smoking is much more complete. Use it in the analysis.

``` r
# Clean up
dt[, c("smoknow", "smoknow_f", "first_smoknow", "first_smoking") := NULL]
```

### Hormones ever

[Female hormones ever. Did you ever use any female hormones like estrogen (Premarin) or progesterone (Provera)? These might be pills, skin patches, implants, creams, suppositories, shots, or birth control pills. (This does not include birth control pills you used before you were 50.)](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

``` r
# Create a factor version
dt[, horm_f := factor(horm, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[obs == 1, .(Women = .N), by = horm_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    horm_f Women Cumsum  Percent
    ## 1:    Yes 83214  83214 51.42762
    ## 2:     No 52644 135858 32.53486
    ## 3:     NA 25950 161808 16.03753

### Hormones now

[Female hormones now. Are you using female hormones now?](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

``` r
# Create factor version
dt[, hormnw_f := factor(hormnw, labels = c("No", "Yes"))]

# Tag first non-missing value
dt[!is.na(hormnw), first_hormnw := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_hormnw == 1, .(Women = .N), by = hormnw_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    hormnw_f Women Cumsum  Percent
    ## 1:       No 36505  36505 34.92199
    ## 2:      Yes 68028 104533 65.07801

``` r
# Clean up
dt[, first_hormnw := NULL]
```

### Taking SSRI

[Medication Therapeutic Class Code](https://www.whi.org/researchers/data/WhiDataDict/f44_ctos_inv.pdf)

tccode = 581600

``` r
# Create factor version
dt[, ssri_f := factor(ssri, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[obs == 1][order(ssri_f), .(Women = .N), by = ssri_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    ssri_f  Women Cumsum     Percent
    ## 1:     No   1687   1687  1.04259369
    ## 2:    Yes     88   1775  0.05438544
    ## 3:     NA 160033 161808 98.90302086

Health and Wellness
-------------------

### Quality of life

[Overall, how you would rate your quality of life? (Mark one oval in the box below.)](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

Scale from 1 to 10 with 10 being the best.

``` r
dt[, .(Missing = sum(is.na(lifequal)), Mean = mean(lifequal, na.rm = TRUE), SD = sd(lifequal, na.rm = TRUE))]
```

    ##    Missing     Mean       SD
    ## 1: 1060385 8.194567 1.518856

### Depression

[Shortened CES-D/DIS Screening Instrument. Computed from Form 36/37, questions 103-108, 109, and 110. Source: Center for Epidemiological Studies; depression scale (CES-D, short form). PSHTDEP ranges from 0 to 1 with a higher score indicating a greater likelihood of depression. Cutoff values of .06 and .009 have been used to indicate depression.](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(pshtdep)), Mean = mean(pshtdep, na.rm = TRUE), SD = sd(pshtdep, na.rm = TRUE))]
```

    ##    Missing       Mean        SD
    ## 1: 1069568 0.03856322 0.1258101

### BMI

[Body-mass Index (BMI), kg/m2. If a participant's BMI is greater than 70, BMI is missing.](https://www.whi.org/researchers/data/WhiDataDict/f80_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(bmi)), Mean = mean(bmi, na.rm = TRUE), SD = sd(bmi, na.rm = TRUE))]
```

    ##    Missing    Mean       SD
    ## 1:  758986 28.5275 5.961675

### General health

[In general, would you say your health is (Mark one oval.)](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Create factor version
dt[, genhel_f := factor(genhel, labels = c("Excellent", "Very good", "Good", "Fair", "Poor"))]

# Tag first non-missing value
dt[!is.na(genhel), first_genhel := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_genhel == 1][order(genhel_f), .(Women = .N), by = genhel_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##     genhel_f Women Cumsum   Percent
    ## 1: Excellent 27498  27498 17.015352
    ## 2: Very good 65970  93468 40.821252
    ## 3:      Good 53324 146792 32.996095
    ## 4:      Fair 13568 160360  8.395676
    ## 5:      Poor  1247 161607  0.771625

``` r
# Dichotomize
dt[, good_health := if_else(genhel_f == "Excellent" | genhel_f == "Very good", 1, 0, NA_real_)]

# Factor version
dt[, good_health_f := factor(good_health, labels = c("No", "Yes"))]

# Descriptives at first response
dt[first_genhel == 1, .(Women = .N), by = good_health_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    good_health_f Women Cumsum Percent
    ## 1:            No 68139  68139 42.1634
    ## 2:           Yes 93468 161607 57.8366

``` r
# Clean up
dt[, first_genhel := NULL]
```

### Hysterectomy ever

[Did you ever have a hysterectomy? (This is an operation to take out your uterus or womb.)](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

``` r
# Create factor version
dt[, hyst_f := factor(hyst, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[obs == 1, .(Women = .N), by = hyst_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    hyst_f Women Cumsum   Percent
    ## 1:     No 94032  94032 58.113319
    ## 2:    Yes 54772 148804 33.849995
    ## 3:     NA 13004 161808  8.036685

### Night sweats

[Below is a list of symptoms people sometimes have. For each item, mark the one oval that best describes how bothersome the symptom was during the past 4 weeks for you. Be sure to mark one oval on each line. Night sweats](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Create factor version
dt[, nightswt_f := factor(nightswt, labels = c("Symptom did not occur", "Symptom was mild", 
                                               "Symptom was moderate", "Symptom was severe"))]

# Tag first non-missing value
dt[!is.na(nightswt), first_nightswt := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_nightswt == 1, .(Women = .N), by = nightswt_f][, Cumsum := cumsum(Women)][, Percent := Women / max(Cumsum) * 100][]
```

    ##               nightswt_f  Women Cumsum   Percent
    ## 1: Symptom did not occur 119926 119926 74.253907
    ## 2:      Symptom was mild  30063 149989 18.613939
    ## 3:  Symptom was moderate   9351 159340  5.789806
    ## 4:    Symptom was severe   2168 161508  1.342348

``` r
# Dichotomize
dt[, night_sweats := if_else(nightswt_f == "Symptom did not occur", 0, 1, NA_real_)]

# Create factor version
dt[, night_sweats_f := factor(night_sweats, labels = c("No", "Yes"))]

# Descriptives
dt[first_nightswt == 1, .(Women = .N), by = night_sweats_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    night_sweats_f  Women Cumsum  Percent
    ## 1:             No 119926 119926 74.25391
    ## 2:            Yes  41582 161508 25.74609

``` r
# Clean up
dt[, first_nightswt := NULL]
```

### Hot flashes

[Below is a list of symptoms people sometimes have. For each item, mark the one oval that best describes how bothersome the symptom was during the past 4 weeks for you. Be sure to mark one oval on each line. Hot flashes](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Create factor version
dt[, hotflash_f := factor(hotflash, labels = c("Symptom did not occur", "Symptom was mild", 
                                               "Symptom was moderate", "Symptom was severe"))]

# Tag first non-missing value
dt[!is.na(hotflash), first_hotflash := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_hotflash == 1][order(hotflash_f), .(Women = .N), by = hotflash_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##               hotflash_f  Women Cumsum   Percent
    ## 1: Symptom did not occur 122428 122428 75.779127
    ## 2:      Symptom was mild  27891 150319 17.263662
    ## 3:  Symptom was moderate   8830 159149  5.465496
    ## 4:    Symptom was severe   2410 161559  1.491715

``` r
# Dichotomize
dt[, hot_flashes := if_else(hotflash_f == "Symptom did not occur", 0, 1, NA_real_)]

# Create factor version
dt[, hot_flashes_f := factor(hot_flashes, labels = c("No", "Yes"))]

# Descriptives
dt[first_hotflash == 1, .(Women = .N), by = hot_flashes_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    hot_flashes_f  Women Cumsum  Percent
    ## 1:            No 122428 122428 75.77913
    ## 2:           Yes  39131 161559 24.22087

``` r
# Clean up
dt[, first_hotflash := NULL]
```

### Vaginal dryness

[Below is a list of symptoms people sometimes have. For each item, mark the one oval that best describes how bothersome the symptom was during the past 4 weeks for you. Be sure to mark one oval on each line. Vaginal or genital dryness](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Create factor version
dt[, vagdry_f := factor(vagdry, labels = c("Symptom did not occur", "Symptom was mild", 
                                               "Symptom was moderate", "Symptom was severe"))]
# Tag first non-missing value
dt[!is.na(vagdry), first_vagdry := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_vagdry == 1][order(vagdry_f), .(Women = .N), by = vagdry_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                 vagdry_f  Women Cumsum   Percent
    ## 1: Symptom did not occur 117331 117331 72.644926
    ## 2:      Symptom was mild  31678 149009 19.613282
    ## 3:  Symptom was moderate   9644 158653  5.971036
    ## 4:    Symptom was severe   2860 161513  1.770755

``` r
# Dichotomize
dt[, vag_dry := if_else(vagdry_f == "Symptom did not occur", 0, 1, NA_real_)]

# Create factor version
dt[, vag_dry_f := factor(vag_dry, labels = c("No", "Yes"))]

# Descriptives
dt[first_vagdry == 1, .(Women = .N), by = vag_dry_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    vag_dry_f  Women Cumsum  Percent
    ## 1:       Yes  44182  44182 27.35507
    ## 2:        No 117331 161513 72.64493

``` r
# Clean up
dt[, first_vagdry := NULL]
```

### Urinary incontinence

[Have you ever leaked even a very small amount of urine involuntarily and you couldn't control it?](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Create factor version
dt[, incont_f := factor(incont, labels = c("No", "Yes"))]

# Tag first non-missing value
dt[!is.na(incont), first_incont := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_incont == 1, .(Women = .N), by = incont_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    incont_f  Women Cumsum  Percent
    ## 1:       No  43950  43950 27.19342
    ## 2:      Yes 117670 161620 72.80658

``` r
# Clean up
dt[, first_incont := NULL]
```

### Atrophy

[Not going to use atrophy. Only asked of HT arm.](https://www.whi.org/researchers/data/WhiDataDict/f81_ht_inv.pdf)

### Chronic disease

Make a single categorical variable - disease X only and multiple.

First clean each individual chronic disease variable.

#### Arthritis

[Did your doctor ever say that you had arthritis?](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, arthrit_f := factor(arthrit, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = arthrit_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    arthrit_f    Obs  Cumsum  Percent
    ## 1:        No 365060  365060 25.48504
    ## 2:        NA 659475 1024535 46.03832
    ## 3:       Yes 407913 1432448 28.47664

#### Cancer - Breast

[What kind of cancer did you have? (Mark "No" or "Yes" for each type of cancer.) Breast](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, brac_f := factor(brca_f30, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = brac_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    brac_f    Obs  Cumsum    Percent
    ## 1:     No 673440  673440 47.0132249
    ## 2:     NA 745368 1418808 52.0345590
    ## 3:    Yes  13640 1432448  0.9522161

#### Cancer - Cervix

[What kind of cancer did you have? (Mark "No" or "Yes" for each type of cancer.) Cervix (opening to the uterus or womb)](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, cervca_f := factor(cervca, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = cervca_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    cervca_f    Obs  Cumsum    Percent
    ## 1:       No 685938  685938 47.8857173
    ## 2:       NA 736439 1422377 51.4112205
    ## 3:      Yes  10071 1432448  0.7030622

#### Cancer - Endometrial

[What kind of cancer did you have? (Mark "No" or "Yes" for each type of cancer.) Endometrium (lining of the uterus or womb)](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, endo_f := factor(endo_f30, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = endo_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    endo_f    Obs  Cumsum    Percent
    ## 1:     No 685885  685885 47.8820174
    ## 2:     NA 738387 1424272 51.5472115
    ## 3:    Yes   8176 1432448  0.5707712

#### Cancer - Ovarian

[What kind of cancer did you have? (Mark "No" or "Yes" for each type of cancer.) Ovary](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, ovryca_f := factor(ovryca, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = ovryca_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    ovryca_f    Obs  Cumsum    Percent
    ## 1:       No 690783  690783 48.2239495
    ## 2:       NA 737908 1428691 51.5137722
    ## 3:      Yes   3757 1432448  0.2622783

#### Cardiovascular disease

[Has a doctor ever told you that you had heart problems, problems with your blood circulation, or blood clots?](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, cvd_f := factor(cvd, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = cvd_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    cvd_f    Obs  Cumsum   Percent
    ## 1:    No 541546  541546 37.805631
    ## 2:    NA 758056 1299602 52.920315
    ## 3:   Yes 132846 1432448  9.274054

#### Diabetes ever

[Did a doctor ever say that you had sugar diabetes or high blood sugar when you were not pregnant?](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

``` r
# Create factor version
dt[, diab_f := factor(diab, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = diab_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    diab_f     Obs  Cumsum   Percent
    ## 1:     No  183919  183919 12.839489
    ## 2:     NA 1167067 1350986 81.473603
    ## 3:    Yes   81462 1432448  5.686908

#### Hypertension

[Did a doctor ever say that you had hypertension or high blood pressure? (Do not include high blood pressure that you had only when you were pregnant.)](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, hypt_f := factor(hypt, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = hypt_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    hypt_f    Obs  Cumsum  Percent
    ## 1:     No 459830  459830 32.10099
    ## 2:     NA 678024 1137854 47.33324
    ## 3:    Yes 294594 1432448 20.56577

#### Osteoporosis

[Has a doctor told you that you have any of the following conditions or have you had any of the following procedures? (Please mark all that apply.) Osteoporosis (weak, thin, or brittle bones)](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, osteopor_f := factor(osteopor, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = osteopor_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    osteopor_f    Obs  Cumsum   Percent
    ## 1:         No 638966  638966 44.606576
    ## 2:         NA 735794 1374760 51.366193
    ## 3:        Yes  57688 1432448  4.027232

#### Peripheral arterial disease

[Did a doctor ever say that you had claudication or peripheral arterial disease (poor blood flow to the legs or blocked or narrowed arteries to the legs)? Do not include varicose veins or phlebitis.](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, pad_f := factor(pad, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = pad_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    pad_f    Obs  Cumsum   Percent
    ## 1:    No 682372  682372 47.636773
    ## 2:    NA 734519 1416891 51.277184
    ## 3:   Yes  15557 1432448  1.086043

#### Combined chronic disease variable

``` r
# Count conditions within id and day. If any are NA then count is NA.
dt[, cd_count := sum(arthrit, brca_f30, cervca, endo_f30, ovryca, cvd, diab, hypt, osteopor, pad)
     , by = .(id, days)]
```

``` r
# Descriptives
dt[!is.na(cd_count), .(.N, Mean = mean(cd_count), Max = max(cd_count))]
```

    ##        N      Mean Max
    ## 1: 66074 0.4251748   9

``` r
dt[!is.na(cd_count), chronic_disease := if_else(cd_count == 0,  0, # None
                                        if_else(cd_count == 2,  1, # 2 conditions
                                        if_else(cd_count == 3,  2, # 3 conditions
                                        if_else(cd_count == 4,  3, # 4 conditions
                                        if_else(cd_count >= 5,  4, # 5+ conditions
                                        if_else(arthrit ==  1,  5, # Arthritis Only
                                        if_else(brca_f30 == 1,  6, # BC Only
                                        if_else(cervca ==   1,  7, # Cervical Only
                                        if_else(endo_f30 == 1,  8, # Endo Only
                                        if_else(ovryca ==   1,  9, # Ovarian Only
                                        if_else(cvd ==      1, 10, # CVD Only
                                        if_else(diab ==     1, 11, # Diab Only
                                        if_else(hypt ==     1, 12, # Hypt Only
                                        if_else(osteopor == 1, 13, # Ost Only
                                        if_else(pad ==      1, 14, # PAD Only
                                        NA_real_)))))))))))))))]

# Create factor version
dt[, chronic_disease_f := factor(chronic_disease, 
                                 levels = c(0:14),
                                 labels = c("None", "2 conditions", "3 conditions", "4 conditions", 
                                            "5+ conditions", "Arthritis Only", "Breast Cancer Only", 
                                            "Cervical Cancer Only", "Endometrial Cancer Only", 
                                            "Ovarian Cancer Only", "Cardiovascular Disease Only",
                                            "Diabetes Only", "Hypertension Only", "Osteoporosis Only",
                                            "Peripheral Artery Disease Only"))]

# Tag first observation per person
dt[!is.na(chronic_disease_f), first_cd := seq_len(.N) == 1, by = id]

# Descriptives at first observation
dt[first_cd == 1][order(chronic_disease_f)][, .(Women = .N), by = chronic_disease_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                  chronic_disease_f Women Cumsum      Percent
    ##  1:                           None 44169  44169 83.262328457
    ##  2:                   2 conditions  2642  46811  4.980395114
    ##  3:                   3 conditions  2901  49712  5.468632182
    ##  4:                   4 conditions  1556  51268  2.933192580
    ##  5:                  5+ conditions   596  51864  1.123510783
    ##  6:                 Arthritis Only    42  51906  0.079173579
    ##  7:    Cardiovascular Disease Only     3  51909  0.005655256
    ##  8:                  Diabetes Only  1118  53027  2.107525260
    ##  9:              Hypertension Only    18  53045  0.033931534
    ## 10:              Osteoporosis Only     2  53047  0.003770170
    ## 11: Peripheral Artery Disease Only     1  53048  0.001885085

``` r
# Clean up
rm(ever_vars, time_invariant)
dt$first_cd <- NULL
```

``` r
# Save progress
analysis_09 <- as_tibble(dt)
write_rds(analysis_09, path = "../data/analysis_09.rds")
```

    ## R version 3.4.0 (2017-04-21)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.5
    ## 
    ## Matrix products: default
    ## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] gmodels_2.16.2    zoo_1.8-0         data.table_1.10.4
    ##  [4] dplyr_0.5.0       purrr_0.2.2       readr_1.1.0      
    ##  [7] tidyr_0.6.2       tibble_1.3.0      ggplot2_2.2.1    
    ## [10] tidyverse_1.1.1  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10     cellranger_1.1.0 compiler_3.4.0   plyr_1.8.4      
    ##  [5] forcats_0.2.0    tools_3.4.0      digest_0.6.12    lubridate_1.6.0 
    ##  [9] jsonlite_1.4     evaluate_0.10    nlme_3.1-131     gtable_0.2.0    
    ## [13] lattice_0.20-35  psych_1.7.5      DBI_0.6-1        yaml_2.1.14     
    ## [17] parallel_3.4.0   haven_1.0.0      xml2_1.1.1       stringr_1.2.0   
    ## [21] httr_1.2.1       knitr_1.16       gtools_3.5.0     hms_0.3         
    ## [25] rprojroot_1.2    grid_3.4.0       R6_2.2.0         readxl_1.0.0    
    ## [29] foreign_0.8-67   rmarkdown_1.5    gdata_2.17.0     modelr_0.1.0    
    ## [33] reshape2_1.4.2   magrittr_1.5     MASS_7.3-47      backports_1.0.5 
    ## [37] scales_0.4.1     htmltools_0.3.6  rvest_0.3.2      assertthat_0.2.0
    ## [41] mnormt_1.5-5     colorspace_1.3-2 stringi_1.1.5    lazyeval_0.2.0  
    ## [45] munsell_0.4.3    broom_0.4.2
