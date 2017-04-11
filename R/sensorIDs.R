#' Sensor IDs of CDEC
#'
#' A dataframe containing the numeric sensor code and descriptions for the water quality stations from cdec.water.ca.gov.
#' @format A dataframe with 243 observations of 5 variables:
#' \describe{
#' \item{Sensor No.}{Numeric sensor number, which is one of the required arguments for the getCDEC function}
#' \item{Sensor}{Abbreviated description of the sensor and what it records}
#' \item{PE Code}{No idea what this is or what it's for}
#' \item{Description}{Longer description of the sensor and what it records}
#' \item{Units}{Units that the sensor records in}
#' }
#'@source \url{http://cdec.water.ca.gov/misc/senslist.html}
#'
"sensorIDs"
