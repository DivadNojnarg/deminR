# library(shiny)
# library(shinyMobile)
# library(testthat)
# library(deminR)
# 
# difficulty <- data.frame(
#     Level = c("Beginner", "Intermediate", "Advanced"),
#     Size = c(6,9,12),
#     Mines = c(5,10,20),
#     Zoom = c(5.8,5.8,5.4),
#     stringsAsFactors = FALSE
#   )
# 
# tryCatch({
#   testModule(mod_game_params_server,{
# 
#     print(r$mod_grid$data)
# 
#   }, r = reactiveValues(
#     mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines = 5)),
#     mod_timer = reactiveValues(),
#     mod_bomb = reactiveValues(),
#     mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
#     click = reactiveValues(counter = 0),
#     currentTab = reactiveValues(val = NULL),
#     warrior = reactiveValues(mode = FALSE),
#     cookies = reactiveValues(),
#     device = reactiveValues(info = NULL),
#     settings = difficulty[difficulty$Level == "Beginner",]
#   ))
# }, error = function(e){
#   print("There was an error!")
#   print(e)
# })
# 
# testModule(mod_game_params_server,{
#   
#   print(r$mod_grid$data)
#   
# }, r = reactiveValues(
#   mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines = 5)),
#   mod_timer = reactiveValues(),
#   mod_bomb = reactiveValues(),
#   mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
#   click = reactiveValues(counter = 0),
#   currentTab = reactiveValues(val = NULL),
#   warrior = reactiveValues(mode = FALSE),
#   cookies = reactiveValues(),
#   device = reactiveValues(info = NULL),
#   settings = difficulty[difficulty$Level == "Beginner",]
# ))




library(shiny)
library(shinyMobile)
library(deminR)
shiny::shinyApp(
  ui = f7Page(
    title = "My app",
    f7SingleLayout(
      navbar = f7Navbar(
        title = "Single Layout",
        hairline = FALSE,
        shadow = TRUE
      ),
      mod_game_params_ui("test")
    )
  ),
  server = function(input, output, session) {
    callModule(mod_game_params_server, "test", r = reactiveValues(
      mod_grid = reactiveValues(playing = "onload", start = FALSE),
      mod_timer = reactiveValues(),
      mod_bomb = reactiveValues(),
      mod_scores = reactiveValues(refresh = NULL, sendToChat = NULL, autoRefresh = NULL),
      click = reactiveValues(counter = 0),
      currentTab = reactiveValues(val = NULL),
      warrior = reactiveValues(mode = FALSE),
      cookies = reactiveValues(),
      device = reactiveValues(info = NULL),
      settings = reactiveValues()
    ))
  }
)
