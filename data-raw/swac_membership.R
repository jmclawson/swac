
swac_membership <- {"1920 - Bishop College - Bishop College - founded -  founding of SWAC, effective beginning the 1920–21 academic year
1920 - Paul Quinn College - Paul Quinn College - founded - founding of SWAC, effective beginning the 1920–21 academic year
1920 - Prairie View State Normal & Industrial College - Prairie View A&M University - founded - founding of SWAC, effective beginning the 1920–21 academic year
1920 - Samuel Huston College - Huston–Tillotson University - founded - founding of SWAC, effective beginning the 1920–21 academic year
1920 - Texas College - Texas College - founded - founding of SWAC, effective beginning the 1920–21 academic year
1920 - Wiley College - Wiley College - founded - founding of SWAC, effective beginning the 1920–21 academic year
1929 - Paul Quinn College - Paul Quinn College - left - effective after the 1928–29 academic year
1932 - Oklahoma Colored Agricultural and Normal University - Langston University - joined - effective in the 1932–33 academic year
1935 - Southern University - Southern University - joined - effective in the 1935–36 academic year
1936 - Arkansas Agricultural, Mechanical & Normal College - University of Arkansas at Pine Bluff - joined - effective in the 1936–37 academic year
1954 - Huston–Tillotson University - Huston–Tillotson University - left - effective after the 1953–54 academic year
1954 - Texas Southern University - Texas Southern University - joined - effective in the 1954–55 academic year
1956 - Bishop College - Bishop College - left - effective after the 1955–56 academic year
1957 - Langston University - Langston University - left - effective after the 1956–57 academic year
1958 - Grambling College - Grambling State University - joined - effective in the 1958–59 academic year
1958 - Jackson College for Negro Teachers - Jackson State University - joined - effective in the 1958–59 academic year
1962 - Texas College - Texas College - left - effective after the 1961–62 academic year
1962 - Alcorn Agricultural and Mechanical College - Alcorn State University - joined - effective in the 1962–63 academic year
1968 - Wiley College - Wiley College - left - effective after the 1967–68 academic year
1968 - Mississippi Valley State College - Mississippi Valley State University - joined - effective in the 1968–69 academic year
1970 - University of Arkansas at Pine Bluff - University of Arkansas at Pine Bluff - left - effective after the 1969–70 academic year
1982 - Alabama State University - Alabama State University - joined - effective in the 1982–83 academic year
1997 - University of Arkansas at Pine Bluff - University of Arkansas at Pine Bluff - joined - effective in the 1997–98 academic year
1999 - Alabama Agricultural and Mechanical University - Alabama Agricultural and Mechanical University - joined - effective in the 1999–2000 academic year
2021 - Bethune–Cookman University - Bethune–Cookman University - joined - effective in the 2021–22 academic year
2021 - Florida Agricultural and Mechanical University - Florida Agricultural and Mechanical University - joined - effective in the 2021–22 academic year"} |>
  strsplit("\n") |>
  data.frame() |>
  setNames("columns") |>
  separate(columns,
           c("year",
             "historic_name", "current_name" ,
             "action", "note"),
           sep = " - ") |>
  mutate(action = factor(action),
         year = as.integer(year))

swac_membership <- as_tibble(swac_membership)

usethis::use_data(swac_membership, overwrite = TRUE)
