# download files from:
# https://fbschedules.com/swac-football-schedule/
library(tidyverse)
library(rvest)

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

source_folder <- "data-raw/sourcefiles/football" # "~/Downloads/SWAC-detailed"

all_files <- source_folder |>
  list.files(full.names = TRUE) |>
  set_names(
    source_folder |>
      list.files() |>
      gsub("-", "_", x = _) |>
      gsub("_football_schedule.html",
           "", x = _) |>
      gsub("([0-9]{4})_(.*)",
           "\\2_\\1", x = _))

records_list <-
  source_folder |>
  list.files(full.names = TRUE) |>
  set_names(
    source_folder |>
      list.files() |>
      gsub("-", "_", x = _) |>
      gsub("_football_schedule.html",
           "", x = _) |>
      gsub("([0-9]{4})_(.*)",
           "\\2_\\1", x = _)) |>
  lapply(read_html) |>
  lapply(html_table) |>
  lapply(first) |>
  lapply(filter, X1 != X2) |>
  lapply(janitor::row_to_names, 1) |>
  lapply(select, -c(2,6)) |>
  setNames(names(all_files)) |>
  do.call(rbind.data.frame,
          args = _) |>
  rownames_to_column("set") |>
  mutate(
    set = set |>
      gsub(".[0-9]+$","",x=_) |>
      gsub("_([0-9]{4})$","-\\1",x=_)) |>
  filter(Opponent != "OFF") |>
  separate(set,
           c("Team", "Season"),
           "-") |>
  separate(Opponent,
           c("Opponent", "Stadium"),
           "\n") |>
  mutate(
    fake_season = case_when(
      Season == "2020" ~ "2021",
      TRUE ~ Season) |>
      as.numeric(),
    Season = factor(Season),
    Opponent = trimws(Opponent),
    Stadium = trimws(Stadium),
    Date = Date |>
      paste0(", ", fake_season) |>
      gsub("^[A-Za-z]+ ","",x=_) |>
      as.Date(
        format = c("%b. %d, %Y"))) |>
  select(-c(`Time/TV`,fake_season)) |>
  separate(Tickets,
           c("Team.Result", "Score"),
           " ") |>
  separate(Score,
           c("High.Score", "Low.Score"),
           "-") |>
  separate(Low.Score,
           c("Low.Score", "Note"),
           "\\(") |>
  mutate(Note = Note |>
           gsub(")", "", x=_),
         Team.Result = case_when(
           Team.Result == "W" ~ "W",
           Team.Result == "L" ~ "L",
           TRUE ~ NA |>
             as.character()),
         Team.Score = case_when(
           Team.Result == "W" ~ High.Score,
           TRUE ~ Low.Score),
         Opponent.Score = case_when(
           Team.Result == "L" ~ High.Score,
           TRUE ~ Low.Score),
         Team.Venue = case_when(
           grepl("^at", Opponent)~"Away",
           grepl("^vs", Opponent)~"Neutral",
           TRUE ~ "Home") |>
           factor(),
         Homecoming = case_when(
           grepl("(HC)", Stadium)~ TRUE,
           TRUE ~ FALSE),
         Stadium = Stadium |>
           gsub("\\(HC\\)", "",x=_),
         Opponent = Opponent |>
           gsub("^at ", "",x=_) |>
           gsub("^vs ", "",x=_),
         Team.Score = Team.Score |>
           as.numeric(),
         Opponent.Score = Opponent.Score |>
           as.numeric()) |>
  select(-c(High.Score, Low.Score)) |>
  relocate(Season, Date) |>
  relocate(Note, .after=Homecoming) |>
  mutate(Team = Team |>
           gsub("_am$", " A&M", x=_) |>
           gsub("_", " ", x=_) |>
           capwords() |>
           gsub("as Pi", "as-Pi", x=_) |>
           gsub("une Co", "une-Co", x=_)) |>
  mutate(
    Opponent = case_when(
      Date == "2015-11-21" &
        Team == "Alabama State" ~
        "Miles College Golden Bears",
      TRUE ~ Opponent),
    Stadium = case_when(
      Date == "2015-11-21" &
        Team == "Alabama State" ~
        "ASU Stadium, Montgomery, AL",
      TRUE ~ Stadium),
    Homecoming = case_when(
      Date == "2015-11-21" &
        Team == "Alabama State" ~
        TRUE,
      TRUE ~ Homecoming))

