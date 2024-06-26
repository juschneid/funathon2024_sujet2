main_color <- "orange"

input_date <- shinyWidgets::airDatepickerInput(
  "date",
  label = "Mois sélectionné :",
  value = "2019-01-01",
  view = "months",
  minView = "months",
  minDate = "2018-01-01",
  maxDate = "2022-12-01",
  dateFormat = "MMMM yyyy",
  language = "fr"
)

input_airport <- selectInput(
  "select",
  "Aéroport sélectionné :",
  choices = liste_aeroports,
  selected = default_airport
)

ui <- page_navbar(
  title = "Tableau de bord des aéroports français",
  bg = main_color,
  inverse = TRUE,
  header = em("Source: DGAC, via data.gouv.fr"),
  layout_columns(
    card(
      card_header("Classement des aéroports selon leur fréquentation", class = "bg-yellow"),
      input_date,
      gt_output(outputId = "table")
    ),
    layout_columns(
      card(card_header("Localisation des aéroports selon leur fréquentation", class = "bg-yellow"),
           card(leafletOutput("carte")),
      card(card_header("Fréquentation d'un aéroport depuis 2018", class = "bg-yellow"),
           input_airport,
           plotlyOutput("lineplot")
      ),
      col_widths = c(12,12)
    ),
    cols_widths = c(12,12,12)
  )
  
))
