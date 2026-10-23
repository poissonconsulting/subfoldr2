# Rounding and formatting of tables for reports.
#
# Estimates are rounded to the second significant digit of the standard
# deviation of the posterior distribution (the `sd` column) or, when it is
# unavailable, 1/4 of the 95% CI. CLs are rounded to one fewer decimal place
# than the estimate, but to at least two significant digits. For proportions,
# significant digits are counted from the nearer of 0 and 1. Estimates without
# CLs are rounded to three significant digits and s-values to one decimal place.

figure_space <- function() intToUtf8(0x2007)

punctuation_space <- function() intToUtf8(0x2008)

bound_distance <- function(x, proportion) {
  if (proportion) {
    return(pmin(abs(x), abs(1 - x)))
  }
  abs(x)
}

first_place <- function(x) {
  place <- rep(NA_real_, length(x))
  ok <- is.finite(x) & x != 0
  place[ok] <- floor(log10(x[ok]))
  place
}

estimate_dp <- function(estimate, lower, upper, sd, proportion) {
  scale <- abs(upper - lower) / 4
  use_sd <- is.finite(sd) & sd > 0
  scale[use_sd] <- sd[use_sd]
  dp <- 1 - first_place(scale)
  no_ci <- is.na(dp)
  dp[no_ci] <- 2 - first_place(bound_distance(estimate[no_ci], proportion))
  dp
}

cl_dp <- function(x, dp, proportion) {
  place <- first_place(bound_distance(x, proportion))
  out <- dp - 1
  ok <- !is.na(place)
  out[ok] <- pmax(dp[ok] - 1, 1 - place[ok])
  out
}

format_dp <- function(x, dp, big_mark = ",") {
  out <- rep(NA_character_, length(x))
  ok <- !is.na(x) & !is.na(dp)
  out[ok] <- vapply(
    which(ok),
    function(i) {
      value <- round(x[i], dp[i]) + 0
      formatC(
        value,
        format = "f",
        digits = max(dp[i], 0),
        big.mark = big_mark
      )
    },
    character(1)
  )
  out
}

format_signif <- function(x, digits) {
  out <- rep(NA_character_, length(x))
  ok <- !is.na(x)
  out[ok] <- vapply(
    x[ok],
    function(x) {
      formatted <- formatC(
        signif(x, digits),
        digits = digits,
        format = "fg",
        flag = "#"
      )
      sub("[.]$", "", formatted)
    },
    character(1)
  )
  out
}

estimate_sets <- function(x) {
  estimates <- grep("(^|_)estimate$", names(x), value = TRUE)
  estimates <- estimates[vapply(x[estimates], is.numeric, TRUE)]
  lapply(estimates, function(estimate) {
    prefix <- sub("estimate$", "", estimate)
    columns <- paste0(prefix, c("lower", "upper", "sd"))
    columns <- columns[columns %in% names(x)]
    list(
      estimate = estimate,
      lower = intersect(paste0(prefix, "lower"), columns),
      upper = intersect(paste0(prefix, "upper"), columns),
      sd = intersect(paste0(prefix, "sd"), columns)
    )
  })
}

column_or_na <- function(x, column) {
  if (!length(column)) {
    return(rep(NA_real_, nrow(x)))
  }
  x[[column]]
}

