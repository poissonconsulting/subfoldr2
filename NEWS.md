# subfoldr2 0.0.0.9044

- Added `sbf_compare_datas()`.
- Added `sbf_compare_data()`.
- Allow `archive = 1L` argument to take path.


# subfoldr2 0.0.0.9043

- Test and fix `sbf_all_equal_datas()`.
- Added `sbf_all_equal_datas()` but not tested!
- Added `full_path = TRUE` argument to `sbf_list_xx()` functions.
- Added `sbf_is_equal_data()`.
- Add `sbf_get_archive()`
- Added `sbf_unarchive_main()` and added `main` argument to `sbf_rm_main()`.
- Added `sbf_rm_main()`.


# subfoldr2 0.0.0.9042

- Added `sbf_archive_main()`.


# subfoldr2 0.0.0.9041

- `sbf_print()` now provides informative error messages!
- Added sbf_create_db().
- Rename sbf_db_execute() to sbf_execute_db().
- Added sbf_db_execute().


# subfoldr2 0.0.0.9040

- Hard deprecate database metadata.
- Resetting main no longer resets the sub - use `sbf_reset()` instead.
- Add sbf_reset().
- Add sbf_get_db_name(), sbf_set_db_name() and sbf_reset_db_name().
- Added exists = NA to sbf_diff_xx() functions and removed sbf_diff_plot_data().


# subfoldr2 0.0.0.9039

- Added sbf_diff_data(), sbf_diff_table() and sbf_diff_plot_data().
- Add argument silent to sbf_print() to silence non-grid error messages.
- sbf_print only retries if grid errors
- sbf_print() no longer silent by default.
- Added sbf_print() to try printing multiple times.
- Added exists = TRUE to sbf_load_xx().


# subfoldr2 0.0.0.9038

- Added exists = TRUE to sbf_load_xx().


