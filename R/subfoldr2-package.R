#' @section Options:
#' The following global options can be set with [options()].
#'
#' - `sbf.main`: A string of the path to the main folder (by default
#'   `"output"`). Set with [sbf_set_main()].
#' - `sbf.sub`: A string of the path to the sub folder. Set with
#'   [sbf_set_sub()].
#' - `sbf.db_name`: A string of the database name (by default `"database"`).
#'   Set with [sbf_set_db_name()].
#' - `sbf.ask`: A flag (by default `TRUE`) specifying whether to ask before
#'   deleting existing folders and files.
#' - `sbf.quiet`: A flag specifying whether to silence messages.
#' - `sbf.save_md`: A flag (by default `TRUE`) specifying whether
#'   [sbf_save_table()] and [sbf_save_plot()] save a `.md` file.
#' - `sbf.signif`: A positive whole number (by default `22`) of the
#'   significant digits [sbf_save_number()] rounds to.
#' - `sbf.protect`: A string (by default `"none"`) of the default for the
#'   `protect` argument, which specifies which existing output is protected.
#'   If `"files"` the save functions and [sbf_open_pdf()] throw an error if a
#'   file they would write already exists.
#'   If `"all"` setting the main or sub folder with `rm = TRUE` and
#'   `ask = FALSE` also throws an error if the folder contains files.
#'
#' @keywords internal
"_PACKAGE"
