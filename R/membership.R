#' Data of institutional membership in the Southwestern Athletic Conference
#'
#' Table showing the chronological change of membership in SWAC among 18 institutions. Data includes founding members through March 2023.
#'
#' @format A tibble with 26 rows and 5 variables:
#' \describe{
#'   \item{year}{int Year of institutional change in membership}
#'   \item{historic_name}{chr Name of institution at time of change}
#'   \item{current_name}{chr Current name of institution}
#'   \item{action}{Factor Description of the change. Options include "founded", "left", and "joined".}
#'   \item{note}{chr Any further explanation}
#' }
#' @source \url{https://en.wikipedia.org/wiki/Southwestern_Athletic_Conference}
"membership"
