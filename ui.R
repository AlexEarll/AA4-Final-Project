# Loads the appropriate library needed
library(shiny)

# Defines a UI using a fluidPage() layout
ui <- fluidPage(
  titlePanel("Battling Pokemon"),
  fluidRow(
  
  column(4, wellPanel(
    h3("Choose Pokemon"),
    uiOutput("first.poke"),
    uiOutput("second.poke")
    )),
  
  column(4, wellPanel(
    h3("Choose Move"),
    uiOutput("move1"),
    uiOutput("move2")
  )),
  
  column(12, wellPanel(
    h4("Battle")
  ))
  )
)
