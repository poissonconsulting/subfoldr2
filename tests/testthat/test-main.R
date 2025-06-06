test_that("main", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  expect_identical(sbf_reset_main(), "output")
  expect_identical(sbf_get_main(), "output")
  expect_identical(sbf_set_main("output2"), "output2")
  expect_identical(sbf_get_main(), "output2")
  expect_identical(sbf_set_main("/"), "/")
  expect_identical(sbf_reset_main(), "output")
  expect_identical(sbf_get_main(), "output")
  expect_identical(sbf_set_main(), character(0))
})

test_that("main not change sub", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  sbf_set_sub("sub/sub2")
  expect_identical(sbf_get_sub(), "sub/sub2")
  expect_identical(sbf_set_main("output2"), "output2")
  expect_identical(sbf_get_sub(), "sub/sub2")
})

test_that("rm_main", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  sbf_save_number(x)
  expect_true(dir.exists(sbf_get_main()))
  expect_message(expect_identical(sbf_rm_main(ask = FALSE), sbf_get_main()))
  expect_false(dir.exists(sbf_get_main()))
})

test_that("remove message mac and linux", {
  skip_on_os("windows")
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  sbf_save_number(x)
  expect_message(
    sbf_rm_main(ask = FALSE),
    paste0("Directory '", sbf_get_main(), "' deleted")
  )
})

test_that("remove message windows", {
  skip_on_os("mac")
  skip_on_os("linux")
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  sbf_save_number(x)
  expect_message(
    sbf_rm_main(ask = FALSE),
    "Directory '.*' deleted"
  )
})
