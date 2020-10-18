#' Get Main
#'
#' @return A string specifying the main directory.
#' @export
#' @examples
#' sbf_get_main()
sbf_get_main <- function() {
  path <- getOption("sbf.main", "output")
  sanitize_path(path, rm_leading = FALSE)
}

#' Set Main
#'
#' The directory is created when needed if it doesn't already exist.
#' Setting the main resets the sub.
#' 
#' @inheritParams sbf_set_sub
#' @return An invisible string of the path to the main folder.
#' @export
sbf_set_main <- function(..., rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  chk_flag(rm)
  chk_flag(ask)
  sbf_reset_sub()
  path <- file_path(..., collapse = TRUE)
  path <- sanitize_path(path, rm_leading = FALSE)
  options(sbf.main = path)
  if(rm) rm_all(ask = ask)
  invisible(path)
}

#' Reset Main
#' 
#' Resetting the main resets the sub.
#'
#' @inheritParams sbf_set_sub
#' @return An invisible copy of the string \code{"output"}.
#' @export
sbf_reset_main <- function(rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  invisible(sbf_set_main("output", rm = rm, ask = ask))
}
