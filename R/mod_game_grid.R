# Module UI
  
#' @title   mod_game_grid_ui and mod_game_grid_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#' @param r cross module variable
#'
#' @rdname mod_game_grid
#'
#' @keywords internal
#' @export 
#' @import shiny 
#' @import leaflet
#' 
# library(shiny)
# library(leaflet)
# 
# if (interactive()){
#  ui <- fluidPage(
#    mod_game_grid_ui("test")
#  )
#  server <- function(input, output, session) {
#    callModule(mod_game_grid_server, "test")
# 
#  }
#  shinyApp(ui, server)
# }

mod_game_grid_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    leafletOutput(ns("map_grid")),
    
    tags$script(
      sprintf(
        "$(function(){
            $('#%s').on('contextmenu', 'path', function (e) {
              // prevent contextmenu display
              e.preventDefault();
              // get class name
              var id = $(e.currentTarget).attr('class').match(/case-\\d+/)[0];
              var right_click = {'count':Math.random(), 'id':id};
              Shiny.setInputValue('%s', right_click);
            });
          });", 
        ns("map_grid"),
        ns("right_click")
      )
    )
  )
}
    
# Module Server
    
#' @rdname mod_game_grid
#' @export
#' @keywords internal
    
mod_game_grid_server <- function(input, output, session, r){
  ns <- session$ns
  
  # generate game grid
  SPDF <- reactiveValues(data = generate_spatial_grid(N = 16, n_mines = 40))
  
  # generate the map of the polygon
  output$map_grid <- renderLeaflet({
    data <- SPDF$data
    leaflet(options = leafletOptions(zoomControl = FALSE,
                                     minZoom = 5.1,
                                     maxZoom = 5.1,
                                     dragging = FALSE,
                                     doubleClickZoom= FALSE)) %>% 
      addPolygons(data = data, 
                  label = data$display,
                  layerId = data$ID,
                  color = data$color,
                  fillColor = data$fillcolor,
                  options = pathOptions(className = data$ID),
                  labelOptions = labelOptions(
                    noHide = TRUE, 
                    textOnly = TRUE,
                    textsize = "15px",
                    direction = "center"
                  ))
  })
  
  
  ### Actions after a left click on a case
  observeEvent(input$map_grid_shape_click, {
    if(r$mod_grid$playing  == "onload"){
      
      data <- SPDF$data
      ind <- data$ID == input$map_grid_shape_click$id
      # when left click, reveal the case
      data$hide[ind] <- FALSE
      data$display[ind] <- data$todisplay[ind]
      
      # if it is a zero, reveal the neighbours
      if(data$value[ind] == 0){
        data <- reveal_onclick(data, input$map_grid_shape_click$id, N = 16)
      }
      
      # if it is a bomb, reveal all other bombs and stop the game
      if(data$value[ind] == -999){
        data$hide[data$value == -999] <- FALSE
        r$mod_grid$playing  <- "loose" 
      }
      
      data$display[!data$hide] <- data$todisplay[!data$hide]
      # data$color[!data$hide] <- '#d5e6f1'
      data$fillcolor[!data$hide] <- '#d5e6f1'
      
      SPDF$data <- data
    }
  })
  
  
  ### Actions after en right click on a case
  observeEvent(input$right_click, {
    if(r$mod_grid$playing  == "onload"){
      data <- SPDF$data
      # when right click, flag or unflag the case
      ind <- data$ID == input$right_click$id
      if(data$hide[ind]){ # an already revealed case cannot be flagged
        data$flag[ind] <- !data$flag[ind]
        data$display[ind] <- ifelse(data$flag[ind],emo::ji("triangular_flag_on_post"), " ")
      }
      SPDF$data <- data
    }
  })
 
  
  # If all bomb cases are hidden and all other cases are revealed, end of the game (win)
  observe({
    data <- SPDF$data
    data_bombs <- data[data$value == -999,]
    data_not_bombs <- data[data$value != -999,]
    
    if(all(!data_not_bombs$hide) & all(data_bombs$hide)){
      r$mod_grid$playing  = "won"
    }
  })
  
  # Start the timer when user first click on the grid
  observe({
    if(any(!SPDF$data$hide)){
      r$mod_grid$start  <- TRUE
    }
  })
  
  observe({
    r$mod_grid$data <- SPDF$data
  })
  
}
    
## To be copied in the UI
# mod_game_grid_ui("game_grid_ui_1")
    
## To be copied in the server
# callModule(mod_game_grid_server, "game_grid_ui_1")

# library(shiny)
# library(leaflet)
# 
# if (interactive()){
#  ui <- fluidPage(
#    mod_game_grid_ui("test")
#  )
#  server <- function(input, output, session) {
#    callModule(mod_game_grid_server, "test")
# 
#  }
#  shinyApp(ui, server)
# }