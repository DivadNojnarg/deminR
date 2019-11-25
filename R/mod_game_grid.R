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
                  options = pathOptions(className = data$ID),
                  labelOptions = labelOptions(
                    noHide = TRUE, 
                    textOnly = TRUE,
                    textsize = "15px",
                    direction = "center"
                  ))
  })
  
  observeEvent(input$map_grid_shape_click, {
    data <- SPDF$data
    # when left click, reveal the case
    data$hide[data$ID == input$map_grid_shape_click$id] <- FALSE
    
    if(data$value[data$ID == input$map_grid_shape_click$id] == 0){
      # data <- reveal_zeros(data, input$map_grid_shape_click$id)
      data <- reveal_onclick(data, input$map_grid_shape_click$id)
    }
    
    SPDF$data <- data
  })
  
  observeEvent(input$right_click, {
    data <- SPDF$data
    # when right click, flag the case
    data$flag[data$ID == input$right_click$id] <- TRUE
    SPDF$data <- data
  })
 
  # refresh the display at each change of the dataset
  observe({
    data <- SPDF$data
    N <- nrow(data)
    data$display <- sapply(1:N, function(i){
      if(data$hide[i]){
        res = ifelse(data$flag[i], emo::ji("triangular_flag_on_post")," ")
      } else{
        res = ifelse(data$value[i] == -999, emo::ji("bomb"),  as.character(data$value[i]))
      }
      return(res)
    })
    SPDF$data <- data
  })
  
  
  # TODO : if all bomb cases are flagged, end of the game (win)
  
  
  
  
  
  # TODO : if a bomb case is revealed, reveal all bomb cases and end of the game (lose)
  
  
  
  
}
    
## To be copied in the UI
# mod_game_grid_ui("game_grid_ui_1")
    
## To be copied in the server
# callModule(mod_game_grid_server, "game_grid_ui_1")

