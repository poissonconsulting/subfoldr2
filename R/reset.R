#' Reset Main, Sub and Database Name
#'
#' @return An invisible NULL.
#' @family reset functions
#' @family directory functions
#' @export
#' @examples
#' sbf_reset()
sbf_reset <- function() {
  sbf_reset_db_name()
  sbf_reset_sub()
  sbf_reset_main()
  invisible(NULL)
}
