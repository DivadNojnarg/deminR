#' @import shiny shinyMobile
#' @importFrom sever use_sever
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    f7Page(
      title = "deminR",
      init = f7Init(
        skin = "md",
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
          bigger = FALSE,
          transparent = TRUE,
          left_panel = TRUE,
          subNavbar = f7SubNavbar(mod_game_info_ui("game_info_ui_1")[[1]])
        ),
        panels = mod_help_ui("help_ui_1")[[1]],
        toolbar = mod_share_ui("share_ui_1")[[1]],
        f7Tabs(
          id = "tabset",
          swipeable = TRUE,
          animated = FALSE,
          .items = tagList(
            mod_game_params_ui("game_params_ui_1"),
            mod_help_ui("help_ui_1")[[2]]
          ),
          f7Tab(
            tabName = "main",
            active = TRUE,
            icon = f7Icon("home"),
            # main content
            mod_game_info_ui("game_info_ui_1")[[2]],
            mod_game_grid_ui("game_grid_ui_1"),
            mod_share_ui("share_ui_1")[[2]]
          ),
          f7Tab(
            tabName = "scores",
            icon = f7Icon("thumb_up"), 
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
    shiny::tags$link(rel = "apple-touch-icon", href = "www/icons/apple-touch-icon.png"),
    shiny::tags$link(rel = "icon", href = "www/icons/favicon.png"),
    shiny::tags$link(rel = "manifest", href = "www/manifest.json"),
    
    # Splatshscreen for IOS must be in a www folder
    shiny::tags$link(href = "www/splashscreens/iphone5_splash.png", media = "(device-width: 320px) and (device-height: 568px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/iphone6_splash.png", media = "(device-width: 375px) and (device-height: 667px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/iphoneplus_splash.png", media = "(device-width: 621px) and (device-height: 1104px) and (-webkit-device-pixel-ratio: 3)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/iphonex_splash.png", media = "(device-width: 375px) and (device-height: 812px) and (-webkit-device-pixel-ratio: 3)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/iphonexr_splash.png", media = "(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/iphonexsmax_splash.png", media = "(device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio: 3)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/ipad_splash.png", media = "(device-width: 768px) and (device-height: 1024px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/ipadpro1_splash.png", media = "(device-width: 834px) and (device-height: 1112px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/ipadpro3_splash.png", media = "(device-width: 834px) and (device-height: 1194px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    shiny::tags$link(href = "www/splashscreens/ipadpro2_splash.png", media = "(device-width: 1024px) and (device-height: 1366px) and (-webkit-device-pixel-ratio: 2)", rel = "apple-touch-startup-image"),
    
    shinyjs::inlineCSS(list(.darkleaflet = "background-color: #121212")),
    shinyjs::useShinyjs(),
    use_sever()
  )
}
