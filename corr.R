source("getPolluteData.R")

#' Takes a directory of data files and a threshold for complete cases and
#' calculates the correlation between sulfate and nitrate for monitor locations
#' where the number of completely observed cases (on all variables) is greater than the threshold.
#' 
#' @param directory A character vector of length 1 indicating the location of the CSV files
#' @param threshold A numeric vector of length 1 indicating the number of completely observed observations (on all variables) required to compute the correlation between nitrate and sulfate; the default is 0
#' @return a numeric verctor of correlations.
#' @examples
#' corr("specdata", 150)
#' corr("specdata", 400)
#' corr("specdata", 5000)
#' corr("specdata")
corr <- function(directory, threshold = 0) {
  # 0. Initialize variables used in the function
  output <- numeric(length = 0)
  
  # 1. Validate input parameters
  if (!(class(directory) == 'character' & (class(threshold) == 'integer' | class(threshold) == 'numeric')))
    return(output)
    
  # 2. Calculate frequency of complete data rows for each given monitor ID with the help of complete() function
  completeDataRowsFreq <- complete(directory)
  
  # 3. Get the monitor IDs after filtering
  filteredMonitorIds <- completeDataRowsFreq["id"][completeDataRowsFreq["nobs"] >= threshold]
  
  # 4. Get the data from the CSV files. Return in case the data could not be read.
  polluteData <- getPolluteData(directory, as.integer(filteredMonitorIds))
  if ( is.null(polluteData) )
    return(output)
  
  # 5. Filter out data rows where sulfate or nitrate value is missing.
  filteredDataRows <- polluteData[ !is.na(polluteData[,"sulfate"]) & !is.na(polluteData[,"nitrate"]), ]
  
  # 6. Iterate through monitor IDs
  for (id in filteredMonitorIds) {
    # 6.1. Calculate correlation between sulfate and nitrate values and add them to the output vector
    output <- c(output, cor(filteredDataRows[filteredDataRows["ID"]==id,"sulfate"], filteredDataRows[filteredDataRows["ID"]==id,"nitrate"]))
  }
  
  # 7. Return the numeric vector
  output
}