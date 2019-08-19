library(readwritesqlite)
conn <- rws_connect("inst/extdata/example.sqlite")
rws_write(mtcars, exists = FALSE, conn = conn)
rws_disconnect(conn)
