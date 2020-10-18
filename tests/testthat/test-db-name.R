test_that("db_name",{
  teardown(sbf_reset_db_name())
  expect_identical(sbf_reset_db_name(), "database")
  expect_identical(sbf_get_db_name(), "database")
  expect_identical(sbf_set_db_name("db2"), "db2")
  expect_identical(sbf_get_db_name(), "db2")
  expect_identical(sbf_reset_db_name(), "database")
  expect_identical(sbf_get_db_name(), "database")
})
