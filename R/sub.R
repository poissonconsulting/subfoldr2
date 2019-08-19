#' Get Sub Folder
#'
#' @return A string specifying the current sub folder.
#' @export
#' @examples 
#' sbf_get_sub()
sbf_get_sub <- function() {
  path <- getOption("sbf.sub", character(0))
  sanitize_path(path)
}

#' Set Sub Folder
#'
#' @param ... One or more character vectors which are combined together.
#' @param rm A flag specifying whether to remove the folder and all its contents if it already exists.
#' @param ask A flag specifying whether to ask before removing the existing folder. 
#' @return An invisible string specifying the new sub folder.
#' @export
sbf_set_sub <- function(..., rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  check_flag(rm)
  check_flag(ask)
  path <- file_path(..., collapse = TRUE)
  path <- sanitize_path(path)
  options(sbf.sub = path)
  if(rm) rm_all(ask = ask)
  invisible(path)
}

#' Reset Sub Folder
#' 
#' @inheritParams sbf_set_sub
#' @return An invisible character vector of length 0.
#' @export
sbf_reset_sub <- function(rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  invisible(sbf_set_sub(rm = rm, ask = ask))
}

#' Add Sub Folder
#' 
#' Add to existing sub folder.
#'
#' @inheritParams sbf_set_sub
#'
#' @return An invisible string specifying the new sub folder.
#' @export
sbf_add_sub <- function(..., rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  path <- file_path(..., collapse = TRUE)
  path <- sanitize_path(path)
  sbf_set_sub(sbf_get_sub(), path, rm = rm, ask = ask)
}

#' Move Up Sub Folder
#' 
#' Moves up the sub folder hierarchy. 
#' 
#' @param n A positive int of the number of subfolders to move up.
#' @inheritParams sbf_set_sub
#'
#' @return An invisible string specifying the new sub folder.
#' @export
sbf_up_sub <- function(n = 1L, rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  chk_count(n)

  n <- as.integer(n)
  sub <- sbf_get_sub()
  nsub <- nsub(sub)
  if(n > nsub) 
    err("n (", n, ") must not exceed the number of subfolders (", nsub, ")")
  sub <- strsplit(sub, "/")[[1]][-((nsub - n + 1L):nsub)]
  sbf_set_sub(sub, rm = rm, ask = ask)
}

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
  check_flag(rm)
  check_flag(ask)
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
