source("getPolluteData.R")

#' Reads a directory full of files and reports the number of completely observed cases in each data file.
#' 
#' Each file contains data from a single monitor and the ID number for each monitor is contained in the file name.
#' For example, data for monitor 200 is contained in the file "200.csv".
#' 
#' @param directory A path to directory where all the files are contained
#' @param id A vector of monitor ID numbers
#' @return A data frame where the first column is the name of the file and the second column is the number of complete cases.
#' @examples
#' complete("specdata", c(2, 4, 8, 10, 12))
#' complete("specdata", 30:25)
#' complete("specdata", 3)
complete <- function(directory, id = 1:332) {
  # 0. Initialize variables used in the function
  output <- NULL
  
  # 1. Validate input parameters
  if (class(directory) == 'character' & (class(id) == 'integer' | class(id) == 'numeric')) {
    
    # 1.1. Get the data from the CSV files. Return NULL, in case the data could not be read.
    polluteData <- getPolluteData(directory, id)
    if ( is.null(polluteData) )
      return(NULL)
    
    # 1.2. Get complete data rows (the data rows where sulfate AND nitrate values are provided)
    completeDataRows <- polluteData[ !is.na(polluteData[,"sulfate"]) & !is.na(polluteData[,"nitrate"]), ]
    
    # 1.3. Calculate frequency of complete data rows for each given monitor ID with the help of table() function
    completeDataRowsFreq <- table(completeDataRows["ID"])
    
    # 1.4. Save the result in a data frame with column names "id" (for monitor ID) and "nobs" (for number of complete data rows for the given monitor ID).
    output <- as.data.frame( completeDataRowsFreq )
    names(output) <- c("id", "nobs")
  }
  
  # 2. Return the data frame from step 1.4 sorted by given id order.
  output[id,]
}