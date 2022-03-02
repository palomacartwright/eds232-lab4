librarian::shelf(
  digest, dplyr, DT, glue, purrr, readr, stringr, tidyr)

# path to folder containing species directories of images
dir_train_mini <- "/courses/EDS232/inaturalist-2021/train_mini"

# get list of directories, one per species (n = 10,000 species)
dirs_spp <- list.dirs(dir_train_mini, recursive = F)
n_spp <- length(dirs_spp)
n_spp


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

inat_spp_images_csv <- "~/inat_spp_images.csv"

d <- tibble(
  # get 10 species names
  species = basename(dirs_spp)[i10],
  # assign TRUE/FALSE for: 10 species (multi-class) and 2 species (binary)
  spp10 = TRUE,
  spp2  = c(T,T,rep(F,8)))
DT::datatable(d)


d <- d %>% 
  mutate(
    # construct full path to species directory
    dir_species = file.path(dir_train_mini, species),
    tbl_images  = purrr::map(dir_species, function(dir){
      # create a tibble per species
      tibble(
        # list files in the species directory (n=50)
        image = list.files(dir),
        # assign subset per species
        subset = c(rep("train", 30), rep("validation", 10), rep("test", 10))) })) %>% 
  # go from a tibble with 10 species rows containing a nested tbl_images to unnested, ie 10 species * 50 images = 500 rows
  tidyr::unnest(tbl_images)

# write tibble to CSV file for subsequent reading
readr::write_csv(d, inat_spp_images_csv)

# show counts of image files per species and subset
d %>% 
  mutate(
    # truncate species to show one line per species
    species_trunc = stringr::str_trunc(species, 40)) %>% 
  select(species_trunc, subset) %>% 
  table()







