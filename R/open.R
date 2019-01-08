#' Opens PDF Device
#'
#' Opens a pdf device in the current pdfs subfolder using 
#' \code{grDevices::\link[grDevices]{pdf}()}.
#' 
#' @inheritParams sbf_save_object
#' @param width A positive number indicating the width in inches.
#' @param height A positive number indicating the height in inches.
#' @param ... Additional arguments passed to \code{grDevices::\link[grDevices]{pdf}()}.
#' @export
sbf_open_pdf <- function(x_name, sub = sbf_get_sub(),
                     exists = NA, width = 6, height = width, ...) {
  check_x_name(x_name)
  check_vector(sub, "", length = c(0L, 1L))
  check_scalar(exists, c(TRUE, NA))
  width <- check_pos_dbl(width, coerce = TRUE)
  height <- check_pos_dbl(height, coerce = TRUE)

  sub <- sanitize_path(sub)
  
  file <- file_name("pdfs", sub, x_name, ext = "pdf", exists = exists)

  grDevices::pdf(file = file, width = width, height = height, ...)
  invisible(file)
}
