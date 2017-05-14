# ==============================================================================
# Create Table 1
# Version: 3.2.2
# Brad Cannell
# 2017-03-30
# ==============================================================================

compare_groups <- c("no_abuse", "any_abuse", "verbal_only", "physical_only",
  "verbal_and_physical")

demo1 <- continuous_rows(variables = "age", groups = compare_groups)

demo2 <- categorical_rows(variables = c("age_group_f", "race_eth_f", "edu4cat_f",
  "inc5cat_f", "married_f", "sex_f", "ctos_f", "parity_f"),
  groups = compare_groups)

behavior1 <- continuous_rows(variables = c("texpwk", "alcswk", "f60caff"),
  groups = compare_groups)

behavior2 <- categorical_rows(variables = c("smoking_f", "horm_f", "hormnw_f",
  "ssri_f"), groups = compare_groups)

ment_hlth1 <- continuous_rows(variables = c("lifequal", "pshtdep", "bmi"),
  groups = compare_groups)

phys_hlth1 <- categorical_rows(variables = c("good_health_f", "hyst_f",
  "night_sweats_f", "hot_flashes_f", "vag_dry_f", "incont_f",
  "chronic_disease_f"), groups = compare_groups)

table1 <- bind_rows(demo1, demo2, behavior1, behavior2, ment_hlth1, phys_hlth1)

# Improve readability
table1 <- table1 %>%
  mutate(
    # Sociodemographics
    variable = if_else(variable == "age", "Age, n (mean)", variable),
    variable = if_else(variable == "age_group_f", "Age group, n (%)", variable),
    variable = if_else(variable == "race_eth_f", "Race and Ethnicity, n (%)", variable),
    variable = if_else(variable == "edu4cat_f", "Education, n (%)", variable),
    variable = if_else(variable == "inc5cat_f", "Income, n (%)", variable),
    variable = if_else(variable == "married_f", "Married, n (%)", variable),
    variable = if_else(variable == "sex_f", "Who you have had sex with, n (%)", variable),
    variable = if_else(variable == "ctos_f", "Clinical trial or observational study, n (%)", variable),
    variable = if_else(variable == "parity_f", "Parity, n (mean)", variable),

    # Health Behavior
    variable = if_else(variable == "texpwk", "Physical activity (MET-hours/week), n (mean)", variable),
    variable = if_else(variable == "alcswk", "Alcohol servings per week, n (mean)", variable),
    variable = if_else(variable == "f60caff", "Dietary caffeine (mg), n (mean)", variable),
    variable = if_else(variable == "smoking_f", "Smoking status, n (%)", variable),
    variable = if_else(variable == "horm_f", "Female hormones ever, n (%)", variable),
    variable = if_else(variable == "hormnw_f", "Female hormones now, n (%)", variable),
    variable = if_else(variable == "ssri_f", "Taking SSRI, n (%)", variable),

    # Health and Wellness
    variable = if_else(variable == "lifequal", "Quality of life, n (mean)", variable),
    variable = if_else(variable == "pshtdep", "Shortened CES-D/DIS, n (mean)", variable),
    variable = if_else(variable == "bmi", "Body Mass Index, n (mean)", variable),
    variable = if_else(variable == "good_health_f", "Good or better health, n (%)", variable),
    variable = if_else(variable == "hyst_f", "Hysterectomy ever, n (%)", variable),
    variable = if_else(variable == "night_sweats_f", "Night sweats, n (%)", variable),
    variable = if_else(variable == "hot_flashes_f", "Night sweats, n (%)", variable),
    variable = if_else(variable == "vag_dry_f", "Vaginal or genital dryness, n (%)", variable),
    variable = if_else(variable == "incont_f", "Ever leaked urine, n (%)", variable),
    variable = if_else(variable == "chronic_disease_f", "Chronic Disease, n (%)", variable)
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