# saveRDS(records_list, "football.rds")

# records_list <- swac

##### Add other details #####

teams_list <-
  # "https://swac.org/stats.aspx?path=football&year=2018" |>
  c("https://swac.org/stats.aspx?path=football&year=2017",
    "/Users/jmclawson/Downloads/2018 Football - Overall Statistics - Southwestern Athletic Conference.html",
    "https://swac.org/stats.aspx?path=football&year=2019",
    "https://swac.org/stats.aspx?path=football&year=2020",
    "https://swac.org/stats.aspx?path=football&year=2021",
    "https://swac.org/stats.aspx?path=football&year=2022") |>
  {\(x) set_names(x, x |> gsub(".*([0-9]{4}).*","\\1",x=_))}() |>
  lapply(read_html) |>
  lapply(html_elements, "#by_team h5") |>
  lapply(html_text) |>
  lapply(strsplit, " \\(") |>
  lapply(sapply, `[`, 1) |>
  lapply(trimws) |>
  lapply(tibble) |>
  lapply(rownames_to_column, "teamnum") |>
  lapply(set_names, "teamnum", "Team") |>
  lapply(mutate,
         teamnum = as.numeric(teamnum)) |>
  bind_rows(.id="Season") |>
  mutate(Season_Team = Season |>
           paste0("_", teamnum)) |>
  select(Season_Team, Team)

attendance_list <-
  # "https://swac.org/stats.aspx?path=football&year=2018" |>
  c(#"https://swac.org/stats.aspx?path=football&year=2015",
    #"https://swac.org/stats.aspx?path=football&year=2016",
    "https://swac.org/stats.aspx?path=football&year=2017",
    "/Users/jmclawson/Downloads/2018 Football - Overall Statistics - Southwestern Athletic Conference.html",
    "https://swac.org/stats.aspx?path=football&year=2019",
    "https://swac.org/stats.aspx?path=football&year=2020",
    "https://swac.org/stats.aspx?path=football&year=2021",
    "https://swac.org/stats.aspx?path=football&year=2022") |>
  {\(x) set_names(x, x |> gsub(".*([0-9]{4}).*","\\1",x=_))}() |>
  lapply(read_html) |>
  lapply(html_elements, "#by_team") |>
  lapply(html_table) |>
  lapply(first) |>
  lapply(mutate,
         Date = Date |>
           substr(1,10) |>
           as.Date(format = "%m/%d/%Y"),
         Opponent = Opponent |>
           gsub("^[*] ", "",
                x = _) |>
           gsub("^at ", "",
                x = _) |>
           trimws(),
         teamnum = cumsum(
           is.na(Date)) + 1) |>
  bind_rows(.id="Season") |>
  mutate(Season_Team = Season |>
           paste0("_", teamnum)) |>
  left_join(teams_list) |>
  filter(!is.na(Date)) |>
  select(Date, Team, Attendance)

swac_all <- records_list |>
  left_join(distinct(attendance_list)) |>
  mutate(Drop_It = case_when(
    Team %in% c("Bethune-Cookman",
                "Florida A&M") &
      as.integer(as.character(Season)) < 2021 ~ TRUE,
    TRUE ~ FALSE)) |>
  filter(!Drop_It) |>
  select(-Drop_It) |>
  # filter(!Team %in% c("Bethune-Cookman",
  #                     "Florida A&M")) |>
  mutate(
    Attendance = case_when(
      Attendance == "" ~ NA |>
        as.integer(),
      TRUE ~ Attendance |>
        as.integer()),
    Stadium = case_when(
      Stadium == "," ~ NA |>
        as.character(),
      TRUE ~ Stadium) |>
      trimws())


