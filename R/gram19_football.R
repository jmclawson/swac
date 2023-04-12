#' Schedule and outcomes of Grambling's football games in 2019
#'
#' Table showing data on one season of football games played by Grambling State University
#'
#' @format A tibble with 11 rows and 10 variables:
#' \describe{
#'   \item{season}{num Year designation of season}
#'   \item{date}{Date Full date of game}
#'   \item{team}{chr Name of team 1, which is always Grambling}
#'   \item{opponent}{chr Name of Grambling's opponent}
#'   \item{stadium}{chr Name and location of stadium where game was played}
#'   \item{team_score}{num Number of points scored by Grambling}
#'   \item{opponent_score}{num Number of points scored by the opposing team}
#'   \item{team_venue}{Factor Venue status from Grambling's perspective, including "Home" or "Away". Status of "Neutral" is used for special games played in a third location.}
#'   \item{attendance}{num Number of people in attendance at game}
#'   \item{homecoming}{logi Indicates whether a game was designated as the homecoming game}
#' }
#' @source \url{https://swac.org/stats.aspx?path=football}
#' @source \url{https://fbschedules.com/swac-football-schedule}
"gram19_football"
