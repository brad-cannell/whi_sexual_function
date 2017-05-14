# ==============================================================================
# Create Table 3
# Version: 3.4.0
# Brad Cannell
# 2017-05-11
# ==============================================================================

compare_groups <- c("no_abuse", "any_abuse", "verbal_only", "physical_only", "verbal_and_physical")

table3 <- categorical_rows(variables = c("satsex_f", "satfrqsx_f"), groups = compare_groups)


table1 <- bind_rows(demo1, demo2, demo3, behavior1, behavior2, ment_hlth1, ment_hlth2, phys_hlth1, phys_hlth2,
                    phys_hlth3)

# Improve readability
table1 <- table1 %>%
  mutate(
    variable = if_else(variable == "age", "Age, n (mean)", variable),
    variable = if_else(variable == "prenum", "Parity, n (mean)", variable),
    variable = if_else(variable == "texpwk", "Physical activity (MET-hours/week), n (mean)", variable),
    variable = if_else(variable == "alcswk", "Alcohol servings per week, n (mean)", variable),
    variable = if_else(variable == "lifequal", "Quality of life, n (mean)", variable),
    variable = if_else(variable == "pshtdep", "Shortened CES-D/DIS, n (mean)", variable),
    variable = if_else(variable == "f60caff", "Dietary caffeine (mg), n (mean)", variable),
    variable = if_else(variable == "bmi", "Body Mass Index, n (mean)", variable),
    variable = if_else(variable == "age_group_f", "Age group, n (%)", variable),
    variable = if_else(variable == "ctos_f", "Clinical trial or observational study, n (%)", variable),
    variable = if_else(variable == "horm_f", "Female hormones ever, n (%)", variable),
    variable = if_else(variable == "hormnw_f", "Female hormones now, n (%)", variable),
    variable = if_else(variable == "hyst_f", "Hysterectomy ever, n (%)", variable),
    variable = if_else(variable == "diab_f", "Diabetes ever, n (%)", variable),
    variable = if_else(variable == "osteopor_f", "Osteoporosis ever, n (%)", variable),
    variable = if_else(variable == "cvd_f", "Cardiovascular disease ever, n (%)", variable),
    variable = if_else(variable == "arthrit_f", "Arthritis ever, n (%)", variable),
    variable = if_else(variable == "hypt_f", "Hypertension ever, n (%)", variable),
    variable = if_else(variable == "pad_f", "Peripheral arterial disease ever, n (%)", variable),
    variable = if_else(variable == "brca_f30_f", "Breast cancer ever, n (%)", variable),
    variable = if_else(variable == "ovryca_f", "Ovarian cancer eve, n (%)", variable),
    variable = if_else(variable == "endo_f30_f", "Endometrial cancer ever, n (%)", variable),
    variable = if_else(variable == "cervca_f", "Cervix cancer ever, n (%)", variable),
    variable = if_else(variable == "smoking_f", "Smoking status, n (%)", variable),
    variable = if_else(variable == "genhel_f", "General Health, n (%)", variable),
    variable = if_else(variable == "nightswt_f", "Night sweats, n (%)", variable),
    variable = if_else(variable == "vagdry_f", "Vaginal or genital dryness, n (%)", variable),
    variable = if_else(variable == "incont_f", "Ever leaked urine, n (%)", variable),
    variable = if_else(variable == "married_f", "Married, n (%)", variable),
    # variable = if_else(variable == "sexactiv_f", "Sexual activity in last year, n (%)", variable),
    variable = if_else(variable == "satsex_f", "Sexual satisfaction, n (%)", variable),
    variable = if_else(variable == "satfrqsx_f", "Sexual frequency satisfaction, n (%)", variable),
    variable = if_else(variable == "sex_f", "Who you have had sex with, n (%)", variable),
    variable = if_else(variable == "atrophy_f", "Atrophy, n (%)", variable),
    variable = if_else(variable == "ssri_f", "Taking SSRI, n (%)", variable),
    variable = if_else(variable == "race_eth_f", "Race and Ethnicity, n (%)", variable),
    variable = if_else(variable == "edu4cat_f", "Education, n (%)", variable),
    variable = if_else(variable == "inc5cat_f", "Income, n (%)", variable),
    variable = if_else(variable == "conditions", "Number of Health Conditions, n (mean)", variable)
  )

# Remove blank rows - kable doesn't like them
table1 <- table1 %>% filter(variable != "")

# Remove duplicate variable names for categorical variables
table1 <- table1 %>%
  group_by(variable) %>%
  mutate(
    x = duplicated(variable),
    x = if_else(variable == "", NA, x)
  ) %>%
  ungroup() %>%
  mutate(
    variable = if_else(x == TRUE, "", variable),
    variable = if_else(is.na(variable), "", variable),
    x = NULL
  )

rm(behavior1, behavior2, demo1, demo2, demo3, ment_hlth1, ment_hlth2,
   phys_hlth1, phys_hlth2, phys_hlth3, compare_groups, categorical_rows,
   continuous_rows, n_mean, n_percent)

# In Rmd file, source the code above, plug the resulting table1 object into the kable function.
