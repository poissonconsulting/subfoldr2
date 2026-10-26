# Rounding follows the usepois report template, adapted from Cole (2015):
# estimates are rounded to the second significant digit of the SD (or 1/4 of
# the 95% CI), CLs to one fewer decimal place but at least two significant
# digits, estimates without CLs to three significant digits and s-values to one
# decimal place.

policy_cols <- c("estimate", "lower", "upper", "sd")

chk_format_column <- function(format_column, x) {
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
      "`format_column` columns must be in `x`: ",
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

chk_proportion_cols <- function(x) {
  if (!is.numeric(x$estimate)) {
    abort_chk(
      "`x` must have a numeric column 'estimate' when `proportion = TRUE`."
    )
  }
  cols <- intersect(policy_cols, names(x))
  values <- unlist(lapply(x[cols], as.numeric), use.names = FALSE)
  if (any(values < 0 | values > 1, na.rm = TRUE)) {
    abort_chk(
      "Columns ",
      cc(cols, " and "),
      " in `x` must be proportions between 0 and 1 when `proportion = TRUE`."
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

cl_dp <- function(x, dp, proportion) {
  distance <- bound_distance(x, proportion)
  ifelse(
    is.finite(distance) & distance != 0,
    pmax(dp - 1, 1 - floor(log10(distance))),
    dp - 1
  )
}

signif_dp <- function(x, digits, proportion = FALSE) {
  distance <- bound_distance(x, proportion)
  ifelse(
    is.finite(distance) & distance != 0,
    digits - 1 - floor(log10(distance)),
    0
  )
}

format_dp <- function(x, dp) {
  out <- rep("", length(x))
  finite <- is.finite(x) & !is.na(dp)
  out[finite] <- vapply(
    which(finite),
    function(i) {
      value <- round(x[i], dp[i])
      if (value == 0) {
        value <- 0
      }
      formatC(value, digits = max(dp[i], 0), format = "f", big.mark = ",")
    },
    ""
  )
  out[!finite & !is.na(x)] <- as.character(x[!finite & !is.na(x)])
  out
}

format_whole <- function(x) {
  out <- rep("", length(x))
  finite <- is.finite(x)
  out[finite] <- formatC(
    as.numeric(x[finite]),
    format = "f",
    digits = 0,
    big.mark = ","
  )
  out[!finite & !is.na(x)] <- as.character(x[!finite & !is.na(x)])
  out
}

format_data <- function(x, digits = 4) {
  if (is.integer(x)) {
    return(format_whole(x))
  }
  whole <- is.finite(x) & x == round(x)
  dp <- signif_dp(x, digits)
  dp[whole] <- 0
  format_dp(x, dp)
}

format_unrounded <- function(x) {
  out <- rep("", length(x))
  finite <- is.finite(x)
  out[finite] <- trimws(formatC(
    x[finite],
    digits = 15,
    format = "fg",
    big.mark = ","
  ))
  out[!finite & !is.na(x)] <- as.character(x[!finite & !is.na(x)])
  out
}

format_estimates <- function(x, proportion) {
  estimate <- as.numeric(x$estimate)
  na <- rep(NA_real_, nrow(x))
  lower <- if (is.numeric(x$lower)) as.numeric(x$lower) else na
  upper <- if (is.numeric(x$upper)) as.numeric(x$upper) else na
  sd <- if (is.numeric(x$sd)) as.numeric(x$sd) else na

  dp <- sd_dp(lower, upper, sd)
  ci <- !is.na(dp)

  out <- list()
  out$estimate <- format_dp(estimate, signif_dp(estimate, 3, proportion))
  out$estimate[ci] <- format_dp(estimate[ci], dp[ci])

  for (cl in intersect(c("lower", "upper"), names(x))) {
    if (!is.numeric(x[[cl]])) {
      next
    }
    value <- as.numeric(x[[cl]])
    out[[cl]] <- format_dp(value, signif_dp(value, 2, proportion))
    out[[cl]][ci] <- format_dp(value[ci], cl_dp(value[ci], dp[ci], proportion))
  }
  if (is.numeric(x$sd)) {
    out$sd <- format_dp(sd, signif_dp(sd, 2))
    out$sd[ci] <- format_dp(sd[ci], dp[ci])
  }
  out
}

format_column_values <- function(x, f) {
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
      call = rlang::caller_call(2)
    )
  }
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

md_table <- function(x, proportion = FALSE, format_column = list()) {
  x[vapply(x, is.list, TRUE)] <- NULL
  x <- remove_geometry(x)
  x <- as.data.frame(x)
  if (!ncol(x)) {
    return(character(0))
  }

  numeric <- vapply(x, is.numeric, TRUE)
  cols <- lapply(x, format_other)
  cols[numeric] <- lapply(x[numeric], format_data)

  if ("svalue" %in% names(x) && is.numeric(x$svalue)) {
    cols$svalue <- format_dp(x$svalue, rep(1, nrow(x)))
  }
  if (is.numeric(x$estimate)) {
    estimates <- format_estimates(x, proportion)
    cols[names(estimates)] <- estimates
  }
  for (f in format_column) {
    col <- rlang::as_string(rlang::f_lhs(f))
    cols[[col]] <- format_column_values(x[[col]], f)
  }

  cols[numeric] <- lapply(cols[numeric], align_decimal)
  cols <- lapply(cols, escape_md)
  header <- escape_md(names(x))

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
  if (nrow(x)) {
    cells <- mapply(justify, cols, width, numeric, SIMPLIFY = FALSE)
    cells <- do.call(cbind, unname(cells))
    body <- apply(cells, 1, row)
  }
  c(header, rule, body)
}
