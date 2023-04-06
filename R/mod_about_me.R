#' about_me UI Function
#'
#' @description A shiny Module.
#'
#' @param id Module id.
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
      class = "margin float-right link action-button",
      id = ns("openProfile"),
      uiOutput(ns("userName")),
      tags$img(src = generateAvatar(golem::get_golem_options("avatars")), width = "40px")
    ),
    f7Sheet(
      id = ns("aboutMeSheet"),
      orientation = "bottom",
      swipeToClose = TRUE,
      swipeToStep = TRUE,
      backdrop = TRUE,
      h1("About Me"),
      hiddenItems = tagList(
        uiOutput(ns("myDevice")),
        uiOutput(ns("workerId"))
      )
    )
  )
}
    
#' about_me Server Function
#'
#' @noRd 
mod_about_me_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    observeEvent(r$currentTab$val, {
      shinyjs::toggle(id = "openProfile", condition = r$currentTab$val != "scores")
      shinyjs::toggle(id = "subnavGhost", condition = r$currentTab$val != "scores")
    })
    
    observeEvent(input$openProfile, {
      updateF7Sheet("aboutMeSheet")
    })
    
    output$userName <- renderUI({
      req(r$cookies$user)
      p(class = "margin", r$cookies$user)
    })
    
    output$myDevice <- renderUI({
      req(r$device$info$os)
      f7Block(
        h4("OS:", f7Badge(r$device$info$os))
      )
    })
    
    output$workerId <- renderUI({
      f7Block(
        h4(
          "Worker Id:", 
          if (session$clientData$url_hostname == "127.0.0.1") {
            f7Badge("Local")
          } else {
            if (session$clientData$url_search != "") {
              f7Badge(session$clientData$url_search)
            } else {
              f7Badge(NA)
            }
          }
        )
      )
    })
  })
}
    
## To be copied in the UI
# mod_about_me_ui("about_me_ui_1")
    
## To be copied in the server
# callModule(mod_about_me_server, "about_me_ui_1")
 
