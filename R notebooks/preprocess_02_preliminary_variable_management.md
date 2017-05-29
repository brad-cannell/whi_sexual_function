Preprocess 02: Preliminary Variable Management
================
2017-05-29

``` r
# Load packages
library(tidyverse)
library(data.table)

# Load functions
source("../R scripts/functions.R")
```

------------------------------------------------------------------------

Dichotomize medications to reduce duplicated days
=================================================

------------------------------------------------------------------------

-   Tccode creates a separate row within id and day for each medication taken. We only care about SSRI's. We will collapse into a single row within id and day with a single variable indicating if an SSRI was reported or not.

-   Drug class from Erika (2017-03-09): 581600

``` r
# Load data
analysis_01 <- read_rds("../data/analysis_01.rds")
check_data(analysis_01) # 2,448,638 observations and 50 variables
```

    ## 2,448,638 observations and 50 variables

``` r
dt <- as.data.table(analysis_01)
```

Tag observations with 581600 and distribute SSRI within id and days
-------------------------------------------------------------------

``` r
# Create new var, SSRI, that is equal to 1 if any drug within id and day is an SSRI
dt[, ssri := if_else(any(tccode == "581600"), 1, 0, NA_real_), by = .(id, days)]
# select(dt, id, days, tccode, ssri) %>% filter(id == 100088)
check_data(dt) # 2,448,638 observations and 51 variables
```

    ## 2,448,638 observations and 51 variables

Now that SSRI is distributed within id and day, keep one row per day
--------------------------------------------------------------------

``` r
# Drop tccode
dt[, tccode := NULL]
check_data(dt) # 2,448,638 observations and 50 variables
```

    ## 2,448,638 observations and 50 variables

``` r
# Create new logical var, dup, that is TRUE when the row is a duplicate
dt[, dup := duplicated(dt)]
check_data(dt) # 2,448,638 observations and 51 variables
```

    ## 2,448,638 observations and 51 variables

``` r
# Count dup == TRUE
sum(dt$dup) # 1,016,190
```

    ## [1] 1016190

``` r
# Drop duplicate rows
dt <- dt[dup == FALSE, ]
check_data(dt) # 1,432,448 observations and 50 variables
```

    ## 1,432,448 observations and 51 variables

``` r
# Any duplicates by id and days?
dt[, dup := duplicated(.SD), .SDcols = c("id", "days")]
dt[, sum(dup)] # 0
```

    ## [1] 0

``` r
# Drop dup
dt$dup <- NULL
check_data(dt) # 1,432,448 observations and 50 variables
```

    ## 1,432,448 observations and 50 variables

``` r
# Save progress
analysis_02 <- dt
write_rds(analysis_02, path = "../data/analysis_02.rds")
```

At this point there are 1,432,448 observations and 50 variables. There are no duplicate rows in terms of id and days.

------------------------------------------------------------------------

Expand age across time
======================

------------------------------------------------------------------------

``` r
# Load data
analysis_02 <- read_rds("../data/analysis_02.rds")
check_data(analysis_02) # 1,432,448 observations and 50 variables
```

    ## 1,432,448 observations and 50 variables

``` r
dt <- as.data.table(analysis_02)
```

``` r
dt[, age_days := age * 365.25]
dt[, age_days_2 := na.omit(age_days)[1], by = id]
dt[, age_days_2 := age_days_2 + days]
dt[, age_2 := round(age_days_2 / 365.25)]
# select(dt, id, days, age, age_days, age_days_2, age_2)
dt[, age := age_2]
dt[, c("age_days", "age_days_2", "age_2") := NULL]
# select(dt, id, days, age)
dt[days == 0, .(.N, `Mean Age at Baseline` = mean(age), SD = sd(age), Min = min(age), Max = max(age))]
```

    ##         N Mean Age at Baseline       SD Min Max
    ## 1: 161808             63.23753 7.236422  49  81

``` r
# Save progress
analysis_03 <- dt
write_rds(analysis_03, path = "../data/analysis_03.rds")
```

------------------------------------------------------------------------

Create variables: obs, finalobs, finalage, numobs, finalyears
=============================================================

------------------------------------------------------------------------

``` r
# Load data
analysis_03 <- read_rds("../data/analysis_03.rds")
check_data(analysis_03) # 1,432,448 observations and 50 variables
```

    ## 1,432,448 observations and 50 variables

``` r
dt <- as.data.table(analysis_03)
```

