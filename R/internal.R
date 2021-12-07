is.POSIXct <- function(x) inherits(x, "POSIXct")

is.Date <- function(x) inherits(x, "Date")

na_omit <- function(x) x[!is.na(x)]

dir_create <- function(dir) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  dir
}

file_path <- function(..., collapse = FALSE) {
  args <- list(...)
  if (!length(args)) {
    return(character(0))
  }
  args <- lapply(args, as.character)
  args <- args[vapply(args, function(x) length(x) > 0L, TRUE)]
  if (collapse) {
    args <- lapply(args, p0, collapse = "/")
  }
  do.call("file.path", args)
}

sanitize_path <- function(path, rm_leading = TRUE) {
  path <- sub("//", "/", path)
  path <- sub("(.+)(/$)", "\\1", path)
  if (isTRUE(rm_leading)) path <- sub("(^/)(.*)", "\\2", path)
  path
}

replace_ext <- function(x, new_ext) {
  sub("[.][^.]+$", p0(".", new_ext), x)
}

create_file_path <- function(x_name, class, sub, main, ext = "rds") {
  chk_string(x_name)
  chk_s3_class(sub, "character")
  chk_range(length(sub), c(0L, 1L))
  chk_string(main)

  sub <- sanitize_path(sub)
  main <- sanitize_path(main, rm_leading = FALSE)

  dir <- file_path(main, class, sub, x_name)
  paste0(dir, ".", ext)
}

named_list <- function() {
  list(x = 1)[-1]
}

is_number <- function(x) {
  is.numeric(x) && identical(length(x), 1L)
}

is_string <- function(x) {
  is.character(x) && identical(length(x), 1L)
}

subfolder_column <- function(x) {
  x <- strsplit(x, "/")[[1]]
  n <- length(x)
  x <- c(x[n], x[-n])
  names <- paste0("sub", 0:(n - 1))
  names[1] <- "name"
  names(x) <- names
  as.data.frame(as.list(x), stringsAsFactors = FALSE)
}

sub_name <- function(data) {
  sub <- data[grepl("^sub\\d", colnames(data))]
  if (!ncol(sub)) {
    data$sub <- ""
    return(data)
  }
  data <- data[!grepl("^sub\\d", colnames(data))]
  data$sub <- apply(sub,
    MARGIN = 1,
    function(x) paste0(na_omit(x), collapse = "/")
  )
  if (ncol(sub) > 1) data <- cbind(data, sub)
  data
}

subfolder_columns <- function(x) {
  x <- lapply(x, subfolder_column)
  data <- data.table::rbindlist(x, fill = TRUE)
  data <- sub_name(data)
  data$file <- names(x)
  data
}

meta_to_character <- function(x) {
  if ("caption" %in% colnames(x)) {
    x$caption <- as.character(x$caption)
  }
  if ("tag" %in% colnames(x)) {
    x$tag <- as.character(x$tag)
  }
  x
}

meta_columns <- function(x) {
  x <- read_metas(x)
  x <- lapply(x, as.data.frame, stringsAsFactors = FALSE)
  x <- lapply(x, meta_to_character)
  data.table::rbindlist(x)
}

get_plot_data <- function(x) {
  data <- x$data
  if (!is.data.frame(data)) {
    return(data.frame())
  }
  data
}

plot_size <- function(dim, units) {
  dim <- dim / switch(units,
    "in" = 1,
    "cm" = 2.54,
    "mm" = 25.4
  )

  if (any(is.na(dim))) {
    if (!length(grDevices::dev.list())) {
      new_dim <- c(6, 6)
    } else {
      new_dim <- graphics::par("din")
    }
    dim[is.na(dim)] <- new_dim[is.na(dim)]
  }
  dim
}

png_dim <- function(file) {
  rev(dim(png::readPNG(file))[1:2])
}

connect_db <- function(file) {
  conn <- DBI::dbConnect(RSQLite::SQLite(), file)
  DBI::dbExecute(conn, "PRAGMA foreign_keys = ON;")
  conn
}

db_metatable_from_connection <- function(conn) {
  data <- rws_read_meta(conn = conn)
  colnames(data) <- sub("Meta$", "", colnames(data))
  data
}

db_metatable_from_file <- function(file) {
  conn <- connect_db(file)
  on.exit(sbf_close_db(conn))
  db_metatable_from_connection(conn)
}

nsub <- function(sub) {
  if (!length(sub)) {
    return(0)
  }
  length(strsplit(sub, "/")[[1]])
}

chk_deparse <- function(x) {
  if (!is.character(x)) {
    x <- deparse(x)
  }
  if (is.na(x)) {
    x <- "NA"
  }
  if (!vld_string(x)) {
    err(substitute(x), " must be a string")
  }
  x
}

get_new_main <- function(main, tz) {
  date_time <- dtt_sys_date_time(tz = tz)
  date_time <- format(date_time, format = "%Y-%m-%d-%H-%M-%S")
  main <- paste(main, date_time, sep = "-")
  dir <- dirname(main) # hack for windows file names
  base <- basename(main)
  if (dir == ".") {
    return(base)
  }
  file.path(dir, base)
}

