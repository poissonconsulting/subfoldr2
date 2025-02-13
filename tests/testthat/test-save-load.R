test_that("object", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  expect_warning(sbf_load_objects(), "no objects to load")

  expect_error(
    sbf_save_object(x_name = "x"),
    "argument \"x\" is missing, with no default"
  )
  expect_error(sbf_save_object(),
    "^`nchar[(]x_name[)]` must be greater than 0, not 0[.]$",
    class = "chk_error"
  )
  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/x.rds")
  )
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_load_object("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_object("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_object("x2"))
  expect_null(sbf_load_object("x2", exists = FALSE))
  expect_null(sbf_load_object("x2", exists = NA))

  y <- 2
  expect_identical(
    sbf_save_objects(env = as.environment(list(x = x, y = y))),
    c(
      file.path(sbf_get_main(), "objects/x.rds"),
      file.path(sbf_get_main(), "objects/y.rds")
    )
  )
  x <- 0
  y <- 0
  expect_identical(sbf_load_objects(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 2)

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_object("x"), x)

  expect_identical(
    list.files(file.path(sbf_get_main(), "objects")),
    sort(c("x.rds", "y.rds"))
  )

  data <- sbf_load_objects_recursive(".rds", sub = character(0))

  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(nrow(data), 0L)
  expect_type(data$objects, "list")

  data <- sbf_load_objects_recursive(
    include_root = FALSE,
    sub = character(0)
  )
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(nrow(data), 0L)

  data <- sbf_load_objects_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(unlist(data$objects), c(x, y))
  expect_identical(data$name, c("x", "y"))
  expect_identical(data$sub, c("", ""))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "objects/x.rds"),
      file.path(sbf_get_main(), "objects/y.rds")
    )
  )

  expect_identical(
    sbf_save_object(x, sub = "t2/t3"),
    file.path(sbf_get_main(), "objects/t2/t3/x.rds")
  )

  data <- sbf_load_objects_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(
    colnames(data),
    c("objects", "name", "sub", "sub1", "sub2", "file")
  )
  expect_type(data$objects, "list")
  expect_identical(unlist(data$objects), c(x, x, y))
  expect_identical(data$name, c("x", "x", "y"))
  expect_identical(data$sub1, c("t2", NA, NA))
  expect_identical(data$sub2, c("t3", NA, NA))
  expect_identical(data$sub, c("t2/t3", "", ""))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "objects/t2/t3/x.rds"),
      file.path(sbf_get_main(), "objects/x.rds"),
      file.path(sbf_get_main(), "objects/y.rds")
    )
  )

  data <- sbf_load_objects_recursive(sub = character(0), include_root = FALSE)
  expect_s3_class(data, "tbl_df")
  expect_identical(
    colnames(data),
    c("objects", "name", "sub", "sub1", "sub2", "file")
  )
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub, "t2/t3")
  expect_identical(data$sub1, "t2")
  expect_identical(data$sub2, "t3")
  expect_identical(
    data$file,
    file.path(sbf_get_main(), "objects/t2/t3/x.rds")
  )

  data2 <- sbf_load_objects_recursive("^x",
    sub = character(0),
    include_root = FALSE
  )
  expect_identical(data2, data)

  data <- sbf_load_objects_recursive(sub = "t2")
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("objects", "name", "sub", "file"))
  expect_identical(unlist(data$objects), x)
  expect_identical(data$name, "x")
  expect_identical(data$sub, "t3")
  expect_identical(
    data$file,
    file.path(sbf_get_main(), "objects/t2/t3/x.rds")
  )

  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_object("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/sub/x.rds")
  )
  expect_identical(sbf_load_object("x"), x)
  expect_identical(sbf_load_object("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_object("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_object("x2"))
  expect_null(sbf_load_object("x2", exists = NA))
  expect_null(sbf_load_object("x2", exists = FALSE))
})

test_that("object", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  sbf_set_sub("one")
  sbf_save_object(x)

  data <- sbf_load_objects_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(
    colnames(data),
    c("objects", "name", "sub", "file")
  )
  expect_identical(data$sub, c("one"))

  sbf_set_sub("one", "two")
  sbf_save_object(x)

  data <- sbf_load_objects_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(
    colnames(data),
    c("objects", "name", "sub", "sub1", "sub2", "file")
  )
  expect_identical(data$sub, c("one/two", "one"))

  expect_identical(
    sbf_subs_object_recursive("x", sub = character(0)),
    c("one/two", "one")
  )
  expect_identical(
    sbf_subs_object_recursive("x2", sub = character(0)),
    character(0)
  )
})

test_that("spatial", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  y <- 1
  expect_error(check_valid_spatial(), "argument \"x\" is missing, with no default")
  expect_error(check_valid_spatial(y), "^Y must inherit from S3 class 'sf'[.]$")

  y <- sf::st_point(c(0, 1)) |> sf::st_sfc() %>% sf::st_as_sf()
  y <- y[0, ]
  expect_error(check_valid_spatial(y), "^`nrow\\(y\\)` must be between 1 and Inf, not 0[.]$")
  
  y <- sf::st_point(c(0, 1)) |> sf::st_sfc() %>% sf::st_as_sf()
  expect_error(check_valid_spatial(y), "^`ncol\\(y\\)` must be between 2 and Inf, not 1[.]$")

  y <- data.frame(index = c(1, 2))
  y$geometry <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y <- sf::st_as_sf(y)
  expect_error(check_valid_spatial(y), "^Y must not have a missing projection[.]$")

  y <- data.frame(index = c(1, 2))
  y$geometry <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y$geometry2 <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y <- sf::st_as_sf(y, crs = 3264)
  expect_error(check_valid_spatial(y), "^Y must have exactly one geometry column[.]$")
  
  y <- data.frame(index = c(1, NA))
  y$geometry <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y <- sf::st_as_sf(y, crs = 3264)
  expect_error(check_valid_spatial(y), "^Y must not have a first \\(index\\) column with missing values[.]$")
  
  y <- data.frame(index = c(1, 1))
  y$geometry <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y <- sf::st_as_sf(y, crs = 3264)
  expect_error(check_valid_spatial(y), "^Y must not have a first \\(index\\) column with duplicated values[.]$")
  
  y <- data.frame(index = c(1, 2))
  y$geometry <- sf::st_point(c(0, 1)) |> sf::st_sfc() 
  y <- sf::st_as_sf(y, crs = 3264)
  expect_identical(check_valid_spatial(y), y)
  
})

