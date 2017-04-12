#' @title CDECquery
#' @description CDECquery function, recreated from the sharpshootR package (function author: Dylan Beaudette)
#' @param id The three letter station ID, quoted and in all caps (for a full list of station ids, see: )
#' @param sensor The number of the sensor you want (for a full list of sensors, see: )
#' @param interval The code of the data duration you want: "D" for daily (default), "E" for event, or "M" monthly.
#' @param start The start date of the data, in mm/dd/yyyy format
#' @param end The end date of the data you want, in mm/dd/yyyy format
#' @details  For original documentation, see ?sharpshootR::CDECquery.  Dates must be in yyyy-mm-dd format, type of data and station is quoted, sensor number is numeric.
#' @return The data between the specified \code{start_date} and \code{end_date}, in table format
#' @export
#' @examples
#' d <- CDECquery("FPT", 20, "E", "03/01/2011", "05/01/2011")
#' head(d)


CDECquery <- function (id, sensor, interval = "D", start, end) {

  opt.original <- options(stringsAsFactors = FALSE)
  if (missing(id) | missing(sensor) | missing(start) | missing(end))
    stop("missing arguments", call. = FALSE)
  u <- paste0("http://cdec.water.ca.gov/cgi-progs/queryCSV?station_id=",
              id, "&sensor_num=", sensor, "&dur_code=", interval, "&start_date=", # generates the URL query string
              start, "&end_date=", end, "&data_wish=Download CSV Data Now")
  u <- URLencode(u) # adds '%20' for the spaces/generally converts string to proper valid url
  tf <- tempfile() # creates an empty temporary file
  suppressWarnings(download.file(url = u, destfile = tf, quiet = TRUE))
  d <- try(read.csv(file = tf, header = TRUE, skip = 1, quote = "'",
                    na.strings = "m", stringsAsFactors = FALSE, colClasses = c("character",
                                                                               "character", "numeric")), silent = TRUE)
  if (class(d) == "try-error") {
    ref.url <- paste0("invalid URL; see ", "http://cdec.water.ca.gov/cgi-progs/queryCSV?station_id=",
                      id)
    stop(ref.url, call. = FALSE)
  }
  if (nrow(d) == 0)
    stop("query returned no data", call. = FALSE)
  d$datetime <- as.POSIXct(paste(d[[1]], d[[2]]), format = "%Y%m%d %H%M") # this works because of the read.csv colClasses specification
  d[[1]] <- NULL # gets rid of the original yyyymmdd column
  d[[1]] <- NULL # gets rid of the original hmm column
  names(d)[1] <- "value" # now the flow value is the new first column
  d$year <- as.numeric(format(d$datetime, "%Y")) # takes the year from the datetime column
  d$month <- factor(format(d$datetime, "%B"), levels = c("January",
                                                         "February", "March", "April", "May", "June", "July",
                                                         "August", "September", "October", "November", "December"))
  return(d[, c("datetime", "year", "month", "value")])
}

