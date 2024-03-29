% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/copy.R
\name{sbf_copy_db}
\alias{sbf_copy_db}
\title{Copy SQLite Database}
\usage{
sbf_copy_db(
  path,
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  exists = FALSE,
  ask = getOption("sbf.ask", TRUE)
)
}
\arguments{
\item{path}{A string of the path to the database to copy
(with the extension).}

\item{db_name}{A string of the name for the new database
(without the extension).}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{exists}{A logical scalar specifying whether the new database must
already exist.}

\item{ask}{A flag specifying whether to ask before deleting an existing
database (if exists = FALSE).}
}
\value{
A flag indicating whether successfully copied.
}
\description{
Copys an existing SQLite database to the subfolder.
}
\seealso{
Other database functions: 
\code{\link{sbf_add_blob_column_to_db}()},
\code{\link{sbf_close_db}()},
\code{\link{sbf_create_db}()},
\code{\link{sbf_execute_db}()},
\code{\link{sbf_open_db}()},
\code{\link{sbf_query_db}()},
\code{\link{sbf_upload_flobs_to_db}()}
}
\concept{database functions}
