#' Add blob column
#'
#' Add named empty blob column to database
#'
#' @family flob
#' @inheritParams dbflobr::add_blob_column
#' @inheritParams sbf_open_db
#' @return Invisible TRUE.
#' @family database functions
#' @export
sbf_add_blob_column_to_db <- function(column_name,
                                      table_name,
                                      db_name = sbf_get_db_name(),
                                      sub = sbf_get_sub(),
                                      main = sbf_get_main()) {
  rlang::check_installed("dbflobr")
  
  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))

  dbflobr::add_blob_column(
    column_name = column_name, table_name = table_name,
    conn = conn
  )
}

#' Save flobs
#'
#' Saves and systematically renames
#' all blobbed files by default (dir = NULL) to flobs sub directory
#' corresponding to database using dbflobr::save_all_flobs().
#'
#' @family flob
#' @inheritParams dbflobr::save_all_flobs
#' @inheritParams sbf_open_db
#' @param dbflobr_sub A logical specifying whether to save all existing files
#' in a subdirectory of the same name (dbflobr_sub = TRUE) or all possible files
#' in a subdirectory of the same name (dbflobr_sub = NA) or not nest files
#' within a subdirectory (dbflobr_sub = FALSE).

#' @return An invisible named list of named vectors of the file names and new
#' file names saved.
#' @export
sbf_save_flobs_from_db <- function(db_name = sbf_get_db_name(),
                                   sub = sbf_get_sub(),
                                   main = sbf_get_main(),
                                   dir = NULL,
                                   dbflobr_sub = FALSE,
                                   replace = FALSE) {
  rlang::check_installed("dbflobr")

  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))

  if (is.null(dir)) {
    sub <- sanitize_path(sub)
    main <- sanitize_path(main, rm_leading = FALSE)
    dir <- file_path(main, "flobs", sub, db_name)
  }

  dbflobr::save_all_flobs(
    conn = conn,
    dir = dir,
    sub = dbflobr_sub,
    replace = replace
  )
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
#' @param dbflobr_sub A logical scalar specifying whether to import flobs based
#' on their filename (sub = FALSE) or the name of their subdirectory
#' (sub = TRUE) which must only contain 1 file.
#' If sub = NA and replace = TRUE then the names of the subdirectories are used
#' irrespective of whether they include files and existing flobs are deleted
#' if the corresponding subdirectory is empty.
#' If sub = TRUE or sub = NA then recursion is just one subfolder deep.
#' @return An invisible named list indicating directory path, file names and
#' whether files were successfully written to database.
#' @family database functions
#' @export
sbf_upload_flobs_to_db <- function(db_name = sbf_get_db_name(),
                                   sub = sbf_get_sub(),
                                   main = sbf_get_main(),
                                   dir = NULL,
                                   dbflobr_sub = FALSE,
                                   exists = FALSE,
                                   replace = FALSE) {
  rlang::check_installed("dbflobr")

  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))

  if (is.null(dir)) {
    sub <- sanitize_path(sub)
    main <- sanitize_path(main, rm_leading = FALSE)
    dir <- file_path(main, "flobs", sub, db_name)
  }
  dbflobr::import_all_flobs(
    conn = conn, dir = dir, exists = exists, replace = replace,
    sub = dbflobr_sub
  )
}
