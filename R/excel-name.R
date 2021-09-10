#' Get Workbook Name
#'
#' Gets the basename of the current working directory
#' 
#' @return A string specifying the name of the current working directory
#' @family excel
#' @export
#' @examples 
#' sbf_get_workbook_name()
sbf_get_workbook_name <- function() {
  basename(getwd())
}
