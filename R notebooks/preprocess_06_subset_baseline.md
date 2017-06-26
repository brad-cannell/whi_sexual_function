Preprocess 06: Subset Baseline Data
================
2017-06-26

``` r
# Load packages
library(tidyverse)
library(data.table)

# Load functions
source("../R scripts/functions.R")
```

-   Primary exposure of interest:
    -   Abuse (Yes / NO)
    -   Abuse (4-level)
-   Sexual activity in past year is another exposure of special interest. We are only interested in the association between abuse and sexual function among women that were sexually active.

-   Outcomes of interest:
    -   Sexual satisfaction
    -   Sexual frequency satisfaction
-   Covariates of interest:
    -   Age
    -   Race / ethnicity
    -   Education
    -   Income
    -   Marital status
    -   Sexual orientation
    -   Study component
    -   Parity
    -   Physical activity
    -   Alcohol use
    -   Caffeine use
    -   Smoking
    -   Hormone use
    -   Taking SSRIs
    -   Quality of life
    -   Depression
    -   BMI
    -   General health
    -   Hysterectomy
    -   Night sweats
    -   Hot flashes
    -   Vaginal dryness
    -   Urinary incontinence
    -   Chronic disease
-   The first set of analyses will be cross-sectional, and use only baseline measures

Currently, all 161,808 women are still represented in the data.

``` r
# Load data
analysis_09 <- read_rds("../data/analysis_09.rds")
check_data(analysis_09) # 1,432,448 observations and 127 variables
```

    ## 1,432,448 observations and 127 variables

``` r
dt <- as.data.table(analysis_09)
```

Tag baseline observations
=========================

Baseline is either each woman's first response to an abuse question or day 0 if she never responded to either abuse question.

``` r
dt[first_ab_obs == TRUE, baseline := TRUE]
dt[abuse_ever == -3 & days == 0, baseline := TRUE]
```

Subset the variables of interest
================================

2017-06-26: Added hypertension

``` r
dt <- dt[, .(id, days, abuse_d_f, abuse4cat_f, sexactiv_f, satisfied_f, freq_satisfied_f, satfrqsx_f, age,
             age_group_f, race_eth_f, edu4cat_f, inc5cat_f, married_f, sex_f, ctos_f, parity_f, texpwk, alcswk,
             f60caff, smoking_f, horm_f, hormnw_f, ssri_f, lifequal, pshtdep, bmi, good_health_f, hyst_f,
             night_sweats_f, hot_flashes_f, vag_dry_f, incont_f, chronic_disease_f, baseline, hypt_f)]
check_data(dt) # 1,432,448 observations and 36 variables
```

    ## 1,432,448 observations and 36 variables

------------------------------------------------------------------------

Missing sexual activity
=======================

------------------------------------------------------------------------

Sexual activity in the past year is not being used for modeling. Rather, we will drop women that were not sexually active in the previous year. Multiple imputation is not prediction. And therefore, it would be inappropriate to try to somehow use MI to predict which women were sexually active in the past year, and retain their data for analysis.

> The main message is that we cannot evaluate imputation methods by their ability to re-create the true data, or by their ability to optimize classification accuracy. Imputation is not prediction. van Buuren, Stef (2012-05-14). Flexible Imputation of Missing Data (Chapman & Hall/CRC Interdisciplinary Statistics) (Page 46). Taylor and Francis CRC ebook account. Kindle Edition.

``` r
# What is the frequency distribution for sexually active at baseline?
dt[baseline == 1][order(sexactiv_f)][, .(Women = .N), by = sexactiv_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    sexactiv_f Women Cumsum   Percent
    ## 1:         No 71239  71239 44.026871
    ## 2:        Yes 83402 154641 51.543805
    ## 3:         NA  7167 161808  4.429324

``` r
71239 + 7167 # 78,406 women have no or NA for sexactive_f at baseline.
```

    ## [1] 78406

All rows for all 78,406 women that did not report being sexually active in the previous year will be dropped from the data.

``` r
# Gather id's with Yes for sexactiv_f at baseline.
keep_ids <- dt[baseline == 1 & sexactiv_f == "Yes", id]

