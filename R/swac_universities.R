#' Data about current and former members of the Southwestern Athletic Conference
#'
#' Table showing information on each of the 18 institutions that are or have been members of SWAC.
#'
#' @format A tibble with 18 rows and 13 variables:
#' \describe{
#'   \item{institution}{chr Common name of the institution}
#'   \item{full_name}{chr Full name of institution}
#'   \item{founded}{num Year institution was founded}
#'   \item{city}{chr City location of institution}
#'   \item{state}{chr State location of institution}
#'   \item{formerly}{List Nested list showing former locations and names of institution. Each row contains a tibble with variable rows and 4 columns: former_city, former_name, from, until. These last two columns indicate years the institution was located or known by former values before moving, renaming, or both.}
#'   \item{team_name}{chr Designation of team mascot, including feminine form where differentiated}
#'   \item{colors}{List Nested list showing colors affiliated with the institution. Each row contains a tibble with variable rows (between 2 and 4) and a single column showing a color definition in hexadecimal code.}
#'   \item{endowment}{num Where noted, the endowed funds available to the institution, in dollars}
#'   \item{enrollment}{num Where available, the total number of students enrolled, as noted on Wikipedia}
#'   \item{website}{chr URL to institutional website}
#'   \item{funding}{chr Indicates whether institution is publicly or privately funded}
#'   \item{note}{chr Any further explanations, where needed}
#' }
"swac_universities"
