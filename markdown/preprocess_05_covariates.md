Preprocess 05: Clean and Manage Covariates
================
Created: 2017-07-17 <br> Updated: 2017-10-23

``` r
# Load packages
library(feather)
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
analysis_07 <- read_feather("../data/analysis_07.feather")
check_data(analysis_07) # 1,432,448 observations and 93 variables
```

    ## 1,432,448 observations and 93 variables

``` r
dt <- as.data.table(analysis_07)
```

Distributing selected covariates across observations
----------------------------------------------------

``` r
# Variables that are either time-invariant, or considered to be nearly time-invariant in this sample
time_invariant <- c("ager", "race", "ethnic", "edu4cat","sex", "ctos", "parity")

# Distribute time-invariant variables across all observations within id
dt[, (time_invariant) := lapply(.SD, function(x) na.omit(x)[1]), 
   .SDcols = time_invariant, 
   by = id]
```

``` r
# Check "have you ever" variables
ever_vars <- c("horm", "hyst", "arthrit", "brca_f30", "cervca", "endo_f30", "ovryca", "cvd", "diab", 
               "hypt", "osteopor", "pad", "canc_f30", "hip55", "diabtrt", "incont")
dt[, c("days", ever_vars), with = FALSE]
```

    ##          days horm hyst arthrit brca_f30 cervca endo_f30 ovryca cvd diab
    ##       1:  -17    1    0      NA       NA     NA       NA     NA  NA    0
    ##       2:  -11   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ##       3:   -2   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ##       4:    0   NA   NA       0        0      0        0      0   0   NA
    ##       5: 1189   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ##      ---                                                                
    ## 1432444:  -41   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ## 1432445:  -14   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ## 1432446:   -1   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ## 1432447:    0   NA   NA       1        0      0        0      0   0   NA
    ## 1432448: 1021   NA   NA      NA       NA     NA       NA     NA  NA   NA
    ##          hypt osteopor pad canc_f30 hip55 diabtrt incont
    ##       1:   NA       NA  NA       NA    NA       0     NA
    ##       2:   NA       NA  NA       NA    NA      NA     NA
    ##       3:   NA       NA  NA       NA    NA      NA      0
    ##       4:    0        0   0        0    NA      NA     NA
    ##       5:   NA       NA  NA       NA    NA      NA      0
    ##      ---                                                
    ## 1432444:   NA       NA  NA       NA    NA      NA     NA
    ## 1432445:   NA       NA  NA       NA    NA      NA     NA
    ## 1432446:   NA       NA  NA       NA    NA      NA      1
    ## 1432447:    0        0   0        1     0      NA     NA
    ## 1432448:   NA       NA  NA       NA    NA      NA      1

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
    ##          diab hypt osteopor pad canc_f30 hip55 diabtrt incont
    ##       1:    0    0        0   0        0    NA       0      0
    ##       2:   NA    0        0   0        0    NA      NA      0
    ##       3:   NA    0        0   0        0    NA      NA      0
    ##       4:   NA    0        0   0        0    NA      NA      0
    ##       5:   NA   NA       NA  NA       NA    NA      NA      0
    ##      ---                                                     
    ## 1432444:   NA    0        0   0       NA     0      NA     NA
    ## 1432445:   NA    0        0   0       NA     0      NA     NA
    ## 1432446:   NA    0        0   0       NA     0      NA      1
    ## 1432447:   NA    0        0   0        1     0      NA      1
    ## 1432448:   NA   NA       NA  NA        1    NA      NA      1

How many logic errors (0's after 1's) were there?

``` r
nines <- function(x) {
  i   <- which(x == 9)
  ids <- dt$id[i]
  ids <- unique(ids)
  out <- length(ids)
  out
}

dt[, lapply(.SD, nines), .SDcols = ever_vars] %>% 
  gather("Variable", "N ID's with Logic Error")
```

    ##    Variable N ID's with Logic Error
    ## 1      horm                       0
    ## 2      hyst                       0
    ## 3   arthrit                       0
    ## 4  brca_f30                       0
    ## 5    cervca                       0
    ## 6  endo_f30                       0
    ## 7    ovryca                       0
    ## 8       cvd                       0
    ## 9      diab                       0
    ## 10     hypt                       0
    ## 11 osteopor                       0
    ## 12      pad                       0
    ## 13 canc_f30                       0
    ## 14    hip55                       0
    ## 15  diabtrt                       0
    ## 16   incont                   15859

