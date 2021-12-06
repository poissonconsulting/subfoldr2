test_that("reset", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  sbf_set_main("output2")
  sbf_set_sub("sub2")
  sbf_set_db_name("database2")

  expect_identical(sbf_get_main(), "output2")
  expect_identical(sbf_get_sub(), "sub2")
  expect_identical(sbf_get_db_name(), "database2")

  expect_null(sbf_reset())

  expect_identical(sbf_get_main(), "output")
  expect_identical(sbf_get_sub(), character(0))
  expect_identical(sbf_get_db_name(), "database")
})
