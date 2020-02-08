# Module UI
  
#' @title   mod_help_ui and mod_help_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_help
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_help_ui <- function(id){
  ns <- NS(id)
  f7Panel(
    inputId = "help_panel",
    title = "About",
    side = "left",
    theme = "dark",
    effect = "cover",
    resizable = FALSE,
    "Some stuff about the deminer..."
  )
}
    
# Module Server
    
#' @rdname mod_help
#' @export
#' @keywords internal
    
mod_help_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_help_ui("help_ui_1")
    
## To be copied in the server
# callModule(mod_help_server, "help_ui_1")
 