test_that("data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  y <- 1
  expect_warning(sbf_load_datas(), "no data to load")

  expect_error(sbf_save_data(), "argument \"x\" is missing, with no default")
  expect_error(sbf_save_data(y),
    "^`x` must inherit from S3 class 'data.frame'[.]$",
    class = "chk_error"
  )
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), file.path(sbf_get_main(), "data/x.rds"))
  expect_identical(sbf_load_data("x"), x)
  chk::expect_chk_error(sbf_load_data("x2"))

  expect_true(file.exists(file.path(sbf_get_main(), "data", "x.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "data", "x2.rds")))

  y <- data.frame(z = 3)
  expect_identical(
    sbf_save_datas(env = as.environment(list(x = x, y = y))),
    c(
      file.path(sbf_get_main(), "data/x.rds"),
      file.path(sbf_get_main(), "data/y.rds")
    )
  )
  expect_identical(
    list.files(file.path(sbf_get_main(), "data")),
    sort(c("x.rds", "y.rds"))
  )
  x <- 0
  y <- 0
  expect_identical(sbf_load_datas(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 3))

  data <- sbf_load_datas_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("data", "name", "sub", "file"))
  expect_identical(data$data[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "data/x.rds"),
      file.path(sbf_get_main(), "data/y.rds")
    )
  )

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_data("x"), x)
  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_data("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_data(x),
    file.path(sbf_get_main(), "data/sub/x.rds")
  )
  expect_identical(sbf_load_data("x"), x)
  expect_identical(sbf_load_data("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_data("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_data("x2"))
  expect_null(sbf_load_data("x2", exists = NA))
  expect_null(sbf_load_data("x2", exists = FALSE))
})

