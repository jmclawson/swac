#' Schedule and outcomes of SWAC football games
#'
#' Table showing data on football games, including schedule and outcome for SWAC institutions for seasons between 2015 and 2022, inclusive
#'
#' @format A tibble with 903 rows and 10 variables:
#' \describe{
#'   \item{season}{chr Year designation of season}
#'   \item{date}{Date Full date of game}
#'   \item{team}{chr Name of team 1 }
#'   \item{opponent}{chr Name of team 2}
#'   \item{stadium}{chr Name and location of stadium where game was played}
#'   \item{team_score}{num Number of matches won by team 1}
#'   \item{opponent_score}{num Number of matches won by team 2}
#'   \item{team_venue}{Factor Venue status of team 1, including "Home" or "Away". Status of "Neutral" is used for special games played in a third location.}
#'   \item{attendance}{num Number of people in attendance at game}
#'   \item{homecoming}{logi Indicates whether a game was designated as an institution's homecoming game for a particular season}
#' }
#' @source \url{https://swac.org/stats.aspx?path=football}
#' @source \url{https://fbschedules.com/swac-football-schedule}
"swac_football"