football <-
  swac_all |>
  group_by(Date, Stadium) |>
  mutate(half_miss = sum(!is.na(Attendance)) - sum(is.na(Attendance)) == 0) |>
  group_by(Date, Stadium) |>
  mutate(Attendance = case_when(
    half_miss ~ sum(Attendance, na.rm = TRUE),
    TRUE ~ Attendance)) |>
  arrange(desc(Date), Team) |>
  select(-c(Team.Result,
            # note,
            half_miss,
  )) |>
  janitor::clean_names() |>
  mutate(attendance = case_when(
    date == "2019-11-09" &
      grepl("BBVA", stadium) &
      is.na(attendance) ~ as.numeric(2422),
    TRUE ~ as.numeric(attendance))) |>
  ungroup() |>
  select(-note)

# supplement missing homecoming games

football_homecomings <-
  football |>
  select(-homecoming) |>
  left_join(
    football |>
      filter(homecoming) |>
      select(date, team, against = opponent) |>
      rbind(
        tribble(
          ~date,       ~team,         ~against,
          "2015-09-26", "Alabama A&M", "UAPB",
          "2016-10-08", "Alabama A&M", "Alcorn",
          "2017-09-30", "Alabama A&M", "UAPB",
          # "2015-11-21", "Alabama State", "Miles",
          "2016-11-24", "Alabama State", "Miles",
          "2017-11-23", "Alabama State", "Edward Waters",
          "2019-11-28", "Alabama State", "Prairie View",
          "2015-10-17", "Alcorn State", "Grambling",
          "2016-10-15", "Alcorn State", "Texas Southern",
          "2017-10-14", "Alcorn State", "Prairie View",
          #
          "2015-11-14", "Arkansas-Pine Bluff", "Grambling",
          "2016-10-15", "Arkansas-Pine Bluff", "Alabama A&M",
          "2017-10-14", "Arkansas-Pine Bluff", "Central State",
          "2018-11-03", "Arkansas-Pine Bluff", "Alabama A&M",
          #
          "2015-10-24", "Grambling State", "MVSU",
          "2016-10-29", "Grambling State", "UAPB",
          "2017-10-28", "Grambling State", "Texas Southern",
          "2015-10-24", "Jackson State", "UAPB",
          "2016-10-29", "Jackson State", "Prairie View",
          "2017-10-28", "Jackson State", "MVSU",
          "2015-10-17", "Mississippi Valley State", "Texas Southern",
          "2016-10-22", "Mississippi Valley State", "Grambling",
          "2017-10-21", "Mississippi Valley State", "Virginia-Lynchburg",
          #
          "2015-10-10", "Prairie View A&M", "MVSU",
          "2016-10-08", "Prairie View A&M", "Alabama State",
          "2017-10-28", "Prairie View A&M", "Bacone",
          "2015-10-17", "Southern", "Prairie View",
          "2016-10-22", "Southern", "UAPB",
          "2017-10-07", "Southern", "Alabama A&M",
          "2018-09-29", "Southern", "Alcorn State",
          "2015-10-24", "Texas Southern", "Southern",
          "2016-10-22", "Texas Southern", "Jackson State",
          "2017-10-14", "Texas Southern", "Alabama State"
        ) |>
          mutate(date = as.Date(date))) |>
      mutate(homecoming = TRUE)) |>
  mutate(homecoming = case_when(
    date == "2018-11-10" & team == "Mississippi Valley State" ~ FALSE,
    is.na(homecoming) ~ FALSE,
    TRUE ~ homecoming
  )) |>
  select(-note, -against)

