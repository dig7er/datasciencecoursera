#' Reads CSV files given by vector of file IDs.
#' 
#' Each file contains data from a single monitor and the ID number for each monitor is contained in the file name.
#' For example, data for monitor 200 is contained in the file "200.csv".
#' 
#' @param directory A path to directory where all the files are contained
#' @param id A vector of monitor ID numbers
#' @return A data frame with contents of all given files
#' @examples 
#' getPolluteData("specdata", 1)
#' getPolluteData("specdata", 1:30)
getPolluteData <- function(directory, id = 1:332) {
  # 0. Initialize variables
  polluteData <- NULL
  
  # 1. Create input file paths from paramteres
  fileNames <- paste( formatC(id, width=3, flag=0), ".csv", sep="")
  filePaths <- file.path(directory, fileNames)
  
  # 2. Iterate through file paths and read CSV files to polluteData
  for(filePath in filePaths) {
    # 2.1. Merge data from CSV files into one R data frame polluteData
    if (file.exists(filePath)) {
      polluteData <- rbind( polluteData, read.csv(filePath, header=TRUE) )
    }
  }
  
  # 3. Return the data from CSV files in a data frame
  polluteData
}