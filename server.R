# Loads the appropriate libraries needed
library("shiny")
library("dplyr")
library("DT")

# Reads and saves the dataset
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
    colnames(first.gen) <- c("id", "pokemon", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
    if(length(colnames(first.gen)) == 11) {
      first.gen <- first.gen %>% select(-id)
    }
  }
  
  colnames(first.gen) <- c("id", "name", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
  return(first.gen)
}

pokemon.data <- LoadPokemon()

server <- function(input, output, clientData, session) {
  # Creates a reactive variable
  filtered.one <- reactive({
    # Checks if the action button for the first pokemon box was clicked
    if(input$action.button.one) {
    # Gathers the first pokemon statistics
      pokemon.data <- pokemon.data %>%
        filter(name == input$first.poke) %>% 
        select(name, id, attack, defense, hp)
      pokemon.data["name"] <- input$first.poke
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
        filter(name == input$second.poke) %>% 
        select(name, id, attack, defense, hp)
      pokemon.data["name"] <- input$second.poke
      pokemon.data["id"] <- pokemon.data$id
      pokemon.data["hp"] <- pokemon.data$hp - input$hp.two
      pokemon.data["defense"] <- pokemon.data$defense
      pokemon.data["attack"] <- pokemon.data$attack - input$attack.two
      return(pokemon.data)
    }
  })
  
  
  output$images <- renderUI({
      img(src = paste0("img/", select(), ".png"), width = 200, height = 200)
  })
  
  select <- reactive({
    pokemon.data <- pokemon.data[pokemon.data$name == input$first.poke, "id"]
    pokemon.data <- as.integer(pokemon.data)
    return(pokemon.data)
  })
  
  #output$names <- renderUI({
  #  selectInput("names",
  #              label = NULL,
  #              choices = c(pokemon.data$name))
  #})
  
  image.vector <- function() {
    empty.vector <- c()
    for(i in pokemon.data$id) {
      link <- paste0("img/", i, ".png")
      empty.vector <- append(empty.vector, paste0('<img src=', link,'></img>'))
    }
    return(empty.vector)
  }
  
  images <- data.frame(
    name = pokemon.data$name,
    images = image.vector()
  )
  
  output$image.table <- DT::renderDataTable({
    DT::datatable(images, escape = FALSE)
  })
  
  
  
  
  

  LoadAllImages <- function() {
    poke.nums <- c(1:151)
    if(!file.exists("data/151.png")){ 
      for(p in poke.nums) {
        image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", p, ".png"))
        
        download.file(image.urls, destfile = paste0("img/", p, ".png"), mode = "wb")
      }
    }
  }
  
  
  

  
  
  
  # Outputs the value of the first pokemon chosen 
  # Then outputs interactive stat options for pokemon one
  output$first.poke <- renderUI({
    selectInput("first.poke",
                label = NULL,
                choices = c(Choose = "", pokemon.data$name),
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
                choices = pokemon.data[pokemon.data$name == input$first.poke, "type_1"],
                selected = "")
  })
  
  # Outputs the value of the second pokemon chosen 
  # Then outputs interactive stat options for pokemon two
  output$second.poke <- renderUI({
    selectInput("second.poke",
                label = NULL,
                choices = c(Choose = "", pokemon.data$name),
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
                choices = pokemon.data[pokemon.data$name == input$second.poke, "type_1"],
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
