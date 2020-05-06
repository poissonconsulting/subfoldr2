#' Print
#'
#' Tries to repeatedly print an object. 
#' 
#' This is a hack to solve the problem with ggplot2/grid graphics.
#' 
#' @param x An object to print.
#' @param ntry A positive whole number specifying the number of attempts.
#' @param silent A flag specifying whether to silence error messages.
#'  
#' @export
sbf_print <- function(x, ntry = 3L, silent = FALSE) {
  chk_whole_number(ntry)
  chk_gt(ntry)
  chk_flag(silent)
  i <- 1
  while(i < ntry) {
    try <- try(print(x), silent = silent)
    if(!vld_is(try, "try-error"))
      return(invisible(try))
  }
  print(x)
}
