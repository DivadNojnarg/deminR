library(shiny)
library(shinyMobile)
library(testthat)
library(deminR)

arg <- reactiveValues(
  cookies = reactiveValues(),
  loginPage = reactiveValues(visible = TRUE)
)


tryCatch({
  testModule(mod_welcome_server,{
    session$setInputs(login_user = "Toto") # set nickname
    session$setInputs(login = 1) # click on submit button
    expect_equal(r$cookies$user, "Toto") # check cookies
  }, r = arg)
}, error = function(e){
  print("There was an error!")
  print(e)
})

