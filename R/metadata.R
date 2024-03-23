#'CDL metadata.
#'
#'\code{metadata} downloads classification and crop class metadata from the cropscape website. 
#'
#'Cropscape provides classification and crop class metadata on the Cropland Data Layer.
#'This function fetches this data through scraping cropscape html.
#'
#' @param state A numeric fips code, a state's two letter abbreviation, or a state name.
#' @param year A numeric year.
#' @param https Legacy https, all traffic uses https, if you need http provide alternative url.
#' @param ssl.verifypeer An optional boolean to turn on and off ssl verfication, default is on.
#' @return The metadata for the state identified by the state argument.  If no match can be made, the 
#'  program returns NA.  The metadata is returned as a list with two elements, overall and class 
#'  specific metrics, each in dataframes.
#' @examples
#' \dontrun{
#' metadata("ia", 2007)
#' metadata('North Carolina',2008)
#' metadata(44,2017)
#' }
#' @author Jonathan Lisic, \email{jlisic@@gmail.com}
#' @importFrom httr config 
#' @importFrom httr http_error 
#' @importFrom rvest read_html 
#' @importFrom rvest html_nodes 
#' @importFrom rvest html_text
#' @importFrom stringr str_count 
#' @importFrom stringr str_pad 
#' @importFrom stringr str_split_1 
#' @export

metadata  <- function( state , year,https=TRUE, ssl.verifypeer = TRUE){

  # handle the case of 0 length
  if(length(state) == 0 ) return(NA)

  # convert to NA
  state = cdlTools::fips(state, to='FIPS')
  
  # handle the case of NA
  if(is.na(state)) return(NA)

  # downloading file
  if(https) {
    url <- sprintf("https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/metadata_%s%02d.htm", tolower(cdlTools::fips(state, to="abbreviation")),year %% 100)
  } else {
    url <- sprintf("https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/metadata_%s%02d.htm", tolower(cdlTools::fips(state, to="abbreviation")),year %% 100)
  }

  # check if URL exists
  if(httr::http_error(url, config = httr::config(ssl_verifypeer = ssl.verifypeer)) ){
     warning( sprintf("%s does not exist.",url) )
     return(NA)
   }

  metadata_result = rvest::read_html(url) 

  ###########################
  ## clean up text 
  ###########################
  x = gsub("\r","",strsplit(rvest::html_text(rvest::html_nodes(metadata_result,"pre")[[2]])  , "\n")[[1]])
  
  ## initialize to find tables
  x_nchar = nchar(x)
  prior_blank = TRUE
  table_index_list = list()
  table_index = c()
  for( i in 1:length(x)){
    
    # is it blank
    if( x_nchar[i] == 0 ) {
      prior_blank = TRUE
      # if there is a list append it
      if ( length(table_index) > 0) {
        table_index_list = append(table_index_list,list(table_index))
        table_index = c()
      }
      next 
    }
    
    table_index = c(table_index,i)
    
    # well it's not blank
    prior_blank = FALSE
  }
  # handle the last row 
  if( !prior_blank ) {
      table_index_list = append(table_index_list,list(table_index))
  }
  
  
  ###########################
  ## find '--' used to identify tables
  ###########################
  divider_index = which(stringr::str_count(x,"-") > 20)
  
  table_index_list = table_index_list[ sapply( table_index_list, function(y) length(intersect(y,divider_index)) > 0 ) ]
 
  # add a place to store things 
  result_dfs = list()
  
  for( table_iter in 1:length(table_index_list) ) {
    # get the table from the html
    z = x[table_index_list[[table_iter]]]
    z_max = max(nchar(z))
    
    Z = t(sapply(z,function(x) {
      x = stringr::str_pad(x,z_max,side='right')
      stringr::str_split_1(x,pattern="") != " "
      }))
    rownames(Z) = NULL
    
    ## build table
    # initialize
    start =1  
    for( stop in  c(which(colSums(Z) == 0),z_max) ) {
      # skip if blank items are right near each other 
      if( (stop - start) < 2) {
        start = stop
        next
      }
      # subset strings
      result = c()
      for( i in 1:NROW(z)) {
        result = c( result, substr(z[i],start,stop) )
      }
      # save result
      if( start == 1) {
        result_df = data.frame( V1=trimws(result) ,stringsAsFactors = FALSE)
      } else {
        result_df[sprintf("V%d",start)] = trimws(gsub("(%|,)","",result))
      }
      start = stop
    }
    
    ###########################
    ## create final table
    ###########################
    # find '-' to split header from body
    split_row = which.max(apply( result_df, 1, function(x) sum(stringr::str_count(x,"-")) ))
    # get header
    headers = trimws(apply( result_df[1:(split_row-1),], 2, paste0, collapse=" "))
    # get body
    result_df = result_df[(split_row+1):NROW(result_df),,drop=FALSE]
    # apply headers
    colnames(result_df) = headers
    # set NA
    result_df[result_df == 'n/a'] = NA
    # convert numeric
    result_df[,-1] = apply(result_df[,-1],1:2,as.numeric)
   
    # aggregate results 
    result_dfs[[table_iter]] = result_df
  } 

  # names
  names(result_dfs) = c("Overall","Cell")
   
  ###########################
  ## return our results 
  ###########################
  return(result_dfs)
}
  
  
  
  
  
