#' Open PDF Device
#'
#' Opens a pdf device in the current pdfs subfolder using 
#' \code{grDevices::\link[grDevices]{pdf}()}.
#' 
#' @inheritParams sbf_save_object
#' @param width A positive number indicating the width in inches.
#' @param height A positive number indicating the height in inches.
#' @export
sbf_open_pdf <- function(x_name = "plots", sub = sbf_get_sub(), main = sbf_get_main(), 
                         width = 6, height = width) {
  chk_string(x_name)
  chk_gt(nchar(x_name))
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  chk_number(width)
  chk_gt(width)
  chk_number(height)
  chk_gt(height)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  file <- file_name(main, "pdfs", sub, x_name, ext = "pdf")
  
  grDevices::pdf(file = file, width = width, height = height)
  invisible(file)
}

#' Open SQLite Database Connection
#'
#' Opens a \code{\linkS4class{SQLiteConnection}} to a SQLite database.
#' Foreign key constraints are enabled.
#'
#' @inheritParams sbf_save_object
#' @param db_name A string of the database name.
#' @param exists A logical scalar specifying whether the database must already exist.
#' @param ask A flag specifying whether to ask before deleting an existing database (if exists = FALSE).
#' @param caption A string specifying the database metadata table caption. 
#' If NULL the caption is unchanged.
#' If the caption is not specified for a databases it is set to be "".
#' @param report A logical scalar specifying whether to include the database metadata table in the report.
#' If report = NA the setting is not changed. 
#' If the report status is not specified for a databases it is included in the report.
#' @param tag A string of the tag.
#' @export
sbf_open_db <- function(db_name = "database", sub = sbf_get_sub(), main = sbf_get_main(), 
                        exists = TRUE, caption = NULL, report = NA, tag = NULL,
                        ask = getOption("sbf.ask", TRUE)) {
  chk_string(db_name)
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  chk_lgl(exists)
  chk_lgl(report)
  if(!is.null(caption)) chk_string(caption)
  if(!is.null(tag)) chk_string(tag)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  file <- file_name(main, "dbs", sub, db_name, ext = "sqlite")
  
  if (isTRUE(exists) && !file.exists(file))
    err("file '", file, "' doesn't exist")
  
  if (isFALSE(exists) && file.exists(file)) {
    if (ask && !yesno("Delete file '", file, "'?")) return(FALSE)
    file.remove(file)
  }
  
  conn <- connect_db(file)

  update_db_meta(db_name = db_name, sub = sub, main = main, 
                 caption = caption, report = report, tag = tag)
  
  conn
}

#' Open Graphics Window
#'
#' Opens a graphics window on any platform. By default the window is 6 x 6 inches.
#'
#' @param width A positive number of the plotting area width in inches.
#' @param height A positive number of the plotting area height in inches.
#' @export
sbf_open_window <- function(width = 6, height = width) {
  fun <- switch(Sys.info()["sysname"],
                Windows = grDevices::windows,
                Darwin = grDevices::quartz,
                grDevices::x11)
  
  fun(width = width, height = height)
}
