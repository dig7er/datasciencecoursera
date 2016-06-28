source("getPolluteData.R")

#' Calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors.
#' The function reads that monitors' data from the CSV files in the specified directory.
#' 
#' Each file contains data from a single monitor and the ID number for each monitor is contained in the file name.
#' For example, data for monitor 200 is contained in the file "200.csv".
#' 
#' @param directory A path to directory where all the files are contained
#' @param pollutant A string, which defines the pollutant type. Should have one of two values: "sulfate" or "nitrate"
#' @param id A vector of monitor ID numbers
#' @return The mean of a pollutant (sulfate or nitrate) across a specified list of monitors.
#' @examples
#' pollutantmean("specdata", "sulfate", 1:10)
#' pollutantmean("specdata", "nitrate", 70:72)
#' pollutantmean("specdata", "nitrate", 23)
pollutantmean <- function(directory, pollutant, id = 1:332) {
  # 0. Initialize variables used in the function
  output <- NULL
  
  # 1. Validate input parameters
  if (class(directory) == 'character' & class(pollutant) == 'character' & (class(id) == 'integer' | class(id) == 'numeric')) {
    
    # 1.1. Get the data from the CSV files. Return NULL, in case the data could not be read.
    polluteData <- getPolluteData(directory, id)
    if ( is.null(polluteData) )
      return(NULL)
    
    # 1.2. Calculate mean value of the pollutant across all data files
    output <- mean( polluteData[,pollutant], na.rm=TRUE )
  }
  
  # 2. Return the mean value calculated in step 1.2.
  output
}