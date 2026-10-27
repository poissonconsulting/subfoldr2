# Rounding follows the usepois report template, adapted from Cole (2015):
# estimates are rounded to the second significant digit of the SD (or 1/4 of
# the 95% CI), CLs to one fewer decimal place but at least two significant
# digits, estimates without CLs to three significant digits and s-values to one
# decimal place.

policy_cols <- c("estimate", "lower", "upper", "sd")

chk_format_column <- function(format_column, x, x_name = "`x`") {
  if (!length(format_column)) {
    return(invisible(format_column))
  }
  is_two_sided <- vapply(
    format_column,
    function(f) {
      rlang::is_formula(f, lhs = TRUE) && rlang::is_symbol(rlang::f_lhs(f))
    },
    TRUE
  )
  if (any(!is_two_sided)) {
    abort_chk(
      "`format_column` must be a list of two-sided formulas of the form `column ~ fun(.)`."
    )
  }
  cols <- vapply(
    format_column,
    function(f) rlang::as_string(rlang::f_lhs(f)),
    ""
  )
  if (anyDuplicated(cols)) {
    abort_chk("`format_column` must not include duplicate columns.")
  }
  if (any(cols %in% policy_cols)) {
    abort_chk(
      "`format_column` must not include the following columns: ",
      cc(intersect(cols, policy_cols), " or ")
    )
  }
  missing <- setdiff(cols, names(x))
  if (length(missing)) {
    abort_chk(
      "`format_column` columns must be in ",
      x_name,
      ": ",
      cc(missing, " and "),
      " not found"
    )
  }
  numeric <- vapply(x[cols], is.numeric, TRUE)
  if (any(!numeric)) {
    abort_chk(
      "`format_column` columns must be numeric: ",
      cc(cols[!numeric], " and ")
    )
  }
  invisible(format_column)
}

chk_round_as_estimate <- function(
  round_as_estimate,
  x,
  format_column,
  x_name = "`x`"
) {
  if (!length(round_as_estimate)) {
    return(invisible(round_as_estimate))
  }
  if (!is.numeric(x$estimate)) {
    abort_chk(
      x_name,
      " must have a numeric column 'estimate' when `round_as_estimate` is used."
    )
  }
  excluded <- c(policy_cols, "svalue")
  if (any(round_as_estimate %in% excluded)) {
    abort_chk(
      "`round_as_estimate` must not include the following columns: ",
      cc(intersect(round_as_estimate, excluded), " or ")
    )
  }
  missing <- setdiff(round_as_estimate, names(x))
  if (length(missing)) {
    abort_chk(
      "`round_as_estimate` columns must be in ",
      x_name,
      ": ",
      cc(missing, " and "),
      " not found"
    )
  }
  numeric <- vapply(x[round_as_estimate], is.numeric, TRUE)
  if (any(!numeric)) {
    abort_chk(
      "`round_as_estimate` columns must be numeric: ",
      cc(round_as_estimate[!numeric], " and ")
    )
  }
  formatted <- vapply(
    format_column,
    function(f) rlang::as_string(rlang::f_lhs(f)),
    ""
  )
  if (any(round_as_estimate %in% formatted)) {
    abort_chk(
      "`round_as_estimate` and `format_column` must not share columns: ",
      cc(intersect(round_as_estimate, formatted), " and ")
    )
  }
  invisible(round_as_estimate)
}

chk_policy_numeric <- function(x) {
  cols <- intersect(policy_cols, names(x))
  text <- cols[!vapply(x[cols], is.numeric, TRUE)]
  if (length(text)) {
    abort_chk(
      "`estimate`, `lower`, `upper` and `sd` columns in `x` must be numeric: ",
      cc(text, " and "),
      " not numeric"
    )
  }
  invisible(x)
}

chk_proportion_cols <- function(
  x,
  round_as_estimate = character(0),
  x_name = "`x`"
) {
  if (!is.numeric(x$estimate)) {
    abort_chk(
      x_name,
      " must have a numeric column 'estimate' when `proportion = TRUE`."
    )
  }
  cols <- intersect(c(policy_cols, round_as_estimate), names(x))
  values <- unlist(lapply(x[cols], as.numeric), use.names = FALSE)
  if (any(values < 0 | values > 1, na.rm = TRUE)) {
    abort_chk(
      "Columns ",
      cc(cols, " and "),
      " in ",
      x_name,
      " must be proportions between 0 and 1 when `proportion = TRUE`."
    )
  }
  invisible(x)
}

