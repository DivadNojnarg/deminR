#' Run the Shiny Application
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(usecase = "local", ec_host = "", ec_room = "") {
  
  if (usecase %in% c("local", "online")) {
    with_golem_options(
      app = shinyApp(ui = app_ui, server = app_server), 
      golem_opts = list(usecase = usecase,
                        ec_host = ec_host,
                        ec_room = ec_room)
    )
  } else{
    stop("Enter a valid usecase")
  }
}
