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
    unlink(file_path(main, "pdfs", sub), recursive = TRUE)
    unlink(file_path(main, "windows", sub), recursive = TRUE)
  }
}
