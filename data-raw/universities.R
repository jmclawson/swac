formerly <- tribble(
  ~institution,    ~former_city, ~former_name,
  "Bishop",           "Marshall", "Bishop College (1881–1961)",
  "Paul Quinn",         "Austin", "Connectional School for the Education of Negro Youth (1872–1877)",
  "Paul Quinn",           "Waco",   "Waco College (1877–1881)",
  "Prairie View", "Prairie View", "Alta Vista Agricultural and Mechanical College of Texas for Colored Youth (1876–1879)",
  "Prairie View", "Prairie View", "Prairie View State Normal School (1879–1899)",
  "Prairie View", "Prairie View", "Prairie View State Normal & Industrial College (1899–1945)",
  "Prairie View", "Prairie View", "Prairie View University (1945–1947)",
  "Prairie View", "Prairie View", "Prairie View A&M College of Texas (1947–1973)",
  "Huston-Tillotson",   "Austin", "Tillotson Collegiate and Normal Institute (1875–1952)",
  "Huston-Tillotson",   "Austin", "Samuel Huston College (1876–1952)",
  "Huston-Tillotson",   "Austin", "Huston–Tillotson College (1952–2005)",
  "Texas College",       "Tyler", "Texas College (1894–1909)",
  "Texas College",       "Tyler", "Phillips University (1909–1912)",
  "Wiley",            "Marshall", "Wiley University (1873–1929)",
  "Langston",         "Langston", "Oklahoma Colored Agricultural and Normal University (1897–1941)",
  "Southern",      "New Orleans", "Southern University for Colored Students (1880–1890)",
  "Arkansas-Pine Bluff", "Pine Bluff", "Branch Normal College (1875–1927)",
  "Arkansas-Pine Bluff", "Pine Bluff", "Arkansas Agricultural, Mechanical and Normal College (1927–1972)",
  "Texas Southern",    "Houston", "Houston Colored Junior College (1927–1934)",
  "Texas Southern",    "Houston", "Houston College for Negroes (1934–1947)",
  "Texas Southern",    "Houston", "Texas State University for Negroes (1947–1951)",
  "Grambling State", "Grambling", "Colored Industrial and Agricultural School (1901–1905)",
  "Grambling State", "Grambling", "North Louisiana Agricultural and Industrial School (1905–1928)",
  "Grambling State", "Grambling", "Louisiana Negro Normal and Industrial Institute (1928–1946)",
  "Grambling State", "Grambling", "Grambling College (1946–1974)",
  "Jackson State",     "Natchez", "Natchez Seminary (1877–1883)",
  "Jackson State",     "Jackson", "Jackson College (1883–1940)",
  "Jackson State",     "Jackson", "Mississippi Negro Training School (1940–1944)",
  "Jackson State",     "Jackson", "Jackson College for Negro Teachers (1944–1967)",
  "Jackson State",     "Jackson", "Jackson State College (1967–1974)",
  "Alcorn State",       "Lorman", "Alcorn University (1871–1878)",
  "Alcorn State",       "Lorman", "Alcorn Agricultural and Mechanical College (1878–1974)",
  "Mississippi Valley State", "Itta Bena", "Mississippi Vocational College (1950–1964)",
  "Mississippi Valley State", "Itta Bena", "Mississippi Valley State College (1964–1974)",
  "Alabama State",      "Marion", "Lincoln Normal School of Marion (1867–1887)",
  "Alabama State",  "Montgomery", "Normal School for Colored Students (1887–1929)",
  "Alabama State",  "Montgomery", "State Teachers College (1929–1948)",
  "Alabama State",  "Montgomery", "Alabama State College for Negroes (1948–1954)",
  "Alabama State",  "Montgomery", "Alabama State College (1954–1969)",
  "Alabama A&M",    "Huntsville", "Huntsville State Normal School for Negroes (1875–1885)",
  "Alabama A&M",    "Huntsville", "State Normal and Industrial School of Huntsville (1885–1896)",
  "Alabama A&M",    "Huntsville", "The State Agricultural and Mechanical College for Negroes (1896–1919)",
  "Alabama A&M",    "Huntsville", "State Agricultural and Mechanical Institute for Negroes (1919–1948)",
  "Alabama A&M",    "Huntsville", "Alabama Agricultural and Mechanical College (1948–1969)",
  "Bethune–Cookman", "Daytona Beach", "Daytona Normal and Industrial Institute for Girls (1904–1927)",
  "Bethune–Cookman", "Daytona Beach", "Cookman Institute for Boys (1872–1927)",
  "Bethune–Cookman", "Daytona Beach", "Daytona Cookman Collegiate Institute (1927–1941)",
  "Bethune–Cookman", "Daytona Beach", "Bethune–Cookman College (1941–2007)",
  "Florida A&M",   "Tallahassee", "Florida Agricultural and Mechanical College for Negroes (1909–1953)",
  "Florida A&M",   "Tallahassee", "State Normal and Industrial College for Colored Students (1891–1909)",
  "Florida A&M",   "Tallahassee", "State Normal College for Colored Students (1887–1891)",
) |>
  separate(former_name, into = c("former_name", "dates"),
           sep = " \\(") |>
  separate(dates, into = c("from", "until"),
           sep = "–") |>
  mutate(until = str_remove_all(until, "[)]")) |>
  nest(.by = institution,
       .key = "formerly")