# Formats the numeric columns of a data frame for reporting, returning a data
# frame of character columns and the names of the numeric columns.
format_report_table <- function(x, proportion = FALSE) {
  numeric <- names(x)[vapply(x, is.numeric, TRUE)]
  out <- lapply(x, function(column) {
    if (is.numeric(column)) {
      return(rep(NA_character_, length(column)))
    }
    as.character(column)
  })
  done <- character(0)

  for (set in estimate_sets(x)) {
    estimate <- x[[set$estimate]]
    lower <- column_or_na(x, set$lower)
    upper <- column_or_na(x, set$upper)
    sd <- column_or_na(x, set$sd)
    dp <- estimate_dp(estimate, lower, upper, sd, proportion)
    out[[set$estimate]] <- format_dp(estimate, dp)
    for (cl in c(set$lower, set$upper)) {
      out[[cl]] <- format_dp(x[[cl]], cl_dp(x[[cl]], dp, proportion))
    }
    if (length(set$sd)) {
      out[[set$sd]] <- format_signif(x[[set$sd]], 2)
    }
    done <- c(done, set$estimate, set$lower, set$upper, set$sd)
  }

  for (column in setdiff(numeric, done)) {
    values <- x[[column]]
    if (grepl("(^|_)svalue$", column)) {
      out[[column]] <- format_dp(values, rep(1, length(values)), big_mark = "")
    } else if (all(is.na(values) | values == round(values))) {
      out[[column]] <- ifelse(
        is.na(values),
        NA_character_,
        format(values, trim = TRUE, scientific = FALSE)
      )
    } else {
      out[[column]] <- format_signif(values, 3)
    }
  }

  out <- tibble::as_tibble(out)
  list(table = out, numeric = numeric)
}

# Pads the formatted values of a column so their decimal points align when
# right-aligned in a proportional font with tabular figures: missing digits
# are figure spaces, a missing decimal point is a punctuation space, and
# missing commas are punctuation spaces. No zeros are added.
align_decimal <- function(x) {
  ok <- !is.na(x)
  if (!any(ok)) {
    return(x)
  }
  has_point <- grepl(".", x[ok], fixed = TRUE)
  whole <- sub("[.].*$", "", x[ok])
  frac <- ifelse(has_point, sub("^[^.]*[.]", "", x[ok]), "")
  frac_width <- max(nchar(frac))
  commas <- nchar(gsub("[^,]", "", whole))
  digits <- nchar(whole) - commas
  pad_left <- strrep(figure_space(), max(digits) - digits)
  pad_comma <- strrep(punctuation_space(), max(commas) - commas)
  point <- ifelse(
    has_point,
    ".",
    if (frac_width > 0) punctuation_space() else ""
  )
  pad_right <- strrep(figure_space(), frac_width - nchar(frac))
  x[ok] <- paste0(pad_comma, pad_left, whole, point, frac, pad_right)
  x
}

escape_markdown <- function(x) {
  x <- gsub("|", "\\|", x, fixed = TRUE)
  gsub("\n", " ", x, fixed = TRUE)
}

# A markdown pipe table of the rounded and decimal-aligned values.
report_table_md <- function(x, proportion = FALSE) {
  formatted <- format_report_table(x, proportion = proportion)
  table <- formatted$table
  for (column in formatted$numeric) {
    table[[column]] <- align_decimal(table[[column]])
  }
  table[] <- lapply(table, function(column) {
    column[is.na(column)] <- ""
    escape_markdown(column)
  })
  align <- ifelse(names(table) %in% formatted$numeric, "---:", ":---")
  rows <- vapply(
    seq_len(nrow(table)),
    function(i) paste0("| ", paste(unlist(table[i, ]), collapse = " | "), " |"),
    character(1)
  )
  c(
    paste0("| ", paste(escape_markdown(names(table)), collapse = " | "), " |"),
    paste0("|", paste(align, collapse = "|"), "|"),
    rows
  )
}

check_table_proportions <- function(x) {
  columns <- unlist(lapply(estimate_sets(x), function(set) {
    c(set$estimate, set$lower, set$upper)
  }))
  values <- unlist(x[columns])
  if (any(values < 0 | values > 1, na.rm = TRUE)) {
    abort_chk(
      "`x` estimates and CLs must be proportions between 0 and 1 when `proportion = TRUE`; convert percentages to proportions first."
    )
  }
  invisible(x)
}

save_md <- function(x, class, sub, main, x_name, proportion = FALSE) {
  x[vapply(x, is.list, TRUE)] <- NULL
  x <- remove_geometry(x)
  file <- file_name(main, class, sub, x_name, "md")
  writeLines(report_table_md(x, proportion = proportion), file, useBytes = TRUE)
  invisible(file)
}
