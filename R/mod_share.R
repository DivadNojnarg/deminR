# Module UI

#' @title   mod_share_ui and mod_share_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_share
#' @importFrom glue glue
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_share_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("shareToolbar")),
    uiOutput(ns("shareFabs"))
  )
}

# Module Server

#' @rdname mod_share
#' @export
#' @keywords internal

mod_share_server <- function(input, output, session, r){
  ns <- session$ns
  
  output$shareFabs <- renderUI({
    req(r$mod_grid$playing == "won")
    f7Fabs(
      id = ns("shareMenu"),
      extended = TRUE,
      label = "Share",
      position = "center-bottom",
      sideOpen = "right",
      morph = TRUE,
      morphTarget = ".toolbar"
    )
  })
  
  output$shareToolbar <- renderUI({
    # only displayed after a victory
    req(r$mod_grid$playing == "won")
    
    shareChatBttn <- f7Button(
      inputId = ns("shareChat"),
      label = f7Icon("envelope_badge", old = FALSE)
    )
    shareChatBttn[[2]]$name <- "a"
    shareChatBttn[[2]]$attribs$type <- NULL
    shareChatBttn[[2]]$attribs$class <- "link fab-close f7-action-button"
    
    f7Toolbar(
      position = "top",
      shareChatBttn,
      a(class = "link twitter-share-button external",
        href = glue(
          user = r$cookies$user, 
          score = r$mod_timer$seconds/100, 
          "https://twitter.com/intent/tweet?text=mineSweeper%20score%20for%20{user}:%20{score}%20"),
        `data-size` = "large",
        onclick = paste0("Shiny.setInputValue(", ns("shareTwitter"), ", true)"),
        f7Icon("logo_twitter", old = TRUE)
      ) %>% f7FabClose()
    ) %>% f7FabMorphTarget()
    
  })
  
  # send to chat signal
  observeEvent(input$shareChat, {
    r$mod_scores$sendToChat <- paste("My score: ", r$mod_timer$seconds/100)
  })
  
  #observe(print(input$shareTwitter))
  #observe(print(input$shareMenu))
}

## To be copied in the UI
# mod_share_ui("share_ui_1")

## To be copied in the server
# callModule(mod_share_server, "share_ui_1")

