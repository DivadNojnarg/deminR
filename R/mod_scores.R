#' scores UI Function
#'
#' @description A shiny Module.
#'
#' @param id Module id.
#' @param r cross module variable
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_scores_ui <- function(id){
  ns <- NS(id)
  tagList(
    f7Tabs(
      id = ns("scores_tabs"),
      style = "strong", 
      animated = TRUE, 
      swipeable = FALSE,
      mod_display_scores_ui(ns("display_scores_ui_1"))[[1]],
      mod_scores_stats_ui(ns("scores_stats_ui_1"))
    ),
    mod_display_scores_ui(ns("display_scores_ui_1"))[[2]]
  )
}
    
#' scores Server Function
#'
#' @noRd 
mod_scores_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    scores_data <- mod_display_scores_server(id = "display_scores_ui_1", r = r)
    mod_scores_stats_server(id = "scores_stats_ui_1", r = r, scores_data)
  })
}
    
## To be copied in the UI
# mod_scores_ui("scores_ui_1")
    
## To be copied in the server
# callModule(mod_scores_server, "scores_ui_1")
 