football <- football_homecomings |>
  mutate(season = as.numeric(season))

saveRDS(football, file = "swac_football.rds")

usethis::use_data(football, overwrite = TRUE)


########## Geolocation for most-visited stadiums

stadiums <- tribble(
  ~lat,       ~lon, ~stadium,
  32.3296, -90.1798, "MS Veterans Memorial Stadium, Jackson, MS",
  31.8736, -91.1351, "Jack Spinks Stadium, Lorman, MS",
  32.3642, -86.2896, "ASU Stadium, Montgomery, AL",
  33.5093, -90.3431, "Rice-Totten Stadium, Itta Bena, MS",
  29.7522, -95.3523, "BBVA Stadium, Houston, TX",
  30.0911, -95.9944, "Panther Stadium, Prairie View, TX",
  34.7837, -86.5784, "Louis Crews Stadium, Huntsville, AL",
  30.5221, -91.1896, "Ace W. Mumford Stadium, Baton Rouge, LA",
  34.2534, -92.0215, "Golden Lion Stadium, Pine Bluff, AR",
  32.5208, -92.7212, "Eddie Robinson Stadium, Grambling, LA",
  30.4261, -84.2918, "Bragg Memorial Stadium, Tallahassee, FL",
  32.7796, -96.7596, "Cotton Bowl Stadium, Dallas, TX",
  33.5113, -86.8427, "Legion Field, Birmingham, AL",
  29.1731, -81.1175, "Daytona Stadium, Daytona Beach, FL",
  29.9511, -90.0812, "Mercedes-Benz Superdome, New Orleans, LA",
  30.6730, -88.0756, "Ladd-Peebles Stadium, Mobile, AL",
  35.1211, -89.9774, "Liberty Bowl Memorial Stadium, Memphis, TN",
  34.2534, -92.0215, "Simmons Bank Field, Pine Bluff, AR",
  28.5390, -81.4028, "Camping World Stadium, Orlando, FL",
  25.9584, -80.2386, "Hard Rock Stadium, Miami Gardens, FL",
  32.4757, -93.7919, "Independence Stadium, Shreveport, LA",
  33.7553, -84.4006, "Mercedes-Benz Stadium, Atlanta, GA",
  34.7499, -92.3301, "War Memorial Stadium, Little Rock, AR",
  32.7510, -97.0830, "Globe Life Park, Arlington, TX",
  31.3290, -89.3312, "M. M. Roberts Stadium, Hattiesburg, MS",
  29.6847, -95.4107, "NRG Stadium, Houston, TX",
  41.3117, -105.5683, "War Memorial Stadium, Laramie, WY",
  29.9511, -90.0812, "Caesars Superdome, New Orleans, LA"
) |>
  arrange(lon) |>
  relocate(stadium)

usethis::use_data(stadiums, overwrite = TRUE)

gram19_football <-
  football |>
  filter(season == 2019, team == "Grambling State")

usethis::use_data(gram19_football, overwrite = TRUE)

