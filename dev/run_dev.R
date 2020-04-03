# Set options here
options(golem.app.prod = FALSE) # TRUE = production mode, FALSE = development mode

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Run the application
deminR::run_app(usecase = "database", 
                dbname = "", 
                dbhost = "", 
                dbport = "", 
                dbuser = "",
                dbpwd = "", 
                table_scores = "", 
                table_message = "")
# deminR::run_app(usecase = "local")


