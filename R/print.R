grid_errors <- function() {
  c("cannot pop the top-level viewport", 
    "no applicable method for 'depth'")
}

#' Print Object
#'
#' Retries printing an object if grid errors occurs.
#'
#' @param x An object to print.
#' @param ntry A positive whole number specifying the number of tries.
#' @param silent A flag specifying whether to display message from non-grid errors.
#'  
#' @export
sbf_print <- function(x, ntry = 3L, silent = FALSE) {
  chk_whole_number(ntry)
  chk_gt(ntry)
  i <- 1
  while(i < ntry) {
    try <- try(print(x), silent = TRUE)
    if(!vld_is(try, "try-error"))
      return(invisible(try))
    if(!any(vapply(grid_errors(), grepl, TRUE, x = try))) {
      if(!silent) cat(x)
      return(print(x))
    }
    i <- i + 1
  }
  print(x)
}
