#install.packages("DT")

library("DT")

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
                                uiOutput("defense.one")), 
                              uiOutput("type.one"),
                              actionButton("action.button.one", "Change Stats", class = "btn-primary")
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
                                uiOutput("defense.two")),
                              uiOutput("type.two"),
                              actionButton("action.button.two", "Change Stats", class = "btn-primary")
                            )),
                            column(12, tabsetPanel(type = "tabs", 
                                                   tabPanel(strong("Battle")), 
                                                   tabPanel(strong("Table"),
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
                 
                 tabPanel("Mission Statements",
                          h3("Mission Statement"),
                          p("Pokemon is a viral game that has been played for many years by a large audience.
                            It is a game that many people have enjoyed - ranging from children to adults. 
                            The popular 'Popular Go' app that was released in the summer of 2016 shows how interactive and positive video games can be."),
                          br(),
                          p("We want to engage people especially the younger generation to statistics by giving them a chance to apply math and learn more about probability through their favorite game.
                            This app allows users to question how the math works and how powerful the pokemon they chose are in order to win, which in return can expose them to statistics and data visualization.
                            Users may begin to understand how important statistics and coding really is by noticing how it is the backend to creating video games.
                            Hopefully, getting them excited to play and expand their knowledge, while also influencing them to use these lessons into their careers."),
                          br(),
                          p("This app is very easy to follow and understand, so anyone can play.
                            We have worked towards keeping this game to its truest form by using the Pokemon API and making sure the calculations, and first generation pokemon moves, attacks, etc. are just like the real games.")
                 )
)
