#Import de nos fonctions
source("R/create_data_list.R")
source("R/clean_dataframe.R")
source("R/import_data.R")
source("R/figures.R")
source("R/divers_function.R")
source("R/tables.R")

#Import des packages
library(tidyverse)
library(readr)
library(sf)
library(plotly)
library(gt)
library(leaflet)

MONTHS_LIST = 1:12

# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all<- import_airport_data(unlist(urls$airports))
pax_cie_all<- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all<- import_liaisons_data(unlist(urls$liaisons))

airport_location <- sf::st_read(unlist(urls$geojson$airport))

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

figure_plotly <- plot_airport_line(pax_apt_all, default_airport)
figure_plotly


YEARS_LIST  <- as.character(2018:2022)
MONTHS_LIST <- 1:12

year <- YEARS_LIST[1]
month <- MONTHS_LIST[1]
stats_aeroports <- summary_stat_airport(pax_apt_all, year, month)
table_airports <- create_table_airports(stats_aeroports)
table_airports


