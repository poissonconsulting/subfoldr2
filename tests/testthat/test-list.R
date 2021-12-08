test_that("list object", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  x <- 1
  expect_identical(
    sbf_save_object(x),
    file.path(sbf_get_main(), "objects/x.rds")
  )

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
  expect_identical(
    sbf_save_object(y),
    file.path(sbf_get_main(), "objects/y.rds")
  )
  expect_equal(
    sbf_list_objects("x", recursive = TRUE),
    c(
      file.path(sbf_get_main(), "objects/down/x.rds"),
      file.path(sbf_get_main(), "objects/x.rds")
    ),
    ignore_attr = TRUE
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

  expect_equal(ignore_attr = TRUE,
               sbf_list_objects("down", recursive = TRUE),
    character(0)
  )
  expect_equal(ignore_attr = TRUE,
               sbf_list_objects("rds", recursive = TRUE),
    character(0))
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

test_that("list tables", {
sbf_reset()
sbf_set_main(file.path(withr::local_tempdir(), "output"))
withr::defer(sbf_reset())

x <- data.frame(x = 1, y = 2)
sbf_save_table(x)
sbf_save_table(x, sub = "down")


expect_match(sbf_list_tables(), "tables/x.rds$")
expect_match(names(sbf_list_tables()), "tables/x")

expect_equal(ignore_attr = TRUE, sbf_list_tables(recursive = TRUE),
             c(file.path(sbf_get_main(), "tables/down/x.rds"),
               file.path(sbf_get_main(), "tables/x.rds")))

expect_equal(names(sbf_list_tables(recursive = TRUE)), c("tables/down/x", "tables/x"))

})


test_that("list numbers", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_save_number(1)
  sbf_save_number(1, sub = "down")
  
  expect_match(sbf_list_numbers(), "numbers/1.rds$")
  expect_match(names(sbf_list_numbers()), "numbers/1")
  
  expect_equal(ignore_attr = TRUE, sbf_list_numbers(recursive = TRUE),
               c(file.path(sbf_get_main(), "numbers/1.rds"),
                 file.path(sbf_get_main(), "numbers/down/1.rds")))
  
  expect_equal(names(sbf_list_numbers(recursive = TRUE)), c("numbers/1", "numbers/down/1"))
    
})

test_that("list strings", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_save_string("x")
  sbf_save_string("x", sub = "down")
  
  expect_match(sbf_list_strings(), "strings/x.rds$")
  expect_match(names(sbf_list_strings()), "strings/x")
  
  expect_equal(ignore_attr = TRUE, sbf_list_strings(recursive = TRUE),
               c(file.path(sbf_get_main(), "strings/down/x.rds"),
                 file.path(sbf_get_main(), "strings/x.rds")))
  
  expect_equal(names(sbf_list_strings(recursive = TRUE)), c("strings/down/x", "strings/x"))
  
})

test_that("list blocks", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_save_block("x")
  sbf_save_block("x", sub = "down")
  
  expect_match(sbf_list_blocks(), "blocks/x.rds$")
  expect_match(names(sbf_list_blocks()), "blocks/x")
  
  expect_equal(ignore_attr = TRUE, sbf_list_blocks(recursive = TRUE),
               c(file.path(sbf_get_main(), "blocks/down/x.rds"),
                 file.path(sbf_get_main(), "blocks/x.rds")))
  
  expect_equal(names(sbf_list_blocks(recursive = TRUE)), c("blocks/down/x", "blocks/x"))
  
})

test_that("list plots", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  data <- data.frame(x = 1, y = 2)
  x <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y))
  
  sbf_save_plot(x)
  sbf_save_plot(x, sub = "down")
  
  expect_match(sbf_list_plots(), "plots/x.rds$")
  expect_match(names(sbf_list_plots()), "plots/x")
  
  expect_equal(ignore_attr = TRUE, sbf_list_plots(recursive = TRUE),
               c(file.path(sbf_get_main(), "plots/down/x.rds"),
                 file.path(sbf_get_main(), "plots/x.rds")))
  
  expect_equal(names(sbf_list_plots(recursive = TRUE)), c("plots/down/x", "plots/x"))
  
})

test_that("list windows", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  png <- system.file("extdata", "example.png",
                     package = "subfoldr2",
                     mustWork = TRUE)
  sbf_save_png(png)
  sbf_save_png(png, sub = "down")
  
  expect_match(sbf_list_windows(), "windows/example.png$")
  expect_match(names(sbf_list_windows()), "windows/example")
  
  expect_equal(ignore_attr = TRUE, sbf_list_windows(recursive = TRUE),
               c(file.path(sbf_get_main(), "windows/down/example.png"),
                 file.path(sbf_get_main(), "windows/example.png")))
  
  expect_equal(names(sbf_list_windows(recursive = TRUE)), c("windows/down/example", "windows/example"))
  
})

test_that("list dbs", {
  
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  sbf_open_db(exists = FALSE)
  sbf_open_db(exists = FALSE, sub = "down")
  
  
  expect_match(sbf_list_dbs(), "dbs/database.sqlite$")
  expect_match(names(sbf_list_dbs()), "dbs/database")
  
  expect_equal(ignore_attr = TRUE, sbf_list_dbs(recursive = TRUE),
               c(file.path(sbf_get_main(), "dbs/database.sqlite"),
                 file.path(sbf_get_main(), "dbs/down/database.sqlite")))
  
  expect_equal(names(sbf_list_dbs(recursive = TRUE)), c("dbs/database", "dbs/down/database"))
  
})
