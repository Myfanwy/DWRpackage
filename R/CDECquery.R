#' @title CDECquery
#' @description CDECquery function, edited from the sharpshootR package (original function author: Dylan Beaudette)
#' @param id The three letter station ID, quoted and in all caps (for a full list of station ids, see: )
#' @param sensor The number of the sensor you want (for a full list of sensors, see: )
#' @param interval The code of the data duration you want: "D" for daily (default), "E" for event, or "M" monthly.
#' @param start The start date of the data, in yyyy-mm-dd format
#' @param end The end date of the data you want, in yyyy-mm-dd format
#' @details  For original documentation, see ?sharpshootR::CDECquery.  For argument inputs, start and end dates must be in yyyy-mm-dd format, duration code and station id are quoted, sensor number is numeric.
#' @return The data between the specified \code{start_date} and \code{end_date}, in table format
#' @export
#' @examples
#' d <- CDECquery("FPT", 20, "E", "2012-05-29", 2012-08-29")
#' head(d)


CDECquery <- function (id, sensor, interval = "D", start, end) {

  opt.original <- options(stringsAsFactors = FALSE)
  u <- paste0("http://cdec.water.ca.gov/dynamicapp/req/CSVDataServlet?Stations=",
              id, "&SensorNums=", sensor, "&dur_code=", interval, "&Start=", # generates the URL query string
              start, "&End=", end)
  u
  #u <- URLencode(u) # adds '%20' for the spaces/generally converts string to proper valid url
  tf <- tempfile() # creates an empty temporary file
  suppressWarnings(download.file(url = u, destfile = tf, quiet = FALSE))
  d <- try(read.csv(file = tf, header = TRUE, stringsAsFactors = FALSE,
                    col.names = c("station", "duration", "sensor", "sensor_type",
                                  "actual_date", "obs_date", "value",
                                  "data_flag", "units")), 
           silent = FALSE)
  if (class(d) == "try-error") {
    ref.url <- paste0("invalid URL; see ", "http://cdec.water.ca.gov/dynamicapp/wsSensorData?station_id=",
                      id)
    stop(ref.url, call. = FALSE)
  }
  if (nrow(d) == 0)
    stop("query returned no data", call. = FALSE)
  d$actual_date <- lubridate::ymd_hm(d$actual_date)
  d$obs_date <- lubridate::ymd_hm(d$obs_date)
  d$year <- as.numeric(lubridate::year(d$actual_date)) 
  d$month <- factor(format(d$actual_date, "%B"), levels = c("January",
                                                            "February", "March", "April", "May", "June", "July",
                                                            "August", "September", "October", "November", "December"))
  
  return(d)
}
