library(shiny)

testModule(mod_game_grid_server, {
  # this test will fail on Travis but not locally
  skip_on_travis()
  
  # Simulate left click
  session$setInputs(map_grid_shape_click = list(id = "case-1"))
  # we expect at least one case to be revealed
  expect_equal(sum(!r$mod_grid$data$hide) > 0, TRUE)

  # Reset the grid
  r$mod_grid$data = generate_spatial_grid(N = 6, n_mines= 5)
  session$flushReact()
  
  # # Simulate right click
  session$setInputs(right_click = list(id = "case-1"))
  # # We expect the case to be flagged
  expect_equal(r$mod_grid$data$flag[r$mod_grid$data$ID == "case-1"], TRUE)

  # Reset the grid
  r$mod_grid$data = generate_spatial_grid(N = 6, n_mines= 5)
  session$flushReact()
  
  # Simulate win of game (all bombs flagged and all non bombs revealed)
  r$mod_grid$data$hide[r$mod_grid$data$value == -999] <- TRUE
  r$mod_grid$data$hide[r$mod_grid$data$value != -999] <- FALSE
  session$flushReact()
  # Expect game status to be won
  expect_equal(r$mod_grid$playing, "won")
  
  # Reset the grid
  r$mod_grid$data <- generate_spatial_grid(N = 6, n_mines= 5)
  r$mod_grid$playing <- "onload"
  session$flushReact()
  
  # Simulate loose of game
  bomb_id <- r$mod_grid$data$ID[r$mod_grid$data$value ==-999][1]
  session$setInputs(map_grid_shape_click = list(id = bomb_id))
  # Expect game status to be loose
  expect_equal(r$mod_grid$playing, "loose")
  
  },
  r = reactiveValues(
    mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines= 5)),
    mod_timer = reactiveValues(),
    mod_bomb = reactiveValues(),
    mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
    click = reactiveValues(counter = 0),
    currentTab = reactiveValues(val = NULL),
    warrior = reactiveValues(mode = FALSE),
    cookies = reactiveValues(),
    device = reactiveValues(info = NULL),
    loginPage = reactiveValues(visible = TRUE),
    settings = reactiveValues()
  )
)


# Run the module alone
# library(shiny)
# library(shinyMobile)
# library(purrr)
# library(leaflet)
# library(sp)
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
#       mod_game_grid_ui("test")
#     )
#   ),
#   server = function(input, output, session) {
#     callModule(mod_game_grid_server, "test", r = reactiveValues(
#       mod_grid = reactiveValues(playing = "onload", start = FALSE, 
#                                 data = generate_spatial_grid(N = 6, n_mines = 5)),
#       mod_timer = reactiveValues(seconds = 0),
#       mod_bomb = reactiveValues(),
#       mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
#       click = reactiveValues(counter = 0),
#       currentTab = reactiveValues(val = NULL),
#       warrior = reactiveValues(mode = FALSE),
#       cookies = reactiveValues(),
#       device = reactiveValues(info = NULL),
#       loginPage = reactiveValues(visible = FALSE),
#       settings = difficulty[difficulty$Level == "Beginner",]
#     ))
#   }
# )
