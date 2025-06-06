% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compare.R
\name{sbf_compare_data}
\alias{sbf_compare_data}
\title{Compare Data}
\usage{
sbf_compare_data(
  x,
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  tolerance = sqrt(.Machine$double.eps),
  ignore_attr = FALSE
)
}
\arguments{
\item{x}{The object to save.}

\item{x_name}{A string of the name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{tolerance}{numeric \eqn{\ge} 0.  Differences smaller than
    \code{tolerance} are not reported.  The default value is close to
    \code{1.5e-8}.}

\item{ignore_attr}{Ignore differences in specified attributes?
Supply a character vector to ignore differences in named attributes.
By default the \code{"waldo_opts"} attribute is listed in \code{ignore_attr} so
that changes to it are not reported; if you customize \code{ignore_attr}, you
will probably want to do this yourself.

For backward compatibility with \code{all.equal()}, you can also use \code{TRUE},
to all ignore differences in all attributes. This is not generally
recommended as it is a blunt tool that will ignore many important
functional differences.}
}
\value{
A character vector with class "waldo_compare".
}
\description{
Compares data using waldo::compare.
}
\seealso{
Other compare functions: 
\code{\link{sbf_compare_data_archive}()},
\code{\link{sbf_diff_data}()},
\code{\link{sbf_diff_data_archive}()},
\code{\link{sbf_diff_table}()},
\code{\link{sbf_is_equal_data}()},
\code{\link{sbf_is_equal_data_archive}()}
}
\concept{compare functions}