test_that("number", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  y <- numeric(0)
  expect_warning(sbf_load_numbers(), "no numbers to load")
  expect_error(
    sbf_save_number(),
    "argument \"x\" is missing, with no default"
  )
  expect_error(sbf_save_number(y),
    "^`x` must be a number [(]non-missing numeric scalar[)][.]$",
    class = "chk_error"
  )
  x <- 1L
  expect_identical(
    sbf_save_number(x),
    file.path(sbf_get_main(), "numbers/x.rds")
  )

  expect_true(file.exists(file.path(sbf_get_main(), "numbers", "x.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "numbers", "x2.rds")))

  expect_identical(sbf_load_number("x"), 1)
  expect_identical(
    list.files(file.path(sbf_get_main(), "numbers")),
    sort(c("x.csv", "x.rds"))
  )
  csv <- read.csv(file.path(sbf_get_main(), "numbers", "x.csv"))
  expect_equal(csv, data.frame(x = 1))

  y <- 3
  expect_identical(
    sbf_save_numbers(env = as.environment(list(x = x, y = y))),
    c(
      file.path(sbf_get_main(), "numbers/x.rds"),
      file.path(sbf_get_main(), "numbers/y.rds")
    )
  )
  expect_identical(
    list.files(file.path(sbf_get_main(), "numbers")),
    sort(c("x.csv", "x.rds", "y.csv", "y.rds"))
  )
  x <- 0
  y <- 0
  expect_identical(sbf_load_numbers(), c("x", "y"))
  expect_identical(x, 1)
  expect_identical(y, 3)

  data <- sbf_load_numbers_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("numbers", "name", "sub", "file"))
  expect_identical(data$numbers, c(1, 3))
  expect_identical(data$name, c("x", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "numbers/x.rds"),
      file.path(sbf_get_main(), "numbers/y.rds")
    )
  )

  chk::expect_chk_error(sbf_load_number("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_number("x"), 1)
  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_number("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_number(x),
    file.path(sbf_get_main(), "numbers/sub/x.rds")
  )
  expect_identical(sbf_load_number("x"), 1)
  expect_identical(sbf_load_number("x", exists = NA), 1)
  chk::expect_chk_error(sbf_load_number("x2", exists = TRUE))
  expect_null(sbf_load_number("x2", exists = NA))
  expect_null(sbf_load_number("x2", exists = FALSE))

  z <- 4L
  expect_identical(
    sbf_save_number(z, x_name = "important_num"),
    file.path(sbf_get_main(), "numbers/sub/important_num.rds")
  )
  expect_true(file.exists(file.path(sbf_get_main(), "numbers/sub/important_num.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "numbers/sub/z.rds")))
  expect_identical(sbf_load_number("important_num"), 4)
  csv <- read.csv(file.path(sbf_get_main(), "numbers/sub/important_num.csv"))
  expect_equal(csv, data.frame(x = 4))
})

test_that("string", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  y <- "two words"
  expect_warning(sbf_load_strings(), "no strings to load")
  expect_error(
    sbf_save_string(),
    "argument \"x\" is missing, with no default"
  )
  expect_identical(
    sbf_save_string(y),
    file.path(sbf_get_main(), "strings/y.rds")
  )

  expect_true(file.exists(file.path(sbf_get_main(), "strings", "y.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "strings", "x2.rds")))

  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(
    list.files(file.path(sbf_get_main(), "strings")),
    sort(c("y.rda", "y.rds", "y.txt"))
  )
  txt <- readLines(file.path(sbf_get_main(), "strings", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")

  x <- "one"
  expect_identical(
    sbf_save_strings(env = as.environment(list(x = x, y = y))),
    c(
      file.path(sbf_get_main(), "strings/x.rds"),
      file.path(sbf_get_main(), "strings/y.rds")
    )
  )
  expect_identical(
    list.files(file.path(sbf_get_main(), "strings")),
    sort(c("x.rda", "x.rds", "x.txt", "y.rda", "y.rds", "y.txt"))
  )
  x <- 0
  y <- 0
  expect_identical(sbf_load_strings(), c("x", "y"))
  expect_identical(x, "one")
  expect_identical(y, "two words")

  data <- sbf_load_strings_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("strings", "name", "sub", "file"))
  expect_identical(data$strings, c("one", "two words"))
  expect_identical(data$name, c("x", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "strings/x.rds"),
      file.path(sbf_get_main(), "strings/y.rds")
    )
  )

  chk::expect_chk_error(sbf_load_string("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_string("y"), "two words")
  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_string("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_string(y),
    file.path(sbf_get_main(), "strings/sub/y.rds")
  )
  expect_identical(sbf_load_string("y"), "two words")
  expect_identical(sbf_load_string("y", exists = NA), "two words")
  chk::expect_chk_error(sbf_load_string("y", exists = FALSE))
  chk::expect_chk_error(sbf_load_string("x2"))
  expect_null(sbf_load_string("x2", exists = NA))
  expect_null(sbf_load_string("x2", exists = FALSE))

  data <- sbf_load_strings_recursive()
  expect_identical(colnames(data), c("strings", "name", "sub", "file"))
  expect_identical(data$strings, "two words")
  expect_identical(data$name, "y")
  expect_identical(sbf_load_strings_recursive(tag = "y"), data[-1, ])
})

test_that("datas_to_db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  y <- data.frame(z = 3)
  expect_error(sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
    "^`file` must specify an existing file [(]'.*dbs/database.sqlite' can't be found[)].$",
    class = "chk_error"
  )

  conn <- sbf_open_db(exists = NA)
  withr::defer(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_identical(
    list.files(file.path(sbf_get_main(), "dbs")),
    "database.sqlite"
  )

  expect_error(
    sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
    "The following data frames in 'x' are unrecognised: 'y' and 'x'; but exists = TRUE."
  )

  DBI::dbExecute(conn, "CREATE TABLE x (
                  x INTEGER PRIMARY KEY NOT NULL)")

  sbf_execute_db("CREATE TABLE y (
                  z INTEGER PRIMARY KEY NOT NULL)")

  expect_identical(
    sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
    c("y", "x")
  )

  expect_error(
    sbf_save_datas_to_db(env = as.environment(list(x = x, y = y))),
    "UNIQUE constraint failed: y.z"
  )

  expect_true(sbf_close_db(conn))
  x <- 0
  y <- 0

  expect_error(sbf_load_datas_from_db("z"),
    "^`file` must specify an existing file [(]'.*dbs/z.sqlite' can't be found[)].$",
    class = "chk_error"
  )
  expect_identical(sbf_load_datas_from_db(), c("x", "y"))
  expect_identical(x, tibble::tibble(x = 1L))
  expect_identical(y, tibble::tibble(z = 3L))
  expect_identical(
    sbf_load_datas_from_db(rename = function(x) paste0("db", x)),
    c("dbx", "dby")
  )
  expect_identical(dbx, tibble::tibble(x = 1L))
  expect_identical(dby, tibble::tibble(z = 3L))

  expect_error(
    sbf_save_data_to_db(x, db_name = "database"),
    "UNIQUE constraint failed: x.x"
  )
  x$x <- 4
  file <- sbf_save_data_to_db(x, db_name = "database")
  expect_match(file, ".+/dbs/database.sqlite")
  expect_identical(sbf_load_data_from_db("x"), tibble::tibble(x = c(1L, 4L)))

  expect_identical(
    sbf_load_db_metatable(),
    tibble::tibble(
      Table = c("X", "Y"),
      Column = c("X", "Z"),
      Meta = c(NA_character_, NA_character_),
      Description = c(NA_character_, NA_character_)
    )
  )

  x <- sbf_load_db_metatable()
  x$Description <- c("xy", "the End.")
  expect_identical(
    sbf_save_db_metatable_descriptions(x),
    x[c("Table", "Column", "Description")]
  )
  expect_identical(x, sbf_load_db_metatable())
  expect_identical(
    sbf_save_db_metatable_descriptions(x),
    x[0, c("Table", "Column", "Description")]
  )
  expect_identical(
    sbf_save_db_metatable_descriptions(x, overwrite = TRUE),
    x[c("Table", "Column", "Description")]
  )
  x$Description <- c("xzy", NA)
  expect_identical(
    sbf_save_db_metatable_descriptions(x),
    x[0, c("Table", "Column", "Description")]
  )
  expect_identical(
    sbf_save_db_metatable_descriptions(x, overwrite = TRUE),
    x[c("Table", "Column", "Description")]
  )
  expect_identical(x, sbf_load_db_metatable())
  x$Description <- c("notxzy", "yes")
  expect_identical(sbf_save_db_metatable_descriptions(x)$Description, "yes")
  expect_identical(
    sbf_save_db_metatable_descriptions(x),
    x[0, c("Table", "Column", "Description")]
  )
  expect_identical(
    sbf_save_db_metatable_descriptions(x, overwrite = TRUE),
    x[c("Table", "Column", "Description")]
  )

  x$Table[1] <- "NotTable"
  expect_error(sbf_save_db_metatable_descriptions(x))
  expect_identical(
    sbf_save_db_metatable_descriptions(x, strict = FALSE),
    x[0, c("Table", "Column", "Description")]
  )
  expect_identical(sbf_save_db_metatable_descriptions(
    x,
    strict = FALSE, overwrite = TRUE
  )$Description, "yes")

  x$Table[1] <- "X"
  x$Description <- NA_character_
  expect_identical(
    sbf_save_db_metatable_descriptions(x, overwrite = TRUE),
    x[c("Table", "Column", "Description")]
  )

  expect_identical(sbf_load_db_metatable(), x)

  expect_identical(
    sbf_save_db_metatable_descriptions(x),
    x[c("Table", "Column", "Description")]
  )
})

test_that("table", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  y <- 1
  expect_warning(sbf_load_tables(), "no tables to load")
  expect_error(
    sbf_save_table(),
    "argument \"x\" is missing, with no default"
  )
  expect_error(sbf_save_table(y),
    "^`x` must inherit from S3 class 'data.frame'[.]$",
    class = "chk_error"
  )
  x <- data.frame(x = 1)
  expect_error(sbf_save_table(data.frame(zz = I(list(t = 3))), x_name = "y"),
    "^The following columns in `x` are not logical, numeric, character, factor, Date, hms or POSIXct: 'zz'[.]$",
    class = "chk_error"
  )

  expect_identical(sbf_save_table(x), file.path(sbf_get_main(), "tables/x.rds"))

  expect_true(file.exists(file.path(sbf_get_main(), "tables/x.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "tables/x2.rds")))

  expect_identical(sbf_load_table("x"), x)
  expect_identical(
    list.files(file.path(sbf_get_main(), "tables")),
    sort(c("x.rda", "x.csv", "x.rds"))
  )
  csv <- read.csv(file.path(sbf_get_main(), "tables", "x.csv"))
  expect_equal(csv, x)
  meta <- readRDS(paste0(file.path(sbf_get_main(), "tables", "x.rda")))
  expect_identical(meta, list(caption = "", report = TRUE, tag = ""))

  y <- data.frame(z = 2L)
  expect_identical(
    sbf_save_table(y, report = FALSE, caption = "A caption"),
    file.path(sbf_get_main(), "tables/y.rds")
  )
  x <- 0
  y <- 0
  expect_identical(sbf_load_tables(), c("x", "y"))
  expect_identical(x, data.frame(x = 1))
  expect_identical(y, data.frame(z = 2L))

  data <- sbf_load_tables_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("tables", "name", "sub", "file"))
  expect_identical(data$tables[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "tables/x.rds"),
      file.path(sbf_get_main(), "tables/y.rds")
    )
  )

  data2 <- sbf_load_tables_recursive(meta = TRUE)
  expect_identical(
    colnames(data2),
    c(
      "tables", "name", "sub", "file",
      "caption", "report", "tag"
    )
  )
  expect_identical(data2[c("tables", "name", "sub", "file")], data)
  expect_identical(data2$caption, c("", "A caption"))
  expect_identical(data2$report, c(TRUE, FALSE))

  expect_identical(data$tables[[1]], data.frame(x = 1))
  expect_identical(data$name, c("x", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "tables/x.rds"),
      file.path(sbf_get_main(), "tables/y.rds")
    )
  )

  chk::expect_chk_error(sbf_load_table("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_table("x"), x)
  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_table("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_table(x),
    file.path(sbf_get_main(), "tables/sub/x.rds")
  )
  expect_identical(sbf_load_table("x"), x)
  expect_identical(sbf_load_table("x", exists = NA), x)
  chk::expect_chk_error(sbf_load_table("x", exists = FALSE))
  chk::expect_chk_error(sbf_load_table("x2"))
  expect_null(sbf_load_table("x2", exists = NA))
  chk::expect_chk_error(sbf_load_table("x2", exists = TRUE))
})

test_that("block", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_set_main(tempdir())
  y <- "two words"
  expect_warning(sbf_load_blocks(), "no blocks to load")
  expect_error(sbf_save_block(), "argument \"x\" is missing, with no default")
  expect_identical(sbf_save_block(y), file.path(sbf_get_main(), "blocks/y.rds"))

  expect_true(file.exists(file.path(sbf_get_main(), "blocks/y.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "blocks/x2.rds")))

  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(
    list.files(file.path(sbf_get_main(), "blocks")),
    sort(c("y.rda", "y.rds", "y.txt"))
  )
  txt <- readLines(file.path(sbf_get_main(), "blocks", "y.txt"), warn = FALSE)
  expect_equal(txt, "two words")

  one <- "some code"
  expect_identical(
    sbf_save_block(one, tag = "R"),
    file.path(sbf_get_main(), "blocks/one.rds")
  )
  one <- 0
  y <- 0
  expect_identical(sbf_load_blocks(), c("one", "y"))
  expect_identical(one, "some code")
  expect_identical(y, "two words")

  data <- sbf_load_blocks_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("blocks", "name", "sub", "file"))
  expect_identical(data$blocks, c("some code", "two words"))
  expect_identical(data$name, c("one", "y"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "blocks/one.rds"),
      file.path(sbf_get_main(), "blocks/y.rds")
    )
  )

  data2 <- sbf_load_blocks_recursive(meta = TRUE)
  expect_identical(
    colnames(data2),
    c(
      "blocks", "name", "sub", "file",
      "caption", "report", "tag"
    )
  )
  expect_identical(data2[c("blocks", "name", "sub", "file")], data)
  expect_identical(data2$tag, c("R", ""))

  data3 <- sbf_load_blocks_recursive(meta = TRUE, tag = "R")
  expect_identical(data3, data2[1, ])

  chk::expect_chk_error(sbf_load_block("x2"))
  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_load_block("y"), "two words")
  expect_message(expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0)))
  chk::expect_chk_error(sbf_load_block("x"))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(
    sbf_save_block(y),
    file.path(sbf_get_main(), "blocks/sub/y.rds")
  )
  expect_identical(sbf_load_block("y"), "two words")
  expect_identical(sbf_load_block("y", exists = NA), "two words")
  chk::expect_chk_error(sbf_load_block("y", exists = FALSE))
  chk::expect_chk_error(sbf_load_block("x2"))
  expect_null(sbf_load_block("x2", exists = NA))
  expect_null(sbf_load_block("x2", exists = FALSE))
})

test_that("plot", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  sbf_close_windows()

  y <- 1
  expect_error(sbf_save_plot(y), "^`x` must inherit from S3 class 'ggplot'[.]$",
    class = "chk_error"
  )

  x <- ggplot2::ggplot()
  expect_identical(sbf_save_plot(x), file.path(sbf_get_main(), "plots/x.rds"))
  expect_true(all.equal(sbf_load_plot("x"), x))
  expect_identical(sbf_load_plot_data("x"), data.frame())

  expect_true(file.exists(file.path(sbf_get_main(), "plots/x.rds")))
  expect_false(file.exists(file.path(sbf_get_main(), "plots/x2.rds")))

  y <- ggplot2::ggplot(
    data = data.frame(x = 1, y = 2),
    ggplot2::aes(x = x, y = y)
  )
  expect_identical(sbf_save_plot(y), file.path(sbf_get_main(), "plots/y.rds"))

  expect_true(all.equal(sbf_load_plot("y"), y))

  expect_identical(sbf_load_plot_data("y"), data.frame(x = 1, y = 2))

  expect_identical(
    list.files(file.path(sbf_get_main(), "plots")),
    sort(c(
      "x.rda", "y.rda", "x.png", "x.rds",
      "y.csv", "y.png", "y.rds"
    ))
  )

  expect_identical(sbf_load_plots_data(), c("x", "y"))
  expect_identical(x, data.frame())
  expect_identical(y, data.frame(x = 1, y = 2))

  z <- ggplot2::ggplot(
    data = data.frame(x = 2, y = 3),
    ggplot2::aes(x = x, y = y)
  )
  expect_identical(sbf_save_plot(z), file.path(sbf_get_main(), "plots/z.rds"))
  expect_true(all.equal(sbf_load_plot("z"), z))

  t <- ggplot2::ggplot(
    data = data.frame(x = c(2, 3), y = c(3, 2)),
    ggplot2::aes(x = x, y = y)
  )
  expect_identical(sbf_save_plot(
    csv = 1L, dpi = 320L, caption = "one c",
    report = FALSE, width = 2.55, height = 3L, units = "cm"
  ), file.path(sbf_get_main(), "plots/plot.rds"))
  expect_true(all.equal(sbf_load_plot("plot"), t))

  expect_identical(
    list.files(file.path(sbf_get_main(), "plots")),
    sort(c(
      "plot.rda", "x.rda", "y.rda", "z.rda",
      "plot.png", "plot.rds", "x.png", "x.rds",
      "y.csv", "y.png", "y.rds", "z.csv",
      "z.png", "z.rds"
    ))
  )

  data <- sbf_load_plots_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("plots", "name", "sub", "file"))
  expect_s3_class(data$plots[[2]], "ggplot")
  expect_identical(data$name, c("plot", "x", "y", "z"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "plots/plot.rds"),
      file.path(sbf_get_main(), "plots/x.rds"),
      file.path(sbf_get_main(), "plots/y.rds"),
      file.path(sbf_get_main(), "plots/z.rds")
    )
  )

  data2 <- sbf_load_plots_recursive(meta = TRUE)
  expect_identical(colnames(data2), c(
    "plots", "name", "sub", "file", "caption", "report",
    "tag",
    "width", "height", "dpi"
  ))
  expect_identical(data2$caption[1:2], c("one c", ""))
  expect_identical(data2$report[1:2], c(FALSE, TRUE))
  expect_equal(data2$width[1:2], c(1.003937, 6.000000))
  expect_equal(data2$height[1:2], c(1.181102, 6.000000), tolerance = 1e-06)
  expect_identical(data2$dpi[1:2], c(320, 300))

  data <- sbf_load_plots_data_recursive()
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("plots_data", "name", "sub", "file"))
  expect_identical(data$plots_data[[2]], data.frame())
  expect_identical(data$name, c("plot", "x", "y", "z"))
  expect_identical(
    data$file,
    c(
      file.path(sbf_get_main(), "plots/plot.rds"),
      file.path(sbf_get_main(), "plots/x.rds"),
      file.path(sbf_get_main(), "plots/y.rds"),
      file.path(sbf_get_main(), "plots/z.rds")
    )
  )

  sbf_reset()
  sbf_close_windows()
})

test_that("clean after up previous test block in case errored, cant use defer with ggplot", {
  expect_identical(1, 1)
  sbf_reset()
  sbf_close_windows()
})

test_that("window", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_close_windows()
  withr::defer(sbf_close_windows())
  expect_error(sbf_save_window(), "^No such device[.]$")

  skip("run locally as uses screen devices")
  expect_identical(sbf_reset_main(rm = TRUE, ask = FALSE), "output")
  sbf_open_window()
  plot(x ~ y, data = data.frame(x = c(5, 4), y = c(6, 7)))
  expect_identical(
    sbf_save_window(height = 7L, dpi = 300L),
    file.path(sbf_get_main(), "windows/window.png")
  )
  sbf_close_window()
  expect_identical(
    list.files(file.path(sbf_get_main(), "windows")),
    sort(c("window.rda", "window.png"))
  )

  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "window.rda")))
  expect_identical(meta, list(
    caption = "", report = TRUE,
    width = 6, height = 7, dpi = 300
  ))

  gp <- ggplot2::ggplot(
    data = data.frame(x = c(4, 5), y = c(6, 7)),
    ggplot2::aes(x = x, y = y)
  )
  gp <- gp + ggplot2::geom_point()
  sbf_open_window(4, 3)
  print(gp)
  expect_identical(
    sbf_save_window("t2", dpi = 72, caption = "nice one", report = FALSE),
    file.path(sbf_get_main(), "windows/t2.png")
  )

  expect_identical(
    list.files(file.path(sbf_get_main(), "windows")),
    sort(c("t2.rda", "window.rda", "t2.png", "window.png"))
  )

  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "t2.rda")))
  expect_identical(meta, list(
    caption = "nice one", report = FALSE,
    width = 4, height = 3, dpi = 72
  ))

  data <- sbf_load_windows_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("windows", "name", "file"))
  expect_identical(data$name, c("t2", "window"))
  expect_identical(data$windows[1], "output/windows/t2.png")
  expect_identical(data$windows, data$file)

  data2 <- sbf_load_windows_recursive(sub = character(0), meta = TRUE)

  expect_identical(colnames(data2), c(
    "windows", "name", "file", "caption",
    "report", "width", "height", "dpi"
  ))
  expect_identical(data2[c("windows", "name", "file")], data)
  expect_identical(data2$caption, c("nice one", ""))
  expect_identical(data2$report, c(FALSE, TRUE))
  expect_identical(data2$width, c(4, 6))
  expect_identical(data2$height, c(3, 7))
  expect_identical(data2$dpi, c(72, 300))
})