bound_distance <- function(x, proportion) {
  if (proportion) {
    return(pmin(abs(x), abs(1 - x)))
  }
  abs(x)
}

sd_dp <- function(lower, upper, sd) {
  sd <- ifelse(is.finite(sd) & sd > 0, sd, abs(upper - lower) / 4)
  ifelse(is.finite(sd) & sd > 0, 1 - floor(log10(sd)), NA_real_)
}

# Rounding can carry a value up to the next power of ten (0.997 to 1.00), which
# then needs one fewer decimal place for the same number of significant digits,
# so the decimal places are recalculated from the rounded value. Values rounded
# onto a proportion bound keep their decimal places so they never print as 1.
settle_dp <- function(x, dp, fun, proportion) {
  if (!length(x)) {
    return(dp)
  }
  rounded <- round(x, ifelse(is.finite(dp), dp, 0))
  distance <- bound_distance(rounded, proportion)
  ifelse(
    is.finite(distance) & distance != 0,
    pmin(dp, fun(rounded)),
    dp
  )
}

cl_dp <- function(x, dp, proportion) {
  fun <- function(x) {
    distance <- bound_distance(x, proportion)
    ifelse(
      is.finite(distance) & distance != 0,
      pmax(dp - 1, 1 - floor(log10(distance))),
      dp - 1
    )
  }
  settle_dp(x, fun(x), fun, proportion)
}

signif_dp <- function(x, digits, proportion = FALSE) {
  fun <- function(x) {
    distance <- bound_distance(x, proportion)
    ifelse(
      is.finite(distance) & distance != 0,
      digits - 1 - floor(log10(distance)),
      0
    )
  }
  settle_dp(x, fun(x), fun, proportion)
}

# Thousands separators are used for every value in a column when any of its
# values is 10,000 or more, so that four-digit values such as years are not
# separated unless they share a column with larger values.
big_mark <- function(x) {
  if (any(abs(x[is.finite(x)]) >= 10000)) "," else ""
}

format_finite <- function(x, fun) {
  out <- rep("", length(x))
  finite <- is.finite(x)
  out[finite] <- vapply(which(finite), fun, "")
  out[!finite & !is.na(x)] <- as.character(x[!finite & !is.na(x)])
  out
}

format_dp <- function(x, dp, mark = big_mark(x)) {
  x[is.na(dp)] <- NA
  format_finite(x, function(i) {
    value <- round(x[i], dp[i])
    if (value == 0) {
      value <- 0
    }
    formatC(
      value,
      digits = max(dp[i], 0),
      format = "f",
      big.mark = mark
    )
  })
}

format_data <- function(x, digits = 4) {
  if (is.integer(x)) {
    return(format_dp(x, rep(0, length(x))))
  }
  # trailing zeros are only added if they are significant digits of the value
  format_dp(x, pmin(signif_dp(x, digits), value_dp(x)))
}

value_dp <- function(x) {
  vapply(
    x,
    function(x) {
      if (!is.finite(x)) {
        return(0)
      }
      for (dp in 0:15) {
        if (isTRUE(all.equal(round(x, dp), x))) {
          return(dp)
        }
      }
      15
    },
    0
  )
}

format_unrounded <- function(x) {
  mark <- big_mark(x)
  format_finite(x, function(i) {
    trimws(formatC(
      x[i],
      digits = 15,
      format = "fg",
      big.mark = mark
    ))
  })
}

