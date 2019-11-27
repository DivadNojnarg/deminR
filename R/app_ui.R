#' @import shiny shinyMobile
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(),
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
            src = "https://github.com/DivadNojnarg/deminR",
            external = TRUE,
            icon = f7Icon("ant", fill = TRUE)
          )
        ),
        
       
        f7Row(
          f7Col(
            " "
          ),
          f7Col(
            # Choose difficulty
            f7Select(
              inputId = "level",
              label = "Choose diffuculty",
              choices = difficulty$Level
            )
          ),
          f7Col(
            " "
          )
        ),
        
        # main content
        f7Row(
          f7Col(
            mod_bomb_counter_ui("bomb_counter_ui_1")
          ),
          f7Col(
            f7Button(inputId = "reload", label = "Reload")
          ),
          f7Col(
            mod_timer_ui("timer_ui_1")
          )
        ),
        f7Row(
          f7Col(
            " "
          ),
          f7Col(
            mod_game_grid_ui("game_grid_ui_1")
          ),
          f7Col(
            " "
          )
        ),
        
        mod_display_scores_ui("display_scores_ui_1")
        
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
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
