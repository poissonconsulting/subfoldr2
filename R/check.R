is_valid_table_column <- function(x) {
   is.logical(x) || is.numeric(x) || is.character(x) || is.factor(x) || is.Date(x) || is.POSIXct(x)
}

check_table <- function (x, nrow = NA, x_name = substitute(x), error = TRUE) {
  x_name <- chk_deparse(x_name)
  check_data(x, nrow = nrow, x_name = x_name, error = error)
  valid <- vapply(x, is_valid_table_column, TRUE)
  if(any(!valid)) {
    chk_fail("the following columns in ", x_name, 
                " are not logical, numeric, character, factor, Date or POSIXct: ", 
             cc(names(x)[!valid], " and "))
  }
  invisible(x)
}
