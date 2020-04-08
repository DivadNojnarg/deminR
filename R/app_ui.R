#' @import shiny shinyMobile
#' @importFrom sever use_sever
#' @importFrom glouton use_glouton
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    f7Page(
      title = "deminR",
      icon = "www/icons/apple-touch-icon.png",
      favicon = "www/icons/favicon.png",
      manifest = "www/manifest.json",
      init = mod_init_ui("init"),
      f7TabLayout(
        # hide page content if not logged (see app_server.R)
        style = "visibility: hidden;",
        navbar = f7Navbar(
          title = "deminR",
          hairline = FALSE,
          shadow = TRUE,
          bigger = FALSE,
          transparent = TRUE,
          left_panel = TRUE,
          subNavbar = f7SubNavbar(
            mod_about_me_ui("about_me_ui_1")[[1]],
            mod_scores_ui("scores_ui_1")[[2]],
            mod_about_me_ui("about_me_ui_1")[c(2, 3)]
          )
        ),
        messagebar = if (golem::get_golem_options("usecase") == "database") {
          mod_chat_ui("chat_ui_1")[[2]]
        },
        panels = tagList(
          mod_about_ui("about_ui_1"),
          mod_help_ui("help_ui_1")[[1]]
        ),
        mod_share_ui("share_ui_1")[[1]],
        f7Tabs(
          id = "tabset",
          swipeable = TRUE,
          style = "toolbar",
          animated = FALSE,
          .items = tagList(
            mod_game_params_ui("game_params_ui_1"),
            mod_help_ui("help_ui_1")[[2]]
          ),
          f7Tab(
            tabName = "main",
            active = TRUE,
            icon = f7Icon("gamecontroller", old = FALSE),
            # main content
            mod_welcome_ui("welcome_ui_1"),
            mod_game_info_ui("game_info_ui_1"),
            mod_game_grid_ui("game_grid_ui_1"),
            mod_share_ui("share_ui_1")[[2]]
          ),
          f7Tab(
            tabName = "scores",
            icon = f7Icon("list_number", old = FALSE), 
            mod_scores_ui("scores_ui_1")[[1]]
          ),
          # only display if database
          f7Tab(
            tabName = "chat",
            icon = f7Icon("chat_bubble_2", old = FALSE),
            mod_chat_ui("chat_ui_1")[[1]]
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
    
    tags$script(src = "www/js/loginInputBinding.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "www/css/colorThemeChooser.css"),
    shinyjs::inlineCSS(list(.darkleaflet = "background-color: #0000")),
    shinyjs::useShinyjs(),
    use_sever(),
    use_glouton()
  )
}
