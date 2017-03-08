# Loads the appropriate library needed
library(shiny)

# Defines a UI using a fluidPage() layout   
ui <- navbarPage("Pokemon Stats Explorer!",
                 tabPanel("Plot",
                          titlePanel("Battling Pokemon"),
                          fluidRow(
                            column(6, wellPanel(
                              h3("Choose Pokemon"),
                              uiOutput("first.poke"),
                              uiOutput("hp.one"),
                              uiOutput("attack.one"),
                              uiOutput("defense.one"),
                              uiOutput("type.one"),
                              actionButton("action.button.one", "Go!")
                            )),
                            column(6, wellPanel(
                              h3("Choose Pokemon"),
                              uiOutput("second.poke"),
                              uiOutput("hp.two"),
                              uiOutput("attack.two"),
                              uiOutput("defense.two"),
                              uiOutput("type.two"),
                              actionButton("action.button.two", "Go!")
                            )),
                            column(12, tabsetPanel(type = "tabs", 
                                                   tabPanel(strong("Battle")), 
                                                   tabPanel(strong("Table"),
                                                            tableOutput("one.table"),
                                                            tableOutput("two.table")), 
                                                   tabPanel(strong("Calculations")
                                                   )
                            )
                            )
                          )
                 ),
                 tabPanel("Pokemon Reference"),
                 tabPanel("Our Mission")
)
