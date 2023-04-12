# download calendar from:
# https://swac.org/calendar.aspx?path=wvball
library(tidyverse)
library(rvest)

vb_page_1 <- read_html("data-raw/volleyball-1.html")

vb_page_2 <- read_html("data-raw/volleyball-2.html")

vb_page_3 <- read_html("data-raw/volleyball-3.html")

vb_tables <-
  list(html_table(vb_page_1) |>
      bind_rows(),
    html_table(vb_page_2) |>
      bind_rows(),
    html_table(vb_page_3) |>
      bind_rows()) |>
  bind_rows()

clean_location <- function(
    df,
    drop_stadium = TRUE
) {
  the_df <-
    df |>
    separate(location, c("location", "stadium"),
             sep = " - ") |>
    separate(location, c("city", "state"), sep = ",[ ]?") |>
    mutate(
      state = state |>
        str_remove_all("[.]") |>
        toupper() |>
        str_replace_all("ALA", "AL") |>
        str_replace_all("ARK", "AR") |>
        str_replace_all("ARIZ", "AZ") |>
        str_replace_all("CALIF", "CA") |>
        str_replace_all("FLA", "FL") |>
        str_replace_all("IIL", "IL") |>
        str_replace_all("ILL", "IL") |>
        str_replace_all("IND", "IN") |>
        str_replace_all("MINN", "MN") |>
        str_replace_all("MISS", "MS") |>
        str_replace_all("NEV", "NV") |>
        str_replace_all("TENN", "TN") |>
        str_replace_all("TEXAS", "TX") |>
        str_replace_all("WASHINGTON", "WA"),
      city = case_when(
        str_detect(toupper(city), "PRAIRIE") ~ "Prairie View",
        TRUE ~ city) |>
        trimws(),
      state = case_when(
        str_detect(toupper(city), "PRAIRIE") ~ "TX",
        TRUE ~ state) |>
        trimws(),
      stadium = trimws(stadium)) |>
    filter(!is.na(state))

  if(drop_stadium){
    the_df <- the_df |>
      mutate(location = paste0(city, ", ", state))
  } else {
    the_df <- the_df |>
      mutate(location = case_when(
        !is.na(stadium) ~
          paste0(city, ", ",
                 state, " - ",
                 stadium),
        TRUE ~
          paste0(city, ", ", state)
      ))
  }
  the_df |>
    select(-c(city, state, stadium)) |>
    mutate(location = location |>
             str_replace_all(
               "Alcorn State, MS",
               "Lorman, MS"))
}

fix_school <- function(x){
  x |>
    str_replace_all("â", " ") |>
    str_replace_all("TCU", "Texas Christian") |>
    str_replace_all("Prairie View$", "Prairie View A&M") |>
    str_replace_all("UAB", "Alabama Birmingham") |>
    str_replace_all("University of Alabama Birmingham", "Alabama Birmingham") |>
    str_replace_all("Alabama-Birmingham", "Alabama Birmingham") |>
    str_replace_all("SMU", "Southern Methodist") |>
    str_replace_all("ULM", "Louisiana Monroe") |>
    str_replace_all("UTEP", "Texas at El Paso") |>
    str_replace_all("Wiley College (Texas)", "Wiley") |>
    str_replace_all("UMKC", "Missouri Kansas City") |>
    str_replace_all("Nicholls State University|^Nicholls$", "Nicholls State") |>
    str_replace_all("^McNeese$", "McNeese State") |>
    str_replace_all("FIU", "Florida International") |>
    str_replace_all("USF", "South Florida") |>
    str_replace_all("Belmont University", "Belmont") |>
    str_replace_all(" Academy", "") |>
    str_replace_all("Tennessee State University", "Tennessee State") |>
    str_replace_all("Albany State University", "Albany State") |>
    str_replace_all("Jacksonville State University", "Jacksonville State")

}

set_location <- function(df,
                         the_school,
                         the_location){
  df |>
    mutate(location = case_when(
      school == the_school ~ the_location,
      TRUE ~ location))
}

