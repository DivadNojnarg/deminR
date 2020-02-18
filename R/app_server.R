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
    mod_welcome = reactiveValues(firstVisit = TRUE),
    mod_click = reactiveValues(counter = 0)
  )
  
  observe(print(r$mod_click$counter))
  
  # welcome module
  callModule(mod_welcome_server, "welcome_ui_1", r = r)
  ### Help module
  callModule(mod_help_server, "help_ui_1")
  ### Params 
  callModule(mod_game_params_server, "game_params_ui_1", r = r)
  ### Grid module (count the number of clicks)
  clickOnGrid <- callModule(mod_game_grid_server, id = "game_grid_ui_1", session = session, r = r)
  observeEvent(clickOnGrid(), {
    r$mod_click$counter <- r$mod_click$counter + 1
  })
  ### Timer module + bomb counter
  callModule(mod_game_info_server, "game_info_ui_1", session = session, r = r)
  ### Score module
  callModule(mod_display_scores_server, 
             id = "display_scores_ui_1",
             session = session,
             r = r)
  # share module
  callModule(mod_share_server, "share_ui_1", session = session, r = r)
  
  }
