# Module UI

#' @title   mod_game_info_ui and mod_game_info_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param r cross module variable
#'
#' @rdname mod_game_info
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
#' @importFrom lubridate today
mod_game_info_ui <- function(id){
  ns <- NS(id)
  tagList(
    f7Row(
      uiOutput(ns("userName")),
      uiOutput(ns("difficultyBadge")) ,
      uiOutput(ns("timer")),
      uiOutput(ns("bombs"))
    ) %>% f7Margin()
  )
  
}

# Module Server

#' @rdname mod_game_info
#' @export
#' @keywords internal

mod_game_info_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$userName <- renderUI({
      f7Chip(label = paste("User:", r$cookies$user))
    })
    
    output$difficultyBadge <- renderUI({
      f7Chip(
        label = r$settings$Level,
        status = switch (r$settings$Level,
                         "Beginner" = "teal",
                         "Intermediate" = "deeporange",
                         "Advanced" = "red"
        )
      )
    })
    
    # bombs counter UI
    output$bombs <- renderUI({
      res <- r$mod_grid$data
      n_b <- sum(res$value == -999)
      f7Chip(
        icon = f7Icon("burst"),
        label = as.character(n_b - sum(res$flag & res$hide)) 
      )
    })
    
    # timer UI
    output$timer <- renderUI({
      f7Chip(
        icon = f7Icon("timer"),
        label = format(r$mod_timer$seconds/100, nsmall = 2)
      )
    })
    
    # initialize timer activation
    active <- reactiveVal(FALSE)
    
    
    # activate the timer
    observeEvent(r$mod_grid$start, {
      if(r$mod_grid$start){active(TRUE)} else{
        active(FALSE)
      }
    })
    
    # observer that invalidates every 0.01 second. If timer is active, increase by one.
    observe({
      invalidateLater(10, session)
      isolate({
        if (active() & r$mod_grid$playing == "onload") {
          r$mod_timer$seconds <- r$mod_timer$seconds + 1
        }
      })
    })
    
    # Feedback on game status. We wait for the timer to be ok.
    observeEvent(r$mod_grid$playing, {
      if (r$mod_grid$playing != "onload") {
        f7Notif(
          text = if (r$mod_grid$playing == "loose") {
            if (r$click$counter == 1) {
              "Oh Boy!! This is so unfortunate :). Life is unfair"
            } else {
              "Ouuups. You fucked up!"
            }
          } else if (r$mod_grid$playing == "won") {
            "Hey! You're a winner!"
          },
          icon = f7Icon("bolt_fill"),
          title = "Woooop!"
        ) 
      }
    })
    
  })
}

## To be copied in the UI
# mod_game_info_ui("game_info_ui_1")

## To be copied in the server
# callModule(mod_game_info_server, "game_info_ui_1")

