#Import de nos fonctions
source("R/create_data_list.R")
source("R/clean_dataframe.R")
source("R/import_data.R")
source("R/figures.R")
source("R/divers_function.R")
source("R/tables.R")

# source("correction/R/import_data.R")
# source("correction/R/create_data_list.R")
# source("correction/R/clean_dataframe.R")
# source("correction/R/divers_functions.R")
# source("correction/R/tables.R")
# source("correction/R/figures.R")

#Import des packages
library(tidyverse)
library(readr)
library(sf)
library(plotly)
library(gt)
library(leaflet)
library(bslib)


YEARS_LIST = 2018:2022
MONTHS_LIST = 1:12

# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all<- import_airport_data(unlist(urls$airports))
pax_cie_all<- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all<- import_liaisons_data(unlist(urls$liaisons))

airport_location <- sf::st_read(unlist(urls$geojson$airport))

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]


# OBJETS NECESSAIRES A L'APPLICATION ------------------------

trafic_aeroports <- pax_apt_all %>%
  mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
  filter(apt %in% default_airport) %>%
  mutate(
    date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
  )

