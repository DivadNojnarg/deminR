library(shiny)
library(shinyMobile)
library(testthat)
library(deminR)
library(xml2)


# Running example of module
# shiny::shinyApp(
#   ui = f7Page(
#     title = "My app",
#     f7SingleLayout(
#       navbar = f7Navbar(
#         title = "Single Layout",
#         hairline = FALSE,
#         shadow = TRUE
#       ),
#       mod_game_info_ui("test")
#     )
#   ),
#   server = function(input, output, session) {
#     callModule(mod_game_info_server, "test", r = reactiveValues(
#       mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines = 5)),
#       mod_timer = reactiveValues(),
#       cookies = reactiveValues(user = "toto"), 
#       settings = reactiveValues(Level = "Beginner")
#     ))
#   }
# )


difficulty <- data.frame(
    Level = c("Beginner", "Intermediate", "Advanced"),
    Size = c(6,9,12),
    Mines = c(5,10,20),
    Zoom = c(5.8,5.8,5.4),
    stringsAsFactors = FALSE
  )


tryCatch({
    testModule(mod_game_info_server,{

      # Testing timer
      active(TRUE)
      session$elapse(100)
      expect_equal(r$mod_timer$seconds > 0, TRUE)

      
      # Testing difficulty badge
      r$settings = difficulty[difficulty$Level == "Intermediate",]
      r$mod_grid$data = generate_spatial_grid(N = r$settings$Size, n_mines = r$settings$Mines)
      session$flushReact()
      expect_equal(grepl("Intermediate",output$difficultyBadge$html ,fixed = TRUE), TRUE)
      expect_equal(grepl("deeporange",output$difficultyBadge$html ,fixed = TRUE), TRUE)
      expect_equal(grepl("Beginner",output$difficultyBadge$html ,fixed = TRUE), FALSE)
      
      # Testing remaining bombs
      expect_equal(xml_text(xml_find_all(read_html(output$bombs$html), '//*[@class="chip-label"]/text()')), "10")
      r$settings = difficulty[difficulty$Level == "Advanced",]
      r$mod_grid$data = generate_spatial_grid(N = r$settings$Size, n_mines = r$settings$Mines)
      session$flushReact()
      expect_equal(xml_text(xml_find_all(read_html(output$bombs$html), '//*[@class="chip-label"]/text()')), "20")
      
      
      # Testing username
      expect_equal(grepl("toto",output$userName$html ,fixed = TRUE), TRUE)
      r$cookies$user = "Divad"
      session$flushReact()
      expect_equal(grepl("toto",output$userName$html ,fixed = TRUE), FALSE)
      expect_equal(grepl("Divad",output$userName$html ,fixed = TRUE), TRUE)
      
    }, r = reactiveValues(
      mod_grid = reactiveValues(playing = "onload", start = FALSE, data = generate_spatial_grid(N = 6, n_mines = 5)),
      mod_timer = reactiveValues(seconds = 0),
      cookies = reactiveValues(user = "toto"), 
      settings = reactiveValues(Level = "Beginner")
    ))
  }, error = function(e){
    print("There was an error!")
    print(e)
})




