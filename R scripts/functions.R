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
