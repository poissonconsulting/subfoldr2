exists_rds <- function(x_name, class, sub, main) {
  file <- create_file_path(x_name, class, sub, main)
  file.exists(file)
}

#' Object Exists
#'
#' @inheritParams sbf_save_data
#' @return A flag specifying whether the object exists.
#' @family exists functions
#' @export
sbf_object_exists <- function(x_name,
                              sub = sbf_get_sub(),
                              main = sbf_get_main()) {
  exists_rds(x_name, class = "objects", sub = sub, main = main)
}

#' Data Exists
#'
#' @inheritParams sbf_save_data
#' @return A flag specifying whether the data exists.
#' @family exists functions
#' @export
sbf_data_exists <- function(x_name,
                            sub = sbf_get_sub(),
                            main = sbf_get_main()) {
  exists_rds(x_name, class = "data", sub = sub, main = main)
}

#' Number Exists
#'
#' @inheritParams sbf_save_data
#' @return A flag specifying whether the number exists.
#' @family exists functions
#' @export
sbf_number_exists <- function(x_name,
                              sub = sbf_get_sub(),
                              main = sbf_get_main()) {
  exists_rds(x_name, class = "numbers", sub = sub, main = main)
}

#' String Exists
#'
#' @inheritParams sbf_save_data
#' @return A flag specifying whether the string exists.
#' @family exists functions
#' @export
sbf_string_exists <- function(x_name,
                              sub = sbf_get_sub(),
                              main = sbf_get_main()) {
  exists_rds(x_name, class = "strings", sub = sub, main = main)
}

#' Code Block Exists
#'
#' @inheritParams sbf_save_object
#' @return A flag specifying whether the block exists.
#' @family exists functions
#' @export
sbf_block_exists <- function(x_name,
                             sub = sbf_get_sub(),
                             main = sbf_get_main()) {
  exists_rds(x_name, class = "blocks", sub = sub, main = main)
}

#' Table Exists
#'
#' @inheritParams sbf_save_object
#' @return A flag specifying whether the table exists.
#' @family exists functions
#' @export
sbf_table_exists <- function(x_name,
                             sub = sbf_get_sub(),
                             main = sbf_get_main()) {
  exists_rds(x_name, class = "tables", sub = sub, main = main)
}

#' Plot Exists
#'
#' @inheritParams sbf_save_object
#' @return A flag specifying whether the plot exists.
#' @family exists functions
#' @export
sbf_plot_exists <- function(x_name,
                            sub = sbf_get_sub(),
                            main = sbf_get_main()) {
  exists_rds(x_name, class = "plots", sub = sub, main = main)
}
