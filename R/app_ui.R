#' @import shiny shinyMobile
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    f7Page(
      title = "deminR",
      init = f7Init(
        skin = "md",
        theme = "light",
        filled = TRUE,
        color = NULL,
        tapHold = TRUE,
        iosTouchRipple = FALSE,
        iosCenterTitle = TRUE,
        iosTranslucentBars = FALSE,
        hideNavOnPageScroll = TRUE,
        hideTabsOnPageScroll = FALSE,
        serviceWorker = NULL
      ),
      f7SingleLayout(
        navbar = f7Navbar(
          title = "deminR",
          hairline = FALSE,
          shadow = TRUE
        ),
        toolbar = f7Toolbar(
          position = "bottom",
          f7Link(
            label = "Github", 
            src = "https://github.com/DivadNojnarg/shinyContest2020",
            external = TRUE,
            icon = f7Icon("ant", fill = TRUE)
          )
        ),
        # main content
        mod_game_grid_ui("game_grid_ui_1")
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'deminR')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