test_that("png", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- system.file("extdata",
    "example.png",
    package = "subfoldr2",
    mustWork = TRUE
  )

  sbf_save_png(x, caption = "map")

  expect_identical(
    list.files(file.path(sbf_get_main(), "windows")),
    sort(c("example.rda", "example.png"))
  )

  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "example.rda")))
  expect_identical(meta, list(
    caption = "map", report = TRUE, tag = "",
    width = 6, height = 5.992, dpi = 125
  ))

  data <- sbf_load_windows_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("windows", "name", "sub", "file"))
  expect_identical(data$name, c("example"))

  data <- sbf_load_windows_recursive(sub = character(0), meta = TRUE)
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c(
    "windows", "name", "sub", "file", "caption", "report", "tag",
    "width", "height", "dpi"
  ))
  expect_identical(data$name, c("example"))
})

test_that("png2", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- system.file("extdata",
    "example.png",
    package = "subfoldr2",
    mustWork = TRUE
  )

  sbf_save_png(x, caption = "map")
  sbf_save_png(x, x_name = "x2", caption = "map2")

  expect_identical(
    list.files(file.path(sbf_get_main(), "windows")),
    sort(c("example.rda", "example.png", "x2.png", "x2.rda"))
  )

  meta <- readRDS(paste0(file.path(sbf_get_main(), "windows", "example.rda")))
  expect_identical(meta, list(
    caption = "map", report = TRUE, tag = "",
    width = 6, height = 5.992, dpi = 125
  ))

  data <- sbf_load_windows_recursive(sub = character(0))
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c("windows", "name", "sub", "file"))
  expect_identical(data$name, c("example", "x2"))

  data <- sbf_load_windows_recursive(sub = character(0), meta = TRUE)
  expect_s3_class(data, "tbl_df")
  expect_identical(colnames(data), c(
    "windows", "name", "sub", "file", "caption", "report", "tag",
    "width", "height", "dpi"
  ))
  expect_identical(data$name, c("example", "x2"))
})

