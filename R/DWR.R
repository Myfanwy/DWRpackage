#' DWR: a package for getting data from cdec.water.ca.gov
#'
#' The DWR package contains a single function (CDECquery) and two built-in datasets (sensorIDs and stationIDs).
#'
#' @section CDECquery function:
#' This function is authored by Dylan Beaudette and implemented here as a standalone-version of the one in the sharpshootR package (https://CRAN.R-project.org/package=sharpshootR).  Documentation has been generated to include the "E" duration type, as it's worked for us so far without modifying the original function (although limited testing has been done).
#'
#'@section Built-in Datasets
#'sensorIDs is a dataframe that contains all the metadata associated with the sensor types of CDEC (20 = flow (cfs), 1 = River Stage (ft), etc).
#' stationIDs is a dataframe that contains all the metadata assocaited with the station codes of CDEC ("FPT" = Freeport, "LIS" = Lisbon Weir, etc).
#'
#'
#' @docType package
#' @name DWR
NULL
