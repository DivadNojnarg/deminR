#' @import shiny
app_server <- function(input, output, session) {
  # List the first level callModules here
  
  # reactiveValues to communicate between all modules
  # 'strategie du petit r'
  r <- reactiveValues(
    mod_grid = reactiveValues(playing = "onload"),
    mod_timer = reactiveValues(seconds = 0),
    mod_bomb = reactiveValues()
  )
  
  callModule(mod_game_grid_server, 
                        id = "game_grid_ui_1",
                        session = session, 
                        r = r)
  
  
  callModule(mod_timer_server, 
             id = "timer_ui_1", 
             session = session,
             r = r)
  
  callModule(mod_bomb_counter_server, 
             id = "bomb_counter_ui_1",
             session = session,
             r = r)

  }
