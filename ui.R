
# Defines a UI using a fluidPage() layout   
# Defines a UI using a fluidPage() layout   
ui <- navbarPage("Pokemon Stats Explorer!",
                 tabPanel("Battle",
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
                            column(5, wellPanel(uiOutput("move.choice.one"))
                            ),
                            column(5, wellPanel(uiOutput("move.choice.two"))
                            ),
                            column(2, wellPanel(actionButton("move.button", "GO!", class = "btn-primary"))
                            ),
                            column(12, tabsetPanel(type = "tabs", 
                                                   tabPanel(strong("Battle Table"),
                                                            verbatimTextOutput("table.sent"), 
                                                            tableOutput("one.table"),
                                                            tableOutput("two.table")), 
                                                   tabPanel(strong("Calculations")
                                                   )
                            )
                            )
                          )
                 ),
                 tabPanel("Pokemon Reference",
                          DT::dataTableOutput("image.table")
                          
                          #uiOutput("images"),
                          #uiOutput("names")
                 ),
                 tabPanel("Mission Statement",
                          h3("Mission Statement"),
                          p("Pokemon has been a much beloved role playing game since 1996. Players train and battle with powerful creatures called Pokemon.
                            People of all ages enjoy Pokemon around the world.
                            In 2016, Nintendo released Pokemon GO, a mobile app Pokemon game that got people up and moving outdoors.
                            The use of video games to promote a greater social cause inspired us to create this app.
                            We were able to achieve this using the Pokemon API: http://pokeapi.co/api/v2/ ."),
                          br(),
                          p("Like most games, Pokemon is driven by coding and statistics. Our hope was to spark an early interest in statistics and coding by showing people how theye make their favorite games work behind the scenes.
                            This app allows users to question how the math works and how powerful the pokemon they chose are in order to win, which in return can expose them to statistics and data visualization.
                            Because all users usually see is the finished game, we hope that by seeing the math and statistics used to determine a Pokemon battle, users will be more excited about statistics and code.
                            The uuniversality of Pokemon GO shows that Pokemon truly connects to users of all ages making it a great platform to spread this message."),
                          br(),
                          p("This app is very easy to follow and understand, so anyone can play.
                            We have worked towards keeping this game to its truest form by using the Pokemon API and making sure the calculations, and first generation pokemon moves, attacks, etc. are just like the real games.")
                          )
                          )

