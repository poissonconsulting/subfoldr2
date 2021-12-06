test_that("datas_to_db", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_create_db()

  # 2 column pk
  sbf_execute_db("CREATE TABLE df (
                char TEXT NOT NULL,
                num REAL NOT NULL,
                PRIMARY KEY (char, num))")

  # one column pk with empty
  sbf_execute_db("CREATE TABLE df2 (
                char TEXT PRIMARY KEY NOT NULL)")

  # one column pk with two blob cols
  df <- data.frame(char = c("a", "a", "b"), num = c(1, 2.1, 1))
  df2 <- data.frame(char = c("a", "b"))
  sbf_save_data_to_db(df)
  sbf_save_data_to_db(df2)

  flob <- flobr::flob_obj
  conn <- sbf_open_db()
  withr::defer(sbf_close_db(conn))
  dbflobr::write_flob(flob, "New", "df", key = data.frame(char = "a", num = 1), conn)

  expect_identical(sbf_save_flobs_from_db(), list(`df/New` = c(flobr.pdf = "a_-_1.pdf")))

  expect_identical(
    list.files(file.path(sbf_get_main(), "flobs"), recursive = TRUE),
    "database/df/New/a_-_1.pdf"
  )

  expect_error(sbf_upload_flobs_to_db())
  expect_identical(sbf_upload_flobs_to_db(exists = TRUE, replace = TRUE), list(`df/New` = c(`a_-_1.pdf` = TRUE)))
  expect_identical(sbf_upload_flobs_to_db(
    exists = TRUE, replace = TRUE,
    dir = file.path(sbf_get_main(), "flobs", sbf_get_db_name())
  ), list(`df/New` = c(`a_-_1.pdf` = TRUE)))

  sbf_rm_flobs(ask = FALSE)
  expect_error(sbf_upload_flobs_to_db())

  expect_true(sbf_add_blob_column_to_db("FieldCard", "df"))
})