``` r
rm(nines)
```

There are 15,859 people with a 9 for incont. Nines appear when there are logically inconsistent answers to an "ever" question. For example, they say on day 0 that they have ever leaked urine and then say no to the same question on day 100.

``` r
# nines <- dt %>% filter(incont == 9) %>% pull(id) %>% unique()
# analysis_07 %>% filter(id %in% nines) %>% select(id, days, incont)
```

There are a lot of these logical inconsistencies. They are typically at the very last observation. We will handle this by making every observation after the first "1" a "1".

``` r
dt <- dt %>% 
  mutate(incont = if_else(incont == 9, 1, incont))
```

``` r
# Save progress
analysis_08 <- dt
write_feather(analysis_08, path = "../data/analysis_08.feather")
```

------------------------------------------------------------------------

Sociodemographic covariates
---------------------------

------------------------------------------------------------------------

``` r
# Load data
analysis_08 <- read_feather("../data/analysis_08.feather")
check_data(analysis_08) # 1,432,448 observations and 93 variables
```

    ## 1,432,448 observations and 93 variables

``` r
dt <- as.data.table(analysis_08)
```

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
# Recode ethnic
dt <- dt %>% mutate(race_eth = case_when(
    is.na(ethnic) ~ NA_real_, # Missing
    ethnic == 5   ~ 1,        # White (not of Hispanic origin)
    ethnic == 3   ~ 2,        # Black or African-American
    ethnic == 4   ~ 3,        # Hispanic/Latino
    ethnic == 2   ~ 4,        # Asian or Pacific Islander
    ethnic == 1   ~ 5,        # American Indian or Alaskan Native
    TRUE          ~ 6         # Other
  )
)
dt <- as.data.table(dt)
```

``` r
# Create factor
dt[, race_eth_f := factor(race_eth, levels = c(1:6), 
                          labels = c("White", "AA", "Hispanic", "Asian PI", "AI AN", "Other"))]

