# Module UI
  
#' @title   mod_about_ui and mod_about_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_about
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_about_ui <- function(id){
  ns <- NS(id)
  tagList(
    f7Panel(
      inputId = ns("about_panel"),
      title = "About",
      side = "left",
      theme = "dark",
      effect = "cover",
      resizable = FALSE,
      f7Chip(img = "avatars/girl.png", label = "Gabrielle Devaux"),
      f7Chip(img = "avatars/boy.png", label = "David Granjon"),
      hr(),
      f7Link(
        label = "Github", 
        src = "https://github.com/DivadNojnarg/deminR",
        external = TRUE,
        icon = f7Icon("ant", old = TRUE)
      )
    )
  )
}
    
# Module Server
    
#' @rdname mod_about
#' @export
#' @keywords internal
    
mod_about_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_about_ui("about_ui_1")
    
## To be copied in the server
# callModule(mod_about_server, "about_ui_1")
 
