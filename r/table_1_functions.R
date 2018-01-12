# ==============================================================================
# Functions for WHI Sexual Function Table 1
# Version: 3.2.2
# Brad Cannell
# 2017-03-27
# ==============================================================================

# Get group sizes for second row of table
# ==============================================================================
get_n <- function(x, ...) {
  summarise(x, n = n()) %>% 
    mutate(n = paste0("N = ", format(n, big.mark = ",")))
}

# Function to calculate n and percent for a single categorical variable
# ==============================================================================
n_percent <- function(x, ...) {
  # Grab n's and format with commas
  n <- table(x) %>% format(., big.mark = ",") %>% as.data.frame()
  # Calculate percentages
  percent <- table(x) %>% prop.table() %>% `*`(100) %>% round(., 2) %>% as.data.frame()
  # Format percentages to always show 2 decimal places
  percent$Freq <- format(percent$Freq, nsmall = 2)
  # Paste together n and percent
  percent$Freq <- paste0(n$., " (", percent$Freq, " %)")
  # Rename columns
  names(percent) <- c("class", "statistics")
  percent$class  <- as.character(percent$class)
  percent
}

# Function to calculate n and mean for continuous variables
# ==============================================================================
n_mean <- function(x, ...) {
  # Grab n's and format with commas
  n <- sum(!is.na(x)) %>% format(., big.mark = ",")
  # Calculate mean and format to always show 2 decimal places
  mean <- mean(x, na.rm = TRUE) %>% round(., 2) %>% format(., nsmall = 2)
  # Paste together n and mean
  n_mean <- paste0(n, " (", mean, ")")
  # Coerce to data frame
  out <- data.frame(class = "", statistics = n_mean)
  out
}

# Function to calculate mean and sd for continuous variables
# ==============================================================================
mean_sd <- function(x, ...) {
  # Calculate mean and format to always show 1 decimal place
  mean <- mean(x, na.rm = TRUE) %>% round(., 2) %>% format(., nsmall = 2)
  # Calculate sd and format to always show 1 decimal place
  sd <- sd(x, na.rm = TRUE) %>% round(., 2) %>% format(., nsmall = 2)
  # Paste together n and mean
  mean_sd <- paste0(mean, " (", sd, ")")
  # Coerce to data frame
  out <- data.frame(class = "", statistics = mean_sd)
  out
}

# Function to call on all continuous variables for all groups and horizontally
# join all groups together into a single data frame
# ==============================================================================
continuous_rows <- function(variables, groups, ...) {

  # Function for use in if/else below
  build_output_df <- function(x, ...) {
    # Calculate statistics
    out <- mean_sd(x)
    # Add variable name
    out[["variable"]] <- var_name
    # Reorder columns
    out <- out[, c(3, 1, 2)]
    # Use group (df) name as column name
    names(out)[3] <- compare_groups[[g]]
    out
  }

  for (i in seq_along(variables)) {
    # Grab variable name
    var_name <- variables[[i]]

    for (g in seq_along(groups)) {
      # Grab group (df) name
      col <- get(groups[[g]])
      # Grab data (df + variable)
      var <- col[[variables[[i]]]]

      if (g == 1) {
        row <- build_output_df(var)
      } else {
        temp <- build_output_df(var)
        row <- left_join(row, temp, by = c("variable", "class"))
      }
    }

    # Row bind variables 
    if (i == 1) {
      all_rows <- row
    } else {
      temp <- row
      all_rows <- bind_rows(all_rows, temp)
    }
  }
  
  # Clean up NA's
  all_rows <- all_rows %>%
    map_if(is.factor, as.character) %>%
    map_df(., function(x) {
      x[is.na(x)] <- ""
      x
    })
  all_rows
}

# Function to call n_percent on all categorical variables for all groups and
# horizontally join all groups together into a single data frame
# ==============================================================================
categorical_rows <- function(variables, groups, ...) {

  # Function for use in if/else below
  build_output_df <- function(x, ...) {
    # Calculate statistics
    out <- n_percent(x)
    # Add variable name
    out[["variable"]] <- var_name
    # Reorder columns
    out <- out[, c(3, 1, 2)]
    # Use group (df) name as column name
    names(out)[3] <- compare_groups[[g]]
    out
  }

  for (i in seq_along(variables)) {
    # Grab variable name
    var_name <- variables[[i]]

    for (g in seq_along(groups)) {
      # Grab group (df) name
      col <- get(groups[[g]])
      # Grab data (df + variable)
      var <- col[[variables[[i]]]]

      if (g == 1) {
        row <- build_output_df(var)
      } else {
        temp <- build_output_df(var)
        row <- left_join(row, temp, by = c("variable", "class"))
      }
    }

    # Row bind variables
    # Insert blank row between variables
    if (i == 1) {
      all_rows <- row
    } else {
      temp <- row
      all_rows <- bind_rows(all_rows, temp)
    }
  }
  # Clean up NA's
  all_rows <- all_rows %>%
    map_if(is.factor, as.character) %>%
    map_df(., function(x) {
      x[is.na(x)] <- ""
      x
    })
  all_rows
}

# Vertically join continuous and categorical data frames
# table1 <- bind_rows(table1_continuous_rows, table1_categorical_rows)
