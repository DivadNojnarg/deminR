#' @import shiny
#' @importFrom shinyMobile f7Dialog
app_server <- function(input, output, session) {
  
  ### reactiveValues to communicate between all modules
  # 'strategie du petit r'
  r <- reactiveValues(
    mod_grid = reactiveValues(playing = "onload", start = FALSE),
    mod_timer = reactiveValues(),
    mod_bomb = reactiveValues()
  )

  ### The user chooses a difficutlty and it determines several parameters :
  # size of the grid, number of mines, leaflet zoom level
  observe({
    r$settings <- difficulty[difficulty$Level == input$level,]
  })

  ### Reset parameters when the user changes the difficulty or clicks on reload button
  observeEvent({
    r$settings
    input$reload
    1
    },{
    r$mod_timer$seconds <- 0 # reset timer
    r$mod_grid$playing <- "onload" # reset current playing status
    r$mod_grid$start  <- FALSE # reset game started
    # generate game grid
    r$mod_grid$data <- generate_spatial_grid(N = r$settings$Size, n_mines = r$settings$Mines)
  })
  
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
  callModule(mod_display_scores_server, 
             id = "display_scores_ui_1",
             session = session,
             r = r)
  
  ### Help module
  callModule(mod_help_server, "help_ui_1")
  
  }
