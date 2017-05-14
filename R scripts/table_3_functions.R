# ==============================================================================
# Functions for WHI Sexual Function Table 3
# Version: 3.4.0
# Brad Cannell
# 2017-05-11
# ==============================================================================

# Function to calculate n and percent for table 3
# ==============================================================================
t3_section <- function(dt, group, outcome, desire = FALSE, ...){
  # Check data.table
  if(!("data.table" %in% class(dt))){
    stop("df must be a data.table")
  }

  # Setting up variables
  g  <- substitute(group) # So you don't have to pass in vars in quotes
  o  <- substitute(outcome)
  by <- paste0("list(", g, ", ", o, ")")
  by <- parse(text = substitute(by)) # parse things that you want to later pass through eval
  j  <- parse(text = paste0("list(", g, ", ", o, ", n_percent)"))

  if (desire == FALSE) {
    # Calculate stats and output df
    out <- dt[, .N, by = eval(by)][
      , cs := cumsum(N), by = eval(g)][
        , percent := round(N / max(cs) * 100, 1), by = eval(g)][
          , n_percent := paste0(format(N, big.mark = ","), " (", percent, ")")][
            , eval(j)]

    # Reshape wide for easier insertion into table 3
    k   <- as.character(o) # Get outcome variable in quotes
    out <- spread_(data = out, key = k, value = "n_percent") %>%
      select_(as.character(g), "Yes", "No")

  } else {

    # Desire is a little different
    j   <- parse(text = paste0("list(", g, ", satfrqsx_f, n_percent)"))
    k   <- parse(text = paste0("list(", g, ", n_percent)"))
    out <- dt[, .N, by = c(as.character(substitute(group)), "satfrqsx_f")][
      , cs := cumsum(N), by = eval(g)][
        , percent := round(N / max(cs) * 100, 1), by = eval(g)][
          , n_percent := paste0(format(N, big.mark = ","), " (", percent, ")")][
            , eval(j)][
              satfrqsx_f == "More often", eval(k)]
  }

  # Select the cells to pass directly into the table_03 shell
  args <- as.list(match.call())
  if (args$group == "abuse_d_f" & args$outcome == "satisfied_f"){
    out[]
  } else if (args$group == "abuse_d_f" & args$outcome == "freq_satisfied_f"){
    out[, 2:3]
  } else if (args$group == "abuse_d_f" & desire == TRUE){
    out[, 2]
  } else if (args$group == "abuse4cat_f") {
    out <- out[-1, ]
    out$abuse4cat_f <- factor(as.character(out$abuse4cat_f),
                              levels = c("Verbal abuse only", "Physical abuse only", "Physical and verbal abuse"))
    if (args$outcome == "satisfied_f") {
      out <- out[order(out$abuse4cat_f), ]
      out$abuse4cat_f <- as.character(out$abuse4cat_f)
      out[]
    } else if (args$outcome == "freq_satisfied_f"){
      out[order(out$abuse4cat_f), 2:3]
    } else if (args$group == "abuse4cat_f" & desire == TRUE){
      out[, 2]
    }
  }
}
