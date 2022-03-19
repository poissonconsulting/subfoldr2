is.sf <- function(x) {
  inherits(x, "sf")
}

is.sfc <- function(x) {
  inherits(x, "sfc")
}

any_sfc <- function(x) {
  is.data.frame(x) && any(vapply(x, is.sfc, TRUE))
}
