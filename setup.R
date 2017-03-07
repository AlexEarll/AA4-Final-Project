library(shiny)
library(ggplot2)
library(dplyr)
library(httr)
library(jsonlite)

###Setup###
pokemon.file <- read.csv("data/Pokemon.csv", stringsAsFactors=FALSE)

pokemon.data <- pokemon.file %>% 
  select(pokemon, species_id, base_experience, type_1, type_2, attack, defense, hp, special_attack, special_defense, ability_1, ability_2, ability_hidden, url_image, generation_id) %>% 
  filter(generation_id == 1)
View(pokemon.data)

move.id <- 1

base.url <- "http://pokeapi.co/api/v2/"

pokemon.name <- "pikachu"

getMoves(pokemon.name)


getMoves <- function(get.name) {
  pokemon.url <- paste(base.url,"pokemon/", get.name, "/", sep = "")
  response <- GET(pokemon.url)
  print(names(response))
  body <- content(response, "text")
  poke.data <- fromJSON(body)
  print(names(poke.data))
  print(is.data.frame(poke.data))
  print(is.data.frame(poke.data$moves))
  poke.moves <- head(poke.data$moves)
  poke.moves <- flatten(poke.moves)
  View(poke.moves)
  print(colnames(poke.moves))
  num.rows <- nrow(poke.moves)
  nums <- c(1:num.rows)
  moves <- data.frame()

  
  row.index <- 0
  
  for (index in nums) {
    print(nums)  
    url <- toString(poke.moves[index, 2])
    print(url)
    response <- GET(url)
    print(names(response))
    body <- content(response, "text")
    temp.data <- fromJSON(body, flatten = TRUE)
    does.damage <- temp.data$meta$category$name
    if(does.damage == "damage" || does.damage == "damage+ailment") {
      row.index <- row.index + 1
      print("adding value 1")
      moves[row.index, 1] <- temp.data$id
      print(temp.data$id)
      print("adding value 2")
      moves[row.index, 2] <- temp.data$name
      print("adding value 3")
      moves[row.index, 3] <- temp.data$power
      print(temp.data$power)
      print("adding value 4")
      moves[row.index, 4] <- temp.data$accuracy
      print("adding value 5")
      moves[row.index, 5] <- temp.data$meta$crit_rate
      print("adding value 6")
      moves[row.index, 6] <- temp.data$damage_class$name
      print("adding value 7")
      moves[row.index, 7] <- temp.data$type$name
      print("adding value 8")
    }
    
    print((move.data))
    
    print(is.data.frame(move.data))
    
  }
  
  colnames(moves) <- c("Id", "Name", "Power", "Accuracy", "Crit Rate", "Damage Class", "Type")
  return(moves)
}

View(moves)

poke.moves <- select(poke.moves, move.name)

poke.moves <- arrange(poke.moves, -move.rank)
