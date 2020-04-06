library(shiny)

arg <- reactiveValues(
  cookies = reactiveValues(user = NULL),
  loginPage = reactiveValues(visible = TRUE)
)

context("Welcome server")


# Test authentication
tryCatch({
  testModule(mod_welcome_server, {
    # we start in a non authenticated state
    expect_equal(authenticated(), FALSE)
    session$setInputs(login_user = "Toto") # set nickname
    session$setInputs(login = 1) # click on submit button
    expect_equal(r$cookies$user, "Toto") # check cookies
    # once logged, we expect to be authenticated
    expect_equal(authenticated(), TRUE)
  }, r = arg)
}, error = function(e){
  print("There was an error!")
  print(e)
})
