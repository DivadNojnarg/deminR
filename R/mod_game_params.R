# Module UI
  
#' @title   mod_game_params_ui and mod_game_params_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross 
#'
#' @rdname mod_game_params
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_game_params_ui <- function(id){
  ns <- NS(id)
  
  # custom reload button
  reload_bttn <- f7Button(
    inputId = ns("reload"), 
    fill = FALSE,
    label = f7Icon("autorenew")
  )
  
  reload_bttn[[2]]$name <- "a"
  reload_bttn[[2]]$attribs$type <- NULL
  reload_bttn[[2]]$attribs$class <- "tab-link f7-action-button"
  reload_bttn[[2]]$children <- NULL
  reload_bttn[[2]] <- tagAppendChildren(
    reload_bttn[[2]], 
    f7Icon("refresh_outline"),
    span(class = "tabbar-label", "Reload")
  )
  
  
  sheetTag <- f7Sheet(
    id = ns("game_params_sheet"),
    orientation = "bottom",
    swipeToClose = TRUE,
    swipeToStep = TRUE,
    backdrop = TRUE,
    f7BlockTitle(title = "Game Options", size = "large"),
    f7Radio(
      inputId = ns("level"),
      label = "Choose difficulty",
      choices = difficulty$Level,
      selected = difficulty$Level[1]
    )
  )
  
  sheetTrigger <- f7TabLink(
    `data-sheet` = paste0("#", ns("game_params_sheet")),
    class = "sheet-open",
    icon = f7Icon("settings_outline"),
    label = "Settings"
  )
  
  tagList(reload_bttn, sheetTag, sheetTrigger)
  
}
    
# Module Server
    
#' @rdname mod_game_params
#' @export
#' @keywords internal
    
mod_game_params_server <- function(input, output, session, r){
  ns <- session$ns
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
  
  # Open the sheet when click on the tabbar button
  observeEvent(input$toggle_params_sheet, {
    updateF7Sheet(inputId = "game_params_sheet", session = session)
  })
}
    
## To be copied in the UI
# mod_game_params_ui("game_params_ui_1")
    
## To be copied in the server
# callModule(mod_game_params_server, "game_params_ui_1")
 