test_that("save table glue", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  data <- data.frame(x = 1)
  sbf_save_table(data, caption = "character")
  sbf_save_table(data, x_name = "data2", caption = glue::glue("glue"))

  expect_identical(
    sbf_load_tables_recursive(meta = TRUE)$caption,
    c("character", "glue")
  )
})

test_that("save df as excel no sf columns", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )
  sbf_save_excel(data)
  data_test <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data_test), c("Places", "Activity"))
  expect_identical(data[["Places"]], c("Yakoun Lake", "Meyer Lake"))
  expect_identical(data[["Activity"]], c("boating", "fishing"))
})

test_that("save df as excel with sf point column", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175)
  )

  data <- convert_coords_to_sfc(data)

  sbf_save_excel(data)
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data), c(
    "Places", "Activity",
    "geometry_X", "geometry_Y"
  ))
  expect_identical(data[["Places"]], c("Yakoun Lake", "Meyer Lake"))
  expect_identical(data[["Activity"]], c("boating", "fishing"))
  expect_equal(data[["geometry_X"]], c(53.350808, 53.640981))
  expect_equal(data[["geometry_Y"]], c(-132.280579, -132.055175))
})

test_that("save df as excel with multiple sf point columns", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175),
    X2 = c(53.350808, 53.640981),
    Y2 = c(-132.280579, -132.055175)
  )

  data <- convert_coords_to_sfc(data)
  data <- convert_coords_to_sfc(data,
    coords = c("X2", "Y2"),
    sfc_name = "geometry2"
  )

  sbf_save_excel(data)
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data), c(
    "Places", "Activity",
    "geometry_X", "geometry_Y",
    "geometry2_X", "geometry2_Y"
  ))
  expect_identical(data[["Places"]], c("Yakoun Lake", "Meyer Lake"))
  expect_identical(data[["Activity"]], c("boating", "fishing"))
  expect_equal(data[["geometry_X"]], c(53.350808, 53.640981))
  expect_equal(data[["geometry_Y"]], c(-132.280579, -132.055175))
  expect_equal(data[["geometry2_X"]], c(53.350808, 53.640981))
  expect_equal(data[["geometry2_Y"]], c(-132.280579, -132.055175))
})