all_equal_data <- function(name, main, archive, tolerance, check.attributes) {
  main <- file_path(main, name)
  archive <- file_path(archive, name)

  main <- p0(main, ".rds")
  archive <- p0(archive, ".rds")

  main <- readRDS(main)
  archive <- readRDS(archive)

  vld_true(all.equal(main, archive,
    tolerance = tolerance,
    check.attributes = check.attributes
  ))
}

compare_data <- function(name, main, archive, tolerance, ignore_attr) {
  main <- file_path(main, name)
  archive <- file_path(archive, name)

  main <- p0(main, ".rds")
  archive <- p0(archive, ".rds")

  main <- if (file.exists(main)) readRDS(main) else NULL
  archive <- if (file.exists(archive)) readRDS(archive) else NULL

  waldo::compare(main, archive,
    x_arg = "main", y_arg = "archive",
    tolerance = tolerance,
    ignore_attr = ignore_attr
  )
}

diff_data <- function(name, main, archive) {
  main <- file_path(main, name)
  archive <- file_path(archive, name)

  main <- p0(main, ".rds")
  archive <- p0(archive, ".rds")

  main <- if (file.exists(main)) readRDS(main) else NULL
  archive <- if (file.exists(archive)) readRDS(archive) else NULL

  if (is.null(main)) {
    main <- archive
  } else if (is.null(archive)) {
    archive <- main
  }

  daff::diff_data(archive, main)
}

convert_coords_to_sfc <- function(x,
                                  coords = c("X", "Y"),
                                  sfc_name = "geometry") {
  # this is a simplified version of ps_coords_to_sfc
  chk::chk_s3_class(x, "data.frame")
  chk::chk_vector(coords)
  chk::check_values(coords, "")
  chk::check_dim(coords, values = c(2L:3L))
  chk::check_names(x, coords)
  chk::chk_string(sfc_name)

  x <- tibble::as_tibble(x)

  x$..ID_coords <- seq_len(nrow(x))

  y <- x[!is.na(x[[coords[1]]]) & !is.na(x[[coords[2]]]), ]

  sfc <- sf::st_multipoint(matrix(c(y[[coords[1]]], y[[coords[2]]]), ncol = 2),
    dim = "XY"
  )
  sfc <- sf::st_sfc(sfc, crs = 4326)
  sfc <- sf::st_cast(sfc, "POINT")

  y[coords[1]] <- NULL
  y[coords[2]] <- NULL

  y[[sfc_name]] <- sfc
  colnames <- colnames(y)
  y <- y[c("..ID_coords", sfc_name)]
  x[[sfc_name]] <- NULL

  x <- merge(y, x, by = "..ID_coords")
  x <- x[colnames]
  x <- x[order(x$..ID_coords), ]
  x$..ID_coords <- NULL

  x <- sf::st_set_geometry(x, sfc_name)

  x
}

check_is_sfc <- function(x) {
  sfc_names <- colnames(x)
  sfc_names <- sfc_names[vapply(x, function(x) {
    inherits(x, "sfc")
  }, TRUE)]
  sfc_names
}

convert_sfc_to_coords <- function(x,
                                  sfc_name,
                                  X = "X",
                                  Y = "Y",
                                  Z = "Z") {
  # this is a simplified version of ps_sfc_to_coords
  chk::chk_s3_class(x, "data.frame")
  chk::chk_string(sfc_name)
  chk::chk_string(X)
  chk::chk_string(Y)
  chk::chk_string(Z)

  if (!(class(x[[sfc_name]])[[1]] %in% c("sfc_LINESTRING", "sfc_MULTILINESTRING", "sfc_POINT", "sfc_MULTIPOINT"))) {
    chk::abort_chk("sfc_name '", sfc_name, "' must be point or linestring")
  }

  if (class(x[[sfc_name]])[[1]] %in% c("sfc_LINESTRING", "sfc_MULTILINESTRING")) {
    x <- sf::st_cast(x, warn = FALSE, "POINT")
  }


  if (!sfc_name %in% check_is_sfc(x)) {
    chk::abort_chk("sfc_name '", sfc_name, "' is not an sfc column")
  }

  x <- tibble::as_tibble(x)

  coords <- sf::st_coordinates(x[[sfc_name]])

  x[[X]] <- unname(coords[, "X", drop = TRUE])
  x[[Y]] <- unname(coords[, "Y", drop = TRUE])

  if ("Z" %in% colnames(coords)) {
    x[[Z]] <- coords[, "Z", drop = TRUE]
  }

  x[[sfc_name]] <- NULL

  x
}

create_blob_object <- function(object, name = substitute(object)) {
  chk::chk_string(name)

  file <- file.path(tempdir(), "object.rds")
  saveRDS(object, file)

  n <- file.info(file)$size
  blob <- readBin(file, what = "integer", n = n, endian = "little")

  blob <- list(blob)

  names(blob) <- tools::file_ext(file)

  blob <- serialize(blob, NULL)
  blob <- list(blob)
  print(blob)
  blob <- blob::as_blob(blob)
  print(blob)
  names(blob) <- file

  blob
}
