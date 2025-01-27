test_that("sbf_open_pg gives deprecation message", {
  expect_error(
    sbf_open_pg(),
    regexp = "was deprecated"
  )
})

test_that("sbf_close_pg gives deprecation message", {
  expect_error(
    sbf_close_pg(),
    regexp = "was deprecated"
  )
})

test_that("sbf_backup_pg gives deprecation message", {
  expect_error(
    sbf_backup_pg(),
    regexp = "was deprecated"
  )
})

test_that("sbf_create_pg gives deprecation message", {
  expect_error(
    sbf_create_pg("new_database"),
    regexp = "was deprecated"
  )
})

test_that("sbf_execute_pg gives deprecation message", {
  expect_error(
    sbf_execute_pg("SELECT * FROM table"),
    regexp = "was deprecated"
  )
})

test_that("sbf_list_tables_pg gives deprecation message", {
  expect_error(
    sbf_list_tables_pg(),
    regexp = "was deprecated"
  )
})

test_that("sbf_load_data_from_pg gives deprecation message", {
  expect_error(
    sbf_load_data_from_pg("table_name"),
    regexp = "was deprecated"
  )
})

test_that("sbf_load_datas_from_pg gives deprecation message", {
  expect_error(
    sbf_load_datas_from_pg(),
    regexp = "was deprecated"
  )
})

test_that("sbf_save_data_to_pg gives deprecation message", {
  expect_error(
    sbf_save_data_to_pg(data.frame(a = 1), "table_name"),
    regexp = "was deprecated"
  )
})

test_that("sbf_set_schema gives deprecation message", {
  expect_error(
    sbf_set_schema(),
    regexp = "was deprecated"
  )
})

test_that("sbf_get_schema gives deprecation message", {
  expect_error(
    sbf_get_schema(),
    regexp = "was deprecated"
  )
})

test_that("sbf_reset_schema gives deprecation message", {
  expect_error(
    sbf_reset_schema(),
    regexp = "was deprecated"
  )
})

test_that("sbf_set_config_file gives deprecation message", {
  expect_error(
    sbf_set_config_file(),
    regexp = "was deprecated"
  )
})

test_that("sbf_get_config_file gives deprecation message", {
  expect_error(
    sbf_get_config_file(),
    regexp = "was deprecated"
  )
})

test_that("sbf_reset_config_file gives deprecation message", {
  expect_error(
    sbf_reset_config_file(),
    regexp = "was deprecated"
  )
})

test_that("sbf_set_config_value gives deprecation message", {
  expect_error(
    sbf_set_config_value(),
    regexp = "was deprecated"
  )
})

test_that("sbf_get_config_value gives deprecation message", {
  expect_error(
    sbf_get_config_value(),
    regexp = "was deprecated"
  )
})

test_that("sbf_reset_config_value gives deprecation message", {
  expect_error(
    sbf_reset_config_value(),
    regexp = "was deprecated"
  )
})
