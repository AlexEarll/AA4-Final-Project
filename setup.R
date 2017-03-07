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

first.gen <- data.frame(nrow=151)

nums <- c(1:151)

if(!file.exists("data/Pokemon.csv")) {
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
}

View(first.gen)

print(temp.data)

print(names(poke.data))

print(is.data.frame(poke.data))

print(is.data.frame(poke.data$moves))

poke.moves <- head(poke.data$moves)
View(poke.moves)

poke.moves <- flatten(poke.moves)

print(colnames(poke.moves))

poke.moves <- select(poke.moves, move.name)

poke.moves <- arrange(poke.moves, -move.rank)

View(poke.moves)

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