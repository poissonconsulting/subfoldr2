% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pg.R
\name{sbf_save_data_to_pg}
\alias{sbf_save_data_to_pg}
\title{Add data frame to PostgreSQL database}
\usage{
sbf_save_data_to_pg(
  x,
  x_name = NULL,
  schema = getOption("psql.schema", "public"),
  config_path = getOption("psql.config_path", NULL),
  config_value = getOption("psql.config_value", "default")
)
}
\arguments{
\item{x}{The data frame to save.}

\item{x_name}{A string of the name.}

\item{schema}{A string of the schema name. Default value is \code{"public"}.}

\item{config_path}{A string of a file path to the yaml configuration file.
The default value grabs the file path from the psql.config_path option
and uses \code{NULL} if no value supplied.}

\item{config_value}{A string of the name of value. The default value grabs
the value from the psql.config_value option and uses \code{"default"} if no
value is supplied.}
}
\value{
A scalar numeric.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}

\code{sbf_save_data_to_pg()} was moved to \code{subfoldr2ext::sbfx_save_data_to_pg()}.

Add data with a data frame to your PostgreSQL database. The data frame name
must match the table name in your database, if not use the \code{tbl_name}
argument to pass the table name.
}
\details{
Wrapper on \code{psql::psql_add_data()}
}
\examples{
\dontrun{
sbf_save_data_to_pg(outing, "creel")
sbf_save_data_to_pg(outing_new, "creel", "outing")
}
}
\seealso{
Other postgresql functions: 
\code{\link{sbf_backup_pg}()},
\code{\link{sbf_close_pg}()},
\code{\link{sbf_create_pg}()},
\code{\link{sbf_execute_pg}()},
\code{\link{sbf_get_config_file}()},
\code{\link{sbf_get_config_value}()},
\code{\link{sbf_get_schema}()},
\code{\link{sbf_list_tables_pg}()},
\code{\link{sbf_load_data_from_pg}()},
\code{\link{sbf_load_datas_from_pg}()},
\code{\link{sbf_open_pg}()},
\code{\link{sbf_reset_config_file}()},
\code{\link{sbf_reset_config_value}()},
\code{\link{sbf_reset_schema}()},
\code{\link{sbf_set_config_file}()},
\code{\link{sbf_set_config_value}()},
\code{\link{sbf_set_schema}()}

Other save functions: 
\code{\link{sbf_basename_sans_ext}()},
\code{\link{sbf_save_aws_files}()},
\code{\link{sbf_save_block}()},
\code{\link{sbf_save_data}()},
\code{\link{sbf_save_data_to_db}()},
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
\concept{postgresql functions}
\concept{save functions}
