is.POSIXct <- function(x) inherits(x, "POSIXct")

is.Date <- function(x) inherits(x, "Date")

dir_create <- function(dir) {
  if(!dir.exists(dir)) 
    dir.create(dir, recursive = TRUE)
  dir
}

file_path <- function(...) {
  args <- list(...)
  if(!length(args)) return(character(0))
  args <- lapply(args, as.character)
  args <- args[vapply(args, function(x) length(x) > 0L, TRUE)]
  do.call("file.path", args)
}

sanitize_path <- function(path, rm_leading = TRUE) {
  path <- sub("//", "/", path)
  path <- sub("(.+)(/$)", "\\1", path)
  if(isTRUE(rm_leading)) path <- sub("(^/)(.*)", "\\2", path)
  path
}

replace_ext <- function(x, new_ext) {
  sub("[.][^.]+$", p0(".", new_ext), x)
}

check_x_name <- function(x_name, nchar = TRUE) {
  check_string(x_name)
  check_nchar(x_name)
  x_name
}

named_list <- function() {
  list(x = 1)[-1]
}

is_number <- function(x) {
  is.numeric(x) && identical(length(x), 1L)  
}

is_string <- function(x) {
  is.character(x) && identical(length(x), 1L)  
}

subfolder_column <- function(x) {
  x <- strsplit(x, "/")[[1]]
  n <- length(x)
  x <- c(x[n], x[-n])
  names <- paste0("sub", 0:(n - 1))
  names[1] <- "name"
  names(x) <- names
  as.data.frame(as.list(x), stringsAsFactors = FALSE)
}

subfolder_columns <- function(x) {
  x <- lapply(x, subfolder_column)
  data <- data.table::rbindlist(x, fill = TRUE)
  data$file <- names(x)
  data
}

meta_columns <- function(x) {
  x <- replace_ext(x, "rda")
  x <- lapply(x, readRDS)
  x <- lapply(x, as.data.frame, stringsAsFactors = FALSE)
  data.table::rbindlist(x)
}

as_conditional_tibble <- function(x) {
  if(requireNamespace("tibble", quietly = TRUE)) {
    x <- tibble::as_tibble(x)
  }
  x
}

get_plot_data <- function(x) {
  data <- x$data
  if(!is.data.frame(data)) return(data.frame())
  data
}

plot_size <- function(dim, units) {
  dim <- dim / switch(units, "in" = 1, "cm" = 2.54, "mm" = 25.4)

  if (any(is.na(dim))) {
    if (!length(grDevices::dev.list())) {
      new_dim <- c(6, 6)
    } else
      new_dim <- graphics::par("din")
    dim[is.na(dim)] <- new_dim[is.na(dim)]
  }
  dim
}

png_dim <- function(file) {
  rev(dim(png::readPNG(file))[1:2])
}
