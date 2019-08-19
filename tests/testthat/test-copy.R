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

test_that("sbf_copy_db with different name",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  expect_error(sbf_open_db(exists = TRUE),
               "^file '.*database.sqlite' doesn't exist$")

  expect_error(sbf_open_db("new_one", exists = TRUE),
               "^file '.*new_one.sqlite' doesn't exist$")
  
  path <- system.file("extdata", "example.sqlite", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_true(sbf_copy_db(path, "new_one"))

  expect_error(sbf_open_db(exists = TRUE),
               "^file '.*database.sqlite' doesn't exist$")

  conn <- sbf_open_db("new_one")
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})

test_that("sbf_copy_db error messages",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  path <- system.file("extdata", "example.png", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_error(sbf_copy_db(path), 
               "^File '.*example[.]png' must have extension '[.]db', '[.]sqlite' or '[.]sqlite3'[.]$")

  path <- sub("[.]png$", ".db", path)

  expect_error(sbf_open_db(path),
               "^file '.*.sqlite' doesn't exist$")
})
