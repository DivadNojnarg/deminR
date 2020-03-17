#' scores_stats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param r cross module variable
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_scores_stats_ui <- function(id){
  ns <- NS(id)
  f7Tab(
    tabName = "Stats",
    icon = f7Icon("chart_bar_square", old = FALSE),
    active = FALSE
  )
}
    
#' scores_stats Server Function
#'
#' @noRd 
mod_scores_stats_server <- function(input, output, session, r){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_scores_stats_ui("scores_stats_ui_1")
    
## To be copied in the server
# callModule(mod_scores_stats_server, "scores_stats_ui_1")
 
