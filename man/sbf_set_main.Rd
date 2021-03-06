% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{sbf_set_main}
\alias{sbf_set_main}
\title{Set Main}
\usage{
sbf_set_main(..., rm = FALSE, ask = getOption("sbf.ask", TRUE))
}
\arguments{
\item{...}{One or more character vectors which are combined together.}

\item{rm}{A flag specifying whether to remove the folder and all its contents if it already exists.}

\item{ask}{A flag specifying whether to ask before removing the existing folder.}
}
\value{
An invisible string of the path to the main folder.
}
\description{
The directory is created when needed if it doesn't already exist.
}
