% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list.R
\name{sbf_list_plots}
\alias{sbf_list_plots}
\title{Gets List of Plot Files as a Character Vector}
\usage{
sbf_list_plots(
  x_name = ".*",
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  recursive = FALSE,
  include_root = TRUE,
  ext = "rds"
)
}
\arguments{
\item{x_name}{A string of the name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{recursive}{A flag specifying whether to recurse into subfolders.}

\item{include_root}{A flag indicating whether to include objects in the top
sub folder.}

\item{ext}{A string of the file extension.}
}
\description{
Returns file paths for all plot files matching regular expression x_name.
}
\seealso{
Other list functions: 
\code{\link{sbf_list_blocks}()},
\code{\link{sbf_list_datas}()},
\code{\link{sbf_list_dbs}()},
\code{\link{sbf_list_numbers}()},
\code{\link{sbf_list_objects}()},
\code{\link{sbf_list_strings}()},
\code{\link{sbf_list_tables}()},
\code{\link{sbf_list_windows}()}
}
\concept{list functions}
