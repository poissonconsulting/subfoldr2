is_valid_table_column <- function(x) {
  is.logical(x) || is.numeric(x) || is.character(x) || is.factor(x) ||
    is.Date(x) || hms::is_hms(x) || is.POSIXct(x)
}
