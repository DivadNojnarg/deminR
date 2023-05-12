#' PWA dependencies utils
#'
#' @description This function attaches PWA manifest and icons to the given tag
#'
#' @param tag Element to attach the dependencies.
#'
#' @importFrom utils packageVersion
#' @importFrom htmltools tagList htmlDependency
#' @export
add_pwa_deps <- function(tag) {
  pwa_deps <- htmlDependency(
    name = "pwa-utils-custom",
    version = packageVersion("deminR"),
    src = c(file = system.file("deminR-0.0.0.9000", package = "deminR")),
    head = "<link rel=\"manifest\" href=\"www/manifest.webmanifest\"  />
<link rel=\"icon\" type=\"image/png\" href=\"www/icons/144x144.png\" sizes=\"144x144\" />",
    package = "deminR",
  )
  tagList(tag, pwa_deps)
}
