rm_class <- function(sub, main, class, ask) {
  chk_string(class)
  chk_flag(ask)
  
  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)
  dir <- file_path(main, class, sub)
  if(!file.exists(dir)) return(invisible(character(0)))
  if(ask && !yesno()) return(invisible(character(0)))
  unlink(dir, recursive = TRUE)
  invisible(dir)
}

#' Delete Flobs Subdfolder
#'
#' @inheritParams sbf_save_object
#' @param ask A flag specifying whether to ask before deleting the subfolder.
#'
#' @return A invisible string of the directory deleted.
#' @export
sbf_rm_flobs <- function(sub = sbf_get_sub(), main = sbf_get_main(), 
                         ask = getOption("sbf.ask", TRUE)) {
  chk_flag(ask)
  
  rm_class(sub = sub, main = main, class = "flobs", ask = ask)
}

rm_all <- function(ask) {
  chk_flag(ask)
  
  main <- sbf_get_main()
  sub <- sbf_get_sub()
  
  if (!dir.exists(main)) return(NULL)
  
  if(identical(sub, character(0))) {
    return(sbf_rm_main(ask = ask))
  }
  msg <- paste("Delete '", sub,"' subfolders of directory '", main, "'?")
  
  if (!ask || yesno(msg)) {
    unlink(file_path(main, "objects", sub), recursive = TRUE)
    unlink(file_path(main, "data", sub), recursive = TRUE)
    unlink(file_path(main, "numbers", sub), recursive = TRUE)
    unlink(file_path(main, "strings", sub), recursive = TRUE)
    unlink(file_path(main, "tables", sub), recursive = TRUE)
    unlink(file_path(main, "blocks", sub), recursive = TRUE)
    unlink(file_path(main, "plots", sub), recursive = TRUE)
    unlink(file_path(main, "dbs", sub), recursive = TRUE)
    unlink(file_path(main, "flobs", sub), recursive = TRUE)
    unlink(file_path(main, "pdfs", sub), recursive = TRUE)
    unlink(file_path(main, "windows", sub), recursive = TRUE)
  }
}