test_that("save df as excel with multiple sf linstring columns", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175),
    X2 = c(53.350808, 53.640981),
    Y2 = c(-132.280579, -132.055175)
  )

  data <- convert_coords_to_sfc(data)
  data <- convert_coords_to_sfc(data,
    coords = c("X2", "Y2"),
    sfc_name = "geometry2"
  )

  data <- sf::st_cast(data, "LINESTRING")
  data <- sf::st_set_geometry(data, "geometry")
  data <- sf::st_cast(data, "LINESTRING")

  sbf_save_excel(data)
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data), c("Places", "Activity"))
})

test_that("save df as excel with linstring column and sf point", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175),
    X2 = c(53.350808, 53.640981),
    Y2 = c(-132.280579, -132.055175)
  )

  data <- convert_coords_to_sfc(data)
  data <- convert_coords_to_sfc(data,
    coords = c("X2", "Y2"),
    sfc_name = "geometry2"
  )

  data <- sf::st_cast(data, "LINESTRING")

  sbf_save_excel(data)
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data), c(
    "Places", "Activity",
    "geometry_X", "geometry_Y"
  ))
})

test_that("save df as excel with blob column", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  expect_output(
    data <- data.frame(
      Places = c("Yakoun Lake", "Meyer Lake"),
      Activity = c("boating", "fishing"),
      Blob = c(
        create_blob_object("hidden"),
        create_blob_object("text")
      )
    )
  )

  sbf_save_excel(data)
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_identical(colnames(data), c("Places", "Activity"))
  expect_identical(data[["Places"]], c("Yakoun Lake", "Meyer Lake"))
  expect_identical(data[["Activity"]], c("boating", "fishing"))
})

