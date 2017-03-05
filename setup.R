library(shiny)
library(ggplot2)
library(dplyr)

###Setup###
pokemon.file <- read.csv("Pokemon.csv", stringsAsFactors=FALSE)

pokemon.data <- pokemon.file %>% 
  select(pokemon, species_id, base_experience, type_1, type_2, attack, defense, hp, special_attack, special_defense, ability_1, ability_2, ability_hidden, url_image, generation_id) %>% 
  filter(generation_id == 1)

###part 1###
#create shiny interface for selecting pokemon

###part 2### 
#Create backend (sever) for math calculations and such to feed into the UI

###part 3###
#Create battle sequence 

###part 4### 
#Create output and summary of the battle