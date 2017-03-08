# Loads the appropriate libraries needed
library("shiny")
library("dplyr")
library("ggplot2")

pokemon.data <- read.csv("data/Pokemon-2.csv", stringsAsFactors=FALSE) %>% 
  select(pokemon, id, type_1, attack, defense, hp, special_attack, special_defense)

server <- function(input, output, clientData, session) {
  filtered.one <- reactive({
    if(input$action.button.one) {
      pokemon.data <- pokemon.data %>% 
        filter(pokemon == input$first.poke) %>% 
        select(pokemon, id, attack, defense, hp)
      pokemon.data["pokemon"] <- input$first.poke
      pokemon.data["id"] <- pokemon.data$id
      pokemon.data["hp"] <- pokemon.data$hp - input$hp.one
      pokemon.data["defense"] <- pokemon.data$defense - input$defense.one
      pokemon.data["attack"] <- pokemon.data$attack - input$attack.one
      return(pokemon.data)
    }
  })
  
  filtered.two <- reactive({
    if(input$action.button.two) {
      pokemon.data <- pokemon.data %>% 
        filter(pokemon == input$second.poke) %>% 
        select(pokemon, id, attack, defense, hp)
      pokemon.data["pokemon"] <- input$second.poke
      pokemon.data["id"] <- pokemon.data$id
      pokemon.data["hp"] <- pokemon.data$hp - input$hp.two
      pokemon.data["defense"] <- pokemon.data$defense - input$defense.two
      pokemon.data["attack"] <- pokemon.data$attack - input$attack.two
      return(pokemon.data)
    }
  })
  
  
  # Outputs the value of the first pokemon chosen 
  # Then outputs interactive stat options for pokemon one
  output$first.poke <- renderUI({
    selectInput("first.poke", 
                "First Pokemon:",
                choices = c(Choose = "", pokemon.data$pokemon),
                selected = NULL)
  })
  
  output$hp.one <- renderUI({
    numericInput("hp.one", 
                 "Pokemon HP:",
                 min = 0, max = 20, value = 0, step = 0.5)
  })
  
  output$attack.one <- renderUI({
    numericInput("attack.one", 
                 "Pokemon Attack:",
                 min = 1, max = 20, value = 0, step = 0.5)
  })
  
  output$defense.one <- renderUI({
    numericInput("defense.one", 
                 "Pokemon Defense:",
                 min = 1, max = 20, value = 0, step = 0.5)
  })
  
  output$type.one <- renderUI({
    selectInput("type.one",
                label = "Pokemon Type:",
                choices = c(Type = "", "VARIABLE TYPES"),
                selected = "")
  })
  
  # Outputs the value of the second pokemon chosen 
  # Then outputs interactive stat options for pokemon two
  output$second.poke <- renderUI({
    selectInput("second.poke", 
                "Second Pokemon:", 
                choices = c(Choose = "", pokemon.data$pokemon),
                selected = NULL)
  })
  
  
  output$hp.two <- renderUI({
    numericInput("hp.two", 
                 "Pokemon HP:",
                 min = 1, max = 20, value = 0, step = 0.5)
  })
  
  output$attack.two <- renderUI({
    numericInput("attack.two", 
                 "Pokemon Attack:",
                 min = 1, max = 20, value = 0, step = 0.5)
  })
  
  output$defense.two <- renderUI({
    numericInput("defense.two", 
                 "Pokemon Defense:",
                 min = 1, max = 20, value = 0, step = 0.5)
  })
  
  output$type.two <- renderUI({
    selectInput("type.two",
                label = "Pokemon Type:",
                choices = c(Type = "", "VARIABLE TYPES"),
                selected = "")
  })
  
  # Takes in the input of each pokemon, and updates the stat labels to match for both pokemon chose
  observe({
    poke.one <- input$first.poke
    poke.two <- input$second.poke
    
    # Change both the label and the text of Pokemon ONE stat labels
    updateTextInput(session, "hp.one",
                    label = paste(poke.one, "HP:")
    )
    
    updateTextInput(session, "attack.one",
                    label = paste(poke.one, "Attack:")
    )
    
    updateTextInput(session, "defense.one",
                    label = paste(poke.one, "Defense:")
    )
    
    updateTextInput(session, "type.one",
                    label = paste(poke.one, "Type:")
    )
    
    
    # Change both the label and the text of Pokemon TWO stat labels
    updateTextInput(session, "hp.two",
                    label = paste(poke.two, "HP:")
    )
    
    updateTextInput(session, "attack.two",
                    label = paste(poke.two, "Attack:")
    )
    
    updateTextInput(session, "defense.two",
                    label = paste(poke.two, "Defense:")
    )
    
    updateTextInput(session, "type.two",
                    label = paste(poke.two, "Type:")
    )
    
    output$one.table <- renderTable({
      filtered.one()
    })
    
    output$two.table <- renderTable({
      filtered.two()
    })
  })
  
  
  
}
