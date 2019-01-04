rm_all <- function(ask) {
  check_flag(ask)
  
  main <- sbf_get_main()
  sub <- sbf_get_sub()

  if (!dir.exists(main)) return(NULL)
}
