#' Query Existing Database
#' 
#' Really just a wrapper on DBI::dbGetQuery().
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_open_db
#' @param sql A string of the SQL statement to execute.
#' @return A scalar numeric of the number of rows affected by the statement.
#' @export
sbf_query_db <- function(sql, db_name = sbf_get_db_name(),
                           sub = sbf_get_sub(),
                           main = sbf_get_main()) {
  chk_string(sql)
  chk_gt(nchar(sql))
  
  conn <- sbf_open_db(db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  DBI::dbGetQuery(conn, sql)
}
