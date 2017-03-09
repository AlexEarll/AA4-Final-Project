# Loads the appropriate libraries needed
library("shiny")
library("dplyr")
library("ggplot2")
library("httr")
library("jsonlite")
library("DT")
library("Cairo")



move.id <- 1

###Setup###
base.url <- "http://pokeapi.co/api/v2/"


# Reads and saves the dataset

#_____________________________________________________________________________________________________________________________________________________


server <- function(input, output, clientData, session) {
   themes <- shinytheme("darkly")
   
   #run the logic behind the pokemon fighitng
   BattleLoop <- function() {
      
      #run to check which pokemon goes first using speed
      if(poke.values$poke.1.stats[1,10] > poke.values$poke.2.stats[1,10]) {
         
         temp.hp <- Poke.Attack(poke.values$poke.1.name, poke.values$poke.1.stats[1,5], poke.values$poke.1.level,
                                attack.num = match(poke.values$poke.1.current.move, poke.values$poke.1.moves[,2]),
                                poke.values$poke.1.moves, poke.values$poke.2.stats[1,6],poke.values$poke.2.stats[1,7], 
                                poke.values$poke.2.stats[1,3], poke.values$poke.2.stats[1,4], LoadDamageTable())
         
         damage.dealt <- poke.values$poke.2.stats[1,7] - temp.hp
         poke.values$poke.1.battle <-  c(poke.values$poke.turn, poke.values$poke.1.name, poke.values$poke.2.stats[1,7], 
                                         damage.dealt, temp.hp, poke.values$poke.1.current.move)
         poke.values$poke.2.stats[1,7] <- temp.hp
         
         
         temp.hp <- Poke.Attack(poke.values$poke.2.name, poke.values$poke.2.stats[1,5], poke.values$poke.2.level, 
                                attack.num = match(poke.values$poke.2.current.move, poke.values$poke.2.moves[,2]),
                                poke.values$poke.2.moves, poke.values$poke.1.stats[1,6], poke.values$poke.1.stats[1,7],
                                poke.values$poke.1.stats[1,3], poke.values$poke.1.stats[1,4], LoadDamageTable())
         
         damage.dealt <- poke.values$poke.1.stats[1,7] - temp.hp
         poke.values$poke.2.battle <-  c(poke.values$poke.turn, poke.values$poke.2.name, poke.values$poke.1.stats[1,7], damage.dealt, temp.hp, poke.values$poke.2.current.move)
         poke.values$poke.1.stats[1,7] <- temp.hp
         
      }
      
      #check to see if pokemon are alive and hangle accoringly
      if(poke.values$poke.1.stats[1,10] <= poke.values$poke.2.stats[1,10]){
         
         temp.hp <- Poke.Attack(poke.values$poke.2.name, poke.values$poke.2.stats[1,5], poke.values$poke.2.level, 
                                attack.num = match(poke.values$poke.2.current.move, poke.values$poke.2.moves[,2]),
                                poke.values$poke.2.moves, poke.values$poke.1.stats[1,6], poke.values$poke.1.stats[1,7],
                                poke.values$poke.1.stats[1,3], poke.values$poke.1.stats[1,4], LoadDamageTable())
         
         damage.dealt <- poke.values$poke.1.stats[1,7] - temp.hp
         poke.values$poke.2.battle <-  c(poke.values$poke.turn, poke.values$poke.2.name, poke.values$poke.1.stats[1,7], damage.dealt, temp.hp, poke.values$poke.2.current.move)
         poke.values$poke.1.stats[1,7] <- temp.hp
         temp.hp <- Poke.Attack(poke.values$poke.1.name, poke.values$poke.1.stats[1,5], poke.values$poke.1.level, 
                                attack.num = match(poke.values$poke.1.current.move, poke.values$poke.1.moves[,2]),
                                poke.values$poke.1.moves, poke.values$poke.2.stats[1,6], poke.values$poke.2.stats[1,7], 
                                poke.values$poke.2.stats[1,3], poke.values$poke.2.stats[1,4], LoadDamageTable())
         
         damage.dealt <- poke.values$poke.2.stats[1,7] - temp.hp
         poke.values$poke.1.battle <-  c(poke.values$poke.turn, poke.values$poke.1.name, poke.values$poke.2.stats[1,7], damage.dealt, temp.hp, poke.values$poke.1.current.move)
         poke.values$poke.2.stats[1,7] <- temp.hp       
      }
   }
   
   # creates data frame of pokemon variables, runs the attack sequence and calculates damage
   Poke.Attack <- function(poke.1.name, poke.1.attack, poke.1.level, attack.num, poke.1.moves, poke.2.defense, poke.2.hp, poke.2.type.1, poke.2.type.2, damage.table) {
      if(sample(1:100,1) > poke.1.moves[attack.num, 4]) {
         return(0)
      }
      crit <- 1
      
      if(sample(1:100, 1) > poke.1.moves[attack.num, 5]) {
         crit <- 2
      }
      
      a <- (((2 * poke.1.level) / 5)) * (poke.1.attack/poke.2.defense) * poke.1.moves[attack.num, 3]
      View(poke.1.moves)
      row <- filter_(damage.table, ~poke.1.moves[attack.num, 7] == rownames(damage.table))
      y <- match(poke.2.type.1, colnames(damage.table))
      # print(paste("x is", x))
      type.1.mult <- row[1, y]
      type.2.mult <- 1
      
      if(exists("poke.2.type.2") && !is.na(poke.2.type.2)) {
         row.2 <- filter_(damage.table, ~poke.1.moves[attack.num, 7] == rownames(damage.table))
         y.2 <- match(poke.2.type.2, colnames(damage.table))
         
         type.2.mult <- row[1, y.2]
      }
      
      # select_(poke.2.type.2)d
      # print(paste("poke 1 name:", poke.1.name, "poke 1 attack:", var))
      c <- type.1.mult * type.2.mult * crit
      
      damage <- round(((a/50) + 2 * c) * (sample(85:100, 1) / 100), 0)
      
      return(poke.2.hp - damage)
   }
   
   
   # Get data for all the pokemon in gen 1
   LoadPokemon <- function() {
      if(!file.exists("data/Pokemon.csv")) {
         
         first.gen <- data.frame()
         nums <- c(1:151)
         
         for(x in nums) {
            pokemon.url = paste0(base.url, "pokemon/", x)
            
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
   
   # Creates data table that loads in damage
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
            pokemon.url = paste0(base.url, "type/", n)
            
            response <- GET(pokemon.url)
            body <- content(response, "text", encoding = "UTF-8")
            
            type.data <- fromJSON(body, flatten = TRUE)
            
            if(is.data.frame(type.data$damage_relations$half_damage_from)) {
               
               type.name <- type.data$damage_relations$half_damage_from$name
               
               damage.table[match(type.name, type.names), n] <- .5
            }
            if(is.data.frame(type.data$damage_relations$no_damage_from)) {
               
               type.name <- type.data$damage_relations$no_damage_from$name
               
               damage.table[match(type.name, type.names), n] <- 0
            }
            if(is.data.frame(type.data$damage_relations$double_damage_from)) {
               
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
   
   # requests all the moves for a given pokemon
   getMoves <- function(get.name) {
      print("trying to get url")
      pokemon.url <- paste(base.url,"pokemon/", get.name, "/", sep = "")
      print(pokemon.url)
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
      nums <- sample(nums, 17)
      
      for (index in nums) {
         
         url <- toString(poke.moves[index, 2])
         print(url)
         
         response <- GET(url)
         
         body <- content(response, "text", encoding = "UTF-8")
         temp.data <- fromJSON(body, flatten = TRUE)
         
         does.damage <- temp.data$meta$category$name
         is.gen.1 <- temp.data$generation$name
         
         if((does.damage == "damage" || does.damage == "damage+ailment" || does.damage == "damage+heal" || does.damage == "damage+lower") 
            && is.gen.1 == "generation-i" && is.numeric(temp.data$power) && is.numeric(temp.data$accuracy)) { 
            row.index <- row.index + 1 
            moves[row.index, 1] <- temp.data$id 
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
   
   # loads the images
   # NOTE: THE SERVER FOR GITHUB POKEMON API STOPPED WORKING BEFORE CLASS. WE SLIGHTLY ADJUSTED CODE TO ACCOUNT FOR THIS
   LoadAllImages <- function() {
      poke.nums <- c(1:151)
      var <- file.exists("www/img/151.png")
      print(var)
      if(!var){ 
         for(p in poke.nums) {
            image.urls <- c(paste0("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/", p, ".png"))
            
            download.file(image.urls, destfile = paste0("www/img/", p, ".png"), mode = "wb")
         }
      }
   }
   LoadAllImages()
#_________________________________________________________________________________________________________________
   
   # Creates reactive variables
   poke.values <- reactiveValues(pokemon.data = LoadPokemon(),
                                 damage.table = LoadDamageTable(),
                                 poke.1.name = "bulbasaur",
                                 poke.2.name = "charmander",
                                 poke.1.level = 1,
                                 poke.2.level = 1,
                                 poke.1.stats = LoadPokemon(),
                                 poke.2.stats = LoadPokemon(),
                                 poke.1.moves = "",
                                 poke.2.moves = "",
                                 poke.1.current.move = "",
                                 poke.2.current.move = "",
                                 poke.1.battle = "",
                                 poke.2.battle = "",
                                 battle.table.1 = data.frame(),
                                 battle.table.2 = data.frame(),
                                 poke.turn = 0)
   
   # Names observable events to execute
   observeEvent(input$level.one, {
      poke.values$poke.1.level <- input$level.one
   })
   
   observeEvent(input$level.two, {
      poke.values$poke.2.level <- input$level.two
   })
   
   observeEvent(input$first.poke, {
      poke.values$poke.1.name <- input$first.poke
   })
   
   observeEvent(input$second.poke, {
      poke.values$poke.2.name <- input$second.poke
   })
   
   observeEvent(input$first.poke, {
      poke.values$poke.1.stats <- poke.values$pokemon.data %>% filter(name == poke.values$poke.1.name)
   })
   
   observeEvent(input$second.poke, {
      poke.values$poke.2.stats <- poke.values$pokemon.data %>% filter(name == poke.values$poke.2.name)
   })
   
   observeEvent(input$first.poke, {
      if((poke.values$poke.1.name) != "") {
         poke.values$poke.1.moves <- head(getMoves(poke.values$poke.1.name), 4)
      }
   })
   
   observeEvent(input$second.poke, {
      if((poke.values$poke.2.name) != "") {
         poke.values$poke.2.moves <- head(getMoves(poke.values$poke.2.name), 4)
      }
   })
   
   observeEvent(input$move.button, {
      poke.values$poke.1.current.move <- input$move.choice.one
      poke.values$poke.2.current.move <- input$move.choice.two
      print(poke.values$poke.1.current.move)
      print(poke.values$poke.2.current.move)
      print("calling battle loop")
      BattleLoop()
      
     
   })
   
#___________________________________________________________________________________________________________________  
   
   # outputs objects from the UI
   output$x.choice <- renderUI({
      selectInput("x.choice",
                  label = "X Axis Variable Choice",
                  choices = c("attack", "defense", "hp", `special_attack` = "special_attack", `special_defense` = "special_defense", "speed"),
                  selected = "attack")
   })
   
   output$y.choice <- renderUI({
      selectInput("y.choice",
                  label = "Y Axis Variable Choice",
                  choices = c("defense", "attack", "hp", `special_attack` = "special_attack", `special_defense` = "special_defense", "speed"),
                  selected = "defense")
   })
   
   output$color.choice <- renderUI({
      selectInput("color.choice",
                  label = "Color Variable Choice",
                  choices = c(`name` = "name", `type_1` = "type_1", `type_2` = "type_2"),
                  selected = "name")
   })
   
   
   # Sets a ranges variable to x/y null to allow for user interfacing with graph
   ranges <- reactiveValues(x = NULL, y = NULL)
   
   selected.poke.data <- reactive({
      selected.poke.data <- select(LoadPokemon(), contains(input$x.choice), contains(input$y.choice), contains(input$color.choice))
      return(selected.poke.data)
   })
   
   # Creates the plot to be called in the UI. Sets titles/axiis, along with x/y/color fill values
   output$poke.plot.1 <- renderPlot({
      
      plot.pokemon.data <- ggplot(data = selected.poke.data(), 
                               mapping = aes(x = selected.poke.data()[,1], 
                                             y = selected.poke.data()[,2], 
                                             color = selected.poke.data()[,3])) +
         scale_colour_continuous(guide = FALSE) +
         geom_point() +
         xlab(input$x.choice) +
         ylab(input$y.choice) +
         labs(title = paste(input$x.choice, "vs.", input$y.choice)) +
         coord_cartesian(xlim = ranges$x, ylim = ranges$y)
      
      return(plot.pokemon.data)
   })
   
   
   # When a double-click happens, check if there's a brush on the plot.
   # If so, zoom to the brush bounds; if not, reset the zoom.
   observeEvent(input$plot1_dblclick, {
      
      brush <- input$plot1_brush
      
      if (!is.null(brush)) {
         ranges$x <- c(brush$xmin, brush$xmax)
         ranges$y <- c(brush$ymin, brush$ymax)
         
      } else {
         ranges$x <- NULL
         ranges$y <- NULL
      }
   })
   
   # Creates the data tables from the UI
   output$battle.table.1 <- renderTable({
      (poke.values$battle.table.1)
   }) 
   
   output$battle.table.2 <- renderTable({
      (poke.values$battle.table.2)
   })
   
   output$battle.1.text <- renderText({
      if (poke.values$poke.1.name != "") {
      if(poke.values$poke.1.stats[1,7] <= 0) {
         print("que")
         paste(poke.values$poke.2.name, "wins! Choose another set of pokemon to try more battles.")
      }
      else {
         paste(poke.values$poke.1.name, "did", poke.values$poke.1.battle[4], "damage to", 
               poke.values$poke.2.name, "with the attack", poke.values$poke.1.battle[6])
      }
      }
   })
   
   # Outputs the battle results
   output$battle.2.text <- renderText({
      if (poke.values$poke.2.name != "") {
      if(poke.values$poke.2.stats[1,7] <= 0) {
         print("que")
         paste(poke.values$poke.1.name, "wins! Choose another set of pokemon to try more battles.")
      }
      else {
         paste(poke.values$poke.2.name, "did", poke.values$poke.2.battle[4], "damage to", 
               poke.values$poke.1.name, "with the attack", poke.values$poke.2.battle[6])
      }
      }   
   })
#___________________________________________________________________________________________________________________   
   
   # Outputs the value of the first pokemon chosen 
   # Then outputs interactive stat options for pokemon one
   output$first.poke <- renderUI({
      selectInput("first.poke",
                  label = NULL,
                  choices = c(Choose = "", poke.values$pokemon.data[ ,2]),
                  selected = NULL)
   })
   
   output$level.one <- renderUI({
      numericInput("level.one",
                   "Pokemon Level:",
                   min = -1, 
                   max = 100, 
                   value = poke.values$poke.1.level)
   })
   
   output$hp.one <- renderUI({
      numericInput("hp.one", 
                   "Pokemon HP:",
                   min = -1,
                   max = 714,
                   value = poke.values$poke.1.stats[1,7] + (poke.values$poke.1.level * 2.5),
                   step = 1)
   })
   
   output$attack.one <- renderUI({
      numericInput("attack.one", 
                   "Pokemon Attack:",
                   min = 0, 
                   max = 504, 
                   value = poke.values$poke.1.stats[1,5], 
                   step = 1)
   })
   
   output$defense.one <- renderUI({
      numericInput("defense.one", 
                   "Pokemon Defense:",
                   min = 0, 
                   max = 614, 
                   value = poke.values$poke.1.stats[1,6],
                   step = 1)
   })
   
   
   # Outputs the value of the second pokemon chosen 
   # Then outputs interactive stat options for pokemon two
   output$second.poke <- renderUI({
      selectInput("second.poke",
                  label = NULL,
                  choices = c(Choose = "", poke.values$pokemon.data[,2]),
                  selected = NULL)
   })
   
   output$level.two <- renderUI({
      numericInput("level.two",
                   "Pokemon Level:",
                   min = -1, 
                   max = 100,
                   value = poke.values$poke.2.level, 
                   step = 1)
   })
   
   output$hp.two <- renderUI({
      numericInput("hp.two", 
                   "Pokemon HP:",
                   min = -1, 
                   max = 714, 
                   value = poke.values$poke.2.stats[1,7] + (poke.values$poke.2.level * 2.5), 
                   step = 1)
   })
   
   output$attack.two <- renderUI({
      numericInput("attack.two", 
                   "Pokemon Attack:",
                   min = 0, 
                   max = 504, 
                   value = poke.values$poke.2.stats[1,5],
                   step = 1)
   })
   
   output$defense.two <- renderUI({
      numericInput("defense.two", 
                   "Pokemon Defense:",
                   min = 0, 
                   max = 614, 
                   value = poke.values$poke.2.stats[1,6],
                   step = 1)
   })
   
   output$ex3 <- renderUI({
      withMathJax(
         helpText('The busy Cauchy distribution
                  $$Damage:= (\frac{(\frac{(2\times Level)}{5}+2)\times Power \times A/D}{50}+2)\times Modifier$$'))
   })
   


#______________________________________________________________________________________________________________________________   
   
   # gives option to observe pokemon
   observeEvent(input$first.poke, {
   output$move.choice.one <- renderUI({
      if (poke.values$poke.1.name != "") {
      selectInput("move.choice.one", 
                  "Choose move for Pokemon 1:",
                  choices = poke.values$poke.1.moves[,2],
                  selected = NULL)}
   })
   })
   
   observeEvent(input$second.poke, {
   output$move.choice.two <- renderUI({
      if (poke.values$poke.2.name != "") {
      selectInput("move.choice.two", 
                  "Choose move for Pokemon 2:",
                  choices = poke.values$poke.2.moves[,2],
                  selected = NULL)}
   })
   })
   
#_____________________________________________________________________________________________________________________________   
   
   # creates reactive variables
   pokemon <- reactive({
      poke.values$pokemon.data %>%
      group_by(type_1) %>% 
      select(id, name, attack, defense, hp, special_attack, special_defense, speed, type_1)
   })
   
   selectedData <- reactive({
      pokemon()[, c(input$xcol, input$ycol)]
   })
   
   output$plot1 <- renderPlot({
      color <- c("#984EA3", "#E41A1C",
                 "#FF7F00",  "#377EB8", "#A65628", "#999999", "#FFFF33", "#4DAF4A", "#F781BF")
      
      plot(selectedData(), pch = 20, col = color, factor = factor(c("Poison", "Fire", "Flying", "Water", "Bug", "Normal", "Electric", "Ground", "Fairy")))
      legend("topright", legend = c("Poison", "Fire", "Flying", "Water", "Bug", "Normal", "Electric", "Ground", "Fairy"), fill = color, col = factor(pokemon.data$type_1))
   })
   
  

#__________________________________________________________________________________________________________________________________   
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
      
      
      level.1.observe <- poke.values$poke.1.level
      level.2.observe <- poke.values$poke.2.level
      
      stat.1.observe <- poke.values$poke.1.stats
      stat.2.observe <- poke.values$poke.2.stats
      
      updateNumericInput(session, "hp.one", value = (stat.1.observe[1,7] + level.1.observe * 2.5))
      

      updateNumericInput(session, "hp.two", value = (stat.2.observe[1,7] + level.2.observe * 2.5))
      
      RenamePokemonData <- function() {
         return.data <- LoadPokemon() 
         colnames(return.data) <- c("id", "name", "type_1", "type_2", "attack", "defense", "hp", "special_attack", "special_defense", "speed")
         return(return.data)
      }
      
      image.vector <- function() {
         poke.data <- RenamePokemonData()
         empty.vector <- c()
         for(i in poke.data$id) {
            link <- paste0("img/", i, ".png")
            empty.vector <- append(empty.vector, paste0('<img src=', link,'></img>'))
         }
         
         return(empty.vector)
      }
      
      images <- data.frame(
         name = RenamePokemonData(),
         images = image.vector()
      )
      
      output$image.table <- DT::renderDataTable({
         DT::datatable(images, colnames = c("ID", "Name", "Type 1", "Type 2", "Attack", "Defense", "HP", "Special Attack", "Special Defense", "Speed", "Image"), escape = FALSE, rownames = FALSE)
      })
      
   })
}

