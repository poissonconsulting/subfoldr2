#' Close PDF Device
#'
#' Closes the current graphics device.
#'
#' The function is just a wrapper on [grDevices::dev.off()].
#' @family graphic functions
#' @export
sbf_close_pdf <- function() grDevices::dev.off()

#' Close Database Connection
#'
#' Closes the database connection.
#'
#' The function is just a wrapper on `[dbDisconnect][DBI::dbDisconnect](conn)`.
#' @inheritParams DBI::dbDisconnect
#' @family database functions
#' @export
sbf_close_db <- function(conn) DBI::dbDisconnect(conn)

#' Close Window
#'
#' Closes the current graphics device.
#'
#' The function is just a wrapper on [grDevices::dev.off()].
#' @family graphic functions
#' @export
sbf_close_window <- function() grDevices::dev.off()

#' Close Windows
#'
#' Closes all current graphics device.
#'
#' The function is just a wrapper on [grDevices::graphics.off()].
#' @family graphic functions
#' @export
sbf_close_windows <- function() grDevices::graphics.off()
