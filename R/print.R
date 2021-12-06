grid_errors <- function() {
  c(
    "cannot pop the top-level viewport",
    "no applicable method for 'depth'"
  )
}

get_err_msg <- function() {
  msg <- geterrmessage()
  sub("^[^:]+[:]", "", msg)
}

#' Print ggplot Object
#'
#' Retries printing a ggplot object if grid errors occurs.
#'
#' Grid errors include the text "cannot pop the top-level viewport" or
#' "no applicable method for 'depth'"
#'
#' @param x An object to print.
#' @param newpage	draw new (empty) page first?
#' @param vp	viewport to draw plot in
#' @param ntry A positive whole number specifying the number of tries.
#'
#' @export
sbf_print <- function(x, newpage = is.null(vp), vp = NULL, ntry = 3L) {
  chk::chk_is(x, "ggplot")
  chk::chk_whole_number(ntry)
  chk::chk_gt(ntry)

  i <- 1
  while (i <= ntry) {
    try <- try(print(x, newpage = newpage, vp = vp), silent = TRUE)
    if (!vld_is(try, "try-error")) {
      return(invisible(x))
    }
    if (!any(vapply(grid_errors(), grepl, TRUE, x = try))) {
      stop(get_err_msg())
    }
    i <- i + 1
  }
  stop(get_err_msg())
}
