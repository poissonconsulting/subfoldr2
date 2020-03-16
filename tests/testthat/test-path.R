test_that("path object",  {
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  sbf_set_main(tempdir())
  expect_match(sbf_path_object("x"), ".*/objects/x[.]rds")
  expect_match(sbf_path_object("x", exists = FALSE), ".*/objects/x[.]rds")
  chk::expect_chk_error(sbf_path_object("x", exists = TRUE), "`x_name` must specify existing files")
})

test_that("path db",  {
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  sbf_set_main(tempdir())
  sbf_open_db("bd", exists = NA)
  expect_match(sbf_path_db("bd"), ".*/dbs/bd[.]sqlite")
  expect_match(sbf_path_db("bd", exists = TRUE), ".*/dbs/bd[.]sqlite")
  chk::expect_chk_error(sbf_path_db("bd", exists = FALSE),  ".*/dbs/bd[.]sqlite")
})
