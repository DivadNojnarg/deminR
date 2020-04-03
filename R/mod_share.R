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
    
    # prepare the share button
    shareChatBttn <- f7Button(
      inputId = ns("shareChat"),
      label = f7Icon("chat_bubble_2", old = FALSE)
    )
    shareChatBttn[[2]]$name <- "a"
    shareChatBttn[[2]]$attribs$type <- NULL
    shareChatBttn[[2]]$attribs$class <- "link fab-close f7-action-button"
    
    f7Toolbar(
      position = "top",
      style = if(r$device$info$os %in% c("ios", "macos")) {
        "margin-top: 44px;"
      },
      shareChatBttn,
      a(class = "link twitter-share-button external",
        href = glue(
          user = r$cookies$user, 
          score = r$mod_timer$seconds, 
          level = r$settings$Level,
          deviceinfo = r$device$deviceType,
          clicks = r$click$counter,
          "https://twitter.com/intent/tweet?text=mineSweeper+score+for+{user}+in+{level}+level%3A+{score}+seconds+in+{clicks}+clicks%2C+yeay+%21+%23rstats+Try+at+https%3A%2F%2Fdgranjon.shinyapps.io%2FdeminR%2F + pic.twitter.com/XkO6sq2zQK"),
        `data-size` = "large",
        onclick = paste0("Shiny.setInputValue(", ns("shareTwitter"), ", true)"),
        f7Icon("logo_twitter", old = TRUE)
      ) %>% f7FabClose()
    ) %>% f7FabMorphTarget()
  })
  
  # send to chat signal
  observeEvent(input$shareChat, {
    r$mod_scores$sendToChat <- paste("My score: ", r$mod_timer$seconds)
  })
}

## To be copied in the UI
# mod_share_ui("share_ui_1")

## To be copied in the server
# callModule(mod_share_server, "share_ui_1")

