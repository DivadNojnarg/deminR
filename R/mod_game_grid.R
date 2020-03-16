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
#' @importFrom purrr map
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
    # grid for game
    leafletOutput(ns("map_grid")),
    # disable mobile browser default "long-tap" actions
    tags$style(
      ".disable-select {
        user-select: none; /* supported by Chrome and Opera */
        -webkit-user-select: none; /* Safari */
        -khtml-user-select: none; /* Konqueror HTML */
        -moz-user-select: none; /* Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
      }
      "
    ),
    # set up custom input
    tags$script(
      # right click on desktop
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
      ),
      # long press for mobiles
      sprintf(
        "$(function() {
          $('#%s').on('taphold', 'path', function (e) {
            var id = $(e.currentTarget).attr('class').match(/case-\\d+/)[0];
            var right_click = {'count':Math.random(), 'id':id};
            Shiny.setInputValue('%s', right_click);
          });
        });
        ",
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
  
  # generate the map of the polygon
  output$map_grid <- renderLeaflet({
    data <- r$mod_grid$data
    leaflet(
      options = leafletOptions(
        zoomControl = FALSE,
        minZoom = r$settings$Zoom,
        maxZoom = r$settings$Zoom,
        dragging = FALSE,
        doubleClickZoom = FALSE,
        attributionControl = FALSE
      )
    ) %>% 
      addPolygons(
        data = data, 
        label = data$display,
        layerId = data$ID,
        color = data$color,
        fillColor = data$fillcolor,
        options = pathOptions(className = data$ID),
        labelOptions = labelOptions(
          noHide = TRUE, 
          textOnly = TRUE,
          textsize = "15px",
          direction = "center",
          style = list(
            "color" = if (r$theme$color == "dark") "white" else "black",
            "font-weight" =  "bold"
          )
        )
      )
  })
  
  
  ### Actions after a left click on a case
  observeEvent(input$map_grid_shape_click, {
    if(r$mod_grid$playing  == "onload"){
      
      data <- r$mod_grid$data
      ind <- data$ID == input$map_grid_shape_click$id
      # when left click, reveal the case
      data$hide[ind] <- FALSE
      data$display[ind] <- data$todisplay[ind]
      
      # if it is a zero, reveal the neighbours
      if(data$value[ind] == 0){
        data <- reveal_onclick(data, input$map_grid_shape_click$id, N = r$settings$Size)
      }
      
      data$display[!data$hide] <- data$todisplay[!data$hide]
      data$fillcolor[!data$hide] <- '#d5e6f1'
      
      # if it is a bomb, reveal all other bombs and stop the game
      if(data$value[ind] == -999){
        data$hide[data$value == -999] <- FALSE
        data$display[!data$hide] <- data$todisplay[!data$hide]
        data$fillcolor[!data$hide] <- '#d5e6f1'
        data$fillcolor[ind] <- "#b00000"
        r$mod_grid$playing  <- "loose" 
      }
      
      r$mod_grid$data<- data
    }
  })
  
  
  ### Actions after en right click on a case
  observeEvent(input$right_click, {
    if(r$mod_grid$playing  == "onload"){
      data <- r$mod_grid$data
      # when right click, flag or unflag the case
      ind <- data$ID == input$right_click$id
      if(data$hide[ind]){ # an already revealed case cannot be flagged
        data$flag[ind] <- !data$flag[ind]
        data$display[ind] <- ifelse(data$flag[ind],emo::ji("triangular_flag_on_post"), " ")
      }
      r$mod_grid$data<- data
    }
  })
  
  
  ### If all bomb cases are hidden and all other cases are revealed, end of the game (win)
  observe({
    data <- r$mod_grid$data
    data_bombs <- data[data$value == -999,]
    data_not_bombs <- data[data$value != -999,]
    
    if(all(!data_not_bombs$hide) & all(data_bombs$hide)){
      r$mod_grid$playing  = "won"
    }
  })
  
  ### Start the timer when user first click on the grid
  observe({
    if(any(!r$mod_grid$data$hide)){
      r$mod_grid$start  <- TRUE
    }
  })
  
  
  # warrior mode does funny things!
  observeEvent({
    req(r$warrior$mode)
    req(r$mod_timer$seconds != 0)
  },{
    degree <- sample(c(90, 180, 270, 360), 1)
    shinyjs::runjs(
      sprintf(
        "jQuery.fn.rotate = function(degrees) {
          $(this).css({'transform' : 'rotate('+ degrees +'deg)'});
          return $(this);
        };
        
        setTimeout(function() {
          $('#%s').one('click', function() {
            $(this).rotate(%i);
          });
        }, 1000);
        ",
        ns("map_grid"),
        degree
      )
    )
  })
  
  
  observeEvent(r$mod_welcome$firstVisit, {
    shinyjs::addCssClass(id = "map_grid", class = "darkleaflet")
  })
  
  return(reactive(input$map_grid_shape_click))
  
}

## To be copied in the UI
# mod_game_grid_ui("game_grid_ui_1")

## To be copied in the server
# callModule(mod_game_grid_server, "game_grid_ui_1")
