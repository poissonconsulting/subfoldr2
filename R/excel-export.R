save_xlsx <- function(x, class, main, sub, x_name) {
  file <- file_name(main, class, sub, x_name, "xlsx")
  openxlsx::write.xlsx(x, file, overwrite = TRUE)
  invisible(file)
}

#' Convert SQLite Database to Excel Workbook
#' 
#' @param x The data frame to save.
#' @param epgs The projection to convert to
#' @inheritParams sbf_save_object
#' @return An invisible string of the path to the saved data.frame
#'
#' @export
sbf_save_xlsx <- function(x, x_name = substitute(x), sub = sbf_get_sub(),
                          main = sbf_get_main(), epgs = NULL) {
  chk::chk_s3_class(x, "data.frame")
  x_name <- chk::chk_deparse(x_name)
  chk::chk_string(x_name)
  chk::chk_gt(nchar(x_name))
  chk::chk_s3_class(sub, "character")
  chk::chk_range(length(sub))
  chk::chk_string(main)
  chk::chk_null_or(epgs, chk_number)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)  
  
  x <- process_sf_columns(x, epgs)
  
  save_rds(x, "xlsx", sub = sub, main = main, x_name = x_name)
  save_xlsx(x, "xlsx", sub = sub, main = main, x_name = x_name)
}

# this finds which columns have a sfc geomertry other then points 
# returns the names of the columns
find_sfc_columns_to_drop <- function(table) {
  col_drop <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "sfc")) {
      if (!any(grepl("^sfc_POINT$", class(table[[i]])))) {
        col_drop <- c(col_drop, i)
      }
    }
  }
  col_drop
}

## this finds which columns have a point sfc column
## returns the names of the columns
find_columns_points <- function(table) {
  col_point <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "sfc_POINT")) {
      col_point <- c(col_point, i)
    }
  }
  col_point
}

## this finds which columns have class blob
## returns the names of the columns
find_blob_columns_to_drop <- function(table) {
  col_blob <- character()
  for (i in colnames(table)) {
    if (inherits(table[[i]], "blob")) {
      col_blob <- c(col_blob, i)
    }
  }
  col_blob
}

# converts the coords to a different projection
convert_coords <- function(table, epgs) {
  points <- find_columns_points(table)
  for (i in points) {
    table <- poisspatial::ps_activate_sfc(table, i)
    table <- sf::st_transform(table, epgs)
  }
  table
}

process_sf_columns <- function(table, epgs){
  # identify names of columns with point geometry
  points <- find_columns_points(table)
  
  # convert coords to other formats
  if (!is.null(epgs)) {
    table <- convert_coords(table, epgs)
  }
  
  # convert from sfc object to normal df
  table <- tibble::as_tibble(table)
  
  # this drops any sfc columns that are not point geometry
  drop_columns <- find_sfc_columns_to_drop(table)
  table <- table[ , !names(table) %in% drop_columns, drop = FALSE]
  
  # this drops columns that are blobs
  drop_blob_columns <- find_blob_columns_to_drop(table)
  table <- table[ , !names(table) %in% drop_blob_columns, drop = FALSE]
  
  # this converts point columns into their X, Y and Z coordinates
  # robust for multiple point columns
  for (column in points) {
    X <- paste0(column, "_X")
    Y <- paste0(column, "_Y")
    Z <- paste0(column, "_Z")
    table <- poisspatial::ps_sfc_to_coords(table, column, X, Y, Z)
  }
  table
}
