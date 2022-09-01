test_that("test sbf_open_pg works", {
  skip_on_ci()
  # set up
  withr::defer(DBI::dbDisconnect(conn))
  # tests
  conn <- sbf_open_pg(config_path = NULL, config_value = NULL)
  expect_s4_class(conn, "PqConnection")
})

test_that("test sbf_close_pg works", {
  skip_on_ci()
  # set up
  withr::defer(suppressWarnings(DBI::dbDisconnect(conn)))
  # tests
  ### switched to DBI fun for opening
  conn <- sbf_open_pg(config_path = NULL, config_value = NULL)
  sbf_close_pg(conn)
  expect_error(
    DBI::dbExecute(conn, "SELECT 1+1;"),
    regexp = "external pointer is not valid"
  )
})

test_that("test sbf_back_pg works", {
  skip_on_ci()
  # set up
  config_path <- create_local_database()
  temp_dir <- withr::local_tempdir()
  dump_path <- file.path(temp_dir, "dump_db1.sql")
  # tests
  sbf_backup_pg(
    path = dump_path,
    config_path = config_path
  )
  expect_true(file.exists(dump_path))
})

test_that("test sbf_create_pg works", {
  skip_on_ci()
  # set up
  clean_up_db("newdb")
  # tests
  output <- sbf_create_pg("newdb", NULL, NULL)
  expect_true(output)
})

test_that("test sbf_execute_pg works", {
  skip_on_ci()
  # set up
  local_config <- create_local_database()
  clean_up_schema(local_config)
  # test
  output <- sbf_execute_pg(
    "CREATE SCHEMA boat_count",
    config_path = local_config
  )
  schema_info <- check_schema_exists(local_config)
  expect_equal(output, 0L)
  expect_true("boat_count" %in% schema_info$schema_name)
})

test_that("test sbf_list_tables_pg works", {
  skip_on_ci()
  # set up 
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(schema = "boat_count", table = outing)
  # test
  output <- sbf_list_tables_pg(
    "boat_count",
    config_path = local_config
  )
  expect_equal(output, "outing")
})

test_that("test sbf_load_data_from_pg works", {
  skip_on_ci()
  # set up 
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(schema = "boat_count", table = outing)
  # tests
  output <- sbf_load_data_from_pg(
    x = "outing",
    schema = "boat_count",
    config_path = local_config
  )
  expect_equal(output, outing)
  expect_s3_class(output, "data.frame")
})

test_that("checking sbf_load_datas_from_pg pulls data from tables", {
  skip_on_ci()
  # set up test
  outing <- data.frame(x = c(1:5), y = c(5:9))
  local_config <- create_local_database(schema = "boat_count", table = outing)
  ### this needs to be wrapped up in a little helper fn 
  outing_dat <- outing
  rm(outing)
  # execute tests
  output <- sbf_load_datas_from_pg(
    "boat_count",
    config_path = local_config
  )
  expect_equal(output, "outing")
  expect_equal(outing, outing_dat)
})

test_that("checking sbf_load_datas_from_pg pulls tables and renames them", {
  skip_on_ci()
  # set up test
  outing <- data.frame(x = c(1:5), y = c(5:9))
  local_config <- create_local_database(schema = "boat_count", table = outing)
  # execute tests
  output <- sbf_load_datas_from_pg(
    "boat_count",
    rename = toupper,
    config_path = local_config
  )
  expect_equal(output, "OUTING")
  expect_equal(OUTING, outing)
})

test_that("test sbf_save_data_to_pg works when no x_name passed", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(
    schema = "boat_count",
    table = outing,
    data = FALSE
  )
  # tests
  output <- sbf_save_data_to_pg(
    x = outing, 
    schema = "boat_count",
    config_path = local_config
  )
  query <- check_db_table(local_config,"boat_count", "outing")
  expect_equal(output, 5)
  expect_equal(query, outing)
})

test_that("test sbf_save_data_to_pg works with x_name passed", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(
    schema = "boat_count",
    table = outing,
    data = FALSE
  )
  # tests
  outing_new <- data.frame(x = 1:2, y = 2:3)
  output <- sbf_save_data_to_pg(
    x = outing_new, 
    schema = "boat_count",
    x_name = "outing",
    config_path = local_config
  )
  query <- check_db_table(local_config,"boat_count", "outing")
  expect_equal(output, 2)
  expect_equal(query, outing_new)
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