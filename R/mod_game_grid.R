# Module UI
  
#' @title   mod_game_grid_ui and mod_game_grid_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
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
    
mod_game_grid_server <- function(input, output, session){
  ns <- session$ns
  
  # generate game grid
  SPDF <- reactiveValues(data = generate_spatial_grid(9,10))
  

  # generate the map of the polygon
  # TODO : how to avoid the map to move when double click ?
  output$map_grid <- renderLeaflet({
    data <- SPDF$data
    leaflet(options = leafletOptions(zoomControl = FALSE,
                                     minZoom = 5.8,
                                     maxZoom = 5.8,
                                     dragging = FALSE)) %>% 
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
    data <- SPDF$data
    ind <- data$ID == input$map_grid_shape_click$id
    # when left click, reveal the case
    data$hide[ind] <- FALSE
    data$display[ind] <- data$todisplay[ind]
    
    # if it is a zero, reveal the neighbours
    if(data$value[ind] == 0){
      data <- reveal_onclick(data, input$map_grid_shape_click$id)
    }
    
    data$display[!data$hide] <- data$todisplay[!data$hide]
    # data$color[!data$hide] <- '#d5e6f1'
    data$fillcolor[!data$hide] <- '#d5e6f1'
    
    # if it is a bomb, reveal all other bombs and stop the game
    
    SPDF$data <- data
  })
  
  
  ### Actions after en right click on a case
  observeEvent(input$right_click, {
    data <- SPDF$data
    # when right click, flag or unflag the case
    ind <- data$ID == input$right_click$id
    if(data$hide[ind]){ # an already revealed case cannot be flagged
      data$flag[ind] <- !data$flag[ind]
      data$display[ind] <- ifelse(data$flag[ind],emo::ji("triangular_flag_on_post"), " ")
    }
    SPDF$data <- data
  })
 
  
  # TODO : if all bomb cases are flagged, end of the game (win)
  
  
  
  
  
  # TODO : if a bomb case is revealed, reveal all bomb cases and end of the game (lose)
  
  
  
  
}
    
## To be copied in the UI
# mod_game_grid_ui("game_grid_ui_1")
    
## To be copied in the server
# callModule(mod_game_grid_server, "game_grid_ui_1")

