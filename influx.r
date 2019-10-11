library(httr)

influx.read <- function(query, user, password){
  # Purpose: Query data from the bee-observer sensor data base
  #
  # Parameters:
  #     query: A query string. Refer to: https://docs.influxdata.com/influxdb/v1.7/query_language/data_exploration/
  #           examples:
  #                   "select * from sensors where time >= now() -1h"
  #                   "select * from sensors where \"key\" = 'Q05rcH1lquY8YrYN' and time >= now() -1h"
  #     user: the user of the influx db
  #     password: influx db password
  #
  # Returns:
  #     the data as data frame
  
  
  
  # Get raw data
  result <- GET(
    "http://134.102.219.159:8086/query?db=bee_data",
    query=list(
      q= query
    ),
    authenticate(user, password),
    verbose()
  )
  
  # parse raw data
  content <- content(result, as="parsed")
  
  # extract values
  content.list <- content$results[[1]]$series[[1]]$values
  
  # extract header
  content.header <- content$results[[1]]$series[[1]]$columns
  
  # convert to data frame
  df <- do.call(rbind, content.list)
  df <- as.data.frame(df)
  names(df) <- unlist(content.header)
  
  return(df)
}



