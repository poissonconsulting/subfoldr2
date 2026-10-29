#' Round Data
#'
#' Rounds the numeric columns of a data frame in the same way as the `.md`
#' file saved by [sbf_save_table()] and [sbf_save_plot()].
#'
#' The rounding is described in [sbf_save_table()].
#' The numeric columns stay numeric, so significant trailing zeros are not
#' kept when the values are printed; use [sbf_as_md()] with `round = TRUE`
#' to keep them.
#' Integer columns and columns that are not numeric are not altered.
#' Columns formatted by `format_column` are replaced by the values returned by
#' the function, which are not rounded further.
#'
#' @param x A data frame.
#' @inheritParams sbf_save_table
#' @return `x` with its numeric columns rounded.
#' @seealso [sbf_as_md()]
#' @export
#' @examples
#' x <- data.frame(
#'   estimate = c(0.53124, 12.3456),
#'   lower = c(0.21234, 9.8765),
#'   upper = c(0.87012, 15.4321),
#'   length = c(1.23456, 123.456)
#' )
#' sbf_round_data(x)
#' sbf_round_data(x, format_column = list(length ~ round(., 1)))
sbf_round_data <- function(
  x,
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0)
) {
  chk_s3_class(x, "data.frame")
  chk_flag(proportion)
  chk_list(format_column)
  chk_character(round_as_estimate)
  chk_not_any_na(round_as_estimate)
  chk_unique(round_as_estimate)
  chk_policy_numeric(x)
  chk_format_column(format_column, x)
  chk_round_as_estimate(round_as_estimate, x, format_column)
  if (proportion) {
    chk_proportion_cols(x, round_as_estimate)
  }
  round_data(x, proportion, format_column, round_as_estimate)
}

#' Convert to Markdown
#'
#' Converts a data frame to the lines of a markdown table in the same format
#' as the `.md` file saved by [sbf_save_table()] and [sbf_save_plot()].
#'
#' Numeric columns are right-aligned with their decimal points aligned using
#' spaces and commas as thousands separators for numbers of 1000 or more
#' except in the columns named by `no_big_mark`.
#' Other columns, including numbers stored as character, are left-aligned.
#' List columns and the geometry column of sf objects are dropped.
#'
#' @param x A data frame.
#' @param round A flag specifying whether to round the numeric columns as in
#'   the `.md` file saved by [sbf_save_table()] (described there), in which
#'   case significant trailing zeros are kept.
#'   If `FALSE` the values are not rounded.
#' @inheritParams sbf_save_table
#' @return A character vector of the lines of the table in markdown format.
#' @seealso [sbf_round_data()]
#' @export
#' @examples
#' x <- data.frame(
#'   term = c("bIntercept", "bYear"),
#'   estimate = c(0.53124, 12.3456),
#'   lower = c(0.21234, 9.8765),
#'   upper = c(0.87012, 15.4321)
#' )
#' writeLines(sbf_as_md(x))
#' writeLines(sbf_as_md(x, round = TRUE))
#' writeLines(sbf_as_md(data.frame(year = 2025L, count = 1500L)))
#' writeLines(sbf_as_md(data.frame(year = 2025L), no_big_mark = "year"))
sbf_as_md <- function(
  x,
  round = FALSE,
  proportion = FALSE,
  format_column = list(),
  round_as_estimate = character(0),
  no_big_mark = character(0)
) {
  chk_s3_class(x, "data.frame")
  chk_flag(round)
  chk_character(no_big_mark)
  chk_not_any_na(no_big_mark)
  chk_unique(no_big_mark)
  chk_no_big_mark(no_big_mark, x)
  if (round) {
    chk_flag(proportion)
    chk_list(format_column)
    chk_character(round_as_estimate)
    chk_not_any_na(round_as_estimate)
    chk_unique(round_as_estimate)
    chk_policy_numeric(x)
    chk_format_column(format_column, x)
    chk_round_as_estimate(round_as_estimate, x, format_column)
    if (proportion) {
      chk_proportion_cols(x, round_as_estimate)
    }
  } else if (
    !identical(proportion, FALSE) ||
      length(format_column) ||
      length(round_as_estimate)
  ) {
    abort_chk(
      "`proportion`, `format_column` and `round_as_estimate` must not be set when `round = FALSE`.",
      call = rlang::current_call()
    )
  }
  md_table(
    x,
    proportion,
    format_column,
    round_as_estimate,
    no_big_mark,
    round = round
  )
}
