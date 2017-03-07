# Loads the appropriate library needed
library(shiny)
# install.packages("shinythemes")
library(shinythemes)

# Defines a UI using a fluidPage() layout
ui <- fluidPage(theme = shinytheme("cerulean"),
  titlePanel("Battling Pokemon"),
  fluidRow(
  
  column(4, wellPanel(
    h3("Choose Pokemon"),
    uiOutput("first.poke"),
    textOutput("first.poke.stats")
    )),
  
  column(4, wellPanel(
    h3("Choose Pokemon"),
    uiOutput("second.poke"),
    textOutput("second.poke.stats")
  )),
  
  column(4, wellPanel(
    h3("Make a Move"),
    uiOutput("move.first.poke"),
    uiOutput("move.second.poke"),
  )),
  
  column(12, tabsetPanel(
    type = "tabs",
    tabPanel(strong("Battle")),
    tabPanel(strong("Table")),
             
             
             #uiOutput("table.sent"),
             #tableOutput("table")),
    tabPanel(strong("Calculations"))
  ))
  )
)
