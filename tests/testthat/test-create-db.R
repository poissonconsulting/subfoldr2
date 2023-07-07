test_that("create-db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  chk::expect_chk_error(sbf_open_db(exists = TRUE))

  expect_true(sbf_create_db())

  withr::defer(suppressWarnings(DBI::dbDisconnect(conn)))
  conn <- sbf_open_db(exists = TRUE)
  expect_s4_class(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})
