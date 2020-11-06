#' Save flobs
#' 
#' Saves and systematically renames 
#' all blobbed files by default (dir = NULL) to flobs sub directory 
#' corresponding to database using dbflobr::save_all_flobs().
#'
#' @family flob
#' @inheritParams dbflobr::save_all_flobs
#' @inheritParams sbf_open_db
#' @return An invisible named list of named vectors of the file names and new file names saved.
#' @export
sbf_save_flobs_from_db <- function(db_name = sbf_get_db_name(), sub = sbf_get_sub(), 
                           main =sbf_get_main(), dir = NULL) {
  if(!requireNamespace("dbflobr", quietly = TRUE))
    stop("Please install.packages('dbflobr').")
  
  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  if(is.null(dir)) {
    sub <- sanitize_path(sub)
    main <- sanitize_path(main, rm_leading = FALSE)
    dir <- file_path(main, "flobs", sub, db_name)
  } 

  dbflobr::save_all_flobs(conn = conn, dir = dir)
}

#' Upload flobs
#' 
#' Uploads all files to database by default dir = NULL 
#' then uploads flobs subdirectory corresponding to database using
#' dbflobr::import_all_flobs().
#'
#' @family flob
#' @inheritParams dbflobr::import_all_flobs
#' @inheritParams sbf_open_db
#' @return An invisible named list indicating directory path, file names and whether files were successfully written to database.
#' @export
sbf_upload_flobs_to_db <- function(db_name = sbf_get_db_name(), sub = sbf_get_sub(), 
                           main =sbf_get_main(), dir = NULL, exists = FALSE, replace = FALSE) {
  
  if(!requireNamespace("dbflobr", quietly = TRUE))
    stop("Please install.packages('dbflobr').")
  
  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  
  if(is.null(dir)) {
    sub <- sanitize_path(sub)
    main <- sanitize_path(main, rm_leading = FALSE)
    dir <- file_path(main, "flobs", sub, db_name)
  }
  dbflobr::import_all_flobs(conn = conn, dir = dir, exists = exists, replace = replace)
}
