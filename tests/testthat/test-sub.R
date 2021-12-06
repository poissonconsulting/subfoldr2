test_that("sub", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  teardown(sbf_reset())

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_get_sub(), character(0))
  expect_identical(sbf_set_sub("sub"), "sub")
  expect_identical(sbf_get_sub(), "sub")
  expect_identical(
    sbf_set_sub(c("sub", "wub"), "mub/yub"),
    c("sub/wub/mub/yub")
  )
  expect_identical(sbf_set_sub("sub", "tub"), "sub/tub")
  expect_identical(sbf_set_sub("sub/rub", "tub"), "sub/rub/tub")
  expect_identical(sbf_set_sub("sub/"), "sub")
  expect_identical(sbf_set_sub("/sub"), "sub")
  expect_identical(sbf_set_sub("sub/", "tub"), "sub/tub")
  expect_identical(sbf_add_sub("bub", "nub"), "sub/tub/bub/nub")
  expect_identical(sbf_up_sub(), "sub/tub/bub")
  expect_identical(sbf_up_sub(2), "sub")
  expect_identical(sbf_up_sub(), character(0))
  expect_error(sbf_up_sub(3),
    "^`n` [(]3[)] must not exceed the number of subfolders [(]0[)][.]$",
    class = "chk_error"
  )

  expect_identical(sbf_reset_sub(), character(0))
  expect_identical(sbf_get_sub(), character(0))
})
