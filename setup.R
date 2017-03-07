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


###Setup###
base.url <- "http://pokeapi.co/api/v2/"

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

View(first.gen)

View(damage.table)


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

View(damage.table)

LoadImages <- function(name1, name2) {
  image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", name1, ".png"))
  
  download.file(image.urls, destfile = paste0("img/", name1, ".png"), mode = "wb")
  
  image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", name2, ".png"))
  
  download.file(image.urls, destfile = paste0("img/", name2, ".png"), mode = "wb")
}

###part 1###
#create shiny interface for selecting pokemon

###part 2### 
#Create backend (sever) for math calculations and such to feed into the UI

###part 3###
#Create battle sequence 

###part 4### 
#Create output and summary of the battle