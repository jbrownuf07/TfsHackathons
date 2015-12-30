
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Example data links
# https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/measurements
# 
# https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/clusters/91e4da90-7b35-4e41-b45f-8cada43a8d6d
# 
# https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/features/91e4da90-7b35-4e41-b45f-8cada43a8d6d

library(shiny)
library(RCurl)
require(jsonlite)
library(plotly)
library(ggplot2)

# source('functions.R')

shinyServer(function(input, output, session) {
  
  serverAddress <- 'https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia'
  
  
  getDatasets <- reactive({
    ds <- fromJSON('https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/measurements')
    ds
  })
  
  # Get the XIC information as a data.frame
  getXics <- reactive({
    xic <- fromJSON(paste(serverAddress, 'clusters', getID(), sep = '/'))[[1]]
    updateSelectInput(session, 'massSelector', choices = sort(unique(xic$MZ)))
    xic
  })
  
  
  getFeatures <- reactive({
    features <- fromJSON(paste(serverAddress, 'features', getID(), sep = '/'))[[1]]
    features
  })
  
  getID <- reactive({
    id <- '91e4da90-7b35-4e41-b45f-8cada43a8d6d'
#     if (nchar(input$datasetTable) > 0 & nchar(input$datafileTable) > 0) {
#       id <- as.character(subset(getDatasets(), 
#                    Project == input$datasetTable & Filename == input$datafileTable,
#                    select = 'MeasurementId'))
#     }
    id
  })
  
  
  
  
  
  output$xicPlot <- renderPlotly(({
    
    gg <- ggplot(data = getXics(), aes(x = RT, y = Intensity, group = 1)) + geom_line()
    
    p <- ggplotly(gg)
    p
  }))
  
  output$featuresPlot <- renderPlotly({
    gg <- qplot(Width, data=getFeatures(), geom="histogram")
    
    p <- ggplotly(gg)
    p
  })
  
  loadDataFiles <- reactive({
    if (is.null(input$datasetTable))
      return()
    
    availableProjects <- processRefresh()
    selectedDataset <- input$datasetTable
    filteredDatasets <- subset(availableProjects, Project == selectedDataset)
  })
  
  
  processRefresh <- reactive({
    vals <- getDatasets()
    projectNames <- sort(unique(vals$Project))
    updateSelectInput(session, 'datasetTable', choices = projectNames)
  })
  
#   # Refresh button has been pushed
  observeEvent(
    input$refreshDatasetsButton,
    {
      processRefresh()
    }
  )
  
  observeEvent(
    input$datasetTable,
    {
      if (nchar(input$datasetTable) > 0) {
        
        vals <- getDatasets()
        
        if (nrow(vals) > 0) {
          
            selectedDS <- input$datasetTable
            selectedDatasetFiles <- subset(vals, Project == selectedDS, select = c('Filename'))
            updateSelectInput(session, 'datafileTable', choices = selectedDatasetFiles)
        }
      }
    }
  )
  
  # Run Xtopia
  observeEvent(
    input$runXtopiaButton,
    {
      id <- '91e4da90-7b35-4e41-b45f-8cada43a8d6d'
      if (!is.null(input$mydatasets_row_selected)) {
        s <- input$mydatasets_rows_selected
        val <- getDatasets()
        id <- unlist(subset(val, Project == input$datasetTable, select='MeasurementId'))[s]
      }
      
      uri <- paste('https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/features/',
                   getID(), sep = '')
      postForm(uri)
    }
  )
  
  observeEvent(
    input$refreshResultMassesButton,
    {
      # console.log('Refreshing masses')
      print('Refreshing masses')
      xics <- getXics()
      updateSelectInput(session, 'massSelector', choices = sort(unique(xics$MZ)))
    }
  )
})
