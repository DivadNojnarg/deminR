#' Run the Shiny Application
#' 
#' @param usecase usecase
#' @param dbname database name
#' @param dbhost database host
#' @param dbport database port
#' @param dbuser database user
#' @param dbpwd database password
#' @param table_scores database table name
#' @param table_message database table name
#' 
#' 
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(usecase = "local", 
                    dbname = "", dbhost = "", dbport = "", dbuser = "", dbpwd = "", table_scores = "", table_message = "") {
  
  if (usecase %in% c("local", "database")) {
    with_golem_options(
      app = shinyApp(ui = app_ui, server = app_server), 
      golem_opts = list(usecase = usecase,
                        dbname = dbname, 
                        dbhost = dbhost, 
                        dbport = dbport, 
                        dbuser = dbuser, 
                        dbpwd = dbpwd,
                        table_scores = table_scores,
                        table_message = table_message)
    )
  } else{
    stop("Enter a valid usecase")
  }
}
