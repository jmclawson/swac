tidy_poetry_texts <- function(
    folder = "data",
    name = ".txt",
    word = TRUE
) {

  tidy_one_text <- function(file, directory) {
    tibble(document = file |> str_remove_all("[.].*"),
           text = readLines(paste0(directory, "/", file))) |>
      mutate(stanza_num = cumsum(text == "") + 1) |>
      filter(text != "") |>
      mutate(line_num = row_number()) |>
      relocate(stanza_num, line_num,
               .after = document)
  }

  the_files <- list.files(path = paste0(folder, "/"), pattern = name)

  full_poetry <- do.call(rbind, lapply(the_files, tidy_one_text, directory=folder))

  if (word) {
    full_poetry <- full_poetry |>
      unnest_tokens(word, text)
  }

  full_poetry
}

swac_almamaters <-
  tidy_poetry_texts("data-raw/sourcefiles/almamaters",
                    word = FALSE) |>
  rename(university = document) |>
  group_by(university, stanza_num) |>
  summarize(text = paste0(text, collapse = "\n")) |>
  summarize(text = paste0(text, collapse = "\n\n"))

usethis::use_data(swac_almamaters, overwrite = TRUE)
