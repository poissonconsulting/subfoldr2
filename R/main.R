#' Get Main
#'
#' @return A string specifying the main directory.
#' @family directory functions
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
#'
#' @inheritParams sbf_set_sub
#' @return An invisible string of the path to the main folder.
#' @family directory functions
#' @export
sbf_set_main <- function(..., rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  chk_flag(rm)
  chk_flag(ask)
  path <- file_path(..., collapse = TRUE)
  path <- sanitize_path(path, rm_leading = FALSE)
  options(sbf.main = path)
  if (rm) rm_all(ask = ask)
  invisible(path)
}

#' Reset Main
#'
#' @inheritParams sbf_set_sub
#' @return An invisible copy of the string `"output"`.
#' @family reset
#' @family directory functions
#' @export
sbf_reset_main <- function(rm = FALSE, ask = getOption("sbf.ask", TRUE)) {
  invisible(sbf_set_main("output", rm = rm, ask = ask))
}


#' Remove Main
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_set_sub
#' @return An invisible copy of the main folder.
#' @family reset
#' @family housekeeping functions
#' @export
sbf_rm_main <- function(main = sbf_get_main(),
                        ask = getOption("sbf.ask", TRUE)) {
  chk_flag(ask)
  chk_string(main)

  if (!fs::file_exists(main)) {
    return(invisible(main))
  }

  msg <- paste0("Delete directory '", main, "'?")

  if (!ask || yesno(msg)) {
    unlink(main, recursive = TRUE)
    usethis::ui_done(paste0("Directory '", main, "' deleted"))
  } else {
    usethis::ui_oops(paste0("Directory '", main, "' was not deleted"))
  }
  invisible(main)
}
