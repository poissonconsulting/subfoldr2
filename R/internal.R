sanitize_path <- function(path, rm_leading = TRUE) {
  path <- sub("//", "/", path)
  path <- sub("(.+)(/$)", "\\1", path)
  if(isTRUE(rm_leading)) path <- sub("(^/)(.+)", "\\2", path)
  path
}