# Keep rows for sexually active women
dt <- dt[id %in% keep_ids]
count_ids(dt$id) # 83,402 unique women
```

    ## 83,402 unique women

How many women report "never having sex" on the sexual orientation question

``` r
dt[, length(unique(id)), by = sex_f]
```

    ##                             sex_f    V1
    ## 1:     Sex with a man or with men 80895
    ## 2:                             NA  1368
    ## 3:    Sex with both men and women   863
    ## 4:             Have never had sex    73
    ## 5: Sex with a woman or with women   203

``` r
drop_ids <- dt[baseline == 1 & sex_f == "Have never had sex", id]
drop_ids <- which(dt$id %in% drop_ids)
dt <- dt[-drop_ids]
count_ids(dt$id) # 83,329 unique women
```

    ## 83,329 unique women

``` r
check_data(dt) # 744,745 observations and 36 variables
```

    ## 744,745 observations and 36 variables

``` r
# Clean up
rm(keep_ids, drop_ids)
```

------------------------------------------------------------------------

Missing abuse
=============

------------------------------------------------------------------------

How many women are missing abuse (2-level) at baseline?

``` r
dt[baseline == 1][order(abuse_d_f)][, .(Women = .N), by = abuse_d_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                         abuse_d_f Women Cumsum      Percent
    ## 1:             Abuse not measured     2      2  0.002400125
    ## 2: Answered phyab, but not verbab   115    117  0.138007176
    ## 3: Answered verbab, but not phyab    43    160  0.051602683
    ## 4:                             No 73759  73919 88.515402801
    ## 5:                            Yes  9410  83329 11.292587215

Of the 83,402 women that reported sexual activity in the past year, 2 never answered either abuse question and 158 women's abuse status could not be determined from their answers. The abuse status (2-level) can be determined for over 99% of the 83,402 women who reported sexual activity in the past year.

How many women are missing abuse (4-level) at baseline?

``` r
dt[baseline == 1][order(abuse4cat_f)][, .(Women = .N), by = abuse4cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                  abuse4cat_f Women Cumsum      Percent
    ## 1: Physical and verbal abuse   824    824  0.988851420
    ## 2:       Physical abuse only   188   1012  0.225611732
    ## 3:         Verbal abuse only  8374   9386 10.049322565
    ## 4:  Did not experience abuse 73759  83145 88.515402801
    ## 5:    Can't determine V no P    60  83205  0.072003744
    ## 6:    Can't determine P no V   122  83327  0.146407613
    ## 7:        Abuse not measured     2  83329  0.002400125

Of the 83,402 women that reported sexual activity in the past year, 2 never answered either abuse question and 182 women's abuse status could not be determined from their answers. The abuse status (4-level) can be determined for over 99% of the 83,402 women who reported sexual activity in the past year.

We will drop observations from the 182 women who's abuse status at baseline was missing or could not be determined from their responses.

``` r
# Set alternate codings for missing to NA
dt[, abuse_d_f := if_else(abuse_d_f %in% c("No", "Yes"), abuse_d_f, NA_integer_)]
dt[baseline == 1][order(abuse_d_f)][, .(Women = .N), by = abuse_d_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    abuse_d_f Women Cumsum  Percent
    ## 1:        No 73759  73759 88.51540
    ## 2:       Yes  9410  83169 11.29259
    ## 3:        NA   160  83329  0.19201

``` r
# Set alternate codings for missing to NA
keep <- c("Physical and verbal abuse", "Physical abuse only", "Verbal abuse only", "Did not experience abuse")
dt[, abuse4cat_f := if_else(abuse4cat_f %in% keep, abuse4cat_f, NA_integer_)]
dt[baseline == 1][order(abuse4cat_f)][, .(Women = .N), by = abuse4cat_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                  abuse4cat_f Women Cumsum    Percent
    ## 1: Physical and verbal abuse   824    824  0.9888514
    ## 2:       Physical abuse only   188   1012  0.2256117
    ## 3:         Verbal abuse only  8374   9386 10.0493226
    ## 4:  Did not experience abuse 73759  83145 88.5154028
    ## 5:                        NA   184  83329  0.2208115

``` r
# Gather id's without NA for abuse4cat_f at baseline.
ids <- dt[baseline == 1 & !is.na(abuse4cat_f), id]

# Keep rows with non-missing abuse4cat
dt <- dt[id %in% ids]
count_ids(dt$id) # 83,145 unique women
```

    ## 83,145 unique women

``` r
83329 - 83145 # 184
```

    ## [1] 184

184 women were dropped from the data because their abuse status (4-level) could not be determined.

``` r
check_data(dt) # 743,094 observations and 36 variables
```

    ## 743,094 observations and 36 variables

``` r
# Clean up
rm(keep, ids)
```

------------------------------------------------------------------------

Missing sexual satisfaction
===========================

------------------------------------------------------------------------

How many women are missing sexual satisfaction at baseline?

``` r
dt[baseline == 1][order(satisfied_f)][, .(Women = .N), by = satisfied_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    satisfied_f Women Cumsum   Percent
    ## 1:          No 18676  18676 22.461964
    ## 2:         Yes 61208  79884 73.615972
    ## 3:          NA  3261  83145  3.922064

How many women are missing sexual frequency satisfaction at baseline?

``` r
dt[baseline == 1][order(freq_satisfied_f)][, .(Women = .N), by = freq_satisfied_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    freq_satisfied_f Women Cumsum   Percent
    ## 1:               No 27191  27191 32.703109
    ## 2:              Yes 52082  79273 62.639966
    ## 3:               NA  3872  83145  4.656925

Only 4% of women are missing sexual satisfaction at baseline, and only 5% of women are missing sexual frequency satisfaction at baseline. At some point, we may want to come back and impute sexual satisfaction and sexual frequency satisfaction longitudinally. For now, we will impute them from other variables in the data set.

Save progress

``` r
analysis_10 <- as_tibble(dt)
write_rds(analysis_10, path = "../data/analysis_10.rds")
```

------------------------------------------------------------------------

Create data subsets for Table 1 (prior to multiple imputation)
==============================================================

------------------------------------------------------------------------

``` r
# Load data
analysis_10 <- read_rds("../data/analysis_10.rds")
check_data(analysis_10) # 743,094 observations and 36 variables
```

    ## 743,094 observations and 36 variables

``` r
count_ids(analysis_10$id) # 83,145 unique women
```

    ## 83,145 unique women

``` r
dt <- as.data.table(analysis_10)
```

 

Currently, the data includes information from 83,218 unique women. All women reported sexual activity in the past year. Additionally, each woman's abuse status can be determined.

Subset baseline observations only
---------------------------------

``` r
baseline_only <- dt %>% filter(baseline == TRUE)

# Drop the baseline variable
baseline_only$baseline <- NULL

check_data(baseline_only) # 83,145 observations and 35 variables
```

    ## 83,145 observations and 35 variables

Create subgroups for Table 1 (no, any, verbal only, phys only, both)
--------------------------------------------------------------------

``` r
no_abuse            <- baseline_only %>% filter(abuse_d_f == "No")
any_abuse           <- baseline_only %>% filter(abuse_d_f == "Yes")
verbal_only         <- baseline_only %>% filter(abuse4cat_f == "Verbal abuse only")
physical_only       <- baseline_only %>% filter(abuse4cat_f == "Physical abuse only")
verbal_and_physical <- baseline_only %>% filter(abuse4cat_f == "Physical and verbal abuse")

# Count total observations
nrow(no_abuse) + nrow(verbal_only) + nrow(physical_only) + nrow(verbal_and_physical) # 83145
```

    ## [1] 83145

### Data check: group sizes

    ## No abuse: 73759

    ## Any abuse: 9386

    ## No + Any: 83145

    ## Verbal only: 8374

    ## Physical only: 188

    ## Both: 824

    ## Total: 83145

Save subgroup data for Table 1
------------------------------

``` r
write_rds(baseline_only, path = "../data/baseline_only.rds")
write_rds(no_abuse, path = "../data/no_abuse.rds")
write_rds(any_abuse, path = "../data/any_abuse.rds")
write_rds(verbal_only, path = "../data/verbal_only.rds")
write_rds(physical_only, path = "../data/physical_only.rds")
write_rds(verbal_and_physical, path = "../data/verbal_and_physical.rds")
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
    ## [1] bindrcpp_0.1      data.table_1.10.4 dplyr_0.7.0       purrr_0.2.2.2    
    ## [5] readr_1.1.1       tidyr_0.6.3       tibble_1.3.3      ggplot2_2.2.1    
    ## [9] tidyverse_1.1.1  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10     bindr_0.1        cellranger_1.1.0 compiler_3.4.0  
    ##  [5] plyr_1.8.4       forcats_0.2.0    tools_3.4.0      digest_0.6.12   
    ##  [9] lubridate_1.6.0  jsonlite_1.4     evaluate_0.10    nlme_3.1-131    
    ## [13] gtable_0.2.0     lattice_0.20-35  rlang_0.1.1      psych_1.7.5     
    ## [17] yaml_2.1.14      parallel_3.4.0   haven_1.0.0      xml2_1.1.1      
    ## [21] stringr_1.2.0    httr_1.2.1       knitr_1.16       hms_0.3         
    ## [25] rprojroot_1.2    grid_3.4.0       glue_1.1.0       R6_2.2.0        
    ## [29] readxl_1.0.0     foreign_0.8-67   rmarkdown_1.6    modelr_0.1.0    
    ## [33] reshape2_1.4.2   magrittr_1.5     backports_1.0.5  scales_0.4.1    
    ## [37] htmltools_0.3.6  rvest_0.3.2      assertthat_0.2.0 mnormt_1.5-5    
    ## [41] colorspace_1.3-2 stringi_1.1.5    lazyeval_0.2.0   munsell_0.4.3   
    ## [45] broom_0.4.2