format_estimates <- function(x, proportion, round_as_estimate = character(0)) {
  estimate <- as.numeric(x$estimate)
  na <- rep(NA_real_, nrow(x))
  lower <- if (is.numeric(x$lower)) as.numeric(x$lower) else na
  upper <- if (is.numeric(x$upper)) as.numeric(x$upper) else na
  sd <- if (is.numeric(x$sd)) as.numeric(x$sd) else na

  dp <- sd_dp(lower, upper, sd)
  ci <- !is.na(dp)

  out <- list()
  estimate_dp <- signif_dp(estimate, 3, proportion)
  estimate_dp[ci] <- dp[ci]
  mark <- big_mark(estimate)
  out$estimate <- format_dp(estimate, estimate_dp, mark)

  # named columns are shown to the precision of the estimate in the same row
  for (col in round_as_estimate) {
    value <- as.numeric(x[[col]])
    has_dp <- is.finite(estimate)
    out[[col]] <- format_data(x[[col]])
    out[[col]][has_dp] <- format_dp(
      value[has_dp],
      estimate_dp[has_dp],
      big_mark(value)
    )
  }

  for (cl in intersect(c("lower", "upper"), names(x))) {
    if (!is.numeric(x[[cl]])) {
      next
    }
    value <- as.numeric(x[[cl]])
    mark <- big_mark(value)
    out[[cl]] <- format_dp(value, signif_dp(value, 2, proportion), mark)
    out[[cl]][ci] <- format_dp(
      value[ci],
      cl_dp(value[ci], dp[ci], proportion),
      mark
    )
  }
  if (is.numeric(x$sd)) {
    mark <- big_mark(sd)
    out$sd <- format_dp(sd, signif_dp(sd, 2), mark)
    out$sd[ci] <- format_dp(sd[ci], dp[ci], mark)
  }
  out
}

apply_format_column <- function(x, f, call) {
  fun <- rlang::as_function(rlang::new_formula(
    NULL,
    rlang::f_rhs(f),
    rlang::f_env(f)
  ))
  value <- fun(x)
  if (length(value) != length(x)) {
    abort_chk(
      "`format_column` function for column '",
      rlang::as_string(rlang::f_lhs(f)),
      "' must return a vector of the same length as the column.",
      call = call
    )
  }
  value
}

format_column_values <- function(x, f) {
  value <- apply_format_column(x, f, call = rlang::caller_call(3))
  if (is.numeric(value)) {
    return(format_unrounded(value))
  }
  value <- as.character(value)
  value[is.na(value)] <- ""
  value
}

format_other <- function(x) {
  na <- is.na(x)
  if (inherits(x, c("Date", "POSIXct", "hms"))) {
    x <- format(x)
  } else {
    x <- as.character(x)
  }
  x[na] <- ""
  x
}

escape_md <- function(x) {
  x <- gsub("\r?\n", " ", x)
  gsub("|", "\\|", x, fixed = TRUE)
}

align_decimal <- function(x) {
  has_dot <- grepl(".", x, fixed = TRUE)
  frac <- ifelse(has_dot, nchar(sub("^[^.]*", "", x)) - 1L, 0L)
  max_frac <- max(c(0L, frac[x != ""]))
  if (max_frac == 0L) {
    return(x)
  }
  pad <- ifelse(has_dot, max_frac - frac, max_frac + 1L)
  pad[x == ""] <- 0L
  paste0(x, strrep(" ", pad))
}

md_data <- function(x) {
  x[vapply(x, is.list, TRUE)] <- NULL
  x <- remove_geometry(x)
  as.data.frame(x)
}

is_whole_column <- function(x) {
  is.integer(x) || inherits(x, "integer64")
}

# classes such as units and integer64 do not support the rounding arithmetic
as_plain_numeric <- function(x) {
  if (is.numeric(x) && is.object(x)) as.double(x) else x
}

md_round <- function(x, proportion, format_column, round_as_estimate) {
  whole <- vapply(x, is_whole_column, TRUE)
  x[] <- lapply(x, as_plain_numeric)
  numeric <- vapply(x, is.numeric, TRUE)

  cols <- lapply(x, format_other)
  cols[numeric] <- lapply(x[numeric], format_data)
  cols[whole] <- lapply(x[whole], function(col) {
    format_dp(col, rep(0, length(col)))
  })

  if ("svalue" %in% names(x) && is.numeric(x$svalue)) {
    cols$svalue <- format_dp(x$svalue, rep(1, nrow(x)))
  }
  if (is.numeric(x$estimate)) {
    estimates <- format_estimates(x, proportion, round_as_estimate)
    cols[names(estimates)] <- estimates
  }
  for (f in format_column) {
    col <- rlang::as_string(rlang::f_lhs(f))
    cols[[col]] <- format_column_values(x[[col]], f)
  }
  cols
}

