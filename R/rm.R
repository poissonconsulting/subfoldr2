rm_all <- function(ask) {
  check_flag(ask)
  
  main <- sbf_get_main()
  sub <- sbf_get_sub()
  
  if (!dir.exists(main)) return(NULL)
  
  if(identical(sub, character(0))) {
    msg <- paste0("Delete directory '", main, "'?")
  } else
    msg <- paste("Delete '", sub,"' subfolders of directory '", main, "'?")
  
  if (!ask || yesno(msg)) {
    if (identical(sub, character(0))) {
      unlink(main, recursive = TRUE)
    } else {
      unlink(file_path(main, "objects", sub), recursive = TRUE)
      unlink(file_path(main, "data", sub), recursive = TRUE)
      unlink(file_path(main, "numbers", sub), recursive = TRUE)
      unlink(file_path(main, "strings", sub), recursive = TRUE)
      unlink(file_path(main, "tables", sub), recursive = TRUE)
      unlink(file_path(main, "blocks", sub), recursive = TRUE)
      unlink(file_path(main, "plots", sub), recursive = TRUE)
      unlink(file_path(main, "dbs", sub), recursive = TRUE)
      unlink(file_path(main, "pdfs", sub), recursive = TRUE)
      unlink(file_path(main, "windows", sub), recursive = TRUE)
    }
  }
}
