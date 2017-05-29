Preprocess 04: Manage Sexual Function Variables
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

Clean outcome variables: Sexual function
========================================

------------------------------------------------------------------------

``` r
# Load data
analysis_06 <- read_rds("../data/analysis_06.rds")
check_data(analysis_06) # 1,432,448 observations and 81 variables
```

    ## 1,432,448 observations and 81 variables

``` r
dt <- as.data.table(analysis_06)
```

Sexual activity in past year
----------------------------

[Did you have any sexual activity with a partner in the last year?](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Recode 9 to missing
dt[sexactiv == 9, sexactiv := NA_real_]
# select(dt, id, days, obs, sexactiv)
```

Many women do not have a measure for sexactiv in their first observation. Below I will create a variable that captures their sexactiv status at the first time it is measured.

``` r
# Tag first non-missing value of sexactiv
dt[!is.na(sexactiv), first_sexactiv := seq_len(.N) == 1, by = id]
# select(dt, id, days, obs, sexactiv, first_sexactiv)
```

Because of the way the question is worded, we can carry responses backwards within the year. However, this changes the interpretation to be somethin like "where you currently sexually active on this day?"

``` r
# Temp variable for response number
dt[!is.na(sexactiv), response_num := 1:.N, by = id]

# Temp variable for days at response
dt[!is.na(response_num), response_days := days]

# Carry backward response_days within id
dt[, response_days := na.locf(response_days, na.rm = FALSE, fromLast = TRUE), by = id]

# Absolute difference in days between days and response_days
dt[, diff := abs(response_days - days)]

# Carry backward sexactiv_f if diff <= 365
dt[diff <= 365, sexactiv := na.locf(sexactiv, na.rm = FALSE, fromLast = TRUE), by = id]

# select(dt, id, days, obs, sexactiv, response_num, response_days, diff)

# Drop temp vars
dt[, c("response_num", "response_days", "diff") := NULL]

# Create factor version
dt[, sexactiv_f := factor(sexactiv, labels = c("No", "Yes"))]

# Descriptives at first response
dt[first_sexactiv == 1, .(Women = .N), by = sexactiv_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    sexactiv_f Women Cumsum  Percent
    ## 1:         No 74008  74008 46.56085
    ## 2:        Yes 84941 158949 53.43915

``` r
# How many never respond?
dt[, all(is.na(first_sexactiv)), by = id][, .(`Never respond` = sum(V1))][] # 2,859
```

    ##    Never respond
    ## 1:          2859

Sexual satisfaction
-------------------

[How satisfied are you with your current sexual activities, either with a partner or alone? (Mark one oval.)](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Recode 9 to missing
dt[satsex == 9, satsex := NA_real_]

# Create factor version
dt[, satsex_f := factor(satsex, labels = c("Very unsatisfied", "A little unsatisfied", "Somewhat satisfied",
                                           "Very satisfied"))]

# Tag first non-missing value of satsex
dt[!is.na(satsex), first_satsex := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_satsex == 1, .(Women = .N), by = satsex_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                satsex_f Women Cumsum  Percent
    ## 1:       Very satisfied 58031  58031 40.37108
    ## 2:   Somewhat satisfied 40371  98402 28.08535
    ## 3: A little unsatisfied 23899 122301 16.62609
    ## 4:     Very unsatisfied 21443 143744 14.91749

``` r
# How many never respond?
dt[, all(is.na(first_satsex)), by = id][, .(`Never respond` = sum(V1))][] # 18,064
```

    ##    Never respond
    ## 1:         18064

``` r
# Create a dichotomous version
dt[, satisfied := if_else(satsex_f == "Somewhat satisfied" | satsex_f == "Very satisfied", 1, 0, NA_real_)]

# Create factor version
dt[, satisfied_f := factor(satisfied, labels = c("No", "Yes"))]

# Descriptives at first response
dt[first_satsex == 1, .(Women = .N), by = satisfied_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    satisfied_f Women Cumsum  Percent
    ## 1:         Yes 98402  98402 68.45642
    ## 2:          No 45342 143744 31.54358

Sexual frequency satisfaction
-----------------------------

[Are you satisfied with the frequency of your sexual activity, or would you like to have sex more or less often? (Mark one oval.)](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

``` r
# Recode 9 to missing
dt[satfrqsx == 9, satfrqsx := NA_real_]

# Create factor version
dt[, satfrqsx_f := factor(satfrqsx, labels = c("Less often", "Satisfied with current frequency", "More often"))]

# Tag first non-missing value of satsex
dt[!is.na(satfrqsx), first_satfrqsx := seq_len(.N) == 1, by = id]

# Descriptives at first response
dt[first_satfrqsx == 1, .(Women = .N), by = satfrqsx_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##                          satfrqsx_f Women Cumsum   Percent
    ## 1: Satisfied with current frequency 82770  82770 61.049278
    ## 2:                       More often 45977 128747 33.911594
    ## 3:                       Less often  6832 135579  5.039128

``` r
# How many never respond?
dt[, all(is.na(first_satfrqsx)), by = id][, .(`Never respond` = sum(V1))][] # 26,229
```

    ##    Never respond
    ## 1:         26229

``` r
# Create a dichotomous version
dt[, freq_satisfied := if_else(satfrqsx_f == "Satisfied with current frequency", 1, 0, NA_real_)]

# Create factor version
dt[, freq_satisfied_f := factor(freq_satisfied, labels = c("No", "Yes"))]

# Descriptives at first response
dt[first_satfrqsx == 1, .(Women = .N), by = freq_satisfied_f][, Cumsum := cumsum(Women)][
  , Percent := Women / max(Cumsum) * 100][]
```

    ##    freq_satisfied_f Women Cumsum  Percent
    ## 1:              Yes 82770  82770 61.04928
    ## 2:               No 52809 135579 38.95072

``` r
# Save progress
analysis_07 <- dt
write_rds(analysis_07, path = "../data/analysis_07.rds")
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
