test_that("sbf_copy_db",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  expect_error(sbf_open_db(exists = TRUE),
               "^`file` must specify an existing file [(]'.*dbs/database.sqlite' can't be found[)].$", class = "chk_error")
  
  path <- system.file("extdata", "example.sqlite", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_true(sbf_copy_db(path))
  
  conn <- sbf_open_db()
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})

test_that("sbf_copy_db with different name",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  sbf_reset_sub()
  teardown(sbf_reset_sub(ask = FALSE))
  
  expect_error(sbf_open_db(exists = TRUE),
               "^`file` must specify an existing file [(]'.*dbs/database.sqlite' can't be found[)].$", class = "chk_error")

  expect_error(sbf_open_db("new_one", exists = TRUE),
               "^`file` must specify an existing file [(]'.*dbs/new_one.sqlite' can't be found[)].$", class = "chk_error")
  
  path <- system.file("extdata", "example.sqlite", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_true(sbf_copy_db(path, "new_one"))

  expect_error(sbf_open_db(exists = TRUE),
               "^`file` must specify an existing file [(]'.*dbs/database.sqlite' can't be found[)].$", class = "chk_error")

  conn <- sbf_open_db("new_one")
  teardown(suppressWarnings(DBI::dbDisconnect(conn)))
  expect_is(conn, "SQLiteConnection")
  expect_true(sbf_close_db(conn))
})

test_that("sbf_copy_db error messages",{
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())
  
  path <- system.file("extdata", "example.png", package = "subfoldr2", 
                      mustWork = TRUE)
  expect_error(sbf_copy_db(path), 
               "^`path` must have extension 'db', 'sqlite' or 'sqlite3' [(]not 'png'[)][.]$", class = "chk_error")

  path <- sub("[.]png$", ".db", path)

  expect_error(sbf_open_db(path),
               "^`file` must specify an existing file [(]'.*.example.db.sqlite' can't be found[)].$", class = "chk_error")
})
