librarian::shelf(
  digest, dplyr, DT, glue, purrr, readr, stringr, tidyr)

# path to folder containing species directories of images
dir_src  <- "/courses/EDS232/inaturalist-2021/train_mini"
dir_dest <- "~/inat"
dir.create(dir_dest, showWarnings = F)

# get list of directories, one per species (n = 10,000 species)
dirs_spp <- list.dirs(dir_src, recursive = F, full.names = T)
n_spp <- length(dirs_spp)
# set seed (for reproducible results) 
# just before sampling (otherwise get different results)
# based on your username (unique amongst class)
Sys.info()[["user"]] %>% 
  digest::digest2int() %>% 
  set.seed()
i10 <- sample(1:n_spp, 10)
# show the 10 indices sampled of the 10,000 possible 
i10
# show the 10 species directory names
basename(dirs_spp)[i10]
# show the first 2 species directory names
i2 <- i10[1:2]
basename(dirs_spp)[i2]
# setup data frame with source (src) and destination (dest) paths to images
d <- tibble(
  set     = c(rep("spp2", 2), rep("spp10", 10)),
  dir_sp  = c(dirs_spp[i2], dirs_spp[i10]),
  tbl_img = map(dir_sp, function(dir_sp){
    tibble(
      src_img = list.files(dir_sp, full.names = T),
      subset  = c(rep("train", 30), rep("validation", 10), rep("test", 10))) })) %>% 
  unnest(tbl_img) %>% 
  mutate(
    sp       = basename(dir_sp),
    img      = basename(src_img),
    dest_img = glue("{dir_dest}/{set}/{subset}/{sp}/{img}"))
# show source and destination for first 10 rows of tibble
d %>% 
  select(src_img, dest_img)
# iterate over rows, creating directory if needed and copying files 
d %>% 
  pwalk(function(src_img, dest_img, ...){
    dir.create(dirname(dest_img), recursive = T, showWarnings = F)
    file.copy(src_img, dest_img) })
# uncomment to show the entire tree of your destination directory
# system(glue("tree {dir_dest}"))