colors <- tribble(
  ~institution,       ~color, ~color_name,
  "Bishop",           "#94b5e2", "Bishop blue",
  "Bishop",           "#FFD700", "gold",
  "Paul Quinn",         "#45115E", "purple",
  "Paul Quinn",         "#000000", "black",
  "Paul Quinn",         "#FECE1C", "gold",
  "Prairie View",      "#330066", "purple",
  "Prairie View",      "#FFCC33", "gold",
  "Huston-Tillotson",   "#660000", "maroon",
  "Huston-Tillotson",   "#FFCC00", "gold",
  "Texas College",       "#4A1E59", "purple",
  "Texas College",       "#FFA32A", "gold",
  "Wiley",            "#5C3A8C", "purple",
  "Wiley",            "#000000", "black",
  "Wiley",            "#FFFFFF", "white",
  "Wiley",            "#B1B6C1", "gray",
  "Langston",         "#002E6D", "blue",
  "Langston",         "#FF671B", "orange",
  "Southern",          "#69B3E7", "Columbia blue",
  "Southern",          "#FFC72C", "gold",
  "Arkansas-Pine Bluff", "#000000", "black",
  "Arkansas-Pine Bluff", "#EEB310", "gold",
  "Texas Southern",    "#6F263D", "maroon",
  "Texas Southern",    "#A2AAAD", "gray",
  "Grambling State",   "#000000", "black",
  "Grambling State",   "#ECAA00", "gold",
  "Jackson State",     "#002147", "navy blue",
  "Jackson State",     "#FFFFFF", "white",
  "Alcorn State",       "#46166A", "purple",
  "Alcorn State",       "#E9A713","gold",
  "Mississippi Valley State", "#046A38", "forest green",
  "Mississippi Valley State", "#FFFFFF", "white",
  "Alabama State",  "#000000", "black",
  "Alabama State",  "#C99700", "old gold",
  "Alabama A&M",    "#660000", "maroon",
  "Alabama A&M",    "#FFFFFF", "white",
  "Bethune–Cookman", "#872046", "maroon",
  "Bethune–Cookman", "#FFB92B", "gold",
  "Florida A&M",   "#F4811F", "orange",
  "Florida A&M",   "#008344", "green"
) |> select(-color_name) |>
  nest(.by = institution,
       .key = "colors")

universities <- data.frame(
  formerly,
  full_name = unique(swac_members$current_name),
  founded = c(1881, 1872, 1876, 1875, 1894,
              1873, 1897, 1880, 1873, 1927,
              1901, 1877, 1871, 1950, 1867,
              1875, 1904, 1887),
  city = c("Dallas",
           "Dallas",
           "Prairie View",
           "Austin",
           "Tyler",
           "Marshall",
           "Langston",
           "Baton Rouge",
           "Pine Bluff",
           "Houston",
           "Grambling",
           "Jackson",
           "Lorman",
           "Itta Bena",
           "Montgomery",
           "Huntsville",
           "Daytona Beach",
           "Tallahassee"),
  state = c("TX", "TX", "TX", "TX", "TX", "TX",
            "OK", "LA", "AR", "TX", "LA", "MS",
            "MS", "MS", "AL", "AL", "FL", "FL"),
  team_name = c("Tigers", "Tigers", "Panthers",
             "Rams", "Steers", "Wildcats",
             "Lions", "Jaguars / Lady Jaguars",
             "Golden Lions / Lady Lions",
             "Tigers", "Tigers",
             "Bengal Tiger",
             "Braves / Lady Braves",
             "Devil",
             "Hornets / Lady Hornets",
             "Bulldogs / Lady Bulldogs",
             "Wildcats",
             "Rattlers / Lady Rattlers"),
  endowment = c(NA, NA, 148500000, 11500000, 3200000,
                27000000, 45000000, 9400000, NA, 59400000,
                7000000, 60000000, NA, NA, 101000000,
                48000000, 47800000, 95600000),
  enrollment = c(NA, 551, 9350, 1160, 972,
                 1100, 1873, 7091, 2670,
                 7524, 5232, 7020, 2933,
                 2406, 5475, 6001, 3773, 9179),
  website = c(NA,
              "www.pqc.edu",
              "www.pvamu.edu",
              "www.htu.edu",
              "www.texascollege.edu",
              "www.wileyc.edu",
              "www.langston.edu",
              "www.subr.edu",
              "www.uapb.edu",
              "www.tsu.edu",
              "www.gram.edu",
              "www.jsums.edu",
              "www.alcorn.edu",
              "www.mvsu.edu",
              "www.alasu.edu",
              "www.aamu.edu",
              "www.cookman.edu",
              "www.famu.edu"),
  funding = c("private", "private", "public",
              "private", "private", "private",
              "public", "public", "public",
              "public", "public", "public",
              "public", "public", "public",
              "public", "private", "public"),
  note = c("closed", NA, NA, NA, NA,
             NA, NA, NA, NA, NA,
             NA, NA, NA, NA, NA,
             NA, NA, NA)) |>
  left_join(colors) |>
  arrange(full_name) |>
  mutate(full_name = str_replace_all(full_name, "A&M",
                                     "Agricultural and Mechanical")) |>
  relocate(formerly, .after = state) |>
  relocate(colors, .after = team_name)

