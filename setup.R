library(shiny)
library(ggplot2)
library(dplyr)
library(httr)
library(jsonlite)
<<<<<<< HEAD

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
x
poke.moves <- select(poke.moves, move.name)

poke.moves <- arrange(poke.moves, -move.rank)

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
   
   colnames(moves) <- c("Id", "Name", "Power", "Accuracy", "Crit Rate", "Damage Class", "Type")
   return(moves)
}

LoadAllImages <- funtion() {
   poke.nums <- c(1:151)
   if(file.exists("data/151.png")){ 
      for(p in poke.nums) {
         image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", p, ".png"))
         
         download.file(image.urls, destfile = paste0("img/", p, ".png"), mode = "wb")
      }
   }
}


