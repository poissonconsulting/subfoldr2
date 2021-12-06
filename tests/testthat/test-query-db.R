test_that("query-db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  sbf_create_db()
  test <- tibble::tibble(x = "one")

  expect_identical(sbf_execute_db("CREATE TABLE test (
    x TEXT);"), 0L)

  sbf_save_data_to_db(test)

  sql <- sbf_query_db("SELECT sql FROM sqlite_master")
  expect_is(sql, "data.frame")
  expect_identical(colnames(sql), "sql")
  expect_is(sql$sql, "character")
  expect_gt(length(sql$sql), 0)
})
