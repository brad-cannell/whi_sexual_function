Preprocess 03: Manage Abuse Variables
================
Created: 2017-07-17 <br> Updated: 2017-09-11

``` r
# Load packages
library(tidyverse)
library(feather)
library(data.table)
library(gmodels)

# Load functions
source("../R scripts/functions.R")
```

------------------------------------------------------------------------

Clean primary exposure variable of interest: Abuse
==================================================

------------------------------------------------------------------------

-   [You were physically abused?](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

Below are some hard things that sometimes happen to people. Please try to think back over the past year to remember if any of these things happened. Mark the answer that seems best. Over the past year: Were you physically abused by being hit, slapped, pushed, shoved, punched or threatened with a weapon by a family member or close friend?

-   [You were verbally abused?](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

Below are some hard things that sometimes happen to people. Please try to think back over the past year to remember if any of these things happened. Mark the answer that seems best. Over the past year: . Were you verbally abused by being made fun of, severely criticized, told you were a stupid or worthless person, or threatened with harm to yourself, your possessions, or your pets, by a family member or close friend?

-   [Possible responses:](https://www.whi.org/researchers/data/WhiDataDict/f37_ctos_inv.pdf)

1.  No
2.  Yes and upset me: Not too much
3.  Yes and upset me: Moderately
4.  Yes and upset me: Very much

Create dichotomous abuse at current observation variables
---------------------------------------------------------

``` r
# Load data
analysis_04 <- read_feather("../data/analysis_04.feather")
check_data(analysis_04) # 1,432,448 observations and 58 variables
```

    ## 1,432,448 observations and 58 variables

``` r
dt <- as.data.table(analysis_04)
```

### Create a dichotomous physical abuse (at current observation) variable

``` r
dt[, phyab_d := if_else(is.na(phyab) & is.na(verbab),  -3, # Abuse not measured
                if_else(is.na(phyab) & !is.na(verbab), -1, # Unable to determine
                if_else(phyab == 0,                     0, # Did not experience physical abuse
                if_else(phyab > 0,                      1, # Experienced physical abuse
                NA_real_))))]

dt[, phyab_d_f := factor(phyab_d, labels = c("Abuse not measured", "Unable to determine", "No", "Yes"))]

attributes(dt$phyab_d)$label   <- "Any physical abuse in the current observation"
attributes(dt$phyab_d_f)$label <- "Any physical abuse in the current observation"

# select(dt, id, days, verbab, phyab, phyab_d, phyab_d_f)

CrossTable(dt$phyab_d_f)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##                     |  Abuse not measured | Unable to determine |                  No |                 Yes | 
    ##                     |---------------------|---------------------|---------------------|---------------------|
    ##                     |             1059536 |                 423 |              368783 |                3706 | 
    ##                     |               0.740 |               0.000 |               0.257 |               0.003 | 
    ##                     |---------------------|---------------------|---------------------|---------------------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:  1,059,536 observations
# Unable to determine: 423 observations
# No:                  368,783 observations
# Yes:                 3,706 observations
```

### Create a dichotomous verbal abuse variable

``` r
dt[, verbab_d := if_else(is.na(verbab) & is.na(phyab),  -3, # Abuse not measured
                 if_else(is.na(verbab) & !is.na(phyab), -1, # Unable to determine
                 if_else(verbab == 0,                    0, # Did not experience verbal abuse
                 if_else(verbab > 0,                     1, # Experienced verbal abuse
                 NA_real_))))]

dt[, verbab_d_f := factor(verbab_d, labels = c("Abuse not measured", "Unable to determine", "No", "Yes"))]

attributes(dt$verbab_d)$label   <- "Any verbal abuse in the current observation"
attributes(dt$verbab_d_f)$label <- "Any verbal abuse in the current observation"

# select(dt, id, days, verbab, phyab, verbab_d, verbab_d_f)

CrossTable(dt$verbab_d_f)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##                     |  Abuse not measured | Unable to determine |                  No |                 Yes | 
    ##                     |---------------------|---------------------|---------------------|---------------------|
    ##                     |             1059536 |                 752 |              337497 |               34663 | 
    ##                     |               0.740 |               0.001 |               0.236 |               0.024 | 
    ##                     |---------------------|---------------------|---------------------|---------------------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:  1,059,536 observations
# Unable to determine: 752 observations
# No:                  337,497 observations
# Yes:                 34,663 observations
```

### Create a dichotomous any abuse variable

``` r
dt[, abuse_d := if_else(phyab_d == 1 | verbab_d == 1,   1, # Experienced abuse
                if_else(phyab_d == 0 & verbab_d == 0,   0, # Did not experience abuse
                if_else(is.na(phyab) & !is.na(verbab), -1, # Can't determine, answered verbab, but not phyab
                if_else(is.na(verbab) & !is.na(phyab), -2, # Can't determine, answered phyab, but not verbab
                if_else(is.na(phyab) & is.na(verbab),  -3, # Abuse not measured
                NA_real_)))))]

dt[, abuse_d_f := factor(abuse_d, labels = c("Abuse not measured", "Answered phyab, but not verbab",
                                             "Answered verbab, but not phyab", "No", "Yes"))]

attributes(dt$abuse_d)$label   <- "Was either type of abuse observed in the current observation"
attributes(dt$abuse_d_f)$label <- "Was either type of abuse observed in the current observation"

# select(dt, id, days, phyab, verbab, phyab_d, verbab_d, abuse_d, abuse_d_f) %>% filter(abuse_d == 1)

CrossTable(dt$abuse_d)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##           |        -3 |        -2 |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ##           |   1059536 |       727 |       337 |    336385 |     35463 | 
    ##           |     0.740 |     0.001 |     0.000 |     0.235 |     0.025 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                              1,059,536 observations
# Can't determine, answered phyab, but not verbab: 727 observations
# Can't determine, answered phyab, but not verbab: 337 observations
# No:                                              336,385 observations
# Yes:                                             35,463 observations
```

Create 4-level abuse at current observation variable
----------------------------------------------------

``` r
dt[, abuse4cat := if_else(phyab_d == 1 & verbab_d == 1,   3, # Experienced physical and verbal abuse
                  if_else(phyab_d == 1 & verbab_d == 0,   2, # Experienced physical abuse only
                  if_else(phyab_d == 0 & verbab_d == 1,   1, # Experienced verbal abuse only
                  if_else(phyab_d == 0 & verbab_d == 0,   0, # Did not experience abuse
                  if_else(is.na(phyab) & !is.na(verbab), -1, # Can't determine, answered verbab, but not phyab
                  if_else(is.na(verbab) & !is.na(phyab), -2, # Can't determine, answered phyab, but not verbab
                  if_else(is.na(phyab) & is.na(verbab),  -3, # Abuse not measured
                  NA_real_)))))))]

dt[, abuse4cat_f := factor(abuse4cat, levels = c(3, 2, 1, 0, -1, -2, -3), 
                           labels = c("Physical and verbal abuse", "Physical abuse only", "Verbal abuse only",
                                      "Did not experience abuse", "Can't determine V no P", 
                                      "Can't determine P no V", "Abuse not measured"))]

attributes(dt$abuse4cat)$label   <- "4-level abuse category observed in the current observation"
attributes(dt$abuse4cat_f)$label <- "4-level abuse category observed in the current observation"

# select(dt, id, days, phyab, verbab, abuse_d, abuse4cat) %>% filter(abuse_d != -2 & abuse4cat == -2)
# sum(is.na(dt$abuse4cat))

CrossTable(dt$abuse4cat)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##           |        -3 |        -2 |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ##           |   1059536 |       752 |       423 |    336385 |     31671 | 
    ##           |     0.740 |     0.001 |     0.000 |     0.235 |     0.022 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ## 
    ## 
    ##           |         2 |         3 | 
    ##           |-----------|-----------|
    ##           |       775 |      2906 | 
    ##           |     0.001 |     0.002 | 
    ##           |-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                              1,059,536 observations
# Can't determine, answered phyab, but not verbab: 752 observations
# Can't determine, answered verbab, but not phyab: 423 observations
# No:                                              336,385 observations
# Experienced verbal abuse only:                   31,671 observations
# Experienced physical abuse only:                 775 observations
# Experienced physical and verbal abuse:           2,906 observations
```

There are more people in the unable to determine groups for 4cat than for any abuse. For example, if someone said that the had experienced physical abuse, and had a missing value for verbal abuse, then we could say that they experienced abuse (abuse\_d == 1), but we cannot classify them into one of the 4-level categories. We could say that they experienced physical abuse, but we cannot say that they experienced physical abuse ONLY.

Creating abuse "ever" variables
-------------------------------

-   Did some testing. In the cases below, there was a big difference in processing time between data.table (~15 secs) and dplyr (~1.5 mins)

### Verbal abuse at any point

``` r
dt[, verbab_ever := if_else(all(verbab_d == -3, na.rm = TRUE), -3, # Abuse not measured
                    if_else(any(verbab_d ==  1, na.rm = TRUE),  1, # Experienced verbal abuse ever
                    if_else(any(verbab_d == -1, na.rm = TRUE), -1, # Unable to determine
                    if_else(any(verbab_d ==  0, na.rm = TRUE),  0, # Did not experience any verbal abuse ever
                    NA_real_)))),
  by = id]

# Make factor version
dt[, verbab_ever_f := factor(verbab_ever, labels = c("Abuse never measured", "Unable to determine", "No", "Yes"))]

attributes(dt$verbab_ever)$label   <- "Reported any verbab during entire follow-up"
attributes(dt$verbab_ever_f)$label <- "Reported any verbab during entire follow-up"

# select(dt, id, days, phyab, verbab, verbab_d, verbab_ever, verbab_ever_f) %>% filter(verbab_ever == -1)
# sum(is.na(dt$verbab_ever))

CrossTable(dt$verbab_ever)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##           |        -3 |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|-----------|
    ##           |       699 |      5865 |   1181129 |    244755 | 
    ##           |     0.000 |     0.004 |     0.825 |     0.171 | 
    ##           |-----------|-----------|-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                       699 observations
# Unable to determine:                      5,865 observations
# Did not experience any verbal abuse ever: 1,181,129 observations
# Experienced verbal abuse ever:            244,755 observations
```

### How many women is that?

``` r
dt %>% 
  group_by(verbab_ever_f) %>% 
  summarise(
    Women = n_distinct(id)
  ) %>% 
  mutate(
    Cumulative_Sum = cumsum(Women),
    Percent_of_Total = (Women / last(Cumulative_Sum) * 100) %>% round(1)
  )%>% 
  format(big.mark = ",")
```

    ## [1] "# A tibble: 4 x 4"                                            
    ## [2] "         verbab_ever_f  Women Cumulative_Sum Percent_of_Total"
    ## [3] "                <fctr>  <int>          <int>            <dbl>"
    ## [4] "1 Abuse never measured    156            156              0.1"
    ## [5] "2  Unable to determine    575            731              0.4"
    ## [6] "3                   No 134795         135526             83.3"
    ## [7] "4                  Yes  26282         161808             16.2"

``` r
# Abuse never measured: 156 women
# Unable to determine:  575 women
# No:                   134,795 women
# Yes:                  26,282 women
```

There are a lot of women (575) who, on at least one occasion, answered the question about physical abuse, but did not answer the question about verbal abuse.

``` r
# What is the distribution of responses to the physical abuse question among women who answered the phyical abuse question, but not the verbal abuse question?
dt %>% 
  filter(verbab_d_f == "Unable to determine") %>% 
  group_by(phyab_d_f) %>% 
  summarise(Count = n()) %>% 
  mutate(Percent = (Count / sum(Count) * 100) %>% round(1))
```

    ## # A tibble: 2 x 3
    ##   phyab_d_f Count Percent
    ##      <fctr> <int>   <dbl>
    ## 1        No   727    96.7
    ## 2       Yes    25     3.3

In about 96.7% of the cases when the physical abuse question was answered, but not the verbal abuse question, there was a "no" response the physical abuse question.

In the analysis of abuse at baseline, I don't think this will be a big issue; however, if I do longitudinal analysis in the future, I may need to impute these values.

### Physical abuse at any point

``` r
dt[, phyab_ever := if_else(all(phyab_d == -3, na.rm = TRUE), -3, # Abuse not measured
                   if_else(any(phyab_d ==  1, na.rm = TRUE),  1, # Experienced physical abuse ever
                   if_else(any(phyab_d == -1, na.rm = TRUE), -1, # Unable to determine
                   if_else(any(phyab_d ==  0, na.rm = TRUE),  0, # Did not experience any physical abuse ever
                   NA_real_)))),
  by = id]

# Make factor version
dt[, phyab_ever_f := factor(phyab_ever, labels = c("Abuse never measured", "Unable to determine", "No", "Yes"))]

attributes(dt$phyab_ever)$label   <- "Reported any phyab during entire follow-up"
attributes(dt$phyab_ever_f)$label <- "Reported any phyab during entire follow-up"

# select(dt, id, days, phyab, verbab, phyab_d, phyab_ever, phyab_ever_f) %>% filter(phyab_ever == 1)
# sum(is.na(dt$phyab_ever))

CrossTable(dt$phyab_ever)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##           |        -3 |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|-----------|
    ##           |       699 |      4154 |   1396872 |     30723 | 
    ##           |     0.000 |     0.003 |     0.975 |     0.021 | 
    ##           |-----------|-----------|-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                         699 observations
# Unable to determine:                        4,154 observations
# Did not experience any physical abuse ever: 1,396,872 observations
# Experienced physical abuse ever:            30,723 observations
```

### How many women is that?

``` r
dt %>% 
  group_by(phyab_ever_f) %>% 
  summarise(
    Women = n_distinct(id)
  ) %>% 
  mutate(
    Cumulative_Sum = cumsum(Women),
    Percent_of_Total = (Women / last(Cumulative_Sum) * 100) %>% round(1)
  )%>% 
  format(big.mark = ",")
```

    ## [1] "# A tibble: 4 x 4"                                            
    ## [2] "          phyab_ever_f  Women Cumulative_Sum Percent_of_Total"
    ## [3] "                <fctr>  <int>          <int>            <dbl>"
    ## [4] "1 Abuse never measured    156            156              0.1"
    ## [5] "2  Unable to determine    404            560              0.2"
    ## [6] "3                   No 157959         158519             97.6"
    ## [7] "4                  Yes   3289         161808              2.0"

``` r
# Abuse never measured: 156 women
# Unable to determine:  404 women
# No:                   157,959 women
# Yes:                  3,289 women
```

There are a lot of women (404) who, on at least one occasion, answered the question about verbal abuse, but did not answer the question about physical abuse.

``` r
# What is the distribution of responses to the physical abuse question among women who answered the phyical abuse question, but not the verbal abuse question?
dt %>% 
  filter(phyab_d_f == "Unable to determine") %>% 
  group_by(verbab_d_f) %>% 
  summarise(Count = n()) %>% 
  mutate(Percent = (Count / sum(Count) * 100) %>% round(1))
```

    ## # A tibble: 2 x 3
    ##   verbab_d_f Count Percent
    ##       <fctr> <int>   <dbl>
    ## 1         No   337    79.7
    ## 2        Yes    86    20.3

In about 79.7% of the cases when the verbal abuse question was answered, but not the physical abuse question, there was a "no" response the verbal abuse question.

In the analysis of abuse at baseline, I don't think this will be a big issue; however, if I do longitudinal analysis in the future, I may need to impute these values.

Any abuse (physical or verbal) at any point
-------------------------------------------

``` r
dt[, abuse_ever := if_else(phyab_ever == 1  | verbab_ever ==  1,  1, # Experienced abuse ever
                   if_else(phyab_ever == 0  & verbab_ever ==  0,  0, # Did not experience any abuse ever
                   if_else(phyab_ever == -3 & verbab_ever == -3, -3, # Abuse not measured
                   -1,                                               # Unable to determine
                   NA_real_)))]

# Make factor version
dt[, abuse_ever_f := factor(abuse_ever, labels = c("Abuse never measured", "Unable to determine", "No", "Yes"))]

attributes(dt$abuse_ever)$label   <- "Reported any abuse during entire follow-up"
attributes(dt$abuse_ever_f)$label <- "Reported any abuse during entire follow-up"

# select(dt, id, days, phyab_ever, verbab_ever, abuse_ever, abuse_ever_f) %>% filter(abuse_ever == 1)
# sum(is.na(dt$abuse_ever))

CrossTable(dt$abuse_ever)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  1432448 
    ## 
    ##  
    ##           |        -3 |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|-----------|
    ##           |       699 |      8634 |   1172939 |    250176 | 
    ##           |     0.000 |     0.006 |     0.819 |     0.175 | 
    ##           |-----------|-----------|-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                699 observations
# Unable to determine:               8,634 observations
# Did not experience any abuse ever: 1,172,939 observations
# Experienced abuse ever:            250,176 observations
```

How many women reported physical or verbal at some point?
---------------------------------------------------------

-   Not necessarily in the same observation.

``` r
dt %>% 
  group_by(abuse_ever_f) %>% 
  summarise(
    Women = n_distinct(id)
  ) %>% 
  mutate(
    Cumulative_Sum = cumsum(Women),
    Percent_of_Total = (Women / last(Cumulative_Sum) * 100) %>% round(1)
  ) %>% 
  format(big.mark = ",")
```

    ## [1] "# A tibble: 4 x 4"                                            
    ## [2] "          abuse_ever_f  Women Cumulative_Sum Percent_of_Total"
    ## [3] "                <fctr>  <int>          <int>            <dbl>"
    ## [4] "1 Abuse never measured    156            156              0.1"
    ## [5] "2  Unable to determine    846           1002              0.5"
    ## [6] "3                   No 133929         134931             82.8"
    ## [7] "4                  Yes  26877         161808             16.6"

``` r
# Abuse never measured: 156 women
# Unable to determine:  846 women
# No:                   133,929 women
# Yes:                  26,877 women
```

``` r
# Save progress
analysis_05 <- as_tibble(dt)
write_feather(analysis_05, path = "../data/analysis_05.feather")
```

------------------------------------------------------------------------

Create baseline abuse status
============================

------------------------------------------------------------------------

``` r
# Load data
analysis_05 <- read_feather("../data/analysis_05.feather")
check_data(analysis_05) # 1,432,448 observations and 72 variables
```

    ## 1,432,448 observations and 72 variables

``` r
dt <- as.data.table(analysis_05)
```

Create baseline physical abuse group based individual woman's initial observed status (not necissarily at observation 1)
------------------------------------------------------------------------------------------------------------------------

``` r
# Tag the first observation for each person with an observed value for phyab
dt[phyab_d != -1 & phyab_d != -3, first_phyab_obs := seq_len(.N) == 1, by = id]
attributes(dt$first_phyab_obs)$label <- "Tag first non-missing value for phyab"
# select(dt, id, days, phyab_d, first_phyab_obs)
```

``` r
# Phyab status at fist observed value (not necissarily at observation 1)
dt[first_phyab_obs == TRUE, first_phyab := phyab]
dt[, first_phyab := na.omit(first_phyab)[1], by = id]
attributes(dt$first_phyab)$label <- "Phyab status at first non-missing value for phyab"
# select(dt, id, days, phyab, phyab_d, first_phyab_obs, first_phyab) %>% filter(first_phyab == 3)
```

Create baseline verbal abuse group based individual woman's initial observed status (not necissarily at observation 1)
----------------------------------------------------------------------------------------------------------------------

``` r
# Tag the first observation for each person with an observed value for verbab
dt[verbab_d != -1 & verbab_d != -3, first_verbab_obs := seq_len(.N) == 1, by = id]
attributes(dt$first_verbab_obs)$label <- "Tag first non-missing value for verbab"
# select(dt, id, days, verbab_d, first_verbab_obs)
```

``` r
# Verbab status at fist observed value (not necissarily at observation 1)
dt[first_verbab_obs == TRUE, first_verbab := verbab]
dt[, first_verbab := na.omit(first_verbab)[1], by = id]
attributes(dt$first_verbab)$label <- "Verbab status at first non-missing value for verbab"
# select(dt, id, days, verbab, verbab_d, first_verbab_obs, first_verbab) %>% filter(first_verbab == 3)
```

Create dichotomous abuse / no abuse (physical or verbal) at baseline based on woman's initial observed status
-------------------------------------------------------------------------------------------------------------

-   Tag the first observation for each woman with an observed value for verbab OR phyab

-   Use and instead of or because if one type of abuse is missing, then abuse status is unknown. If abuse status is unknown, then it isn't really their first observation of abuse.

-   No, the first observation is the first observation, even if one type is missing for the first observation

``` r
# Tag the first time first_phyab_obs OR first_verbab_obs is TRUE
dt[, x := first_phyab_obs == TRUE | first_verbab_obs == TRUE]
dt[x == TRUE, first_ab_obs := seq_len(.N) == 1, by = id]
attributes(dt$first_verbab_obs)$label <- "Tag first observed value of any abuse"
# select(dt, id, days, phyab_d, verbab_d, first_phyab_obs, first_verbab_obs, first_ab_obs) %>%
#   filter(id %in% c(103039, 103617, 104299, 104353, 112203))
dt$x <- NULL
```

 

### How many women have a non-missing response to the abuse question at WHI day 0?

``` r
dt[days == 0, .N, by = abuse_d][abuse_d != -3, CumSum := cumsum(N)][]
```

    ##    abuse_d      N CumSum
    ## 1:      -3 149848     NA
    ## 2:       0  10603  10603
    ## 3:       1   1321  11924
    ## 4:      -1     18  11942
    ## 5:      -2     18  11960

Only 11,960 women responded to the abuse questions on WHI day 0.

### What is the distribution of days when women answered the abuse questions look like?

``` r
dt[first_ab_obs == 1, .(Min = min(days), Mean = mean(days), Median = median(days), Max = max(days))]
```

    ##     Min      Mean Median  Max
    ## 1: -867 -29.87915    -22 3981

``` r
# How many women have a first abuse observation?
dt %>% 
  summarise(
    `Total in Data` = unique(id) %>% length(),
    `Total with first_ab_obs` = sum(first_ab_obs, na.rm = TRUE),
    `Total without first_ab_obs` = `Total in Data` - `Total with first_ab_obs`,
    `Percent with at least one obs` = `Total with first_ab_obs` / `Total in Data` * 100
  )
```

    ##   Total in Data Total with first_ab_obs Total without first_ab_obs
    ## 1        161808                  161652                        156
    ##   Percent with at least one obs
    ## 1                      99.90359

``` r
# 156 matches the expected number from above - 156 women never have any measure of abuse.
```

``` r
# At the first abuse observation, how many are complete (i.e., a measure of phyab AND verbab)?
dt %>% 
  summarise(
    `Phyab Missing`    = sum(first_ab_obs == TRUE & (phyab_d == -1 | phyab_d == -3), na.rm = TRUE),
    `Verbab Missing`   = sum(first_ab_obs == TRUE & (verbab_d == -1 | verbab_d == -3), na.rm = TRUE),
    Total              = `Phyab Missing` + `Verbab Missing`,
    `Total Complete`   = 161808 - Total,
    `Percent Complete` = `Total Complete` / 161808 * 100
  )
```

    ##   Phyab Missing Verbab Missing Total Total Complete Percent Complete
    ## 1           141            288   429         161379         99.73487

``` r
# 429 women are missing a measure for one form of abuse at the first occation that they answer the question about either form of abuse.
```

99.9 percent of women have at least one measure of one form of abuse. Additionally, at their first measure of abuse, 99.7% of women have either a yes or no response for BOTH physical AND verbal abuse.

``` r
# At the first abuse observation, how many are incomplete?
# How many, when incomplete, have a yes response to one type of abuse or the other?
dt %>% 
  mutate(
    incomplete = first_ab_obs == TRUE & ((phyab_d == -1 | phyab_d == -3) | (verbab_d == -1 | verbab_d == -3)),
    inc_w_yes  = incomplete == TRUE & (phyab_d == 1 | verbab_d == 1)
  ) %>% 
  summarise(
    Incomplete = sum(incomplete, na.rm = TRUE),
    `Incomplete with Yes` = sum(inc_w_yes, na.rm = TRUE),
    `Unable to determine` = Incomplete - `Incomplete with Yes`
  )
```

    ##   Incomplete Incomplete with Yes Unable to determine
    ## 1        429                  60                 369

``` r
# 429 women are missing a measure for one form of abuse at the first occation that they answer the question about either form of abuse.
```

At the first observation in which they give an response to either abuse question, 429 women answer only one of the abuse questions. Of those, 60 said yes to the question they answered, and 369 said no to the question they answered - leaving us unable to determine their abuse status.

Any abuse (physical or verbal) at baseline
------------------------------------------

``` r
dt[first_ab_obs == TRUE, 
   first_ab := if_else(phyab_d ==  1 | verbab_d ==  1,  1, # Experienced abuse at baseline
               if_else(phyab_d ==  0 & verbab_d ==  0,  0, # Did not experience any abuse at baseline
               if_else(phyab_d == -3 & verbab_d == -3, -3, # Abuse not measured
               -1,                                         # Unable to determine
               NA_real_)))]

# Make factor version
dt[, first_ab_f := factor(first_ab, levels = c(-3, -1, 0, 1), 
                          labels = c("Abuse never measured", "Unable to determine", "No", "Yes"))]

attributes(dt$first_ab)$label   <- "Abuse status at first measure"
attributes(dt$first_ab_f)$label <- "Abuse status at first measure"

# select(dt, id, days, phyab_d, verbab_d, first_ab_obs, first_ab, first_ab_f) %>% filter(first_ab == -1)

CrossTable(dt$first_ab)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  161652 
    ## 
    ##  
    ##           |        -1 |         0 |         1 | 
    ##           |-----------|-----------|-----------|
    ##           |       369 |    142931 |     18352 | 
    ##           |     0.002 |     0.884 |     0.114 | 
    ##           |-----------|-----------|-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                       0 women (women w/o first measure not included)
# Unable to determine:                      369 women
# Did not experience any abuse at baseline: 142,931 women
# Experienced abuse at baseline:            18,352 women
```

### Distribute firstab across all observations within id

``` r
dt[, first_ab := na.omit(first_ab)[1], by = id]
# select(dt, id, days, phyab_d, verbab_d, first_ab_obs, first_ab)
```

Create categorical variable (no abuse, verbal only, physical only, physical and verbal) based on woman's initial observed status
--------------------------------------------------------------------------------------------------------------------------------

``` r
dt[first_ab_obs == TRUE, 
   first_abuse4cat := if_else(phyab_d ==   1 & verbab_d ==  1, 3, # Experienced physical and verbal at baseline
                      if_else(phyab_d ==   1 & verbab_d ==  0, 2, # Physical only
                      if_else(phyab_d ==   0 & verbab_d ==  1, 1, # Verbal only
                      if_else(phyab_d ==   0 & verbab_d ==  0, 0, # No abuse
                      if_else(phyab_d ==  -1,                 -1, # Answered verbab, but not phyab
                      if_else(verbab_d == -1,                 -2, # Answered phyab, but not verbab
                                                              -3, # Abuse not measured
                      NA_real_))))))]

# Make factor version
dt[, first_abuse4cat_f := factor(first_abuse4cat, levels = c(3, 2, 1, 0, -1, -2, -3), 
                          labels = c("Experienced P and V abuse", "Experienced P abuse only", 
                                     "Experienced V abuse only", "Did not experience abuse", 
                                     "Can't determine V no P", "Can't determine P no V", "Abuse not measured"))]

attributes(dt$first_abuse4cat)$label   <- "4-level abuse status at baseline"
attributes(dt$first_abuse4cat_f)$label <- "4-level abuse status at baseline"

# select(dt, id, days, phyab_d, verbab_d, first_ab_obs, first_abuse4cat, first_abuse4cat_f) %>%
#   filter(first_abuse4cat == -2)

CrossTable(dt$first_abuse4cat)
```

    ## 
    ##  
    ##    Cell Contents
    ## |-------------------------|
    ## |                       N |
    ## |         N / Table Total |
    ## |-------------------------|
    ## 
    ##  
    ## Total Observations in Table:  161652 
    ## 
    ##  
    ##           |        -2 |        -1 |         0 |         1 |         2 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ##           |       288 |       141 |    142931 |     16211 |       401 | 
    ##           |     0.002 |     0.001 |     0.884 |     0.100 |     0.002 | 
    ##           |-----------|-----------|-----------|-----------|-----------|
    ## 
    ## 
    ##           |         3 | 
    ##           |-----------|
    ##           |      1680 | 
    ##           |     0.010 | 
    ##           |-----------|
    ## 
    ## 
    ## 
    ## 

``` r
# Abuse not measured:                              0 women (women w/o first measure not included)
# Can't determine, answered phyab, but not verbab: 288 women
# Can't determine, answered verbab, but not phyab: 141 women
# No:                                              142,931 women
# Experienced verbal abuse only:                   16,211 women
# Experienced physical abuse only:                 401 women
# Experienced physical and verbal abuse:           1,680 women
```

``` r
# Save progress
analysis_06 <- as_tibble(dt)
write_feather(analysis_06, path = "../data/analysis_06.feather")
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
    ##  [1] bindrcpp_0.2      gmodels_2.16.2    data.table_1.10.4
    ##  [4] feather_0.3.1     dplyr_0.7.3       purrr_0.2.3      
    ##  [7] readr_1.1.1       tidyr_0.7.1       tibble_1.3.4     
    ## [10] ggplot2_2.2.1     tidyverse_1.1.1  
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
