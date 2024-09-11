# app.R

library(shiny)
library(DT)

# Assuming result_list_updated and ItemMap are already loaded in the environment
# If not, you need to load them here
# procedure_info should be a dataframe with columns: ProcedureItemNumber, Description, ScheduleFee

ui <- fluidPage(
  titlePanel("Most Commonly Used Anaesthesia Items for a Given Procedure"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_df", "Select a Procedure Item Number:", 
                  choices = c("", ItemMap$ItemNum)),
      br(),
      actionButton("display_button", "Display Information"),
      br(), br(),
      h4("Procedure Information"),
      tableOutput("procedure_info_table")
    ),
    
    mainPanel(
      h4("Most Commonly Used Anaesthesia Items for Selected Procedure"),
      DTOutput("result_table")
    )
  )
)

server <- function(input, output, session) {
  
  # Display selected information when button is clicked
  observeEvent(input$display_button, {
    req(input$selected_df)
    
    # Display procedure information
    output$procedure_info_table <- renderTable({
      procedure_info[ItemMap$ItemNum == input$selected_df, ]
    })
    
    # Display dataframe contents
    output$result_table <- renderDT({
      selected_data <- result_list_updated[[input$selected_df]]
      datatable(selected_data, options = list(pageLength = 10))
    })
  })
}

shinyApp(ui = ui, server = server)
