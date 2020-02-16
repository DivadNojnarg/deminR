#' @import shiny
#' @importFrom shinyMobile f7Dialog
#' @importFrom sever sever
app_server <- function(input, output, session) {
  
  # custom disconnect screen
  sever()
  ### reactiveValues to communicate between all modules
  # 'strategie du petit r'
  r <- reactiveValues(
    mod_grid = reactiveValues(playing = "onload", start = FALSE),
    mod_timer = reactiveValues(),
    mod_bomb = reactiveValues(),
    mod_welcome = reactiveValues(firstVisit = TRUE)
  )
  
  # welcome module
  callModule(mod_welcome_server, "welcome_ui_1", r = r)
  
  ### Help module
  callModule(mod_help_server, "help_ui_1")
  
  ### Params 
  callModule(mod_game_params_server, "game_params_ui_1", r = r)
  
  ### Grid module
  callModule(mod_game_grid_server, 
                        id = "game_grid_ui_1",
                        session = session, 
                        r = r)
  ### Timer module
  callModule(mod_timer_server, 
             id = "timer_ui_1", 
             session = session,
             r = r)
  
  ### Count remaining bombs module
  callModule(mod_bomb_counter_server, 
             id = "bomb_counter_ui_1",
             session = session,
             r = r)
  ### Score module
  #callModule(mod_display_scores_server, 
  #           id = "display_scores_ui_1",
  #           session = session,
  #           r = r)
  
  }