# Descriptives at first obs
dt[obs == 1][order(race_eth_f), .(Women = .N), by = race_eth_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    race_eth_f  Women Cumsum    Percent
    ## 1:      White 133541 133541 82.5305300
    ## 2:         AA  14618 148159  9.0341639
    ## 3:   Hispanic   6484 154643  4.0072184
    ## 4:   Asian PI   4190 158833  2.5894888
    ## 5:      AI AN    713 159546  0.4406457
    ## 6:      Other   1849 161395  1.1427124
    ## 7:         NA    413 161808  0.2552408

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

``` r
# Dichotomize Education
dt[edu4cat_f %in% c("<HS", "HS Grad", "Some College or Tech School"), edu2cat := 0]
dt[edu4cat_f == "College Grad", edu2cat := 1]
dt[, edu2cat_f := factor(edu2cat, labels = c("Not Collge Grad", "College Grad"))]
dt[obs == 1][order(edu2cat_f), .(Women = .N), by = edu2cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##          edu2cat_f Women Cumsum   Percent
    ## 1: Not Collge Grad 97177  97177 60.056981
    ## 2:    College Grad 63415 160592 39.191511
    ## 3:              NA  1216 161808  0.751508

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

------------------------------------------------------------------------

Health and health risk factors
------------------------------

------------------------------------------------------------------------

### Smoking status

[Pack years of smoking](https://www.whi.org/researchers/data/WhiDataDict/f34_ctos_inv.pdf)

Pack-years of smoking is a computed variable taking into account years of smoking and number of cigarettes smoked per day on average. Please see the PACKYRS algorithm notes (Pack Years of Smoking Algorithm May 2014.doc) for additional detail on how it is computed.

Over all observations

``` r
dt[, .(Missing = sum(is.na(packyrs)), Mean = mean(packyrs, na.rm = T), SD = sd(packyrs, na.rm = T))]
```

    ##    Missing     Mean       SD
    ## 1: 1278731 9.498494 17.76434

Pack years of smoking at first observation

``` r
dt[obs == 1, .(Missing = sum(is.na(packyrs)), Mean = mean(packyrs, na.rm = T), SD = sd(packyrs, na.rm = T))]
```

    ##    Missing     Mean       SD
    ## 1:  160749 7.706492 15.65939

Pack years of smoking at first observation with a non-missing value

``` r
dt[!is.na(packyrs), first_packyrs := seq_len(.N) == 1, by = id] # Tag first non-missing value

dt[first_packyrs == 1, 
   .(Missing = sum(is.na(packyrs)), Mean = mean(packyrs, na.rm = T), SD = sd(packyrs, na.rm = T))]
```

    ##    Missing     Mean       SD
    ## 1:       0 9.498494 17.76434

### BMI

[Body-mass Index (BMI), kg/m2. If a participant's BMI is greater than 70, BMI is missing.](https://www.whi.org/researchers/data/WhiDataDict/f80_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(bmi)), Mean = mean(bmi, na.rm = TRUE), SD = sd(bmi, na.rm = TRUE))]
```

    ##    Missing    Mean       SD
    ## 1:  758986 28.5275 5.961675

At first observation with a non-missing value

``` r
dt[!is.na(bmi), first_bmi := seq_len(.N) == 1, by = id] # Tag first non-missing value

dt[first_bmi == 1, 
   .(Missing = sum(is.na(bmi)), Mean = mean(bmi, na.rm = T), SD = sd(bmi, na.rm = T))]
```

    ##    Missing     Mean       SD
    ## 1:       0 27.97535 5.943838

Create categorical BMI variable

``` r
dt <- dt %>% mutate(bmi4cat = case_when(
  is.na(bmi) ~ NA_real_, # Missing
  bmi < 25 ~ 1,          # < 25
  bmi < 30 ~ 2,          # 25-29
  bmi < 35 ~ 3,          # 30-34
  TRUE     ~ 4           # 35+
  )
) %>% 
as.data.table()
```

``` r
dt[, bmi4cat_f := factor(bmi4cat, labels = c("< 25", "25-29", "30-34", "35+"))]
dt[obs ==1][order(bmi4cat_f), .(Women = .N), by = bmi4cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    bmi4cat_f  Women Cumsum    Percent
    ## 1:      < 25    710    710  0.4387917
    ## 2:     25-29    697   1407  0.4307574
    ## 3:     30-34    344   1751  0.2125976
    ## 4:       35+    242   1993  0.1495600
    ## 5:        NA 159815 161808 98.7682933

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

### Hypertension

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

### Cardiovascular disease

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

### Arthritis

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

### Diabetes ever

[Did a doctor ever say that you had sugar diabetes or high blood sugar when you were not pregnant?](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

[Computed from Form 2, question 23, 23.4 and 23.6. Indicator for whether the participant has ever been treated for diabetes with pills or shots.](https://www.whi.org/researchers/data/WhiDataDict/f2_ctos_inv.pdf)

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

Update 2017-09-26: Combine diab and diabtrt

``` r
dt[, diab_combined := case_when(
  diab == 1 | diabtrt == 1 ~ 1,       # Yes
  diab == 0 & diabtrt == 0 ~ 0,       # No
  TRUE                     ~ NA_real_ # Missing
)]
dt[, diab_combined_f := factor(diab_combined, levels = c(0, 1), labels = c("No", "Yes"))]
dt[, .(Obs = .N), by = diab_combined_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    diab_combined_f     Obs  Cumsum   Percent
    ## 1:              No  183919  183919 12.839489
    ## 2:              NA 1167067 1350986 81.473603
    ## 3:             Yes   81462 1432448  5.686908

Checked back to SAS f\_2. There aren't actually any instances where a woman said no to diab and yes to diabtrt.

### Cancer

[Did a doctor ever say that you had cancer, a malignant growth, or tumor? (This does not include "fibroids" of the uterus.)](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, canc_f := factor(canc_f30, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = canc_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    canc_f    Obs  Cumsum   Percent
    ## 1:     No 634293  634293 44.280351
    ## 2:     NA 742823 1377116 51.856891
    ## 3:    Yes  55332 1432448  3.862758

### Hip fracture after age 55

[Hip fracture age 55 or older](https://www.whi.org/researchers/data/WhiDataDict/f30_ctos_inv.pdf)

``` r
# Create factor version
dt[, hip55_f := factor(hip55, labels = c("No", "Yes"))]

# Descriptives at first observation
dt[, .(Obs = .N), by = hip55_f][, Cumsum := cumsum(Obs)][, Percent := Obs / max(Cumsum) * 100][]
```

    ##    hip55_f    Obs  Cumsum    Percent
    ## 1:      NA 905592  905592 63.2198865
    ## 2:      No 522851 1428443 36.5005222
    ## 3:     Yes   4005 1432448  0.2795913

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
dt[genhel_f %in% c("Fair", "Poor"), good_health := 0]
dt[genhel_f %in% c("Excellent", "Very good", "Good"), good_health := 1]

# Factor version
dt[, good_health_f := factor(good_health, labels = c("No", "Yes"))]

# Descriptives at first response
dt[first_genhel == 1, .(Women = .N), by = good_health_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    good_health_f  Women Cumsum   Percent
    ## 1:           Yes 146792 146792 90.832699
    ## 2:            No  14815 161607  9.167301

### Depression

[Shortened CES-D/DIS Screening Instrument. Computed from Form 36/37, questions 103-108, 109, and 110. Source: Center for Epidemiological Studies; depression scale (CES-D, short form). PSHTDEP ranges from 0 to 1 with a higher score indicating a greater likelihood of depression. Cutoff values of .06 and .009 have been used to indicate depression.](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
dt[, .(Missing = sum(is.na(pshtdep)), Mean = mean(pshtdep, na.rm = TRUE), SD = sd(pshtdep, na.rm = TRUE))]
```

    ##    Missing       Mean        SD
    ## 1: 1069568 0.03856322 0.1258101

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

------------------------------------------------------------------------

Menopausal symptoms and treatment variables
-------------------------------------------

------------------------------------------------------------------------

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
rm(ever_vars, time_invariant)
```

``` r
# Save progress
analysis_09 <- as_tibble(dt)
write_feather(analysis_09, path = "../data/analysis_09.feather")
```

    ## R version 3.4.1 (2017-06-30)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS High Sierra 10.13
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
    ##  [1] bindrcpp_0.2      gmodels_2.16.2    zoo_1.8-0        
    ##  [4] data.table_1.10.4 dplyr_0.7.3       purrr_0.2.3      
    ##  [7] readr_1.1.1       tidyr_0.7.1       tibble_1.3.4     
    ## [10] ggplot2_2.2.1     tidyverse_1.1.1   feather_0.3.1    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.12     cellranger_1.1.0 compiler_3.4.1   plyr_1.8.4      
    ##  [5] bindr_0.1        forcats_0.2.0    tools_3.4.1      digest_0.6.12   
    ##  [9] lubridate_1.6.0  jsonlite_1.5     evaluate_0.10.1  nlme_3.1-131    
    ## [13] gtable_0.2.0     lattice_0.20-35  pkgconfig_2.0.1  rlang_0.1.2     
    ## [17] psych_1.7.8      yaml_2.1.14      parallel_3.4.1   haven_1.1.0     
    ## [21] xml2_1.1.1       httr_1.3.1       stringr_1.2.0    knitr_1.17      
    ## [25] gtools_3.5.0     hms_0.3          rprojroot_1.2    grid_3.4.1      
    ## [29] glue_1.1.1       R6_2.2.2         readxl_1.0.0     foreign_0.8-69  
    ## [33] rmarkdown_1.6    gdata_2.18.0     modelr_0.1.1     reshape2_1.4.2  
    ## [37] magrittr_1.5     MASS_7.3-47      backports_1.1.0  scales_0.5.0    
    ## [41] htmltools_0.3.6  rvest_0.3.2      assertthat_0.2.0 mnormt_1.5-5    
    ## [45] colorspace_1.3-2 stringi_1.1.5    lazyeval_0.2.0   munsell_0.4.3   
    ## [49] broom_0.4.2
