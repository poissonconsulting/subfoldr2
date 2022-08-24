test_that("checking sbf_load_datas_from_pg pulls tables", {
  skip_on_ci()
  # set up test
  dat <- data.frame(x = c(1:5), y = c(5:9))
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      )
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.input (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  psql::psql_add_data(dat, schema = "boat_count", tbl_name = "input", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.input",
        config_path = config_path
      )
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.counts (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  psql::psql_add_data(dat, schema = "boat_count", tbl_name = "counts", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.counts",
        config_path = config_path
      )
    )
  )
  # execute tests
  output <- sbf_load_datas_from_pg(
    "boat_count",
    config_path = config_path
  )
  expect_equal(sort(output), sort(c("input", "counts")))
  expect_equal(counts, dat)
  expect_equal(input, dat)
})

test_that("checking sbf_load_datas_from_pg pulls tables and renames them", {
  skip_on_ci()
  # set up test
  dat <- data.frame(x = c(1:5), y = c(5:9))
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      )
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.input (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  psql::psql_add_data(dat, schema = "boat_count", tbl_name = "input", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.input",
        config_path = config_path
      )
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.counts (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  psql::psql_add_data(dat, schema = "boat_count", tbl_name = "counts", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.counts",
        config_path = config_path
      )
    )
  )
  # execute tests
  output <- sbf_load_datas_from_pg(
    "boat_count",
    rename = toupper,
    config_path = config_path
  )
  expect_equal(sort(output), sort(c("INPUT", "COUNTS")))
  expect_equal(COUNTS, dat)
  expect_equal(INPUT, dat)
})

test_that("set and get schema", {
  schema <- "trucks"
  sbf_set_schema(schema)
  set_schema <- sbf_get_schema()
  expect_equal(set_schema, schema)
})

test_that("reset schema", {
  schema <- "trucks"
  sbf_set_schema(schema)
  sbf_reset_schema()
  set_schema <- sbf_get_schema()
  expect_equal(set_schema, "public")
})

test_that("set and get config file path", {
  path <- "~/Keys/config.yml"
  sbf_set_config_file(path)
  set_path <- sbf_get_config_file()
  expect_equal(set_path, path)
})

test_that("reset config file path", {
  path <- "~/Keys/config.yml"
  sbf_set_config_file(path)
  sbf_reset_config_file()
  set_path <- sbf_get_config_file()
  expect_equal(set_path, "config.yml")
})

test_that("set and get config file value", {
  value <- "database"
  sbf_set_config_value(value)
  set_value <- sbf_get_config_value()
  expect_equal(set_value, value)
})

test_that("reset config file value", {
  value <- "database"
  sbf_set_config_value(value)
  sbf_reset_config_value()
  set_value <- sbf_get_config_value()
  expect_equal(set_value, character(0))
})

test_that("test sbf_open_pg works", {
  skip_on_ci()
  conn <- sbf_open_pg(config_path = NULL, config_value = NULL)
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("test sbf_close_pg works", {
  skip_on_ci()
  conn <- sbf_open_pg(config_path = NULL, config_value = NULL)
  withr::defer(
    suppressWarnings(
      DBI::dbDisconnect(conn)
    )
  )
  sbf_close_pg(conn)
  expect_error(
    DBI::dbExecute(conn, "SELECT 1+1;"),
    regexp = "external pointer is not valid"
  )
})

test_that("test sbf_save_pg works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config-hosted.yml", package = "psql")
  temp_dir <- withr::local_tempdir()
  dump_path <- file.path(temp_dir, "dump_db1.sql")
  sbf_save_pg(
    path = dump_path,
    config_path = config_path
  )
  expect_true(file.exists(dump_path))
})

test_that("test sbf_create_pg works", {
  skip_on_ci()
  output <- sbf_create_pg("newdb", NULL, NULL)
  # clean up afterwards
  withr::defer({
    try(
      result <- DBI::dbSendQuery(psql::psql_connect(NULL, NULL), "DROP DATABASE newdb;"),
      silent = TRUE
    )
    try(
      DBI::dbClearResult(result),
      silent = TRUE
    )
  })
  # test
  expect_true(output)
})

test_that("test sbf_execute_pg works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  output <- sbf_execute_pg(
    "CREATE SCHEMA boat_count",
    config_path = config_path
  )
  withr::defer({
    try(
      sbf_execute_pg(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  })
  query <- DBI::dbGetQuery(
    psql::psql_connect(config_path = config_path),
    "SELECT schema_name FROM information_schema.schemata"
  )
  expect_equal(output, 0L)
  expect_true("boat_count" %in% query$schema_name)
})

test_that("test sbf_list_tables_pg works", {
  skip_on_ci()
  # set up test
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  sbf_execute_pg("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      )
    )
  )
  sbf_execute_pg(
    "CREATE TABLE boat_count.counts (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.counts",
        config_path = config_path
      )
    )
  )
  # execute tests
  output <- sbf_list_tables_pg(
    "boat_count",
    config_path = config_path
  )
  expect_equal(output, c("counts"))
})

test_that("test sbf_load_data_from_pg works", {
  skip_on_ci()
  # set up database
  dat <- data.frame(
    x = c(1:10),
    y = c(rep("yes", 5), rep("no", 4), NA)
  )
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      )
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.dat (
     x INTEGER NOT NULL,
     y TEXT)",
    config_path = config_path
  )
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.dat",
        config_path = config_path
      )
    )
  )
  psql::psql_add_data(dat, schema = "boat_count", config_path = config_path)
  # execute tests
  output <- sbf_load_data_from_pg(
    x = "dat",
    schema = "boat_count",
    config_path = config_path
  )
  expect_equal(output, dat)
  expect_s3_class(output, "data.frame")
})

test_that("test sbf_save_data_to_pg works when no x_name passed", {
  skip_on_ci()
  # set up test
  dat <- data.frame(
    x = c(1:10),
    y = c(21:30)
  )
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.dat (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.dat",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  output <- sbf_save_data_to_pg(
    x = dat, 
    schema = "boat_count",
    config_path = config_path
  )
  query <- DBI::dbGetQuery(
    psql::psql_connect(config_path = config_path),
    "SELECT * FROM boat_count.dat"
  )
  # tests
  expect_equal(output, 10)
  expect_equal(query, dat)
})

test_that("test sbf_save_data_to_pg works with x_name passed", {
  skip_on_ci()
  # set up test
  dat <- data.frame(
    x = c(1:10),
    y = c(21:30)
  )
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  psql::psql_execute_db(
    "CREATE TABLE boat_count.data (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  withr::defer(
    try(
      psql::psql_execute_db(
        "DROP TABLE boat_count.data",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  output <- sbf_save_data_to_pg(
    x = dat, 
    schema = "boat_count",
    x_name = "data",
    config_path = config_path
  )
  query <- DBI::dbGetQuery(
    psql::psql_connect(config_path = config_path),
    "SELECT * FROM boat_count.data"
  )
  # tests
  expect_equal(output, 10)
  expect_equal(query, dat)
})

