#' @import shiny shinyMobile
app_ui <- function() {
  
  # custom reload button
  reload_bttn <- f7Button(
    inputId = "reload", 
    fill = FALSE,
    label = "Reload"
  )
  
  reload_bttn[[2]]$attribs$class <- paste(
    reload_bttn[[2]]$attribs$class,
    "tab-link"
  )
  
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(),
    # List the first level UI elements here 
    f7Page(
      title = "deminR",
      init = f7Init(
        skin = "auto",
        theme = "dark",
        filled = FALSE,
        color = "pink",
        tapHold = TRUE,
        iosTouchRipple = TRUE,
        iosCenterTitle = TRUE,
        iosTranslucentBars = TRUE,
        hideNavOnPageScroll = TRUE,
        hideTabsOnPageScroll = FALSE,
        serviceWorker = NULL
      ),
      f7TabLayout(
        navbar = f7Navbar(
          title = "deminR",
          hairline = FALSE,
          shadow = TRUE,
          bigger = TRUE,
          left_panel = TRUE
        ),
        panels = mod_help_ui("help_ui_1")[[1]],
        toolbar = f7Toolbar(
          position = "bottom",
          f7Link(
            label = "Github", 
            src = "https://github.com/DivadNojnarg/deminR",
            external = TRUE,
            icon = f7Icon("ant", fill = TRUE)
          )
        ),
        
        f7Tabs(
          id = "tabset",
          swipeable = TRUE,
          animated = FALSE,
          .items = tagList(
            reload_bttn,
            mod_game_params_ui("game_params_ui_1")[[2]],
            mod_help_ui("help_ui_1")[[2]]
          ),
          f7Tab(
            tabName = "main",
            active = TRUE,
            icon = NULL,
            
            # the sheet content (must be here in the main tab)
            mod_game_params_ui("game_params_ui_1")[[1]],
            # main content
            f7Flex(
              mod_bomb_counter_ui("bomb_counter_ui_1"),
              mod_timer_ui("timer_ui_1")
            ),
            mod_game_grid_ui("game_grid_ui_1"),
            mod_display_scores_ui("display_scores_ui_1")
          )
        )
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
