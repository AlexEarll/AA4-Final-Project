library("colourpicker")

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
                                uiOutput("hp.one"),
                                uiOutput("attack.one")),
                              splitLayout(
                                uiOutput("defense.one"),
                                uiOutput("type.one")
                              ), 
                              actionButton("action.button.one", "Begin!")
                            )),
                            column(6, wellPanel(
                              h3("Pokemon Two"),
                              uiOutput("second.poke"),
                              h3("Base Stats"),
                              splitLayout(
                                uiOutput("hp.two"),
                                uiOutput("attack.two")),
                              splitLayout(
                                uiOutput("defense.two"),
                                uiOutput("type.two")),
                              actionButton("action.button.two", "Begin!")
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
                 )
)