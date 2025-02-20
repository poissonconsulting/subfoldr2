% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/save.R
\name{sbf_save_plot}
\alias{sbf_save_plot}
\title{Save Plot}
\usage{
sbf_save_plot(
  x = ggplot2::last_plot(),
  x_name = substitute(x),
  sub = sbf_get_sub(),
  main = sbf_get_main(),
  caption = "",
  report = TRUE,
  tag = "",
  units = "in",
  width = NA,
  height = width,
  dpi = 300,
  limitsize = TRUE,
  csv = 1000L
)
}
\arguments{
\item{x}{The ggplot object to save.}

\item{x_name}{A string of the name.}

\item{sub}{A string specifying the path to the sub folder (by default the
current sub folder).}

\item{main}{A string specifying the path to the main folder (by default the
current main folder)}

\item{caption}{A string of the caption.}

\item{report}{A flag specifying whether to include in a report.}

\item{tag}{A string of the tag.}

\item{units}{A string of the units. Can be "in" (default) or "mm" or "cm".}

\item{width}{A number of the plot width in inches.}

\item{height}{A number of the plot width in inches.}

\item{dpi}{A number of the resolution in dots per inch.}

\item{limitsize}{When \code{TRUE} (the default), \code{ggsave()} will not
save images larger than 50x50 inches, to prevent the common error of
specifying dimensions in pixels.}

\item{csv}{A count specifying the maximum number of rows to save as a csv
file.}
}
\description{
Saves a ggplot object.
By default it saves the last plot to be modified or created.
}
\seealso{
Other save functions: 
\code{\link{sbf_basename_sans_ext}()},
\code{\link{sbf_save_aws_files}()},
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