universities <- universities |>
  as_tibble()

# 2025 corrections and updates, from {scorecard-db} and adding DOE ids

if (!file.exists("data-raw/sourcefiles/scorecard-db/scorecard.rds")) {
  download.file("https://github.com/gadenbuie/scorecard-db/raw/refs/heads/main/data/tidy/scorecard.rds", "data-raw/sourcefiles/scorecard-db/scorecard.rds")
}

if (!file.exists("data-raw/sourcefiles/scorecard-db/school.rds")) {
  download.file("https://github.com/gadenbuie/scorecard-db/raw/refs/heads/main/data/tidy/school.rds", "data-raw/sourcefiles/scorecard-db/school.rds")
}

scorecard <- readRDS("data-raw/sourcefiles/scorecard-db/scorecard.rds")
school <- readRDS("data-raw/sourcefiles/scorecard-db/school.rds")

universities_corrected <-
  universities |>
  mutate(
    city = case_when(
      institution == "Alabama A&M" ~ "Normal",
      .default = city),
    full_name = case_when(
      institution == "Wiley" ~ "Wiley University",
      .default = full_name
    )
  )

universities_corrected$formerly[[which(universities_corrected$institution == "Alabama A&M")]] <- universities_corrected$formerly[[which(universities_corrected$institution == "Alabama A&M")]] |>
  add_row(
    former_city = "Normal",
    former_name = "State Normal and Industrial School of Huntsville",
    from = "1890",
    until = "1896") |>
  arrange(from, until) |>
  mutate(
    from = as.integer(from),
    until = as.integer(until),
    former_city = if_else(from >= 1890, "Normal", "Huntsville"),
    until = if_else(from == 1885, 1890, until)
  )

universities_corrected$formerly[[which(universities_corrected$institution == "Wiley")]] <- universities_corrected$formerly[[which(universities_corrected$institution == "Wiley")]] |>
  add_row(
    former_city = "Marshall",
    former_name = "Wiley College",
    from = "1929",
    until = "2023"
  )

universities <- universities_corrected |>
  mutate(
    website = case_when(
      institution == "Wiley" ~ str_remove_all(website, "www."),
      .default = website)) |>
  rename(
    common = institution,
    name = full_name,
    url = website,
    mascot = team_name) |>
  select(-funding) |>
  mutate(
    abbrev = url |>
      str_remove_all("^www.") |>
      str_remove_all(".edu$") |>
      {\(x) if_else(
        is.na(x), "bishop", x)}(),
    url = if_else(
      !is.na(url),
      paste0("https://", url, "/"),
      NA_character_
    )) |>
  rowwise() |>
  mutate(
    mascot = mascot |>
      strsplit(" / ") |>
      unlist() |>
      map_chr(str_squish) |>
      list()) |>
  ungroup() |>
  select(
    abbrev, swac_name = name,
    founded, formerly,
    state,
    mascot, colors, url, note) |>
  left_join(
    school |>
      filter(!is.na(url))) |>
  arrange(founded) |>
  mutate(name = if_else(is.na(name), swac_name, name)) |>
  select(-swac_name) |>
  relocate(
    id, name, abbrev, founded) |>
  relocate(
    city, state,
    .before = formerly) |>
  select(id:note)

usethis::use_data(universities, overwrite = TRUE)
