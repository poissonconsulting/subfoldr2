test_that("object", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  expect_identical(sbf_save_object(x), file.path(sbf_get_main(), "objects/x.rds"))

  expect_match(sbf_list_objects("x"), "objects/x.rds$")
  expect_identical(names(sbf_list_objects("x")), "objects/x")
  x <- 3
  expect_identical(
    sbf_save_object(x, sub = "down"),
    file.path(sbf_get_main(), "objects/down/x.rds")
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects("x", recursive = TRUE),
    c(
      file.path(sbf_get_main(), "objects/down/x.rds"),
      file.path(sbf_get_main(), "objects/x.rds")
    )
  )

  expect_identical(
    names(sbf_list_objects("x", recursive = TRUE)),
    c("objects/down/x", "objects/x")
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects("x"),
    file.path(sbf_get_main(), "objects/x.rds")
  )

  expect_identical(
    names(sbf_list_objects("x")),
    "objects/x"
  )

  y <- 4
  expect_identical(sbf_save_object(y), file.path(sbf_get_main(), "objects/y.rds"))
  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects("x", recursive = TRUE),
    c(
      file.path(sbf_get_main(), "objects/down/x.rds"),
      file.path(sbf_get_main(), "objects/x.rds")
    )
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects("y"),
    file.path(sbf_get_main(), "objects/y.rds")
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects(),
    c(
      file.path(sbf_get_main(), "objects/x.rds"),
      file.path(sbf_get_main(), "objects/y.rds")
    )
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects(sub = "down"),
    file.path(sbf_get_main(), "objects/down/x.rds")
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_objects(recursive = TRUE),
    c(
      file.path(sbf_get_main(), "objects/down/x.rds"),
      file.path(sbf_get_main(), "objects/x.rds"),
      file.path(sbf_get_main(), "objects/y.rds")
    )
  )

  expect_identical(
    names(sbf_list_objects(recursive = TRUE)),
    c(
      "objects/down/x",
      "objects/x",
      "objects/y"
    )
  )

  expect_equal(ignore_attr = TRUE, sbf_list_objects("down", recursive = TRUE), character(0))
  expect_equal(ignore_attr = TRUE, sbf_list_objects("rds", recursive = TRUE), character(0))
  expect_identical(names(sbf_list_objects("rds", recursive = TRUE)), character(0))
})

test_that("data", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), file.path(sbf_get_main(), "data/x.rds"))

  expect_match(sbf_list_datas("x"), "data/x.rds$")
  expect_match(
    names(sbf_list_datas("x")),
    "data/x"
  )
  x <- data.frame(y = 3)
  expect_identical(
    sbf_save_data(x, sub = "down"),
    file.path(sbf_get_main(), "data/down/x.rds")
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_datas("x", recursive = TRUE),
    c(
      file.path(sbf_get_main(), "data/down/x.rds"),
      file.path(sbf_get_main(), "data/x.rds")
    )
  )

  expect_identical(
    names(sbf_list_datas("x", recursive = TRUE)),
    c(
      "data/down/x",
      "data/x"
    )
  )

  expect_equal(ignore_attr = TRUE, 
    sbf_list_datas("x", recursive = FALSE),
    file.path(sbf_get_main(), "data/x.rds")
  )

  expect_identical(
    names(sbf_list_datas("x", recursive = FALSE)),
    "data/x"
  )
})
