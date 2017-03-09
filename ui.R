
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
                 tabPanel("Pokemon Reference"),
                  tabPanel("Mission")
)

