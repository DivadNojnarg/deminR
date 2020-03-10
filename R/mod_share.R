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
    f7Toolbar(
      position = "top",
      lapply(1:3, function(i) f7Link(i) %>% f7FabClose())
    ) %>% f7FabMorphTarget(),
    # put an empty f7Fabs container
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
    
    # only displayed after a victory
    req(r$mod_grid$playing == "won")
    
    f7Fabs(
      id = ns("shareMenu"),
      extended = TRUE,
      label = "Share",
      position = "center-bottom",
      sideOpen = "right",
      f7Fab(
        inputId = ns("shareChat"),
        label = f7Icon("envelope_badge", old = FALSE)
      ),
      a(class = "twitter-share-button external",
        href = glue(value = r$mod_timer$seconds/100, "https://twitter.com/intent/tweet?text=mineSweeper%20score:%20{value}%20"),
        `data-size` = "large",
        onclick = paste0("Shiny.setInputValue(", ns("shareTwitter"), ", true)"),
        f7Icon("logo_twitter", old = TRUE)
      )
      #morph = TRUE,
      #morphTarget = ".toolbar"
    )
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

