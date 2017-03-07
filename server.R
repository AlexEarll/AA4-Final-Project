# Loads the appropriate libraries needed
library("shiny")
library("dplyr")
library("ggplot2")

pokemon.data <- read.csv("data/Pokemon.csv", stringsAsFactors=FALSE) %>% 
  select(pokemon, species_id, base_experience, type_1, type_2, attack, defense, hp, special_attack, special_defense, ability_1, ability_2, ability_hidden, url_image, generation_id) %>% 
  filter(generation_id == 1)

server <- function(input, output, session) {
  output$first.poke <- renderUI({
    selectInput("first.poke", 
                "First Pokeman:",
                choices = pokemon.data$pokemon,
                selected = NULL)
  })
  
  output$second.poke <- renderUI({
    selectInput("second.poke", 
                "Second Pokeman:",
                choices = pokemon.data$pokemon,
                selected = NULL)
  })
  
  output$first.poke.stats <- renderText({
    paste(paste0(input$first.poke, "'s"), "Statistics:",
          "Species Id: \n",
          "Type: \n",
          "Abilities:", sep = "\n")
  })
  
  output$second.poke.stats <- renderText({
    paste(paste0(input$second.poke, "'s"), "Statistics:",
          "Species Id: \n",
          "Type: \n",
          "Abilities:", sep = "\n")
  })
  
  output$table <- renderTable({
    
  })
  
  
  
}
