Preprocess 01: Read in SAS Data Set
================
Created: 2017-07-17 <br> Updated: 2017-09-20

------------------------------------------------------------------------

-   Individual form data sets were previously cleaned and duplicates (by id, days) were removed using SAS. However, after merging forms, there may be new duplicate rows by id/days.

-   Individual form data sets were previously merged by id and days in the program merge\_forms.

``` r
# Load packages
library(tidyverse)
library(lubridate)
library(haven)
library(feather)
library(data.table)

# Load functions
source("../R scripts/functions.R")
```

``` r
# Load data created in SAS
start  <- now()
merged <- read_sas("../data/merged.sas7bdat")
finish <- now()
difftime(finish, start)
```

    ## Time difference of 6.241399 mins

``` r
check_data(merged) # 2,448,638 observations and 817 variables
```

    ## 2,448,638 observations and 817 variables

Quick Save

``` r
write_feather(merged, path = "../data/merged.feather")
```

Load data again (if needed)

``` r
# merged <- read_feather("../data/merged.feather")
# check_data(merged) # 2,448,638 observations and 817
```

Set all variable names to lowercase
===================================

``` r
names(merged) <- tolower(names(merged))
```

Subset variables of interest
============================

``` r
analysis_01 <- merged %>% 
  select(
    # Administrative and Sociodemographic
      id, days, age, ager, race, ethnic, edu4cat, inc5cat, inc5cat_f20, marital, married, sex, ctos, parity,

      # Health Behavior
      texpwk, alcswk, f60alc, f60alcwk, f60caff, packyrs, packyrsc, horm, hormnw, tccode, livalor, livaln,

      # Health and Wellness
      lifequal, pshtdep, bmi, genhel, hyst, nightswt, hotflash, vagdry, incont, atrophy,

      # Chronic Disease
      arthrit, brca_f30, cervca, endo_f30, ovryca, cvd, diab, hypt, osteopor, pad, canc_f30, hip55, diabtrt,

      # Sexual Function
      sexactiv, satsex, satfrqsx,

      # Abuse
      phyab, verbab
  )
check_data(analysis_01) # 2,448,638 observations and 54 variables
```

    ## 2,448,638 observations and 54 variables

Change " " in character vectors to NA
=====================================

``` r
analysis_01 <- analysis_01 %>% 
  map_if(is.character, function(x) {
    x[x == ""] <- NA
    x
  }) %>% 
  as.tibble()
```

Data checks
===========

``` r
check_data(analysis_01) # 2,448,638 observations and 54 variables
```

    ## 2,448,638 observations and 54 variables

``` r
count_ids(analysis_01$id) # 161,808 unique women
```

    ## 161,808 unique women

``` r
sum(analysis_01$days == 0) # There are 166,347 day 0's, but only 161,808 women.
```

    ## [1] 166347

Why do some women have more than one day 0?

``` r
check <- analysis_01 %>%
  group_by(id) %>%
  mutate(
    day0 = if_else(days == 0, 1L, NA_integer_),
    count_day0 = sum(day0, na.rm = TRUE)
  ) %>%
  filter(count_day0 > 1)
```

Manually review. The multiple days come from form 44 - medications. Each separate medication has a separate row.

``` r
rm(check, start, finish)
```

Save in R binary format

``` r
write_feather(analysis_01, path = "../data/analysis_01.feather")
```

    ## R version 3.4.1 (2017-06-30)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.6
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
    ##  [1] bindrcpp_0.2      data.table_1.10.4 feather_0.3.1    
    ##  [4] haven_1.1.0       lubridate_1.6.0   dplyr_0.7.3      
    ##  [7] purrr_0.2.3       readr_1.1.1       tidyr_0.7.1      
    ## [10] tibble_1.3.4      ggplot2_2.2.1     tidyverse_1.1.1  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.12     cellranger_1.1.0 compiler_3.4.1   plyr_1.8.4      
    ##  [5] bindr_0.1        forcats_0.2.0    tools_3.4.1      digest_0.6.12   
    ##  [9] jsonlite_1.5     evaluate_0.10.1  nlme_3.1-131     gtable_0.2.0    
    ## [13] lattice_0.20-35  pkgconfig_2.0.1  rlang_0.1.2      psych_1.7.8     
    ## [17] yaml_2.1.14      parallel_3.4.1   xml2_1.1.1       httr_1.3.1      
    ## [21] stringr_1.2.0    knitr_1.17       hms_0.3          rprojroot_1.2   
    ## [25] grid_3.4.1       glue_1.1.1       R6_2.2.2         readxl_1.0.0    
    ## [29] foreign_0.8-69   rmarkdown_1.6    modelr_0.1.1     reshape2_1.4.2  
    ## [33] magrittr_1.5     backports_1.1.0  scales_0.5.0     htmltools_0.3.6 
    ## [37] rvest_0.3.2      assertthat_0.2.0 mnormt_1.5-5     colorspace_1.3-2
    ## [41] stringi_1.1.5    lazyeval_0.2.0   munsell_0.4.3    broom_0.4.2
