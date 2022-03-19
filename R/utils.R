is.sf <- function(x) {
  inherits(x, "sf")
}

is.sfc <- function(x) {
  inherits(x, "sfc")
}

sfc_column_names <- function(x) {
  colnames(x)[vapply(x, is.sfc, TRUE)]
}

any_sfc <- function(x) {
  is.data.frame(x) && length(sfc_column_names)
}

hms_to_text <- function(x) {
  is_hms <- vapply(x, hms::is_hms, TRUE)
  wch <- which(is_hms)
  for(i in wch) {
    x[,i] <- as.character(as.data.frame(x)[,i])
  }
  x
}
