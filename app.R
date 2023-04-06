# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all()
options( "golem.app.prod" = TRUE)

# Important note: the app deployed on shinyapps.io uses some credentials
# to connect to a database and are not shown here. Therefore, we specify the
# usecase to local. If you have a Postgres database, you may provide your own
# credentials for instance:
deminR::run_app(
  usecase = "database", 
  dbname = Sys.getenv("DB_NAME"), 
  dbhost = Sys.getenv("DB_HOST"), 
  dbport = Sys.getenv("DB_PORT"), 
  dbuser = Sys.getenv("DB_USER"), 
  dbpwd = Sys.getenv("DB_PWD"), 
  table_scores = "scores",
  table_message = "messages"
) 
# Obviously, the chat feature is disabled in local mode.
#deminR::run_app(usecase = "local")

