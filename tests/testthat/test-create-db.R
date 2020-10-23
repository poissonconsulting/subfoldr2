test_that("create-db", {
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))

  chk::expect_chk_error(sbf_open_db(exists = TRUE))
  
  expect_true(sbf_create_db())
  
  conn <- sbf_open_db(exists = TRUE)
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})