tidy_vb_schedule <- function(dat = vb_tables){
  dat |>
    mutate(
      Away = Away |>
        str_remove_all("\n|\t") |>
        str_replace_all("[ ]+", " "),
      Home = Home |>
        str_remove_all("\n|\t") |>
        str_replace_all("[ ]+", " ")) |>
    separate(
      Home,
      c("Home", "Home.Result"),
      sep = " \\(Home\\) ") |>
    separate(
      Away,
      c("Away", "Away.Result"),
      sep = " \\(Away\\) ") |>
    mutate(
      Tournament = case_when(
        str_detect(Location, "Tournament|Classic|Invitational") ~
          str_extract(Location,
                      "\n\t\t[A-Z a-z 0-9 [:punct:]]+$") |>
          trimws(),
        TRUE ~ NA_character_),
      Conference = Location |>
        str_detect("(Conf.)"),
      Location = Location |>
        str_remove_all("\\(Conf\\.\\)") |>
        str_remove_all("\t\t[A-Z a-z 0-9 [:punct:]]+$") |>
        trimws(),
      Date = as.Date(Date,
                     tryFormats = "%A %m/%d/%Y"),
      Season = format(Date, "%Y")) |>
    mutate(Season = case_when(
      Season == "2021" & Date < as.Date("2021-07-01") ~ "2020",
      TRUE ~ Season)) |>
    select(-Time, -Links, -Result) |>
    mutate(
      Home = Home |>
        str_remove_all("[(]Home[)]"),
      Away = Away |>
        str_remove_all("[(]Away[)]")) |>
    janitor::clean_names() |>
    pivot_longer(-c(date, location, tournament, conference, season)) |>
    mutate(
      name = name |>
        str_replace_all("away","opponent") |>
        str_replace_all("home","team")) |>
    pivot_wider() |>
    unnest(
      cols = c(opponent, opponent_result,
               team, team_result)) |>
    relocate(season, date, team, opponent, team_result, opponent_result) |>
    clean_location() |>
    mutate(team = fix_school(team),
           opponent = fix_school(opponent)) |>
    filter(!str_detect(team, "2017 SWAC")) |>
    filter(!str_detect(team, "~")) |>
    filter(team != "")
}

fix_location <- function(df){
  df |>
    set_location("Oral Roberts",
                 "Tulsa, OK") |>
    set_location("Oklahoma",
                 "Norman, OK") |>
    set_location("Missouri Kansas City",
                 "Kansas City, MO") |>
    set_location("Arkansas-Little Rock",
                 "Little Rock, AR") |>
    set_location("High Point University",
                 "High Point, NC") |>
    set_location("Abilene Christian",
                 "Abilene, TX") |>
    set_location("Marist",
                 "Poughkeepsie, New York") |>
    set_location("DePaul",
                 "Chicago, IL") |>
    set_location("Stetson",
                 "DeLand, FL") |>
    set_location("Duquesne",
                 "Pittsburgh, PA") |>
    # set_location("Southeastern University",
    #              "Hammond, LA") |>
    set_location("Gardner-Webb",
                 "Boiling Springs, NC") |>
    set_location("Southern Methodist University", "Dallas, TX") |>
    set_location("Cal State Fullerton",
                 "Fullerton, CA") |>
    set_location("University of Louisiana Monroe", "Monroe, LA") |>
    set_location("Davidson",
                 "Davidson, NC") |>
    set_location("Arkansas State University",
                 "Jonesboro, AR") |>
    set_location("Indiana State University",
                 "Terre Haute, IN") |>
    set_location("Missouri State",
                 "Springfield, MO") |>
    set_location("San Jose State",
                 "San Jose, CA") |>
    set_location("Western Illinois",
                 "Macomb, IL") |>
    set_location("Wiley",
                 "Wiley, TX") |>
    set_location("Norfolk State",
                 "Norfolk, VA") |>
    set_location("Omaha",
                 "Omaha, NE") |>
    # set_location("Nicholls State University",
    #              "Thibodaux, LA") |>
    set_location("Rust",
                 "Holly Springs, MS") |>
    set_location("Albany State",
                 "Albany, GA") |>
    set_location("Colorado",
                 NA) |>
    set_location("Arkansas-Monticello",
                 "Monticello, AR") |>
    set_location("Wofford",
                 "Spartanburg, SC") |>
    set_location("Charleston Southern",
                 "North Charleston, SC") |>
    set_location("",
                 "") |>
    set_location("",
                 "") |>
    set_location("",
                 "")

}

vb_combined <- tidy_vb_schedule()

probable_home_venues <-
  vb_combined |>
  select(team, opponent, location) |>
  pivot_longer(-location,
               values_to = "school") |>
  count(school, location, sort = TRUE) |>
  group_by(school) |>
  arrange(desc(n)) |>
  slice_head(n = 1) |>
  ungroup() |>
  group_by(location) |>
  arrange(desc(n)) |>
  slice_head(n = 2) |>
  ungroup() |>
  arrange(desc(n)) |>
  fix_location()

# try to guess whether away, home, or neutral
volleyball <-
  vb_combined |>
  clean_location() |>
  mutate(team = trimws(team),
         opponent = trimws(opponent)) |>
  left_join(
    probable_home_venues |>
      select(-n) |>
      rename(team = school,
             home_team = location)) |>
  left_join(
    probable_home_venues |>
      select(-n) |>
      rename(opponent = school,
             home_opponent = location)) |>
  mutate(team_venue = case_when(
    !is.na(tournament) ~ "Neutral",
    location == home_team ~ "Home",
    location == home_opponent ~ "Away",
    TRUE ~ NA)) |>
  select(-home_team, -home_opponent)

volleyball <- volleyball |>
  mutate(team_result = as.numeric(team_result),
         opponent_result = as.numeric(opponent_result),
         team_venue = factor(team_venue))

usethis::use_data(volleyball, overwrite = TRUE)
