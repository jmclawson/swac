#' Geolocation data for SWAC-affiliated football stadiums
#'
#' Table showing coordinates in latitude and longitude for the football stadiums used most commonly by SWAC members since 2015. Data includes coordinates for all stadiums visited at least 4 times.
#'
#' @format A tibble with 28 rows and 3 variables:
#' \describe{
#'   \item{stadium}{chr Name of stadium, with city and state}
#'   \item{lat}{num Latitude of stadium, expressed in degrees north of the equator}
#'   \item{lon}{num Longitude of stadium, with negative numbers showing degrees west of the prime meridian}
#' }
"swac_stadiums"
