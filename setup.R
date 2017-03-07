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

pokemon <- "charmander"

pokemon.url <- paste(base.url,"pokemon/", pokemon, "/", sep = "")

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

for (index in nums) {

  print(nums)  
  
  url <- toString(poke.moves[index, 2])
  
  print(url)
  
  response <- GET(url)
  
  print(names(response))
  
  body <- content(response, "text")
  
  temp.data <- fromJSON(body, flatten = TRUE)
  
  moves[index, 1] <- temp.data$id
  moves[index, 2] <- temp.data$meta$category$name
  moves[index, 3] <- temp.data$power
  moves[index, 4] <- temp.data$accuracy
  moves[index, 5] <- temp.data$meta$crit_rate
  moves[index, 6] <- temp.data$damage_class
  moves[index, 7] <- temp.data$type
  moves[index, 7] <- temp.data$meta$
  
  print((move.data))
  
  print(is.data.frame(move.data))
  
}




poke.moves <- select(poke.moves, move.name)

poke.moves <- arrange(poke.moves, -move.rank)
