#' Diff Data
#' 
#' Find differences with existing data.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @export
sbf_diff_data <- function(x, x_name = substitute(x), 
                          sub = sbf_get_sub(), main = sbf_get_main()) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  
  if(!requireNamespace("daff", quietly = TRUE))
    stop("Please `install.packages('daff')`.", call. = FALSE)
  
  y <- sbf_load_data(x_name, sub = sub, main = main, exists = TRUE)
  daff::diff_data(y, x)
}

#' Diff Table
#' 
#' Find differences with existing table data.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @export
sbf_diff_table <- function(x, x_name = substitute(x), 
                           sub = sbf_get_sub(), main = sbf_get_main()) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)
  
  if(!requireNamespace("daff", quietly = TRUE))
    stop("Please `install.packages('daff')`.", call. = FALSE)

  y <- sbf_load_table(x_name, sub = sub, main = main, exists = TRUE)
  daff::diff_data(y, x)
}

#' Diff Plot Data
#' 
#' Find differences with existing plot data.
#'
#' @inheritParams sbf_save_object
#' @inheritParams sbf_load_object
#' @return A daff difference object.
#' @export
sbf_diff_plot_data <- function(x, x_name = substitute(x), 
                               sub = sbf_get_sub(), main = sbf_get_main()) {
  chk_s3_class(x, "data.frame")
  x_name <- chk_deparse(x_name)

  if(!requireNamespace("daff", quietly = TRUE))
    stop("Please `install.packages('daff')`.", call. = FALSE)

  y <- sbf_load_plot_data(x_name, sub = sub, main = main, exists = TRUE)
  daff::diff_data(y, x)
}