# AlabamaAM <-
#   read.csv("~/Downloads/gsu-football/swac2019/AlabamaAM-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# AlabamaState <-
#   read.csv("~/Downloads/gsu-football/swac2019/AlabamaState-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# AlcornState <-
#   read.csv("~/Downloads/gsu-football/swac2019/AlcornState-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# GramblingState <-
#   read.csv("~/Downloads/gsu-football/swac2019/GramblingState-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# JacksonState <-
#   read.csv("~/Downloads/gsu-football/swac2019/JacksonState-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# MSValleyState <-
#   read.csv("~/Downloads/gsu-football/swac2019/MSValleyState-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# PrairieView <-
#   read.csv("~/Downloads/gsu-football/swac2019/PrairieView-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# Southern <-
#   read.csv("~/Downloads/gsu-football/swac2019/Southern-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# TexasSouthern <-
#   read.csv("~/Downloads/gsu-football/swac2019/TexasSouthern-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
# UAPineBluff <-
#   read.csv("~/Downloads/gsu-football/swac2019/UAPineBluff-Table 1.csv",
#            stringsAsFactors = FALSE,
#            skip = 1)
#
# swac <- list(AlabamaAM=AlabamaAM, AlabamaState=AlabamaState,
#              AlcornState=AlcornState, GramblingState=GramblingState,
#              JacksonState=JacksonState, MSValleyState=MSValleyState,
#              PrairieView=PrairieView, Southern=Southern,
#              TexasSouthern=TexasSouthern, UAPineBluff=UAPineBluff)
#
# swac <- do.call(rbind.data.frame, swac)
#
# swac$Team <- rownames(swac) %>% strsplit("\\.") %>% sapply(`[`,1)
# rownames(swac) <- NULL
#
# swac <- swac[-grep("OFF",swac$Opponent),c("Date", "Team", "Opponent", "Tickets")]
# swac <- swac[-grep("SWAC Championship",swac$Opponent),]
# swac$Tickets[swac$Tickets=="Buy Tickets"] <- NA
# colnames(swac)[4] <- "Results"
# swac$Team <- gsub("([A-z])([A-Z][a-z])", "\\1 \\2", swac$Team)
# swac$Team <- gsub("([a-z])([A-Z])", "\\1 \\2", swac$Team)
# swac$Location <- swac$Opponent %>% strsplit("\n") %>% sapply(`[`,2)
# swac$Opponent <- swac$Opponent %>% strsplit("\n") %>% sapply(`[`,1)
# swac$Opponent <- gsub("^at ", "", swac$Opponent)
# swac$Opponent <- gsub("^vs ", "", swac$Opponent)
# swac$Homecoming <- FALSE
# swac$Homecoming[grep("(HC)",swac$Opponent)] <- TRUE
# swac$Opponent <- gsub(" \\(HC\\)", "", swac$Opponent)
# swac$Team.Score <- swac$Results %>% strsplit(" ") %>% sapply(`[`,2) %>% strsplit("-") %>% sapply(`[`,1)
# swac$Opponent.Score <- swac$Results %>% strsplit(" ") %>% sapply(`[`,2) %>% strsplit("-") %>% sapply(`[`,2) %>% gsub(pattern="([0-9]*).*",replacement = "\\1", x=.)
# swac$Results <- swac$Results %>% strsplit(" ") %>% sapply(`[`,1)
# swac$Location <- gsub("ASU", "Alabama State University", swac$Location)
#
# write.csv(swac, "swac.csv", row.names = FALSE)
#
# write.csv(swac[swac$Team=="Alabama AM",], "swac-alabama-am.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Alcorn State",], "swac-alcorn.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Grambling State",], "swac-grambling.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Jackson State",], "swac-jackson.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="MS Valley State",], "swac-msvalley.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Prairie View",], "swac-prairieview.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Southern",], "swac-southern.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="Texas Southern",], "swac-texassouthern.csv", row.names = FALSE)
# write.csv(swac[swac$Team=="UA Pine Bluff",], "swac-uapb.csv", row.names = FALSE)
#
#
# #############
#
# for (r in 1:nrow(swac)){
#   if(!is.na(swac$Team.Score[r])){
#     if(swac$Team.Score[r]>swac$Opponent.Score[r]){
#       swac$Actual[r] <- "W"
#     } else {
#       swac$Actual[r] <- "L"}
#   } else {
#     swac$Actual[r] <- NA
#   }
#   }
#
# for (r in 1:nrow(swac)){
#   if(!is.na(swac$Team.Score[r])){
#     if(swac$Results[r]!=swac$Actual[r]) {
#       score1 <- swac$Team.Score[r]
#       score2 <- swac$Opponent.Score[r]
#       swac$Team.Score[r] <- score2
#       swac$Opponent.Score[r] <- score1
#     }
#   }
# }
