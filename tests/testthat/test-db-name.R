test_that("db_name",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  expect_identical(sbf_reset_db_name(), "database")
  expect_identical(sbf_get_db_name(), "database")
  expect_identical(sbf_set_db_name("db2"), "db2")
  expect_identical(sbf_get_db_name(), "db2")
  expect_identical(sbf_reset_db_name(), "database")
  expect_identical(sbf_get_db_name(), "database")
})
