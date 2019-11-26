# Module UI
  
#' @title   mod_timer_ui and mod_timer_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_timer
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList invalidateLater
#' @importFrom lubridate seconds_to_period
mod_timer_ui <- function(id){
  ns <- NS(id)
  tagList(
    htmlOutput(ns("timeleft"))
  )
}
    
# Module Server
    
#' @rdname mod_timer
#' @export
#' @keywords internal
    
mod_timer_server <- function(input, output, session, r){
  ns <- session$ns
  
  # initialize timer activation
  active <- reactiveVal(FALSE)
  
  # activate the timer
  observeEvent(r$mod_grid$start, {
    active(TRUE)
  })
  
  # Output the timer
  output$timeleft <- renderUI({
    HTML(paste("<p>", as.character(r$mod_timer$seconds/100), "s", "</p>"))
  })
  
  # observer that invalidates every 0.01 second. If timer is active, increase by one.
  observe({
    invalidateLater(10, session)
    isolate({
      if (active() & r$mod_grid$playing == "onload") {
        r$mod_timer$seconds <- r$mod_timer$seconds +1
      }
    })
  })
}
    
## To be copied in the UI
# mod_timer_ui("timer_ui_1")
    
## To be copied in the server
# callModule(mod_timer_server, "timer_ui_1")

# library(shiny)
# library(lubridate)
# if (interactive()){
#  ui <- fluidPage(
#    mod_timer_ui("test")
#  )
#  server <- function(input, output, session) {
#    callModule(mod_timer_server, "test")
# 
#  }
#  shinyApp(ui, server)
# }