Creating a observation number variable
--------------------------------------

``` r
dt <- dt[order(id, days), ]
dt[, obs := 1:.N, by = id]
# select(dt, id, days, obs)
dt[, .(`Mean Number of Observations Per Woman` = mean(obs), SD = sd(obs))]
```

    ##    Mean Number of Observations Per Woman       SD
    ## 1:                              6.015779 4.111518

Creating an age at final observation tag
----------------------------------------

``` r
dt[, final_obs := if_else(obs == max(obs), TRUE, FALSE), by = id]
attributes(dt$final_obs)$label <- "Tag largest observation number by id"
# select(dt, id, days, obs, final_obs)
sum(dt$final_obs) # 161,808
```

    ## [1] 161808

Creating age at final observation variable
------------------------------------------

``` r
dt[final_obs == TRUE, final_age := age, by = id]
dt[final_obs == TRUE, .(.N, `Mean Age at Last Observation` = mean(final_age), SD = sd(final_age), 
                        Min = min(final_age), Max = max(final_age))]
```

    ##         N Mean Age at Last Observation       SD Min Max
    ## 1: 161808                      68.2519 7.513456  50  90

Distribute final age across observations
----------------------------------------

``` r
dt[, final_age := max(final_age, na.rm = TRUE), by = id]
attributes(dt$final_age)$label <- "Age at final observation"
# select(dt, id, days, age, final_age)
```

Creating number of observations variable at final observation
-------------------------------------------------------------

``` r
dt[final_obs == TRUE, num_obs := obs]
dt[final_obs == TRUE, .(.N, `Mean Observations per Woman` = mean(obs), SD = sd(obs), Min = min(obs), 
                        Max = max(obs))]
```

    ##         N Mean Observations per Woman       SD Min Max
    ## 1: 161808                    8.852764 4.391865   2  25

Distribute num\_obs across observations
---------------------------------------

``` r
dt[, num_obs := max(num_obs, na.rm = TRUE), by = id]
attributes(dt$numobs)$label <- "Number of observations"
# select(dt, id, days, obs, num_obs)
```

Creating years since e/r at final observation variable
------------------------------------------------------

``` r
dt[, years := round(days / 365.25)]
dt[final_obs == TRUE, total_years := years]
dt[final_obs == TRUE, .(.N, `Mean Number of Years Enrolled` = mean(years), SD = sd(years), Min = min(years), 
                        Max = max(years))]
```

    ##         N Mean Number of Years Enrolled       SD Min Max
    ## 1: 161808                      5.014375 2.876696   0  11

Distribute total\_years across observations
-------------------------------------------

``` r
dt[, total_years := max(total_years, na.rm = TRUE), by = id]
attributes(dt$finalyears)$label <- "Total years since e/r @ last observation"
# select(dt, id, days, final_obs, years, total_years)
```

``` r
# Save progress
analysis_04 <- dt
write_rds(analysis_04, path = "../data/analysis_04.rds")
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
    ## [1] data.table_1.10.4 dplyr_0.5.0       purrr_0.2.2       readr_1.1.0      
    ## [5] tidyr_0.6.2       tibble_1.3.0      ggplot2_2.2.1     tidyverse_1.1.1  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10     cellranger_1.1.0 compiler_3.4.0   plyr_1.8.4      
    ##  [5] forcats_0.2.0    tools_3.4.0      digest_0.6.12    lubridate_1.6.0 
    ##  [9] jsonlite_1.4     evaluate_0.10    nlme_3.1-131     gtable_0.2.0    
    ## [13] lattice_0.20-35  psych_1.7.5      DBI_0.6-1        yaml_2.1.14     
    ## [17] parallel_3.4.0   haven_1.0.0      xml2_1.1.1       stringr_1.2.0   
    ## [21] httr_1.2.1       knitr_1.16       hms_0.3          rprojroot_1.2   
    ## [25] grid_3.4.0       R6_2.2.0         readxl_1.0.0     foreign_0.8-67  
    ## [29] rmarkdown_1.5    modelr_0.1.0     reshape2_1.4.2   magrittr_1.5    
    ## [33] backports_1.0.5  scales_0.4.1     htmltools_0.3.6  rvest_0.3.2     
    ## [37] assertthat_0.2.0 mnormt_1.5-5     colorspace_1.3-2 stringi_1.1.5   
    ## [41] lazyeval_0.2.0   munsell_0.4.3    broom_0.4.2