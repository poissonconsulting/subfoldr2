#' Compare Data
#' 
#' Compares data using waldo::compare.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @inheritParams base::all.equal
#' @inheritParams waldo::compare
#' @return A character vector with class "waldo_compare".
#' @family compare
#' @export
sbf_compare_data <- function(x, x_name = substitute(x), 
                             sub = sbf_get_sub(), main = sbf_get_main(), 
                             tolerance = sqrt(.Machine$double.eps),
                             ignore_attr = TRUE) {
  
  if(!requireNamespace("waldo", quietly = TRUE))
    stop("Please `install.packages('waldo')`.", call. = FALSE)
  
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  file <- file_path("data", sub, x_name)
  
  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = NA)
  waldo::compare(existing, x, x_arg = "saved", y_arg = "current", 
                 tolerance = tolerance, 
                 ignore_attr = ignore_attr)
}
