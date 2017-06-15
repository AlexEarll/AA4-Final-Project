<<<<<<< HEAD
library("shinythemes")

library("shinythemes")

# Defines a UI using a fluidPage() layout   
ui <- navbarPage(h2("Pokemon Stats Explorer!"), theme = shinytheme("united"),
                 # Creates a tabPanel for the Home Page
=======

library("shinythemes")

# Defines a UI using a fluidPage() layout   
<<<<<<< HEAD
# Defines a UI using a fluidPage() layout   
ui <- navbarPage(h2("Pokemon Stats Explorer!"), theme = shinytheme("united"),
                 # Ad titled tab panel with descriptive text
>>>>>>> master
=======
ui <- navbarPage(h2("Pokemon Stats Explorer!"), theme = shinytheme("united"),
                 # Ad titled tab panel with descriptive text
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                 tabPanel(h3("Home"),
                          h1(strong("Exploring Data Interactions Through Pokemon")),
                          h3("Created by Alex Earll, Soobin Kwon, Kirsten Anders, and Sam Otto"),
                          h4("INFO 201: AA"),
                          br(),
<<<<<<< HEAD
<<<<<<< HEAD
                          # A column stating our Mission Statement
=======
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                          fluidRow(column(7,
                                          h3(strong("Mission Statement:")),
                                          h4("Pokemon is a worldwide video game staple. It is a game that many people have enjoyed - ranging from children to adults. 
                                             The popular 'Pokemon Go' app that was released in the summer of 2016 showed us how the interactivity and positivity of 
                                             the Pokemon franchise could be used to physically engage people in their surroundings."),
                                          h4("Similarly, we seek to engage people, and especially younger people, in learning about statistics through their favorite game.
                                             This app is meant to showcase how statistics and coding are used to determine outcomes in everyone's favorite games, while also introducing people to interactive visualizations.
                                             Hopefully, getting younger people excited to play and expand their knowledge will also influencing them to use these lessons into their careers.")
                                          ),
<<<<<<< HEAD
<<<<<<< HEAD
                                   # A column discussing the Data Set
=======
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                                   column(5, wellPanel(
                                     h3(strong("Data Set")),
                                     h4("The data used in this interactive platform comes entirely from the Pokemon.API. This is the largest API
                                        source for accurate Pokemon statistics on the web. The original data and framework for this API was produced by Paul Hallett. Eventually it became too expansive for one person, and Zane Adickes became 
                                        involved in its maintenance and growth. Now it is maintained largely by an organization of Github contributors."),
                                     helpText(a("Click Here to View the Pokemon API", href="https://pokeapi.co", target = "_blank")
                                     )
                                     )
                                   )
                                          ),
<<<<<<< HEAD
<<<<<<< HEAD
                          # A column that discusses our app
=======
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                          fluidRow(column(12,
                                          h3(strong("Our App:")),
                                          h4("This app contains expansive information regarding Pokemon statistics and moves. As such, this app could also be used by more advanced Pokemon Trainers to test battles or moves before they happen in-game. By exploring our aggregated Pokemon data
                                             serious players could use this app as a resource for making themselves a more thoughtful and statistics based video game player."),
                                          h4("The primary feature of this app is the interactive Pokemon battle simulation. You can choose a Pokemon to use, customize it's stats by hand
                                             (if you'd rather not use the Pokemon's own base stats), and have it fight an opponent of your choice. You get to choose every move used!"),
                                          h4("In case you don't now every Pokemon by heart, there is a Pokemon reference guide, where you can see pictures and full stats of the Pokemon.
                                             Lastly, we have graphed visualizations for your personalized exploration of the Pokemon API.")))
                                          ),
<<<<<<< HEAD
<<<<<<< HEAD
                 # A tabPanel for the Pokemon Images
=======
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                 tabPanel(h3("Pokemon Reference"),
                          DT::dataTableOutput("image.table")
                          
                 ),
<<<<<<< HEAD
<<<<<<< HEAD
                 # A tabPanel that allows users to manipulate the pokemon battle stats for both Pokemon 
=======
                 # Creates a tab panel for attack, hp, defense, and level inputs
>>>>>>> master
=======
                 # Creates a tab panel for attack, hp, defense, and level inputs
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                 tabPanel(h3("Battle"),
                          titlePanel("Pokemon Battle Stats"),
                          fluidRow(
                            column(6, wellPanel(
                              h3("Pokemon One"),
                              uiOutput("first.poke"),
                              h3("Base Stats"),
                              splitLayout(
                                uiOutput("level.one"),
                                uiOutput("hp.one")),
                              splitLayout(
                                uiOutput("attack.one"),
                                uiOutput("defense.one"))
                            )),
                            column(6, wellPanel(
                              h3("Pokemon Two"),
                              uiOutput("second.poke"),
                              h3("Base Stats"),
                              splitLayout(
                                uiOutput("level.two"),
                                uiOutput("hp.two")),
                              splitLayout(
                                uiOutput("attack.two"),
                                uiOutput("defense.two"))
                            )),
<<<<<<< HEAD
<<<<<<< HEAD
                            # Pokemon1's move choice
                            column(5, wellPanel(uiOutput("move.choice.one"))
                            ),
                            # Pokemon2's move choice
                            column(5, wellPanel(uiOutput("move.choice.two"))
                            ),
                            # Runs the simulation
                            column(2, wellPanel(actionButton("move.button", "Run This Round!", class = "btn-primary"))
                            ),
                            # Creates tabs for the Battle Table and Calculations
                            column(12, tabsetPanel(type = "tabs", 
                                                   # tabPanel that shows the Battle Table
=======
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                            # Creats input for moves to use
                            column(5, wellPanel(uiOutput("move.choice.one"))
                            ),
                            column(5, wellPanel(uiOutput("move.choice.two"))
                            ),
                            column(2, wellPanel(actionButton("move.button", "Run This Round!", class = "btn-primary"))
                            ),
                            column(12, tabsetPanel(type = "tabs", 
<<<<<<< HEAD
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                                                   tabPanel(strong("Battle Table"),
                                                            br(),
                                                            h4("Below is the output for each round that is ran by the user. Pokemon have their damage increased when attacking Pokemon of a type that is weak to their attacks. When a Pokemon reaches zero health or less they will faint. Then it's time to pick new Pokemon to duel!"), 
                                                            br(),
                                                            splitLayout(
                                                              verbatimTextOutput("battle.1.text"),
<<<<<<< HEAD
<<<<<<< HEAD
                                                              verbatimTextOutput("battle.2.text"))), 
                                                   # tabPanel showing the calculations
                                                   tabPanel(strong("Calculations"),
                                                            fluidPage(
                                                              title = 'Stat Equations Used',
                                                              withMathJax(),
                                                              uiOutput('ex3')
                                                            )
                                                   )
=======
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                                                              verbatimTextOutput("battle.2.text")))
                                                   
                                                   
                                                   
<<<<<<< HEAD
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                            )
                            )
                          )
                 ),
<<<<<<< HEAD
<<<<<<< HEAD
                 # A TabPanel discussing Damage Type Multipliers
                 tabPanel(h3("Damage Type Multipliers"),
                          h2(strong("Damage Type Multipliers")),
                          h4("This table shows which pokemon are effective/resistive to each type. To use the table,
                             find the type you want know the effects on and then go down the column to find the multipliers
                             applied by attacks of the type to the left."),
                          br()
                          ),
                 # Presents a tabPanel for users to interact with a graph
=======
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                 # Creats graph with pokemon data
                 tabPanel(h3(strong("Variable Pokemon Graph")),
                          sidebarPanel(
                            
                            
                            selectInput('xcol', 'X Variable', c("attack", "defense", "hp", "special_attack", "special_defense", "speed")),
                            selectInput('ycol', 'Y Variable', c("attack", "defense", "hp", "special_attack", "special_defense", "speed"),
                                        selected="Defense")
                          ),
                          mainPanel(
                            plotOutput('plot1')
                          )
                          
                          
                 ),
                 # creates tab panel with interactive graph
<<<<<<< HEAD
>>>>>>> master
=======
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
                 tabPanel(h3("Interactive Graph"),
                          pageWithSidebar(
                            headerPanel('Explore Pokemon Data through Graphing!'),
                            sidebarPanel(
                              uiOutput("x.choice"),
                              uiOutput("y.choice"),
                              uiOutput("color.choice")
                            ),
                            mainPanel(
                              plotOutput("poke.plot.1", dblclick = "plot1_dblclick", brush = brushOpts(id = "plot1_brush", resetOnNew = TRUE))
                            )
                          ))
                 
<<<<<<< HEAD
<<<<<<< HEAD
                 )
=======
                          )
>>>>>>> master
=======
                          )
>>>>>>> 8c674cba664b3065aae79720d5115953a2efa5f2
