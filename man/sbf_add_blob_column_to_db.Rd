% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flob.R
\name{sbf_add_blob_column_to_db}
\alias{sbf_add_blob_column_to_db}
\title{Add blob column}
\usage{
sbf_add_blob_column_to_db(
  column_name,
  table_name,
  db_name = sbf_get_db_name(),
  sub = sbf_get_sub(),
  main = sbf_get_main()
)
}
\arguments{
\item{column_name}{A string of the name of the BLOB column.}

\item{table_name}{A string of the name of the existing table.}

\item{db_name}{A string of the database name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}
}
\value{
Invisible TRUE.
}
\description{
Add named empty blob column to database
}
\seealso{
Other flob: 
\code{\link{sbf_save_flobs_from_db}()},
\code{\link{sbf_upload_flobs_to_db}()}

Other database functions: 
\code{\link{sbf_close_db}()},
\code{\link{sbf_copy_db}()},
\code{\link{sbf_create_db}()},
\code{\link{sbf_execute_db}()},
\code{\link{sbf_open_db}()},
\code{\link{sbf_query_db}()},
\code{\link{sbf_upload_flobs_to_db}()}
}
\concept{database functions}
\concept{flob}
