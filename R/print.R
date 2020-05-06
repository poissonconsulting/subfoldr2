#' Print
#'
#' Tries to repeatedly print an object. 
#' 
#' This is a hack to solve the problem with ggplot2/grid graphics.
#' 
#' @param x An object to print.
#' @param ntry A positive whole number specifying the number of attempts.
#'  
#' @export
sbf_print <- function(x, ntry = 3L) {
  chk_whole_number(ntry)
  chk_gt(ntry)
  i <- 1
  while(i < ntry) {
    try <- try(print(x), silent = TRUE)
    if(!vld_is(try, "try-error"))
      return(invisible(try))
  }
  print(x)
}
