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
      title = "Props",
      mobileOutput(ns("props"))
    )
  )
}
    
#' scores_stats Server Function
#'
#' @noRd 
mod_scores_stats_server <- function(input, output, session, r, scores){
  ns <- session$ns
  
  output$props <- render_mobile({
    req(scores())
    
    df <- scores() %>% 
      count(difficulty) %>%
      mutate(props = n / nrow(scores()) * 100) %>%
      mutate(x = "1")
    
    mobile(df, aes(x, props, color = difficulty, adjust = stack)) %>% 
      mobile_bar() %>% 
      mobile_coord("polar", transposed = TRUE) %>% 
      mobile_hide_axis()
  })
  observe(print(scores()))
}
    
## To be copied in the UI
# mod_scores_stats_ui("scores_stats_ui_1")
    
## To be copied in the server
# callModule(mod_scores_stats_server, "scores_stats_ui_1")
 
