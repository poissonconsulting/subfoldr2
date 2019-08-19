context("copy")

test_that("sbf_copy_db",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  expect_error(sbf_open_db(exists = TRUE),
               "^file '.*database.sqlite' doesn't exist$")
  
  path <- system.file("extdata", "example.sqlite", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_true(sbf_copy_db(path))
  
  conn <- sbf_open_db()
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})
