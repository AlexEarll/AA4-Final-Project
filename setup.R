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


base.url <- "http://pokeapi.co/api/v2/"

pokemon <- "butterfree"

pokemon.url <- paste(base.url,"pokemon/", pokemon, "/", sep = "")

response <- GET(pokemon.url)

print(names(response))

body <- content(response, "text")

poke.data <- fromJSON(body)

print(names(poke.data))

print(is.data.frame(poke.data))

print(is.data.frame(poke.data$moves))

poke.moves <- head(poke.data$moves)
View(poke.moves)

poke.moves <- flatten(poke.moves)

print(colnames(poke.moves))

poke.moves <- select(poke.moves, move.name)

poke.moves <- arrange(poke.moves, -move.rank)




###part 1###
#create shiny interface for selecting pokemon

###part 2### 
#Create backend (sever) for math calculations and such to feed into the UI

###part 3###
#Create battle sequence 

###part 4### 
#Create output and summary of the battle