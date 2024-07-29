test_that("sbf_print", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())

  withr::local_file(pdf(NULL))
  withr::defer(dev.off())

  data <- data.frame(x = 1)
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point()
  
  expect_error(sbf_print(gp), ":geom_point()")
  data$y <- 1
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point()
  expect_identical(sbf_print(gp), gp)
})

test_that("sbf_print doesn't print if plot = FALSE", {
  data <- data.frame(x = 1, y = 1)
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point()
  
  expect_identical(sbf_print(gp, plot = FALSE), invisible())
})

test_that("sbf_print plot argument errors if not logical", {
  data <- data.frame(x = 1, y = 1)
  gp <- ggplot2::ggplot(data = data, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point()
  
  expect_snapshot(
    error = TRUE,
    sbf_print(gp, plot = "x")
  )
})
