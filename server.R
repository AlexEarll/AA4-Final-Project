# Loads the appropriate libraries needed
library("shiny")
library("dplyr")

# Reads and saves the dataset
pokemon.data <- read.csv("data/Pokemon-2.csv", stringsAsFactors=FALSE)
  #select(pokemon, id, type_1, attack, defense, hp, special_attack, special_defense)




server <- function(input, output, clientData, session) {
  # Creates a reactive variable
  filtered.one <- reactive({
    # Checks if the action button for the first pokemon box was clicked
    # Gathers the first pokemon statistics
    if(input$action.button.one) {
      pokemon.data <- pokemon.data %>%
        filter(pokemon == input$first.poke) %>% 
        select(pokemon, id, attack, defense, hp)
      pokemon.data["pokemon"] <- input$first.poke
      pokemon.data["id"] <- pokemon.data$id
      pokemon.data["hp"] <- pokemon.data$hp - input$hp.one
      pokemon.data["defense"] <- pokemon.data$defense
      pokemon.data["attack"] <- pokemon.data$attack - input$attack.one
      return(pokemon.data)
    }
  })
  
  # Creates a reactive variable
  filtered.two <- reactive({
    # Checks if the action button in the second pokemon box was chosen
    if(input$action.button.two) {
      # Checks if the action button for the second pokemon box was clicked
      # Gathers the first pokemon statistics
      pokemon.data <- pokemon.data %>% 
        filter(pokemon == input$second.poke) %>% 
        select(pokemon, id, attack, defense, hp)
      pokemon.data["pokemon"] <- input$second.poke
      pokemon.data["id"] <- pokemon.data$id
      pokemon.data["hp"] <- pokemon.data$hp - input$hp.two
      pokemon.data["defense"] <- pokemon.data$defense
      pokemon.data["attack"] <- pokemon.data$attack - input$attack.two
      return(pokemon.data)
    }
  })
  
  # Outputs the value of the first pokemon chosen 
  # Then outputs interactive stat options for pokemon one
  output$first.poke <- renderUI({
    selectInput("first.poke",
                label = NULL,
                choices = c(Choose = "", pokemon.data$pokemon),
                selected = NULL)
  })
  
  output$level.one <- renderUI({
    numericInput("level.one",
                 "Pokemon Level:",
                 min = 1, max = 100, value = 1, step = 1)
  })
  
  output$hp.one <- renderUI({
    numericInput("hp.one", 
                 "Pokemon HP:",
                 min = 1,
                 max = 714,
                 value = 0, 
                 step = 0.5)
  })
    
  output$attack.one <- renderUI({
    numericInput("attack.one", 
                 "Pokemon Attack:",
                 min = 1, max = 504, value = 0, step = 0.5)
  })
    
  output$defense.one <- renderUI({
    numericInput("defense.one", 
                 "Pokemon Defense:",
                 min = 1, max = 614, value = 0, step = 0.5)
  })
  
  output$type.one <- renderUI({
    selectInput("type.one",
                label = "Pokemon Type:",
                choices = pokemon.data[pokemon.data$pokemon == input$first.poke, "type_1"],
                selected = "")
  })
  
  # Outputs the value of the second pokemon chosen 
  # Then outputs interactive stat options for pokemon two
  output$second.poke <- renderUI({
    selectInput("second.poke",
                label = NULL,
                choices = c(Choose = "", pokemon.data$pokemon),
                selected = NULL)
  })
    
  output$level.two <- renderUI({
    numericInput("level.two",
                 "Pokemon Level:",
                 min = 1, max = 100, value = 1, step = 1)
  })
    
  output$hp.two <- renderUI({
    numericInput("hp.two", 
                 "Pokemon HP:",
                 min = 1, max = 714, value = 0, step = 0.5)
  })
  
  output$attack.two <- renderUI({
    numericInput("attack.two", 
                 "Pokemon Attack:",
                 min = 1, max = 504, value = 0, step = 0.5)
  })
  
  output$defense.two <- renderUI({
    numericInput("defense.two", 
                 "Pokemon Defense:",
                 min = 1, max = 614, value = 0, step = 0.5)
  })
    
  output$type.two <- renderUI({
    selectInput("type.two",
                label = "Pokemon Type:",
                choices = pokemon.data[pokemon.data$pokemon == input$second.poke, "type_1"],
                selected = "")
  })
  
  # Assigns a reactive renderTable() function to produce a table displaying the statistics of the pokemon chosen
  output$one.table <- renderTable(bordered = TRUE, {
    filtered.one()
  })
  
  output$two.table <- renderTable(bordered = TRUE, {
    filtered.two()
  })
  
  output$table.sent <- renderText({
    "The first pokemon that gets a negative value loses."
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
  })
  }

  