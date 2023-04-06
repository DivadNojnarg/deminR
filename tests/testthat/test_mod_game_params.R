library(shiny)

difficulty <- data.frame(
  Level = c("Beginner", "Intermediate", "Advanced"),
  Size = c(6,9,12),
  Mines = c(5,10,20),
  Zoom = c(5.8,5.8,5.4),
  stringsAsFactors = FALSE
)

context("Game params server")


testServer(mod_game_params_server, {
  session$setInputs(level = "Intermediate")
  # Test data dimension ; if level is intermediate, data should have NxN rows
  expect_equal(nrow(r$mod_grid$data), difficulty$Size[difficulty$Level=='Intermediate']^2)
  
  
  ### Reset parameters when the user clicks on reload button
  # Assign some parameters
  r$click$counter <- 10
  r$mod_timer$seconds <- 9
  r$mod_grid$playing <- "won"
  r$mod_grid$start  <- TRUE 
  # Simulate click on refresh button
  session$setInputs(action1_button = 1)
  # Check the parameters are reset
  expect_equal(r$click$counter, 0)
  expect_equal(r$mod_timer$seconds, 0)
  expect_equal(r$mod_grid$playing , "onload")
  expect_equal(r$mod_grid$start , FALSE)
  
  # Reset parameters when the user changes the difficulty 
  # Assign some parameters
  r$click$counter <- 10
  r$mod_timer$seconds <- 9
  r$mod_grid$playing <- "won"
  r$mod_grid$start  <- TRUE 
  # Simulate change pf difficulty 
  session$setInputs(level = "Advanced")
  # Check the parameters are reset
  expect_equal(r$click$counter, 0)
  expect_equal(r$mod_timer$seconds, 0)
  expect_equal(r$mod_grid$playing , "onload")
  expect_equal(r$mod_grid$start , FALSE)
    
  }, args = list(
    r = reactiveValues(
      mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines = 5)),
      mod_timer = reactiveValues(),
      mod_bomb = reactiveValues(),
      mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
      click = reactiveValues(counter = 0),
      currentTab = reactiveValues(val = NULL),
      warrior = reactiveValues(mode = FALSE),
      cookies = reactiveValues(),
      device = reactiveValues(info = NULL),
      settings = reactiveValues(
        Level = "Beginner",
        Size = 6,
        Mines = 5,
        Zoom = 5.8
      )
    )    
  )
)




# 
# library(shiny)
# library(shinyMobile)
# library(deminR)
# shiny::shinyApp(
#   ui = f7Page(
#     title = "My app",
#     f7SingleLayout(
#       navbar = f7Navbar(
#         title = "Single Layout",
#         hairline = FALSE,
#         shadow = TRUE
#       ),
#       mod_game_params_ui("test")
#     )
#   ),
#   server = function(input, output, session) {
#     callModule(mod_game_params_server, "test", r = reactiveValues(
#       mod_grid = reactiveValues(playing = "onload", start = FALSE),
#       mod_timer = reactiveValues(),
#       mod_bomb = reactiveValues(),
#       mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
#       click = reactiveValues(counter = 0),
#       currentTab = reactiveValues(val = NULL),
#       warrior = reactiveValues(mode = FALSE),
#       cookies = reactiveValues(),
#       device = reactiveValues(info = NULL),
#       settings = reactiveValues()
#     ))
#   }
# )
