#' scores_stats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param r cross module variable
#' @param scores Scores raw data
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import mobileCharts
mod_scores_stats_ui <- function(id){
  ns <- NS(id)
  f7Tab(
    tabName = "Stats",
    icon = f7Icon("chart_bar_square", old = FALSE),
    active = FALSE,
    f7Card(
      title = tagList(
        "Props",
        f7Radio(
          inputId = ns("propsCol"),
          label = "",
          choices = c("difficulty", "device"),
          selected = "difficulty"
        )
      ),
      mobileOutput(ns("propsChart"))
    ),
    f7Card(
      title = "Clicks",
      mobileOutput(ns("nclicks"))
    )
  )
}
    
#' scores_stats Server Function
#'
#' @noRd 
mod_scores_stats_server <- function(input, output, session, r, scores){
  ns <- session$ns
  
  props <- reactive({
    req(scores())
    scores() %>% 
      count(.data[[input$propsCol]]) %>%
      mutate(props = n / nrow(scores()) * 100) %>%
      mutate(x = "1")
  })
  
  # difficulty level props
  output$propsChart <- render_mobile({
    req(props())
    mobile(props(), aes(x, props, color = .data[[input$propsCol]], adjust = stack)) %>% 
      mobile_bar() %>% 
      mobile_coord("polar", transposed = TRUE) %>% 
      mobile_hide_axis()
  })
  
  # n clicks distribution
  output$nclicks <- render_mobile({
    req(scores())
    
    # filter by category
    df <- scores() %>% 
      filter(difficulty == r$settings$Level) %>%
      count(clicks)
    
    mobile(df, aes(x = clicks, y = n)) %>% 
      mobile_bar() %>% 
      mobile_interaction("bar-select") %>% # highlight on select
      #mobile_interaction("pan", limitRange = lmt) %>% 
      mobile_scroll(mode = "x", xStyle = list(offsetY = -5))
  })
  
  observe(print(scores()))
}
    
## To be copied in the UI
# mod_scores_stats_ui("scores_stats_ui_1")
    
## To be copied in the server
# callModule(mod_scores_stats_server, "scores_stats_ui_1")
 
