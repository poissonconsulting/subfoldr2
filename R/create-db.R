#' Create SQLite Database
#'
#' @inheritParams sbf_save_object
#' @param db_name A string of the database name.
#' @param ask A flag specifying whether to ask before deleting an
#' existing database.
#' @family database functions
#' @export
sbf_create_db <- function(db_name = sbf_get_db_name(),
                          sub = sbf_get_sub(),
                          main = sbf_get_main(),
                          ask = getOption("sbf.ask", TRUE)) {
  conn <- sbf_open_db(
    db_name = db_name, sub = sub, main = main,
    exists = FALSE, ask = ask
  )
  sbf_close_db(conn)
}
