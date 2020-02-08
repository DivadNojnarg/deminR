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
  
  # customized action button to render well
  # in the tabbar
  toggle_sheet_bttn <- f7Button(
    inputId = ns("toggle_params_sheet"),
    fill = FALSE,
    label = "Params"#icon("circle_grid_hex")
  )
  
  toggle_sheet_bttn[[2]]$attribs$class <- paste(
    toggle_sheet_bttn[[2]]$attribs$class,
    "tab-link"
  )
  
  tagList(
    f7Sheet(
      id = ns("game_params_sheet"),
      orientation = "top",
      swipeToClose = TRUE,
      swipeToStep = TRUE,
      backdrop = TRUE,
      f7BlockTitle(title = "Select a difficulty", size = "large"),
      f7Radio(
        inputId = ns("level"),
        label = "Choose difficulty",
        choices = difficulty$Level,
        selected = difficulty$Level[1]
      )
    ),
    toggle_sheet_bttn
  )
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
 
