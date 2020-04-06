context("About me server")
testModule(mod_about_me_server, {
  
  # test userName
  expect_equal(grepl("toto", output$userName$html , fixed = TRUE), TRUE)
  r$cookies$user <- "Divad"
  session$flushReact()
  expect_equal(grepl("toto", output$userName$html , fixed = TRUE), FALSE)
  expect_equal(grepl("Divad", output$userName$html , fixed = TRUE), TRUE)
  r$cookies$user <- NULL
  session$flushReact()
  expect_error(output$userName)
  
  # OS output
  r$device$info$os <- "ios"
  session$flushReact()
  expect_equal(html2R(output$myDevice$html)$children[[1]]$children[[2]]$children[[1]], "ios")
  r$device$info$os <- NULL
  session$flushReact()
  expect_error(output$myDevice)
  
  # workerId output
  session$clientData$url_hostname <- "127.0.0.1"
  session$flushReact()
  expect_equal(html2R(output$workerId$html)$children[[1]]$children[[2]]$children[[1]], "?mocksearch=1")
  
}, r = reactiveValues(
  cookies = reactiveValues(user = "toto"),
  currentTab = reactiveValues(val = "scores")
))
