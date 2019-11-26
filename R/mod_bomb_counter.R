# Module UI
  
#' @title   mod_bomb_counter_ui and mod_bomb_counter_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_bomb_counter
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_bomb_counter_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns('bombs'))
  )
}
    
# Module Server
    
#' @rdname mod_bomb_counter
#' @export
#' @keywords internal
    
mod_bomb_counter_server <- function(input, output, session, r){
  ns <- session$ns
  
  output$bombs <- renderUI({
    res <- r$mod_grid$data
    n_b <- sum(res$value == -999)
    HTML(paste(n_b - sum(res$flag)))
  })
  
}
    
## To be copied in the UI
# mod_bomb_counter_ui("bomb_counter_ui_1")
    
## To be copied in the server
# callModule(mod_bomb_counter_server, "bomb_counter_ui_1")
 