test_that("checking return value for sbf_save_excel", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(100))
  return_path <- sbf_save_excel(data)
  expect_match(return_path, "output/excel/data.xlsx$")
})

test_that("two spreadsheets are created due to long table with correct sheet
          pairing", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(2097150))
  sbf_save_excel(data, max_sheets = 2L)

  data_1 <- readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 1
  )
  data_2 <- readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 2
  )

  expect_error(readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 3
  ))

  expect_equal(nrow(data_1), 1048575L)
  expect_equal(nrow(data_2), 1048575L)
})

test_that("two spreadsheets are created due to long table when only 1 sheet
          requested", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(2097150))
  sbf_save_excel(data, max_sheets = 1L)

  data_1 <- readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 1
  )

  expect_error(readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 2
  ))

  expect_equal(nrow(data_1), 1048575L)
})

test_that("two spreadsheets are created due to long table when extra sheets
          requested", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(2097150))
  sbf_save_excel(data, max_sheets = 5L)

  data_1 <- readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 1
  )

  data_2 <- readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 2
  )

  expect_error(readxl::read_excel(
    file.path(path, "excel/data.xlsx"),
    sheet = 3
  ))

  expect_equal(nrow(data_1), 1048575L)
  expect_equal(nrow(data_2), 1048575L)
})


test_that("save two tables from the environment to separate excel files", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )

  species <- data.frame(
    Species = c("Rainbow Trout", "Coho"),
    Code = c("RT", "CO")
  )

  sbf_save_excels(env = as.environment(list(
    sites = sites,
    species = species
  )))

  site_data <- readxl::read_excel(file.path(path, "excel/sites.xlsx"))
  species_data <- readxl::read_excel(file.path(path, "excel/species.xlsx"))

  expect_identical(colnames(site_data), c("Places", "Activity"))
  expect_identical(colnames(species_data), c("Species", "Code"))
})

test_that("checking return value for sbf_save_excels", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(100))
  return_path <- sbf_save_excels(env = as.environment(list(data = data)))

  expect_match(return_path, "output/excel/data.xlsx$")
})

test_that("save two dataframes as excel workbook", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )

  species <- data.frame(
    Species = c("Rainbow Trout", "Coho"),
    Code = c("RT", "CO")
  )

  sbf_save_workbook("data")

  site_data <- readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = "sites"
  )
  species_data <- readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = "species"
  )

  expect_identical(colnames(site_data), c("Places", "Activity"))
  expect_identical(colnames(species_data), c("Species", "Code"))
})

test_that("checking return value for sbf_save_workbook", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(x = seq(100))
  return_path <- sbf_save_workbook("data")

  expect_match(return_path, "output/excel/data.xlsx$")
})

test_that("database can be written to excel workbook", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  # create test data
  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )

  species <- data.frame(
    Species = c("Rainbow Trout", "Coho"),
    Caught = c(5, 2)
  )

  sbf_create_db(db_name = "database")

  sbf_execute_db("CREATE TABLE species (
                Species TEXT,
                Caught INTEGER)")

  sbf_execute_db("CREATE TABLE sites (
                Places TEXT,
                Activity TEXT)")

  sbf_save_data_to_db(sites, db_name = "database")
  sbf_save_data_to_db(species, db_name = "database")

  # write db to excel tables
  sbf_save_db_to_workbook(workbook_name = "data", db_name = "database")
  # do tests
  site_data <- readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = "sites"
  )
  species_data <- readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = "species"
  )

  expect_identical(colnames(site_data), c("Places", "Activity"))
  expect_identical(colnames(species_data), c("Species", "Caught"))
})

test_that("exclude table function working for db to workbook", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  # create test data
  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )

  species <- data.frame(
    Species = c("Rainbow Trout", "Coho"),
    Caught = c(5, 2)
  )

  sbf_create_db(db_name = "database")

  sbf_execute_db("CREATE TABLE species (
                Species TEXT,
                Caught INTEGER)")

  sbf_execute_db("CREATE TABLE sites (
                Places TEXT,
                Activity TEXT)")

  sbf_save_data_to_db(sites, db_name = "database")
  sbf_save_data_to_db(species, db_name = "database")

  # write db to excel tables
  sbf_save_db_to_workbook(
    workbook_name = "data",
    db_name = "database",
    exclude_tables = "species"
  )
  # do tests
  site_data <- readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = 1
  )
  expect_identical(colnames(site_data), c("Places", "Activity"))

  expect_error(readxl::read_excel(file.path(path, "excel/data.xlsx"),
    sheet = 2
  ))
})

test_that("expect empty table when all tables are excluded", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  # create test data
  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )


  sbf_create_db(db_name = "database")

  sbf_execute_db("CREATE TABLE sites (
                Places TEXT,
                Activity TEXT)")

  sbf_save_data_to_db(sites, db_name = "database")

  # write db to excel tables
  sbf_save_db_to_workbook(
    workbook_name = "data",
    db_name = "database",
    exclude_tables = "sites"
  )
  # do tests
  data <- readxl::read_excel(file.path(path, "excel/data.xlsx"))

  expect_equal(nrow(data), 0L)
  expect_equal(colnames(data), character(0))
})

