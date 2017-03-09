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

first.gen <- LoadPokemon()
damage.table <- LoadDamageTable()

View(first.gen)
poke.1.name <- "charizard"
poke.1.moves <- head(getMoves(poke.1.name), 4)
poke.1.stats <- filter(first.gen, name == poke.1.name)
poke.1.level <- 100
poke.1.hp <- poke.1.stats[1, 7] * (poke.1.level * 2.5)
poke.1.attack <- poke.1.stats[1, 5]
poke.1.defense <- poke.1.stats[1, 6]
poke.1.speed <- poke.1.stats[1, 10]
poke.1.type.1 <- as.character(poke.1.stats[1, 3])
poke.1.type.2 <- as.character(poke.1.stats[1, 4])
View(poke.1.stats)

poke.2.name <- "mew"
poke.2.moves <- head(getMoves(poke.2.name), 4)
poke.2.stats <- filter(first.gen, name == poke.2.name)
poke.2.level <- 25
poke.2.hp <- poke.2.stats[1, 7] * (poke.2.level * 2.5)
poke.2.attack <- poke.2.stats[1, 5]
poke.2.defense <- poke.2.stats[1,6]
poke.2.speed <- poke.2.stats[1, 10]
poke.2.type.1 <- as.character(poke.2.stats[1, 3])
poke.2.type.2 <- as.character(poke.1.stats[1, 4])

while(poke.2.hp > 0 && poke.1.hp > 0) {
   if(poke.1.speed > poke.2.speed) {
      poke.2.hp <- Poke.Attack(poke.1.name, poke.1.attack, poke.1.level, attack.num = 1, poke.1.moves, poke.2.defense, poke.2.hp, poke.2.type.1, poke.2.type.2, damage.table)
      poke.1.hp <- Poke.Attack(poke.2.name, poke.2.attack, poke.2.level, attack.num = 1, poke.2.moves, poke.1.defense, poke.1.hp, poke.1.type.1, poke.1.type.2, damage.table)
   } else {
      poke.1.hp <- Poke.Attack(poke.2.name, poke.1.attack, poke.1.level, attack.num = 1, poke.1.moves, poke.2.defense, poke.2.hp, poke.2.type.1, poke.2.type.2, damage.table)
      poke.2.hp <- Poke.Attack(poke.1.name, poke.2.level, attack.num = 1, poke.2.moves, poke.1.defense, poke.1.hp, poke.1.type.1, poke.1.type.2, damage.table)
   }
}


Poke.Attack <- function(poke.1.name, poke.1.attack, poke.1.level, attack.num, poke.1.moves, poke.2.defense, poke.2.hp, poke.2.type.1, poke.2.type.2, damage.table) {
   if(sample(1:100,1) > poke.1.moves[attack.num, 4]) {
      return(0)
   }
   crit <- 1
   if(sample(1:100, 1) > poke.1.moves[attack.num, 5]) {
      crit <- 2
   }
   
   a <- (((2 * poke.1.level) / 5)) * (poke.1.attack/poke.1.defense) * poke.1.moves[attack.num, 3]
   
   print("working on first multiplyer")
   
   # type adjustments & crit
   type.1.mult <- damage.table %>% filter_(~poke.2.type.1 == rownames(damage.table)) %>% 
      select_(poke.2.type.1)
   
   type.1.mult <- type.1.mult[1, 1]
   
   type.2.mult <- 1
   
   if(exists("poke.2.type.2")) {
      type.2.mult <- filter_(damage.table, ~poke.2.type.2 == rownames(damage.table)) %>% 
         select_(poke.2.type.2)
      type.2.mult <- type.2.mult[1, 1]
   }
   
   c <- type.1.mult * type.2.mult * crit
   
   damage <- round(((a/50) + 2 * c) * (sample(85:100, 1) / 100), 0)
   
   
   print(paste(poke.1.name, "did", damage, "with", poke.1.moves[attack.num, 2]))
   return(poke.2.hp - damage)
}

# Get data for all the pokemon in gen 1
LoadPokemon <- function() {
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
      first.gen <- read.csv("data/Pokemon.csv", stringsAsFactors = FALSE)
      colnames(first.gen) <- c("id", "name", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
      if(length(colnames(first.gen)) == 11) {
         first.gen <- first.gen %>% select(-id)
      }
   }
   
   colnames(first.gen) <- c("id", "name", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
   return(first.gen)
}

LoadDamageTable <- function() {
   
   type.names <- c("normal", "fighting", "flying", "poison", "ground", "rock", "bug", 
                   "ghost", "steel", "fire", "water", "grass", "electric", "psychic", 
                   "ice", "dragon", "dark", "fairy")
   
   if(!file.exists("data/damage_table.csv")) {
      
      nums <- c(1:18)
      
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
      damage.table <- read.csv("data/damage_table.csv", stringsAsFactors = FALSE)
      damage.table <- damage.table %>% select(-X)
      row.names(damage.table) <- type.names
   }
   return(damage.table)
}

getMoves <- function(get.name) {
   pokemon.url <- paste(base.url,"pokemon/", get.name, "/", sep = "")
   response <- GET(pokemon.url)
   
   body <- content(response, "text")
   poke.data <- fromJSON(body)
   
   poke.moves <- (poke.data$moves)
   poke.moves <- flatten(poke.moves)
   
   num.rows <- nrow(poke.moves)
   if(num.rows > 167) {
      num.rows <- 167
   }
   
   nums <- c(1:num.rows)
   moves <- data.frame()
   
   row.index <- 0
   nums <- sample(nums, 10)
   
   for (index in nums) {
      url <- toString(poke.moves[index, 2])
      
      response <- GET(url)
      
      body <- content(response, "text")
      temp.data <- fromJSON(body, flatten = TRUE)
      
      does.damage <- temp.data$meta$category$name
      
      if(does.damage == "damage" || does.damage == "damage+ailment") { 
         row.index <- row.index + 1 
         moves[row.index, 1] <- temp.data$id 
         print(temp.data$id) 
         moves[row.index, 2] <- temp.data$name 
         moves[row.index, 3] <- temp.data$power 
         moves[row.index, 4] <- temp.data$accuracy 
         moves[row.index, 5] <- temp.data$meta$crit_rate 
         moves[row.index, 6] <- temp.data$damage_class$name 
         moves[row.index, 7] <- temp.data$type$name 
      } 
      
   }
   
 
   }
}
