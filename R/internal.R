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

update_db_meta <- function(db_name, sub, main, caption, report, tag) {
  meta <- read_meta("dbs", sub = sub, main = main, x_name = db_name)
  
  if(!"caption" %in% names(meta)) meta$caption <- ""
  if(!"report" %in% names(meta)) meta$report <- TRUE
  if(!"tag" %in% names(meta)) meta$tag <- ""
  
  if(!is.null(caption)) meta$caption <- caption
  if(!is.na(report)) meta$report <- report
  if(!is.null(tag)) meta$tag <- tag
  
  save_meta(meta, "dbs", sub = sub, main = main, x_name = db_name)
}

connect_db <- function(file) {
  conn <- DBI::dbConnect(RSQLite::SQLite(), file)
  DBI::dbGetQuery(conn, "PRAGMA foreign_keys = ON;")
  conn
}

db_metatable_from_connection <- function(conn) {
  data <- rws_read_sqlite_meta(conn = conn)
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