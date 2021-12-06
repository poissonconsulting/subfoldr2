test_that("create-db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_create_db()

  expect_identical(sbf_execute_db("CREATE TABLE test (
    x TEXT);"), 0L)

  test <- tibble::tibble(x = "one")
  sbf_save_data_to_db(test)
  expect_identical(sbf_load_data_from_db("test"), test)
})
