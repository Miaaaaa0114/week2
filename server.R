shinyServer(
  function(input, output, session) {
    output$out1 <- renderPrint(input$in1)
    output$out2 <- renderPrint(input$in2)
    output$out3 <- renderPrint(input$in3)
    # Create a spot where we can store additional
    # reactive values for this session
    val <- reactiveValues(x=NULL, y=NULL)    
    
    # Listen for clicks
    observe({
      # Initially will be empty
      if (is.null(input$clusterClick)){
        return()
      }
      
      isolate({
        val$x <- c(val$x, input$clusterClick$x)
        val$y <- c(val$y, input$clusterClick$y)
      })
    })
    
    # Count the number of points
    output$numPoints1 <- renderText({
      mean(val$x)
    })
    output$numPoints2 <- renderText({
      median(val$x)
    })
    # Clear the points on button click
    observe({
      if (input$clear > 0){
        val$x <- NULL
        val$y <- NULL
      }
    })
    
    # Generate the plot of the clustered points
    output$clusterPlot <- renderPlot({
      
      tryCatch({
        # Format the data as a matrix
        data <- matrix(c(val$x, val$y), ncol=2)
        
        # Try to cluster       
        if (length(val$x) <= 1){
          stop("We can't cluster less than 2 points")
        } 
        suppressWarnings({
          fit <- Mclust(data)
        })
        
        mclust2Dplot(data = data, what = "classification", 
                     classification = fit$classification, main = FALSE,
                     xlim=c(-2,2), ylim=c(-2,2),cex=input$opt.cex, cex.lab=input$opt.cexaxis)
      }, error=function(warn){
        # Otherwise just plot the points and instructions
        plot(val$x, val$y, xlim=c(input$min, input$max), ylim=c(-2, 2), xlab="X", ylab="Y",
             cex=input$opt.cex, cex.lab=input$opt.cexaxis)
        text(0, 0, "Click \nto add \nmore \npoints.")
      })
    })
    output$text1 <- renderText({ 
      paste("You have selected", input$X1)
    })   
    output$summary<-renderPrint(
      { dataset<- c( input$X1, 6, 87,
                     99, 54, 23, 34, 45,78,32,20, 5, 7, 8, 9, 3, 5, 6, 10)
      summary(dataset, background = "green")}
    )
    formulaText <- reactive({
      paste("Boxplot")
    })
    # Return the formula text for printing as a caption
    output$caption <- renderText({
      formulaText()
    })
    
    # Generate a plot of the requested variable against mpg and only 
    # include outliers if requested
    output$distPlot <- renderPlot({      
      dataset<- c( input$X1,  6, 87,
                   99, 54, 23, 34, 45,78,32,20, 5, 7, 8, 9, 3, 5, 6, 10)
      boxplot(dataset, ylim = c(0, 120), 
              ylab = 'range', xlab = 'x',col = "red", border = 'orange', background = 'black')
    })
    output$hisPlot <- renderPlot(
      {dataset<-c(input$X1, 6, 87,
                  99, 54, 23, 34, 45,78,32,20, 5, 7, 8, 9, 3, 5, 6, 10)
      hist(dataset, ylim = c(0, 15), xlim = c(0, 120), ylab = 'Y', xlab = 'values', col = 'yellow',
           border = 'red')
      })
  })
