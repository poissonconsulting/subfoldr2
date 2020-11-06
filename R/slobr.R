#' Run Slobr Shiny App
#' 
#' Runs slobr shiny app to allow user to add files to database.
#'
#' @inheritParams sbf_open_db
#'
#' @export
sbf_run_slobr_db <- function(db_name = sbf_get_db_name(), sub = sbf_get_sub(), main = sbf_get_main()) {
  if(!requireNamespace("slobr", quietly = TRUE))
    stop("Please remotes::install_github('poissonconsulting/slobr').")
  
  conn <- sbf_open_db(db_name = db_name, sub = sub, main = main, exists = TRUE)
  on.exit(sbf_close_db(conn))
  slobr::run_slobr(conn)
}
