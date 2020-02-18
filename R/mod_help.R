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
  
  # customized action button to render well
  # in the tabbar
  help_bttn <- f7Button(
    inputId = ns("toggle_help"),
    fill = FALSE,
    label = "Help"
  )
  
  help_bttn[[2]]$name <- "a"
  help_bttn[[2]]$attribs$type <- NULL
  help_bttn[[2]]$attribs$class <- "tab-link sheet-open f7-action-button"
  help_bttn[[2]]$children <- NULL
  help_bttn[[2]] <- tagAppendChildren(
    help_bttn[[2]], 
    f7Icon("help_outline"),
    span(class = "tabbar-label", "Help")
  )
  
  # Part of the UI goes in the left panel
  # The button goes in the tabbar. We access each part
  # with mod_help_ui(id)[[1]] and mod_help_ui(id)[[2]],
  # respectively
  tagList(
    f7Panel(
      inputId = ns("help_panel"),
      title = "About",
      side = "left",
      theme = "dark",
      effect = "cover",
      resizable = FALSE,
      "Some stuff about the deminer...",
      f7Link(
        label = "Github", 
        src = "https://github.com/DivadNojnarg/deminR",
        external = TRUE,
        icon = f7Icon("ant")
      )
    ),
    help_bttn
  )
}
    
# Module Server
    
#' @rdname mod_help
#' @export
#' @keywords internal
    
mod_help_server <- function(input, output, session){
  ns <- session$ns
  # Help is located in the left panel
  observeEvent(input$toggle_help,{
    updateF7Panel(inputId = "help_panel", session = session)
  })
}
    
## To be copied in the UI
# mod_help_ui("help_ui_1")
    
## To be copied in the server
# callModule(mod_help_server, "help_ui_1")
 