test_that("checking return value for sbf_save_data_to_db", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  # create test data
  sites <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing")
  )
  sbf_create_db(db_name = "database")
  sbf_execute_db("CREATE TABLE sites (
                Places TEXT,
                Activity TEXT)")
  sbf_save_data_to_db(sites, db_name = "database")
  # do tests
  return_path <- sbf_save_db_to_workbook(
    workbook_name = "data",
    db_name = "database"
  )

  expect_match(return_path, "output/excel/data.xlsx$")
})

test_that("save df as gpkg with sf point column", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175)
  )

  sf <- convert_coords_to_sfc(data)

  sbf_save_gpkg(sf)
  expect_output(gpkg <- sf::st_read(file.path(path, "gpkg/sf.gpkg")), "^Reading layer `sf' from data source ")

  expect_s3_class(gpkg, "sf")

  expect_identical(colnames(gpkg), c("Places", "Activity", "geom"))
  sf <- convert_sfc_to_coords(gpkg, "geom")
  expect_identical(sf$Places, data$Places)
  expect_identical(sf$Activity, data$Activity)
  expect_identical(sf$X, data$X)
  expect_identical(sf$Y, data$Y)
})

test_that("save sf as gpkg errors if gpkg", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175)
  )

  gpkg <- convert_coords_to_sfc(data)

  expect_error(sbf_save_gpkg(gpkg), "'gpkg' is a reserved geopackage prefix\\.")
})

test_that("save sf as gpkg time", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    time = hms::as_hms("12:01:03"),
    X = c(53.350808),
    Y = c(-132.280579)
  )

  sff <- convert_coords_to_sfc(data)

  sbf_save_gpkg(sff)
  expect_output(gpkg <- sf::st_read(file.path(path, "gpkg/sff.gpkg")), "^Reading layer `sff' from data source ")

  expect_s3_class(gpkg, "sf")

  expect_identical(colnames(gpkg), c("time", "geom"))
  sf <- convert_sfc_to_coords(gpkg, "geom")
  expect_identical(sf$time, as.character(data$time))
  expect_identical(sf$X, data$X)
  expect_identical(sf$Y, data$Y)
})

test_that("save df as gpkg with linstring column and sf point", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175),
    X2 = c(53.350808, 53.640981),
    Y2 = c(-132.280579, -132.055175)
  )

  sf <- convert_coords_to_sfc(data)
  sf <- convert_coords_to_sfc(sf,
    coords = c("X2", "Y2"),
    sfc_name = "geometry2"
  )

  sf <- sf::st_cast(sf, "LINESTRING")

  expect_warning(sbf_save_gpkg(sf), "Dropping column\\(s\\) geometry of class\\(es\\) sfc_POINT")
  expect_output(gpkg <- sf::st_read(file.path(path, "gpkg/sf.gpkg")), "^Reading layer `sf' from data source ")

  expect_s3_class(gpkg, "sf")

  expect_identical(colnames(gpkg), c(
    "Places", "Activity", "geom"
  ))
  expect_s3_class(gpkg$geom, "sfc_LINESTRING")
  expect_identical(gpkg$Places, data$Places)
  expect_identical(gpkg$Activity, data$Activity)
})

test_that("save sfs as gpkg and ignores data frame", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    X = c(53.350808, 53.640981),
    Y = c(-132.280579, -132.055175)
  )
  sf <- convert_coords_to_sfc(data)
  sf2 <- sf[1, "Activity"]
  files <- sbf_save_gpkgs()
  expect_identical(length(files), 2L)
  expect_match(files[1], "output/gpkg/sf\\.gpkg")
  expect_match(files[2], "output/gpkg/sf2\\.gpkg")

  expect_output(gpkg <- sf::st_read(file.path(path, "gpkg/sf2.gpkg")), "^Reading layer `sf2' from data source ")

  expect_s3_class(gpkg, "sf")

  expect_identical(colnames(gpkg), c("Activity", "geom"))
  sf <- convert_sfc_to_coords(gpkg, "geom")
  expect_identical(sf$Activity, "boating")
  expect_identical(sf$X, data$X[1])
  expect_identical(sf$Y, data$Y[1])
})

test_that("save sf as gpkgs with linstring column and sf point and all_sfc = FALSE", {
  sbf_reset()
  path <- file.path(withr::local_tempdir(), "output")
  sbf_set_main(path)
  withr::defer(sbf_reset())

  data <- data.frame(
    Places = c("Yakoun Lake", "Meyer Lake"),
    Activity = c("boating", "fishing"),
    Y = c(53.350808, 53.640981),
    X = c(-132.280579, -132.055175),
    Y2 = c(53.350808, 53.640981),
    X2 = c(-132.280579, -132.055175)
  )

  sf <- convert_coords_to_sfc(data)
  sf <- convert_coords_to_sfc(sf,
    coords = c("X2", "Y2"),
    sfc_name = "geometry2"
  )

  sf$geometry <- sf::st_cast(sf$geometry, "LINESTRING")

  expect_warning(expect_warning(files <- sbf_save_gpkgs(), "Dropping column\\(s\\) geometry of class\\(es\\) sfc_LINESTRING"), "Dropping column\\(s\\) geometry2 of class\\(es\\) sfc_POINT")
  expect_length(files, 2L)
  expect_match(files[1], "output/gpkg/sf_geometry.gpkg")
  expect_match(files[2], "output/gpkg/sf.gpkg")
  expect_output(gpkg <- sf::st_read(file.path(path, "gpkg/sf.gpkg")), "^Reading layer `sf' from data source ")

  expect_s3_class(gpkg, "sf")

  expect_identical(colnames(gpkg), c(
    "Places", "Activity", "geom"
  ))
  expect_s3_class(gpkg$geom, "sfc_POINT")
  expect_identical(gpkg$Places, data$Places)
  expect_identical(gpkg$Activity, data$Activity)
  gpkg <- convert_sfc_to_coords(gpkg, "geom")
  expect_identical(gpkg$X, gpkg$X)
  expect_identical(gpkg$Y, gpkg$Y)
})
