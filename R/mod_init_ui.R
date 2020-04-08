#' init UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_init_ui <- function(id){
  ns <- NS(id)
  f7Init(
    skin = "auto",
    theme = "dark",
    filled = FALSE,
    color = "blue",
    tapHold = TRUE,
    tapHoldDelay = 500,
    iosTouchRipple = TRUE,
    iosCenterTitle = TRUE,
    iosTranslucentBars = TRUE,
    hideNavOnPageScroll = FALSE,
    hideTabsOnPageScroll = FALSE,
    serviceWorker = NULL
  )
}
    
#' init Server Function
#'
#' @noRd 
mod_init_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_init_ui("init_ui_1")
    
## To be copied in the server
# callModule(mod_init_server, "init_ui_1")
 
