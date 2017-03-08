library("colourpicker")

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
                 )
)
                            
                            
                            
                            