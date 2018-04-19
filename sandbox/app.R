# Read in data
plots <- read.csv("../sandbox/portal-teachingdb-master/plots.csv", stringsAsFactors = FALSE)
species <- read.csv("../sandbox/portal-teachingdb-master/species.csv", stringsAsFactors = FALSE)
surveys <- read.csv("../sandbox/portal-teachingdb-master/surveys.csv", na.strings = "", stringsAsFactors = FALSE)

ui <- navbarPage(title = "Species Data",
                       tabPanel(title = "Data", dataTableOutput("surveys_subset")),
                                sidebarLayout(
                                  sidebarPanel(
                                    selectInput("pick_species", label = "Pick a species", 
                                                choices = unique(species$species_id)),
                                    downloadButton("download_data", label = "Download"), 
                                    sliderInput("slider_months", label = "Month range",
                                                min = 1, max = 12, value = c(1,12)),
                                    textOutput(outputId = "species_id")
                                  ),
                                  mainPanel(
                                    plotOutput("species_plot")
                                  )
                                )
                       )
# Server   ## stuggling to add a title
server <- function(input, output){
  output$species_id <- renderText({input$pick_species})
  
  surveys_subset <- reactive({
    surveys_subset <- subset(surveys, surveys$species_id == input$pick_species)
    return(surveys_subset)
  })
  
  output$species_plot <- renderPlot({
    species_name <- paste(species[species$species_id==input$pick_species,"genus"],
                          species[species$species_id==input$pick_species,"species"])
    barplot(table(surveys_subset()$year), main = paste("Observations of", species_name, "per year"))
  })
  
  output$surveys_subset <- renderDataTable({
    surveys_subset()
    
    output$download_data <- downloadHandler(
      filename = "portals_subset.csv",
      content = function(file) {
        write.csv(surveys_subset(), file)
      }
    )
  })
}

# Run app
shinyApp(ui = ui, server = server)

