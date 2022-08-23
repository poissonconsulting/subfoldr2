# test_that("checking sbf_load_datas_from_pg pulls tables", {
#   skip_on_ci()
#   # set up test
#   dat <- data.frame(x = c(1:5), y = c(5:9))
#   config_path <- system.file("testhelpers/config.yml", package = "psql")
#   psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP SCHEMA boat_count",
#         config_path = config_path
#       )
#     )
#   )
#   psql::psql_execute_db(
#     "CREATE TABLE boat_count.input (
#      x INTEGER NOT NULL,
#      y INTEGER)",
#     config_path = config_path
#   )
#   psql::psql_add_data(dat, schema = "boat_count", tbl_name = "input", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP TABLE boat_count.input",
#         config_path = config_path
#       )
#     )
#   )
#   psql::psql_execute_db(
#     "CREATE TABLE boat_count.counts (
#      x INTEGER NOT NULL,
#      y INTEGER)",
#     config_path = config_path
#   )
#   psql::psql_add_data(dat, schema = "boat_count", tbl_name = "counts", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP TABLE boat_count.counts",
#         config_path = config_path
#       )
#     )
#   )
#   # execute tests
#   output <- sbf_load_datas_from_pg(
#     "boat_count",
#     config_path = config_path
#   )
#   expect_equal(sort(output), sort(c("input", "counts")))
#   expect_equal(counts, dat)
#   expect_equal(input, dat)
# })
# 
# test_that("checking sbf_load_datas_from_pg pulls tables and renames them", {
#   skip_on_ci()
#   # set up test
#   dat <- data.frame(x = c(1:5), y = c(5:9))
#   config_path <- system.file("testhelpers/config.yml", package = "psql")
#   psql::psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP SCHEMA boat_count",
#         config_path = config_path
#       )
#     )
#   )
#   psql::psql_execute_db(
#     "CREATE TABLE boat_count.input (
#      x INTEGER NOT NULL,
#      y INTEGER)",
#     config_path = config_path
#   )
#   psql::psql_add_data(dat, schema = "boat_count", tbl_name = "input", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP TABLE boat_count.input",
#         config_path = config_path
#       )
#     )
#   )
#   psql::psql_execute_db(
#     "CREATE TABLE boat_count.counts (
#      x INTEGER NOT NULL,
#      y INTEGER)",
#     config_path = config_path
#   )
#   psql::psql_add_data(dat, schema = "boat_count", tbl_name = "counts", config_path = config_path)
#   withr::defer(
#     try(
#       psql::psql_execute_db(
#         "DROP TABLE boat_count.counts",
#         config_path = config_path
#       )
#     )
#   )
#   # execute tests
#   output <- sbf_load_datas_from_pg(
#     "boat_count",
#     rename = toupper,
#     config_path = config_path
#   )
#   expect_equal(sort(output), sort(c("INPUT", "COUNTS")))
#   expect_equal(COUNTS, dat)
#   expect_equal(INPUT, dat)
# })
