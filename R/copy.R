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
sbf_copy_db <- function(path, db_name = sbf_get_db_name(), sub = sbf_get_sub(),
                        main = sbf_get_main(),
                        exists = FALSE, ask = getOption("sbf.ask", TRUE)) {
  chk_ext(path, c("db", "sqlite", "sqlite3"))
  chk_file(path)

  chk_string(db_name)
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  chk_lgl(exists)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  file <- file_name(main, "dbs", sub, db_name, ext = "sqlite")

  if (isTRUE(exists)) chk_file(file)

  if (isFALSE(exists) && file.exists(file)) {
    if (ask && !yesno("Delete file '", file, "'?")) {
      return(FALSE)
    }
    file.remove(file)
  }
  file.copy(path, file)
}
