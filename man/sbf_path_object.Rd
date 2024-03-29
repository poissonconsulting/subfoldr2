% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/path.R
\name{sbf_path_object}
\alias{sbf_path_object}
\title{Path to Object}
\usage{
sbf_path_object(
  x_name,
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  ext = "rds",
  exists = NA
)
}
\arguments{
\item{x_name}{A string of the name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{ext}{A string specifying the extension.}

\item{exists}{A logical scalar specifying whether the file should exist.}
}
\value{
A string indicating the path.
}
\description{
Path to Object
}
