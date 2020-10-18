is.POSIXct <- function(x) inherits(x, "POSIXct")

is.Date <- function(x) inherits(x, "Date")

na_omit <- function(x) x[!is.na(x)]

dir_create <- function(dir) {
  if(!dir.exists(dir)) 
    dir.create(dir, recursive = TRUE)
  dir
}

file_path <- function(..., collapse = FALSE) {
  args <- list(...)
  if(!length(args)) return(character(0))
  args <- lapply(args, as.character)
  args <- args[vapply(args, function(x) length(x) > 0L, TRUE)]
  if(collapse)
    args <- lapply(args, p0, collapse = "/")
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

create_file_path <- function(x_name, class, sub, main, ext = "rds") {
  chk_string(x_name)
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub, x_name)
  paste0(dir, ".", ext)
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

sub_name <- function(data) {
  sub <- data[grepl("^sub\\d", colnames(data))]
  if(!ncol(sub)) {
    data$sub <- ""
    return(data)
  } 
  data <- data[!grepl("^sub\\d", colnames(data))]
  data$sub <- apply(sub, MARGIN = 1, function(x) paste0(na_omit(x), collapse = "/"))
  if(ncol(sub) > 1) data <- cbind(data, sub)
  data
}

subfolder_columns <- function(x) {
  x <- lapply(x, subfolder_column)
  data <- data.table::rbindlist(x, fill = TRUE)
  data <- sub_name(data)
  data$file <- names(x)
  data
}

meta_to_character <- function(x) {
  if("caption" %in% colnames(x)) {
    x$caption <- as.character(x$caption)
  }
  if("tag" %in% colnames(x)) {
    x$tag <- as.character(x$tag)
  }
  x
}

meta_columns <- function(x) {
  x <- replace_ext(x, "rda")
  x <- lapply(x, readRDS)
  x <- lapply(x, as.data.frame, stringsAsFactors = FALSE)
  x <- lapply(x, meta_to_character)
  data.table::rbindlist(x)
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

connect_db <- function(file) {
  conn <- DBI::dbConnect(RSQLite::SQLite(), file)
  DBI::dbExecute(conn, "PRAGMA foreign_keys = ON;")
  conn
}

db_metatable_from_connection <- function(conn) {
  data <- rws_read_meta(conn = conn)
  colnames(data) <- sub("Meta$", "", colnames(data))
  data
}

db_metatable_from_file <- function(file) {
  conn <- connect_db(file)
  on.exit(sbf_close_db(conn))
  db_metatable_from_connection(conn) 
}

nsub <- function(sub) {
  if(!length(sub)) return(0)
  length(strsplit(sub, "/")[[1]])
}

chk_deparse <- function (x) 
{
    if (!is.character(x)) 
        x <- deparse(x)
    if (is.na(x)) 
        x <- "NA"
    if (!vld_string(x)) 
      err(substitute(x), " must be a string")
    x
}
