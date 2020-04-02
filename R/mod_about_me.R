#' about_me UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param r cross module variable
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_about_me_ui <- function(id){
  ns <- NS(id)
  tagList(
    # ghost div to ensure proper float-right alignement of the link
    div(id = ns("subnavGhost")),
    # sheet trigger
    a(
      class = "float-right link action-button",
      id = ns("openProfile"),
      tags$img(src = generateAvatar(golem::get_golem_options("avatars")), width = "40px")
    )
  )
}
    
#' about_me Server Function
#'
#' @noRd 
mod_about_me_server <- function(input, output, session, r){
  ns <- session$ns
  observeEvent(r$currentTab$val, {
    shinyjs::toggle(id = "openProfile", condition = r$currentTab$val != "scores")
    shinyjs::toggle(id = "subnavGhost", condition = r$currentTab$val != "scores")
  })
}
    
## To be copied in the UI
# mod_about_me_ui("about_me_ui_1")
    
## To be copied in the server
# callModule(mod_about_me_server, "about_me_ui_1")
 
