# test_that("archive", {
#   sbf_reset()
#   sbf_set_main(file.path(withr::local_tempdir(), "output"))
#   withr::defer(sbf_reset())
# 
#   expect_chk_error(sbf_archive_main(ask = FALSE))
# 
#   x <- 1
#   sbf_save_number(x)
#   expect_identical(sbf_load_number("x"), x)
#   expect_message(new_main <- sbf_archive_main(ask = FALSE))
#   expect_identical(sbf_load_number("x"), x)
#   expect_identical(sbf_load_number("x", main = new_main), x)
#   expect_true(grepl("\\d{4,4}(-\\d{2,2}){5,5}$", new_main))
# })

test_that("archive message", {
  sbf_reset()
  sbf_set_main(file.path(withr::local_tempdir(), "output"))
  withr::defer(sbf_reset())
  
  path <- as.character(str2expression(sprintf('"%s"', sbf_get_main())))
  
  x <- 1
  sbf_save_number(x)
  expect_message(
    sbf_archive_main(ask = FALSE),
    paste0("Directory '", path, "' copied to '", path, "-", dttr2::dtt_sys_date())
  )
})

# expect_message(
#   sbf_archive_main(ask = FALSE),
#   cat(paste0("Directory '", sbf_get_main(), "' copied to '", sbf_get_main(), "-", dttr2::dtt_sys_date()))
# )
# 
# paste0("Directory '", "/var/folders/yr/")
# 
# stringr::str_match()
# file.path("/var/folders/yr/")
# file.path("\\var\\folders\\yr/")
# 
# as.character("\\var\\folders\\yr/")
# 
# gsub("\\\\", "/", "\\var\\folders\\yr/")
# 
# as.character(str2expression(sprintf('"%s"', "\\var\\folders\\r/")))
# as.character(str2expression(sprintf('"%s"', "/var/folders/r/")))
# 
# sprintf("%s", "\\var\\folders\\r/")
# 
# 
# x <- cat("hello\\")
# x
# 
# x <- toString(c("hello\\", c(1,2,3)))
# x
# 
# x <- capture.output(cat("hello\\", c(1,2,3), sep=","))
# x
# test_that("get_archive", {
#   sbf_reset()
#   sbf_set_main(file.path(withr::local_tempdir(), "output"))
#   withr::defer(sbf_reset())
# 
#   x <- 1
#   sbf_save_number(x)
#   expect_message(new_main1 <- sbf_archive_main(ask = FALSE))
#   x <- 2
#   sbf_save_number(x)
#   expect_message(new_main2 <- sbf_archive_main(ask = FALSE))
# 
#   expect_equal(as.character(sbf_get_archive(archive = 2L)), new_main1)
#   expect_equal(as.character(sbf_get_archive(archive = 1L)), new_main2)
#   expect_error(sbf_get_archive(archive = 3L))
# })
# 
# test_that("unarchive", {
#   sbf_reset()
#   sbf_set_main(file.path(withr::local_tempdir(), "output"))
#   withr::defer(sbf_reset())
# 
#   x <- 1
#   sbf_save_number(x)
#   expect_message(archive1 <- sbf_archive_main(ask = FALSE))
#   x <- 2
#   sbf_save_number(x)
#   expect_message(archive2 <- sbf_archive_main(ask = FALSE))
#   x <- 3
#   sbf_save_number(x)
#   expect_message(archive3 <- sbf_archive_main(ask = FALSE))
# 
#   expect_identical(sbf_load_number("x"), 3)
#   expect_message(expect_message(expect_equal(sbf_unarchive_main(archive = archive1, ask = FALSE), archive1)))
#   expect_identical(sbf_load_number("x"), 1)
#   expect_message(expect_message(expect_equal(as.character(sbf_unarchive_main(ask = FALSE)), archive3)))
#   expect_identical(sbf_load_number("x"), 3)
#   expect_error(sbf_unarchive_main(archive = 2L, ask = FALSE))
#   expect_message(expect_message(expect_equal(as.character(sbf_unarchive_main(ask = FALSE)), archive2)))
#   expect_identical(sbf_load_number("x"), 2)
#   expect_error(sbf_unarchive_main(ask = FALSE))
# })
