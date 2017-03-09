# Loads the UI and Server
source('ui.R')
source('server.R')

# Creates a shinyApp()
shinyApp(ui = my.ui, server = my.server)