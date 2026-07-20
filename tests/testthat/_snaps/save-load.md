# sbf_load_plots_recursive() fails if at least one sub is populated and we drop all subs.

    Code
      out <- sbf_load_plots_recursive(main = temp_dir)
      out$file <- NULL
      out
    Output
      # A tibble: 5 x 3
        plots      name   sub  
        <list>     <chr>  <chr>
      1 <ggplt2::> plot-1 sub  
      2 <ggplt2::> plot-2 sub  
      3 <ggplt2::> plot-3 sub  
      4 <ggplt2::> plot-2 sub2 
      5 <ggplt2::> plot-3 sub3 

---

    Code
      out <- sbf_load_plots_recursive(main = temp_dir, drop = "sub")
      out$file <- NULL
      out
    Output
      # A tibble: 2 x 3
        plots      name   sub  
        <list>     <chr>  <chr>
      1 <ggplt2::> plot-2 sub2 
      2 <ggplt2::> plot-3 sub3 

# load_rdss_recursive() informs user on which folders were dropped.

    Code
      expect_identical(sbf_load_tables_recursive(drop = "t1")$name, c("t2", "t3",
        "t4", "t2", "t3", "t4", "t2", "t3", "t4"))
    Message
      Dropped:
      ! sub1/t1
      ! sub2/t1
      ! sub3/t1

---

    Code
      sbf_load_tables_recursive(drop = "sub1") %>% dplyr::mutate(file = gsub(
        ".*tables.", "", file))
    Message
      Dropped:
      ! sub1/t1
      ! sub1/t2
      ! sub1/t3
      ! sub1/t4
    Output
      # A tibble: 8 x 4
        tables       name  sub   file       
        <list>       <chr> <chr> <chr>      
      1 <df [1 x 1]> t1    sub2  sub2/t1.rds
      2 <df [1 x 1]> t2    sub2  sub2/t2.rds
      3 <df [1 x 1]> t3    sub2  sub2/t3.rds
      4 <df [1 x 1]> t4    sub2  sub2/t4.rds
      5 <df [1 x 1]> t1    sub3  sub3/t1.rds
      6 <df [1 x 1]> t2    sub3  sub3/t2.rds
      7 <df [1 x 1]> t3    sub3  sub3/t3.rds
      8 <df [1 x 1]> t4    sub3  sub3/t4.rds

---

    Code
      sbf_load_tables_recursive(drop = c("sub1", "sub2")) %>% dplyr::mutate(file = gsub(
        ".*tables.", "", file))
    Message
      Dropped:
      ! sub1/t1
      ! sub1/t2
      ! sub1/t3
      ! sub1/t4
      ! sub2/t1
      ! sub2/t2
      ! sub2/t3
      ! sub2/t4
    Output
      # A tibble: 4 x 4
        tables       name  sub   file       
        <list>       <chr> <chr> <chr>      
      1 <df [1 x 1]> t1    sub3  sub3/t1.rds
      2 <df [1 x 1]> t2    sub3  sub3/t2.rds
      3 <df [1 x 1]> t3    sub3  sub3/t3.rds
      4 <df [1 x 1]> t4    sub3  sub3/t4.rds

# `sbf_load_numbers_recursive()` drops based on file name.

    Code
      numbers
    Output
      # A tibble: 1 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       1 one   ""   

# `sbf_load_numbers_recursive()` drops based on nested file name.

    Code
      numbers
    Output
      # A tibble: 2 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       1 one   ""   
      2       1 two   ""   

# `sbf_load_numbers_recursive()` drops only exact matches.

    Code
      numbers
    Output
      # A tibble: 8 x 5
        numbers name  sub         sub1  sub2 
          <dbl> <chr> <chr>       <chr> <chr>
      1       6 hone  "bone"      bone  <NA> 
      2       5 one   "bone"      bone  <NA> 
      3       8 cone  "bone/zone" bone  zone 
      4       7 one   "bone/zone" bone  zone 
      5       1 one   ""          <NA>  <NA> 
      6       3 one   "one"       one   <NA> 
      7       4 tone  "one"       one   <NA> 
      8       2 ones  ""          <NA>  <NA> 

---

    Code
      numbers_one
    Output
      # A tibble: 3 x 5
        numbers name  sub         sub1  sub2 
          <dbl> <chr> <chr>       <chr> <chr>
      1       6 hone  "bone"      bone  <NA> 
      2       8 cone  "bone/zone" bone  zone 
      3       2 ones  ""          <NA>  <NA> 

---

    Code
      numbers_dotone
    Output
      # A tibble: 8 x 5
        numbers name  sub         sub1  sub2 
          <dbl> <chr> <chr>       <chr> <chr>
      1       6 hone  "bone"      bone  <NA> 
      2       5 one   "bone"      bone  <NA> 
      3       8 cone  "bone/zone" bone  zone 
      4       7 one   "bone/zone" bone  zone 
      5       1 one   ""          <NA>  <NA> 
      6       3 one   "one"       one   <NA> 
      7       4 tone  "one"       one   <NA> 
      8       2 ones  ""          <NA>  <NA> 

---

    Code
      numbers_bone
    Output
      # A tibble: 4 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       1 one   ""   
      2       3 one   "one"
      3       4 tone  "one"
      4       2 ones  ""   

---

    Code
      numbers_onebone
    Output
      # A tibble: 1 x 3
        numbers name  sub  
          <dbl> <chr> <chr>
      1       2 ones  ""   

