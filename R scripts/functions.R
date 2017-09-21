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
distribute_ever <- function(x, ...) {
  # Check to see that x only includes NA, 0, and 1 values
  if (!(all(unique(na.omit(x)) %in% c(0, 1)))) {
    stop("x must be a numeric vector with values 0 or 1 only")
  }
  
  # Check to see if all NA
  # If not
  # Check to see if all non-NA values are 0's
  # If not
  # Check to see if all non-NA values are 1's
  # If not
  # Then there must be a combination of 0's and 1's
  
  if (all(is.na(x))) {                        # All NA's
    return(x)
    
  } else if (all(unique(na.omit(x)) == 0)) {  # All 0's (and NA)
    last_0  <- max(which(x == 0))             # Get index for last 0
    x[seq_along(x) < last_0] <- 0             # Set x to 0 at every position before last_0
    x
    
  } else if (all(unique(na.omit(x)) == 1)) {  # All 1's (and NA)
    first_1 <- min(which(x == 1))             # Get index for first 1
    x[seq_along(x) > first_1] <- 1            # Set x to 1 at every postion after first_1
    x
    
  } else {                                    # 0's and 1's
    
    # There is a mix of 0's and 1's
    # Check logical ordering of values
    # If there is a zero (no, never) AFTER a one (yes, ever), THEN
    # We want to flag as a logic error
    if (min(which(x == 1)) < max(which(x == 0))) {
      
      # What was the index of the first 0 that came after a 1?
      # What are the indicies for the 1's
      # What are the indicies for the 0's
      # What is the index for the lowest zero that is higher than the lowest index for a 1
      # Order is important
      zeros <- which(x == 0)                        # Indicies for all 0's
      ones  <- which(x == 1)                        # Indicies for all 1's
      first_1 <- min(ones)                          # Index for the first 1
      zeros_after_1 <- zeros[zeros > first_1]       # Subset of 0 indicies that are higher than first_1
      first_0_after_1 <- min(zeros_after_1)         # Index for the first 0 that comes after any 1
      x[seq_along(x) >= first_0_after_1] <- 9       # Set to 9 if index is on or after the logic error
      new_last_0 <- max(which(x == 0))              # New highest index for a 0 (no 0's after 1's anymore)
      x[seq_along(x) < new_last_0] <- 0             # Set x to 0 in all positions before new_last_0
      new_first_1 <- min(which(x == 1))             # New highst index for 1
      x[is.na(x) & seq_along(x) > new_first_1] <- 1 # If there are any NA's after 1's, set to 1
      x
      
      # There is a mix of 0's and 1's, but no 0's after 1's
    } else {
      last_0 <- max(which(x == 0))    # Last 0 in x (by group)
      x[seq_along(x) < last_0] <- 0   # Set x to 0 before last 0
      first_1 <- min(which(x == 1))   # First 1 in x (by group)
      x[seq_along(x) > first_1] <- 1  # Set x to 1 after first 1
      x
    }
  }
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
