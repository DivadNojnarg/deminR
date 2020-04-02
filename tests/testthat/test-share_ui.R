shareUI <- mod_share_ui("share_ui")

test_that("share UI global", {
  expect_shinytaglist(shareUI)
  expect_length(shareUI, 2)
  expect_equal(shareUI[[1]]$attribs$id, "share_ui-shareToolbar")
  expect_equal(shareUI[[2]]$attribs$id, "share_ui-shareFabs")
})
