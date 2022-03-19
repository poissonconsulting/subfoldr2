is.sf <- function(x) {
  inherits(x, "sf")
}

is.sfc <- function(x) {
  inherits(x, "sfc")
}

any_sfc <- function(x) {
  is.data.frame(x) && any(vapply(x, is.sfc, TRUE))
}

hms_to_text <- function(x) {
  is_hms <- vapply(x, hms::is_hms, TRUE)
  wch <- which(is_hms)
  for(i in wch) {
    x[,i] <- as.character(as.data.frame(x)[,i])
  }
  x
}
