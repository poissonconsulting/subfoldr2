% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/save.R
\name{sbf_save_aws_files}
\alias{sbf_save_aws_files}
\title{Download files from AWS S3}
\usage{
sbf_save_aws_files(
  bucket_name,
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  data_type = NULL,
  year = NULL,
  month = NULL,
  day = NULL,
  file_name = NULL,
  file_extension = NULL,
  max_request_size = 1000,
  ask = getOption("sbf.ask", TRUE),
  silent = TRUE,
  aws_access_key_id = Sys.getenv("AWS_ACCESS_KEY_ID"),
  aws_secret_access_key = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
  region = Sys.getenv("AWS_REGION", "ca-central-1")
)
}
\arguments{
\item{bucket_name}{A string of the AWS S3 bucket name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{data_type}{A string (by default \code{NULL}) for which data type to return.
Check the folder names within the shiny-upload in AWS for options common
examples include punch-data, tracks, logger, image and pdf.}

\item{year}{A whole number (by default \code{NULL}) indicating which year to
return. Format YYYY.}

\item{month}{A whole number (by default \code{NULL}) indicating which month to
return. Format MM.}

\item{day}{A whole number (by default \code{NULL}) indicating which day to return.
Format DD.}

\item{file_name}{A string (by default \code{NULL}) containing the name of the file
to return. Do not include extension type.}

\item{file_extension}{A string (by default \code{NULL}) with the file extension to
return. Do not include period.}

\item{max_request_size}{A whole number (by default \code{1000}) indicating the
maximum number of files to be returned.}

\item{ask}{A flag specifying whether to ask before overwriting files.}

\item{silent}{A flag (by default \code{FALSE}) to silence messages about number of
files returned. Set to \code{TRUE} to silence messages.}

\item{aws_access_key_id}{A string of your AWS user access key ID. The default
is the environment variable named \code{AWS_ACCESS_KEY_ID}.}

\item{aws_secret_access_key}{A string of your AWS user secret access key. The
default is the environment variable named \code{AWS_SECRET_ACCESS_KEY}.}

\item{region}{A string of the AWS region. The default is the environment
variable named \code{AWS_REGION}.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

\code{sbf_save_aws_files()} was moved to \code{subfoldr2ext::sbfx_save_aws_files()}.

Download files from an AWS S3 bucket into the analysis.
}
\examples{
\dontrun{
sbf_save_aws_files(
  bucket_name = "exploit-upload-poissonconsulting",
  data_type = "upload-recapture",
  year = 2021,
  file_name = "processed_data",
  file_extension = "csv"
)
}
}
\seealso{
Other save functions: 
\code{\link{sbf_basename_sans_ext}()},
\code{\link{sbf_save_block}()},
\code{\link{sbf_save_data}()},
\code{\link{sbf_save_data_to_db}()},
\code{\link{sbf_save_data_to_pg}()},
\code{\link{sbf_save_datas}()},
\code{\link{sbf_save_datas_to_db}()},
\code{\link{sbf_save_db_metatable_descriptions}()},
\code{\link{sbf_save_db_to_workbook}()},
\code{\link{sbf_save_excel}()},
\code{\link{sbf_save_excels}()},
\code{\link{sbf_save_gpkg}()},
\code{\link{sbf_save_gpkgs}()},
\code{\link{sbf_save_number}()},
\code{\link{sbf_save_numbers}()},
\code{\link{sbf_save_object}()},
\code{\link{sbf_save_objects}()},
\code{\link{sbf_save_plot}()},
\code{\link{sbf_save_png}()},
\code{\link{sbf_save_spatial}()},
\code{\link{sbf_save_spatials}()},
\code{\link{sbf_save_string}()},
\code{\link{sbf_save_strings}()},
\code{\link{sbf_save_table}()},
\code{\link{sbf_save_window}()},
\code{\link{sbf_save_workbook}()}
}
\concept{save functions}
