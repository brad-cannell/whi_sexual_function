# ==============================================================================
# Functions for WHI Sexual Function Preprocessing
# Version: 3.2.2
# Brad Cannell
# 2017-04-20
# ==============================================================================

# Simple function that returns observations a variables in data for data checks
check_data <- function(x, ...) {
  dims <- format(dim(x), big.mark = ",")
  cat(dims[1], "observations and", trimws(dims[2]), "variables")
}




# Count unique ids
count_ids <- function(x, ...) {
  count <- format(length(unique(x)), big.mark = ",")
  cat(count, "unique women")
}





# Distribute "have you ever" variables
# If they say "no", then all previous observations should be no. If you've 
# never had diabetes on day 100, then you didn't have diabetes on day 99.
# If they say "Yes", then all future observations should be yes. If you have 
# diabetes on day 100, then you have ever had diabetes on day 200.
# Updated 2017-09-20: No longer sets all values to 9 when there is a logical 
# error. Just the values that come after the logical error (i.e., 0's after 1)
distribute_ever <- function(x, check_logic = TRUE, ...) {
  if (check_logic) {
    if (length(which(x == 1)) > 0 & length(which(x == 0)) > 0) { # Check for 0's AND 1's
      if (min(which(x == 1)) < max(which(x == 0))) {             # Check for 0 after 1
        last_one                         <- max(which(x == 1))   # Index last "1"" by group
        x[seq_along(x) > last_one]       <- 9                    # Set x (0) to 9 if zero comes after 1
        x
      }
    }
  } else {
    ones                                 <- which(x == 1)        # Get indices for 1's
    if (length(ones) > 0) {
      first_1_by_group                   <- min(which(x == 1))   # Index first 1 by group
      x[seq_along(x) > first_1_by_group] <- 1                    # Set values of x at subsequent indices to 1
    }
    zeros                                <- which(x == 0)        # Get indices for 0's
    if (length(zeros) > 0) {
      last_0_by_group                    <- max(which(x == 0))   # Index last 0 by group
      x[seq_along(x) < last_0_by_group]  <- 0                    # Set values of x at previous indices to 0
    }
  }
  x
}




# Grab the closest value to baseline, that isn't baseline
# Run on variables with high proportion of missing data, and longitudinal
# information for that data, prior to MI
get_imp_value <- function(df, imp_vars, ...){

  if(!("data.table" %in% class(df))){
    stop("df must be a data.table")
  }

  for(i in seq_along(imp_vars)){
    iv   <- imp_vars[i]
    n2   <- paste0(iv, "_2")
    nd   <- paste0(iv, "_days")
    rows <- which(!is.na(df[[iv]]) & df$diff_days != 0)

    df[rows,
       c(n2, nd) := list(ifelse(diff_days == min(diff_days), get(iv), NA),
                         ifelse(diff_days == min(diff_days), diff_days, NA)),
       by = id]

    df[, c(n2, nd) := list(na.omit(get(n2))[1],
                           na.omit(get(nd))[1]),
       by = id]
  }
  df[]
}
