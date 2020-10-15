#' Diff Data
#' 
#' Find differences with existing data.
#' If doesn't exist (exists = NA) x is compared to itself.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @export
sbf_diff_data <- function(x, x_name = substitute(x), 
                          sub = sbf_get_sub(), main = sbf_get_main(), 
                          exists = NA) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  
  if(!requireNamespace("daff", quietly = TRUE))
    stop("Please `install.packages('daff')`.", call. = FALSE)
  
  existing <- sbf_load_data(x_name, sub = sub, main = main, exists = exists)
  if(is.null(existing)) existing <- x
  daff::diff_data(existing, x)
}

#' Diff Table
#' 
#' Find differences with existing table data.
#' If doesn't exist (exists = NA) x is compared to itself.
#' 
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @export
sbf_diff_table <- function(x, x_name = substitute(x), 
                           sub = sbf_get_sub(), main = sbf_get_main(), 
                           exists = NA) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  
  if(!requireNamespace("daff", quietly = TRUE))
    stop("Please `install.packages('daff')`.", call. = FALSE)

  existing <- sbf_load_table(x_name, sub = sub, main = main, exists = exists)
  if(is.null(existing)) existing <- x
  daff::diff_data(existing, x)
}
