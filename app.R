# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all()
options( "golem.app.prod" = TRUE)

# Important note: the app deployed on shinyapps.io uses some credentials
# to connect to a database and are not shown here. Therefore, we specify the
# usecase to local. If you have a Postgres database, you may provide your own
# credentials for instance:
# deminR::run_app(
#   usecase = "database", 
#   dbname = "whatever", 
#   dbhost = "whatever", 
#   dbport = "whatever", 
#   dbuser = "whatever", 
#   dbpwd = "whatever", 
#   table_scores = "scores_table",
#   table_message = "messages_table"
# ) 
# Obviously, the chat feature is disabled in local mode.
deminR::run_app(usecase = "local")

