# Loads the necessary libraries
library("httr")
library("jsonlite")
library("knitr")
library("dplyr")

base.uri <- "http://pokeapi.co/"
generation.1 <- "api/v2/generation/1"
generation.2 <- "api/v2/generation/2"

uri.generation.1 <- paste0(base.uri, generation.1)
response.generation.1 <- GET(uri.generation.1)
body.1 <- fromJSON(content(response.generation.1, "text", encoding = "UTF-8"))
pokemon1 <- flatten(body.1$pokemon_species)

uri.generation.2 <- paste0(base.uri, generation.2)
response.generation.2 <- GET(uri.generation.2)
body.2 <- fromJSON(content(response.generation.2, "text", encoding = "UTF-8"))
pokemon2 <- flatten(body.2$pokemon_species)

pokemon1.vector <- as.vector(unlist(pokemon1$name))
pokemon2.vector <- as.vector(unlist(pokemon2$name))

pokemon.names.vect <- c(pokemon1.vector, pokemon2.vector)
pokemon.names.df <- as.data.frame(pokemon.names)


images.links.vect <- vector()
for (name in pokemon.names.vect) {
  images <- "api/v2/ability/"
  uri.info <- paste0(base.uri, images, name)
  print(uri.info)
  #response <- GET(uri.info)
  #body <- fromJSON(content(response, "text", encoding = "UTF-8"))
  
}
images.links.df <- as.data.frame(images.links.vect)

