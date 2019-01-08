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
  if(isTRUE(rm_leading)) path <- sub("(^/)(.+)", "\\2", path)
  path
}

check_x_name <- function(x_name, nchar = TRUE) {
  check_string(x_name)
  check_nchar(x_name)
  check_grepl(x_name, "(^[^_])")
  x_name
}

named_list <- function() {
  list(x = 1)[-1]
}
