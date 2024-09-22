file_path <- "model_run_log.txt"

if (!file.exists(file_path)) {
  file.create(file_path)
}
current_datetime <- Sys.time()
user <- sub("^/Users/([^/]+)/.*$", "\\1", getwd())

write(paste(current_datetime, "\n", user), file = file_path, append = TRUE)

cat("Current date and time has been appended to", file_path, "\n")
