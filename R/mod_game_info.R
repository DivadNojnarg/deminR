# Module UI

#' @title   mod_game_info_ui and mod_game_info_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
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
    uiOutput(ns("difficultyBadge")),
    uiOutput(ns('infos'))
  )
  
}

# Module Server

#' @rdname mod_game_info
#' @export
#' @keywords internal

mod_game_info_server <- function(input, output, session, r){
  ns <- session$ns
  
  output$difficultyBadge <- renderUI({
    f7Badge(
      "Difficulty",
      color = switch (r$settings$Level,
        "Beginner" = "teal",
        "Intermediate" = "deeporange",
        "Advanced" = "red"
      )
    ) 
  })
  
  output$infos <- renderUI({
    res <- r$mod_grid$data
    n_b <- sum(res$value == -999)
    rowTag <- f7Row(
      f7Col(
        f7Card(
          HTML(paste("<h2>Bombs: ", n_b - sum(res$flag & res$hide)),"</h2>") 
        ) %>% f7Align("center") 
      ),
      f7Col(
        f7Card(
          HTML(paste("<h2>", f7Icon("timer"), ": ", format(r$mod_timer$seconds/100, nsmall = 2), "s","</h2>"))
        ) %>% f7Align("center") 
      )
    ) %>% f7Margin()
    
    # display a loading skeleton only at app startup
    if (r$click$counter == 0) {
      for(i in seq_along(rowTag$children)) {
        rowTag$children[[i]]$children[[1]] <- rowTag$children[[i]]$children[[1]] %>%
          f7Skeleton()
      }
    }
    
    rowTag
    
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
          "Ouuups. You fucked up!"
        } else if (r$mod_grid$playing == "won") {
          "Hey! You're a winner!"
        },
        icon = f7Icon("bolt_fill"),
        title = "Woooop!",
        titleRightText = lubridate::today()
      ) 
    }
  })
  
}

## To be copied in the UI
# mod_game_info_ui("game_info_ui_1")

## To be copied in the server
# callModule(mod_game_info_server, "game_info_ui_1")

