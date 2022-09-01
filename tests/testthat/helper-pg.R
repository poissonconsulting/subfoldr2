create_local_database <- function(schema = NULL,
                                  table = NULL,
                                  data = TRUE,
                                  env = parent.frame()) {
  # create a local database, schema and table (with or without data)
  # all objects that are created are removed (complete clean up)
  chk::chk_null_or(schema, vld = chk::vld_string)
  chk::chk_null_or(table, vld = chk::vld_s3_class, class = "data.frame")
  chk::chk_flag(data)
  chk::chk_null_or(env, vld = chk::vld_s3_class, class = "environment")

  withr::defer(DBI::dbDisconnect(conn), envir = env)

  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = NULL,
    user = NULL,
    password = NULL
  )

  local_dbname <- tolower(
    rawToChar(
      as.raw(
        sample(c(65:90, 97:122), 12, TRUE)
      )
    )
  )

  withr::defer(
    {
      clean_cmd <- paste0("DROP DATABASE ", local_dbname, ";")
      result1 <- DBI::dbSendQuery(conn, clean_cmd)
      DBI::dbClearResult(result1)
    },
    envir = env
  )

  cmd <- paste0("CREATE DATABASE ", local_dbname, ";")
  result2 <- DBI::dbSendQuery(conn, cmd)
  DBI::dbClearResult(result2)

  if (!is.null(schema)) {
    withr::defer(DBI::dbDisconnect(conn_local), envir = env)

    conn_local <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = "127.0.0.1",
      port = 5432,
      dbname = local_dbname,
      user = NULL,
      password = NULL
    )
    withr::defer(
      {
        sql_drop <- paste0("DROP SCHEMA ", schema, ";")
        try(result3 <- DBI::dbSendQuery(conn_local, sql_drop), silent = TRUE)
        try(DBI::dbClearResult(result3), silent = TRUE)
      },
      envir = env
    )
    sql <- paste0("CREATE SCHEMA ", schema, ";")
    DBI::dbExecute(conn_local, sql)
  }

  if (!is.null(table)) {
    withr::defer(
      {
        sql_drop <- paste0(
          "DROP TABLE ", schema, ".", deparse(substitute(table)), ";"
        )
        result4 <- DBI::dbSendQuery(conn_local, sql_drop)
        DBI::dbClearResult(result4)
      },
      envir = env
    )

    tbl_name <- deparse(substitute(table))

    if (data) {
      DBI::dbWriteTable(
        conn_local,
        name = DBI::Id(schema = schema, table = tbl_name),
        value = table
      )
    } else {
      DBI::dbCreateTable(
        conn_local,
        name = DBI::Id(schema = schema, table = tbl_name),
        fields = table
      )
    }
  }

  config_deets <- paste0("default:\n  dbname: ", local_dbname, "\n")
  config_file_path <- withr::local_file(
    "local_test_config.yml",
    .local_envir = env
  )
  fileConn <- file(config_file_path)
  writeLines(config_deets, fileConn)
  close(fileConn)

  config_file_path
}


local_connection <- function(file) {
  config_details <- config::get(file = file)
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = config_details$dbname,
    user = NULL,
    password = NULL
  )
  conn
}

local_connection_default <- function() {
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = NULL,
    user = NULL,
    password = NULL
  )
  conn
}

check_schema_exists <- function(config_path) {
  withr::defer(DBI::dbDisconnect(conn))
  conn <- local_connection(config_path)
  query <- DBI::dbGetQuery(
    conn,
    "SELECT schema_name FROM information_schema.schemata"
  )
  query
}

check_db_table <- function(config_path, schema, tbl_name) {
  cmd <- paste0("SELECT * FROM ", schema, ".", tbl_name)
  withr::defer(DBI::dbDisconnect(conn))
  conn <- local_connection(config_path)
  query <- DBI::dbGetQuery(
    conn,
    cmd
  )
  query
}

clean_up_schema <- function(config_path,
                            schema = "boat_count",
                            env = parent.frame()) {
  withr::defer(DBI::dbDisconnect(conn))
  conn <- local_connection(config_path)
  cmd <- paste0("DROP SCHEMA ", schema)
  withr::defer(try(DBI::dbExecute(conn, cmd), silent = TRUE))
}

clean_up_db <- function(dbname = "newdb", env = parent.frame()) {
  cmd <- paste0("DROP DATABASE ", dbname, ";")
  withr::defer(DBI::dbDisconnect(conn), envir = env)

  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = NULL,
    user = NULL,
    password = NULL
  )

  withr::defer(
    {
      try(
        result <- DBI::dbSendQuery(conn, cmd),
        silent = TRUE
      )
      try(
        DBI::dbClearResult(result),
        silent = TRUE
      )
    },
    envir = env
  )
}

rename_and_remove_data <- function(data) {
  new_dat <- data
  rm(data)
  invisible(new_dat)
}
