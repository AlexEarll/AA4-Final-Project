# Loads the UI and Server
source('ui.R')
source('server.R')

# Creates a shinyApp()
shinyApp(ui = ui, server = server)



# Reactive variable that takes in stats from above,
# upon a move selection/button being used it will run the math,
# it will update the health variable in the ui element above,
# add an entry to our table for the battle

# also needs to use math jax to output math