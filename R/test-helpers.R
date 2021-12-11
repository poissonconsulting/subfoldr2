subs_rds_recursive <- function(x_name,
                               class,
                               sub,
                               main,
                               include_root,
                               ext = "rds") {
  chk_string(x_name)
  chk_character(sub)
  chk_range(length(sub))
  chk_string(main)
  chk_flag(include_root)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  
  dir <- file_path(main, class, sub)
  
  ext <- p0("[.]", ext, "$")
  files <- list.files(dir, pattern = p0("^", x_name, ext), recursive = TRUE)
  
  names(files) <- file.path(dir, files)
  files <- sub(ext, "", files)
  files <- files[basename(files) == x_name]
  if (!include_root) files <- files[grepl("/", files)]
  
  if (!length(files)) {
    return(character(0))
  }
  
  subfolder_columns(files)$sub
}


list_subs_object_recursive <- function(x_name,
                                       sub = sbf_get_sub(),
                                       main = sbf_get_main(),
                                       include_root = TRUE) {
  subs_rds_recursive(x_name, "objects",
                     sub = sub, main = main,
                     include_root = include_root
  )
}