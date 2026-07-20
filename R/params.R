#' Parameter Descriptions for Package
#'
#' Default parameter descriptions which may be overridden in individual
#' functions.
#'
#' A flag is a non-missing logical scalar.
#'
#' A string is a non-missing character scalar.
#
#' @inheritParams rlang::args_dots_empty
#' @param drop A character vector specifying the names of sub folders
#' and files to drop or `NULL` (the default).
#' @param quiet A flag indicating whether messages should be silenced.
#' Warnings are still returned regardless.
#' Can be set globally using the option `sbf.quiet`.
#' @keywords internal
#' @aliases parameters arguments args
#' @usage NULL
# nocov start
params <- function(...) NULL
# nocov end
