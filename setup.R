library(shiny)
library(ggplot2)
library(dplyr)
library(httr)
library(jsonlite)

# Getting stats
# Start: http://pokeapi.co/api/v2/pokemon/?count=150&limit=150
# go into pokemon url
# Get stats from JSON   
# hp, defence, attack, speed, type, color one for block colors
# Get moves and then query the moves api
# Check for key words or make super if statement tree
# Check power accuracy and type
# 'is damaging' and crit rate is in meta js

# Backend
# need something resembling an enum for damage types
# probably a damage type table represented by a table in excel
# Damage multipliers 
# http://bulbapedia.bulbagarden.net/wiki/Type/Type_chart
# turn based loop
# print into a csv which we read out of after for data processing

move.id <- 1

###Setup###
base.url <- "http://pokeapi.co/api/v2/"

LoadPokemon()
LoadDamageTable()

pokemon.name <- "pikachu"

getMoves(pokemon.name)

LoadPokemon <- function() {
  # Get data for all the pokemon in gen 1
  if(!file.exists("data/Pokemon.csv")) {
    
    first.gen <- data.frame()
    nums <- c(1:151)
    
    for(x in nums) {
      pokemon.url = paste0(base.url, "pokemon/", x)
      print(pokemon.url)
      
      response <- GET(pokemon.url)
      body <- content(response, "text", encoding = "UTF-8")
      
      temp.data <- fromJSON(body, flatten = TRUE)
      
      first.gen[x, 1] <- x
      first.gen[x, 2] <- temp.data$name
      first.gen[x, 3] <- temp.data$types$type.name[1]
      first.gen[x, 4] <- temp.data$types$type.name[2]
      first.gen[x, 5] <- temp.data$stats$base_stat[5]
      first.gen[x, 6] <- temp.data$stats$base_stat[4]
      first.gen[x, 7] <- temp.data$stats$base_stat[6]
      first.gen[x, 8] <- temp.data$stats$base_stat[2]
      first.gen[x, 9] <- temp.data$stats$base_stat[3]
      first.gen[x, 10] <- temp.data$stats$base_stat[1]
    }
    write.csv(first.gen, file = "data/Pokemon.csv")
  } else {
    first.gen <- read.csv("data/Pokemon.csv")
  }
  
  colnames(first.gen) <- c("id", "name", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
  
}

LoadDamageTable <- function() {
  
  if(!file.exists("data/damage_table.csv")) {
    
    nums <- c(1:18)
    
    type.names <- c("normal", "fighting", "flying", "poison", "ground", "rock", "bug", 
                    "ghost", "steel", "fire", "water", "grass", "electric", "psychic", 
                    "ice", "dragon", "dark", "fairy")
    
    damage.table <- data.frame()
    
    for(i in nums) {
      for(j in nums) {
        damage.table[i,j] <- 1
      }
    }
    
    for(n in nums) {
      print(paste("on", n, "type"))
      pokemon.url = paste0(base.url, "type/", n)
      print(pokemon.url)
      
      response <- GET(pokemon.url)
      body <- content(response, "text", encoding = "UTF-8")
      
      type.data <- fromJSON(body, flatten = TRUE)
      
      print("checking multipliers")
      if(is.data.frame(type.data$damage_relations$half_damage_from)) {
        print("chceking half multiplyers")
        type.name <- type.data$damage_relations$half_damage_from$name
        
        damage.table[match(type.name, type.names), n] <- .5
      }
      if(is.data.frame(type.data$damage_relations$no_damage_from)) {
        print("chceking zero multiplyers")
        type.name <- type.data$damage_relations$no_damage_from$name
        
        damage.table[match(type.name, type.names), n] <- 0
      }
      if(is.data.frame(type.data$damage_relations$double_damage_from)) {
        print("chceking half multiplyers")
        type.name <- type.data$damage_relations$double_damage_from$name
        
        damage.table[match(type.name, type.names), n] <- 2
      }
    }
    colnames(damage.table) <- type.names
    rownames(damage.table) <- type.names
    write.csv(damage.table, file = "data/damage_table.csv")
  } else {
    damage.table <- read.csv("data/damage_table.csv")
  }
}

LoadImages <- function(name1, name2) {
  image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", name1, ".png"))
  
  download.file(image.urls, destfile = paste0("img/", name1, ".png"), mode = "wb")
  
  image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", name2, ".png"))
  
  download.file(image.urls, destfile = paste0("img/", name2, ".png"), mode = "wb")
}

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
      moves[row.index, 1] <- temp.data$id
      print(temp.data$id)
      moves[row.index, 2] <- temp.data$name
      moves[row.index, 3] <- temp.data$power
      print("adding value 4")
      print("adding value 5")
      print("adding value 6")
      print("adding value 7")
      print("adding value 8")
    }
    
    print((move.data))
    
    print(is.data.frame(move.data))
    
  }
  
  colnames(moves) <- c("Id", "Name", "Power", "Accuracy", "Crit Rate", "Damage Class", "Type")
  return(moves)
}
