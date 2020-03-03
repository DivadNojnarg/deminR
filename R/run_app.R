#' Run the Shiny Application
#' 
#' @param usecase usecase
#' @param ec_host ethercalc host
#' @param ec_room ethercalc room
#' @param dbname database name
#' @param dbhost database host
#' @param dbport database port
#' @param dbuser database user
#' @param dbpwd database password
#' @param table_name database table name
#' 
#' 
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(usecase = "local", 
                    ec_host = "", ec_room = "",
                    dbname = "", dbhost = "", dbport = "", dbuser = "", dbpwd = "", table_name = "") {
  
  if (usecase %in% c("local", "ethercalc", "database")) {
    with_golem_options(
      app = shinyApp(ui = app_ui, server = app_server), 
      golem_opts = list(usecase = usecase,
                        ec_host = ec_host,
                        ec_room = ec_room,
                        dbname = dbname, 
                        dbhost = dbhost, 
                        dbport = dbport, 
                        dbuser = dbuser, 
                        dbpwd = dbpwd,
                        table_name = table_name)
    )
  } else{
    stop("Enter a valid usecase")
  }
}
