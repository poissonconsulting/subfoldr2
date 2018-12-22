#' Get Sub Folder
#'
#' @return A character vector specifying the current sub folder.
#' @export
sbf_get_sub <- function() {
  getOption("sbf.sub", character(0))
}

#' Set Sub Folder
#'
#' @param ... One or more character vectors.
#' @param rm A flag specifying whether to remove the subdirectories.
#' @param recursive A flag indicating whether to recursively delete items.
#' @param ask A flag specifying whether to 
#' @return A character vector specifying the new sub folder.
#' @export
sbf_set_sub <- function(..., rm = FALSE, recursive = TRUE,
                    ask = getOption("sbf.ask", TRUE)) {
  check_flag(rm)
  sub <- file_path(...)
  check_string(sub)
  options(subfoldr.sub = sub)
  if(rm) rm_all(sub = sub, recursive = recursive, ask = ask)
  invisible(sub)
}

#' Reset Sub Folder
#'
#' @return A character vector of length 0 specifying the new sub folder.
#' @export
sbf_reset_sub <- function() {
  options(sbf.sub = character(0))
  invisible(character(0))
}

#' Get Main
#'
#' @return A string of the main subfolder.
#' @export
#'
#' @examples
#' get_main()
get_main <- function() {
  getOption("subfoldr.main", "output")
}

#' Set Main
#'
#' @param ... One or more strings
#' @return A string of the new main.
#' @export
set_main <- function(...) {
  main <- file_path(...)
  check_string(main)
  options(subfoldr.main = main)
  invisible(main)
}

#' Reset Main
#'
#' @return A string of the new main.
#' @export
reset_main <- function() {
  options(subfoldr.main = "output")
  invisible("output")
}

#' Get Report
#'
#' @return A string of the report folder.
#' @export
#'
#' @examples
#' get_report()
get_report <- function() {
  getOption("subfoldr.report", "report")
}

#' Set Report
#'
#' @param ... One or more strings
#' @return A string of the new main.
#' @export
set_report <- function(...) {
  report <- file_path(...)
  check_string(report)
  options(subfoldr.report = report)
  invisible(report)
}

#' Reset Report
#'
#' @return A string of the new report
#' @export
reset_report <- function() {
  options(subfoldr.report = "report")
  invisible("report")
}

#' Reset All
#'
#' Resets main and sub.
#' @return An invisible flag indicating whether successful.
#' @export
sbf_reset <- function() {
  reset_main()
  reset_sub()
  invisible(TRUE)
}
