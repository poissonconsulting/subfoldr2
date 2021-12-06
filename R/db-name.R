#' Get Database Name
#'
#' Gets database name (without the extension or path).
#' By default (ie if not set) 'database'.
#'
#' @return A string specifying the current database name (without the extension or path).
#' @family db_name
#' @export
#' @examples
#' sbf_get_db_name()
sbf_get_db_name <- function() {
  getOption("sbf.db_name", "database")
}

#' Set Database Name
#'
#' Sets database name option (without the extension or path).
#'
#' @param db_name A string specifying the new database name (without the extension or path).
#' @return An invisible string specifying the new database name (without the extension or path).
#' @family db_name
#' @export
#' @examples
#' sbf_set_db_name("database")
sbf_set_db_name <- function(db_name = "database") {
  chk_string(db_name)
  chk_gt(nchar(db_name))

  options(sbf.db_name = db_name)
  invisible(db_name)
}

#' Reset Database Name
#'
#' Sets database name option to 'database'.
#'
#' @return An invisible string of the 'database'.
#' @family db_name reset
#' @export
#' @examples
#' sbf_reset_db_name()
sbf_reset_db_name <- function() {
  sbf_set_db_name("database")
}