md_unrounded <- function(x) {
  x[] <- lapply(x, as_plain_numeric)
  numeric <- vapply(x, is.numeric, TRUE)
  cols <- lapply(x, format_other)
  cols[numeric] <- lapply(x[numeric], format_unrounded)
  cols
}

md_layout <- function(cols, header, numeric) {
  cols[numeric] <- lapply(cols[numeric], align_decimal)
  cols <- lapply(cols, escape_md)
  header <- escape_md(header)

  width <- pmax(
    3L,
    nchar(header, type = "width"),
    vapply(cols, function(col) max(c(0L, nchar(col, type = "width"))), 1L)
  )
  justify <- function(x, width, right) {
    pad <- strrep(" ", pmax(0L, width - nchar(x, type = "width")))
    if (right) paste0(pad, x) else paste0(x, pad)
  }
  row <- function(cells) paste0("| ", paste(cells, collapse = " | "), " |")

  header <- row(mapply(justify, header, width, numeric, USE.NAMES = FALSE))
  rule <- ifelse(
    numeric,
    paste0(strrep("-", width - 1L), ":"),
    paste0(":", strrep("-", width - 1L))
  )
  rule <- row(rule)
  body <- character(0)
  if (length(cols[[1]])) {
    cells <- mapply(justify, cols, width, numeric, SIMPLIFY = FALSE)
    cells <- do.call(cbind, unname(cells))
    body <- apply(cells, 1, row)
  }
  c(header, rule, body)
}

md_table <- function(
  x,
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0),
  round = TRUE
) {
  x <- md_data(x)
  if (!ncol(x)) {
    return(character(0))
  }
  numeric <- vapply(x, is.numeric, TRUE)
  cols <- if (round) {
    md_round(x, proportion, format_column, round_as_estimate)
  } else {
    md_unrounded(x)
  }
  md_layout(cols, names(x), numeric)
}

round_data <- function(x, proportion, format_column, round_as_estimate) {
  data <- md_data(x)
  cols <- md_round(data, proportion, list(), round_as_estimate)
  for (nm in names(cols)) {
    value <- data[[nm]]
    if (!is.numeric(value) || is_whole_column(value)) {
      next
    }
    rounded <- as.numeric(gsub(",", "", cols[[nm]], fixed = TRUE))
    finite <- is.finite(value)
    rounded[!finite] <- as.double(value[!finite])
    x[[nm]][] <- rounded
  }
  for (f in format_column) {
    col <- rlang::as_string(rlang::f_lhs(f))
    x[[col]] <- apply_format_column(data[[col]], f, call = rlang::caller_call())
  }
  x
}

split_md_row <- function(x) {
  cells <- strsplit(paste0(x, " "), "(?<!\\\\)[|]", perl = TRUE)[[1]]
  cells[-c(1L, length(cells))]
}

# Replaces the trailing spaces that align the decimal points in each
# right-aligned cell with a punctuation space for a missing decimal point and
# figure spaces for missing digits.
md_entities <- function(x) {
  if (length(x) < 3L) {
    return(x)
  }
  right <- grepl("^ *-+: *$", split_md_row(x[2]))
  body <- vapply(
    x[-(1:2)],
    function(row) {
      cells <- split_md_row(row)
      values <- trimws(cells)
      pad <- nchar(sub("^.*?( *)$", "\\1", cells, perl = TRUE)) - 1L
      pad <- pmax(pad, 0L)
      for (i in which(right & pad > 0L & values != "")) {
        figure <- strrep("&#8199;", pad[i])
        if (!grepl(".", values[i], fixed = TRUE)) {
          figure <- paste0("&#8200;", strrep("&#8199;", pad[i] - 1L))
        }
        values[i] <- paste0(values[i], figure)
      }
      paste0("| ", paste(values, collapse = " | "), " |")
    },
    "",
    USE.NAMES = FALSE
  )
  c(x[1:2], body)
}
