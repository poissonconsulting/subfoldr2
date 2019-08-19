#' Copy SQLite Database
#'
#' Copys an existing SQLite database to the subfolder.
#'
#' @inheritParams sbf_save_object
#' @param path A string of the path to the database to copy (with the extension).
#' @param db_name A string of the name for the new database (without the extension).
#' @param exists A logical scalar specifying whether the new database must already exist.
#' @param ask A flag specifying whether to ask before deleting an existing database (if exists = FALSE).
#' @return A flag indicating whether successfully copied.
#' @export
sbf_copy_db <- function(path, db_name = "database", sub = sbf_get_sub(), main = sbf_get_main(), 
                        exists = FALSE, ask = getOption("sbf.ask", TRUE)) {
  chk_file(path)
  if(!chk_match(path, "[.]((db)|(sqlite3{0,1}))$", err = FALSE))
    err("File '", path, "' must have extension '.db', '.sqlite' or '.sqlite3'.")
  
  chk_string(db_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_string(main)
  chk_lgl(exists)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  file <- file_name(main, "dbs", sub, db_name, ext = "sqlite")
  
  if (isTRUE(exists) && !file.exists(file))
    err("file '", file, "' doesn't exist")
  
  if (isFALSE(exists) && file.exists(file)) {
    if (ask && !yesno("Delete file '", file, "'?")) return(FALSE)
    file.remove(file)
  }
  file.copy(path, file)
}
