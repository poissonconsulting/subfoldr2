context("list")

test_that("object",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  x <- 1
  expect_identical(sbf_save_object(x), sub("//", "/", file.path(sbf_get_main(), "objects/x.rds")))
  
  expect_match(sbf_list_objects("x"),
               sub("//", "/", file.path(sbf_get_main(), "objects/x.rds")))
  x <- 3
  expect_identical(sbf_save_object(x, sub = "down"),
                   sub("//", "/", file.path(sbf_get_main(), "objects/down/x.rds")))

  expect_identical(sbf_list_objects("x", recursive = TRUE),
               c(sub("//", "/", file.path(sbf_get_main(), "objects/down/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "objects/x.rds"))))

  expect_identical(sbf_list_objects("x"),
               sub("//", "/", file.path(sbf_get_main(), "objects/x.rds")))
  
  y <- 4
  expect_identical(sbf_save_object(y), sub("//", "/", file.path(sbf_get_main(), "objects/y.rds")))
  expect_identical(sbf_list_objects("x", recursive = TRUE),
               c(sub("//", "/", file.path(sbf_get_main(), "objects/down/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "objects/x.rds"))))

  expect_identical(sbf_list_objects("y"),
               sub("//", "/", file.path(sbf_get_main(), "objects/y.rds")))

  expect_identical(sbf_list_objects(),
               c(sub("//", "/", file.path(sbf_get_main(), "objects/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "objects/y.rds"))))
  
  expect_identical(sbf_list_objects(sub = "down"),
                sub("//", "/", file.path(sbf_get_main(), "objects/down/x.rds")))

    expect_identical(sbf_list_objects(recursive = TRUE),
               c(sub("//", "/", file.path(sbf_get_main(), "objects/down/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "objects/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "objects/y.rds"))))
  
  expect_identical(sbf_list_objects("down", recursive = TRUE), character())
  expect_identical(sbf_list_objects("rds", recursive = TRUE), character())
})

test_that("data",{
  teardown(sbf_reset_sub(rm = TRUE, ask = FALSE))
  expect_identical(sbf_reset_sub(rm = TRUE, ask = FALSE), character(0))
  
  sbf_set_main(tempdir())
  x <- data.frame(x = 1)
  expect_identical(sbf_save_data(x), sub("//", "/", file.path(sbf_get_main(), "data/x.rds")))
  
  expect_match(sbf_list_datas("x"),
               sub("//", "/", file.path(sbf_get_main(), "data/x.rds")))
  x <- data.frame(y = 3)
  expect_identical(sbf_save_data(x, sub = "down"),
                   sub("//", "/", file.path(sbf_get_main(), "data/down/x.rds")))

  expect_identical(sbf_list_datas("x", recursive = TRUE),
               c(sub("//", "/", file.path(sbf_get_main(), "data/down/x.rds")),
               sub("//", "/", file.path(sbf_get_main(), "data/x.rds"))))
  
  expect_identical(sbf_list_datas("x", recursive = FALSE),
               sub("//", "/", file.path(sbf_get_main(), "data/x.rds")))
})