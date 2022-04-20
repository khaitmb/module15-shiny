# Load the shiny, ggplot2, and dplyr libraries
install.packages("shiny")
install.packages("ggplot2")
install.packages("dplyr")

library(shiny)
library(ggplot2)
library(dplyr)

# You will once again be working with the `diamonds` data set provided by ggplot2
# Use dplyr's `sample_n()` function to get a random 3000 rows from the data set
# Store this sample in a variable `diamonds.sample`
diamonds.sample <- sample_n(diamonds, 3000)

# For convenience store the `range()` of values for the `price` and `carat` values
# for the ENTIRE diamonds dataset.
price_range <- range(diamonds$price) # 326 18823
carat_range <- range(diamonds$carat) # 0.20 5.01


# Define a UI using a fluidPage layout
ui <- fluidPage(
  titlePanel("Diamond Viewer"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("price", "Price (in dollars)", min = min(price_range), max = max(price_range), min(price_range)),
      sliderInput("carat", "Carats", min = min(carat_range), max = max(carat_range), min(carat_range)),
      checkboxInput("trendline", "Show Trendline", value = TRUE),
      selectInput("facet", "Facet By", c("cut", "clarity", "color"))
    ),
    
    mainPanel(
      plotOutput('plot')
    )
  )
)

  # Include a `titlePanel` with the title "Diamond Viewer"


  # Include a `sidebarLayout()`


    # The `siderbarPanel()` should have the following control widgets:


      # A sliderInput labeled "Price (in dollars)". This slider should let the user pick a range
      # between the minimum and maximum price of the entire diamond data set


      # A sliderInput labeled "Carats". This slider should let the user pick a range
      # between the minimum and maximum carats of the entire diamond data set


      # A checkboxInput labeled "Show Trendline". It's default value should be TRUE


      # A slectInput labeled "Facet By", with choices "cut", "clarity" and "color"



    # The `mainPanel()` should have the following reactive outputs:


      # A plotOutput showing a plot based on the user specifications


      # Bonus: a dataTableOutput showing a data table of relevant observations



# Define a Server function for the app
server <- function(input, output) {
  output$plot <- renderPlot({
    diamonds.filtered <- filter(diamonds.sample, price <= input$price & carat <= input$carat)
    graph <- ggplot(data = diamonds.filtered, mapping = aes(x = carat, y = price, color = clarity)) +
      geom_point() +
      facet_wrap(~input$facet)
    if (input$trendline == TRUE) {
      return(graph + geom_smooth(se = FALSE))
    } else {
      return(graph)
    }
  })
}

  # Assign a reactive `renderPlot()` function to the outputted `plot`


    # This function should take the `diamonds.sample` data set and filter it by the
    # input price and carat ranges.
    # Hint: use dplyr and multiple `filter()` operations

    # The filtered data set should then be used in a ggplot2 scatter plot with the
    # carat on the x-axis, the price on the y-axis, and color based on the clarity
    # You should specify facets based on what feature the user selected to "facet by"
    #   (hint: you can just pass that string to the `facet_wrap()` function!)


    # Finally, if the "trendline" checkbox is selected, you should also include a
    # geom_smooth geometry (with `se=FALSE`)
    # Hint: you'll need to use an `if` statement, and save the `ggplot` as a variable
    #      that you can then add the geom to.
    # Be sure and return the completed plot!




  # Bonus: Assign a reactive `renderDataTable()` function to the outputted table
  # You may want to use a `reactive()` variable to avoid needing to filter the data twice!


# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = ui, server = server)

## Double Bonus: For fun, can you make a similar browser for the `mpg` data set?
## it makes the bonus data table a lot more useful
