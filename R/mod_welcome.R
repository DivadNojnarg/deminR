# Module UI
  
#' @title   mod_welcome_ui and mod_welcome_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_welcome
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_welcome_ui <- function(id){
  ns <- NS(id)
  tagList()
}
    
# Module Server
    
#' @rdname mod_welcome
#' @export
#' @keywords internal
    
mod_welcome_server <- function(input, output, session, r){
  ns <- session$ns
  observe({
    req(r$mod_welcome$firstVisit)
    f7Dialog(
      text = "Welcome on the mineSweeper!",
      type = "alert",
      session = session
    )
  })
}
    
## To be copied in the UI
# mod_welcome_ui("welcome_ui_1")
    
## To be copied in the server
# callModule(mod_welcome_server, "welcome_ui_1")
 
