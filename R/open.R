#' Open PDF Device
#'
#' Opens a pdf device in the current pdfs subfolder using 
#' \code{grDevices::\link[grDevices]{pdf}()}.
#' 
#' @inheritParams sbf_save_object
#' @param width A positive number indicating the width in inches.
#' @param height A positive number indicating the height in inches.
#' @param ... Additional arguments passed to \code{grDevices::\link[grDevices]{pdf}()}.
#' @export
sbf_open_pdf <- function(x_name, sub = sbf_get_sub(),
                     exists = NA, width = 6, height = width, ...) {
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  width <- check_pos_dbl(width, coerce = TRUE)
  height <- check_pos_dbl(height, coerce = TRUE)

  sub <- sanitize_path(sub)
  
  file <- file_name("pdfs", sub, x_name, ext = "pdf", exists = exists)

  grDevices::pdf(file = file, width = width, height = height, ...)
  invisible(file)
}

#' Open SQLite Database Connection
#'
#' Opens a \code{\linkS4class{SQLiteConnection}} to a SQLite database.
#' Foreign key constraints are enabled.
#'
#' @inheritParams sbf_save_object
#' @export
sbf_open_db <- function(x_name, sub = sbf_get_sub(), exists = NA) {
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  
  sub <- sanitize_path(sub)
  file <- file_name("dbs", sub, x_name, ext = "sqlite", exists = exists)
  conn <- DBI::dbConnect(RSQLite::SQLite(), file)
  DBI::dbGetQuery(conn, "PRAGMA foreign_keys = ON;")
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
