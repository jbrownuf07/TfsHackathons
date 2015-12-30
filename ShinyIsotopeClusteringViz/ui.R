
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyBS)
library(shinydashboard)
library(plotly)
library(ggplot2)
library(DT)

dashboardPage(
  dashboardHeader(title = "Xtopia",
                  
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Xtopia Team",
                                 message = "Welcome to the Xtopia Results Viz"
                               )),
                  
                  titleWidth = 150),
  dashboardSidebar(
    width = 150,
    sidebarMenu(
      menuItem("Process", tabName = "runXtopia", icon = icon("gear")),
      # menuItem("Process", tabName = "isotopes", icon = icon("bar-chart")),
      menuItem("Results", tabName = "results", icon = icon("area-chart"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    tabItems(
      
      tabItem(tabName = "runXtopia",
                h2("Process a dataset"),
                
                fluidRow(
                  column(width = 9,
                         
                         
                         p('Press the refresh button on the right to get started...')
                         , div(title='Select a dataset', selectInput("datasetTable", label = "", choices = NULL))
                         # , DT::dataTableOutput('mydatasets')
                         , div(title='Select a datafile within the dataset', selectInput("datafileTable", label = "", choices = NULL))
                  ),
                  column(width = 2,
                         fluidRow(
                         actionButton("runXtopiaButton", "", icon = icon('gears')),
                         bsTooltip('runXtopiaButton', 'Run Xtopia',
                                   'top', options = list(container = 'body')),
                         actionButton("refreshDatasetsButton", "", icon = icon("refresh")),
                         bsTooltip('refreshDatasetsButton', 'Refresh available datasets',
                                   'right', options = list(container = 'body')))
                         )
                )
              ),
      
      # The results page
      tabItem(tabName = "results",
              h2("Results"),
              fluidRow(
                tabBox(
                  title = tagList(shiny::icon("rocket"), "Xtopia Results"),
                  id = "xtopiaRes",
                  width = NULL,
                  height = "600px",
                  tabPanel("Isotopes", "Isotope Clusters view is not currently available"),
                  tabPanel("XICs", "", {
                    fluidPage(
                    fluidRow(
                    
                      box(title='Select a mass to plot XIC', solidHeader = TRUE,
                          collapsible = TRUE,
                          selectInput("massSelector", label = "", choices = NULL), 
                          actionButton('refreshResultMassesButton', '', icon = icon('refresh')))
                      
                      # plotlyOutput('xicPlot')
                    ),
                    fluidRow(
                      box(title = 'plot',
                          plotlyOutput('xicPlot'))
                    )
                    )
                    
                    # plotlyOutput('xicPlot')
                    
                  }),
                  tabPanel("Peaks", "Features", {
                    verbatimTextOutput('selectedDatafileName')
                    plotlyOutput('featuresPlot')
                  }, width = '300px')
                )
              ))
    )
  )
)
