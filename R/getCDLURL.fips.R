getCDLURL.fips <-
function(x, years) {

  # create a list to return
  cdl.url.list <- list()

  for( year in years ) {
    # make a CDL request for the bounding box    
    htmlResult <- 
      unlist(
        strsplit( 
          a <- getURL(
            sprintf("http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLFile?year=%d&fips=%02d",year,x)
          )
          ,
        "<(/|)returnURL>"  # regexp to split on
        )
      )

    if( length(htmlResult) != 3 ) {
      targetGeoTif <- NA 
    } else {
      targetGeoTif <- htmlResult[2] 
    }

    # select the value from the html tree that contains the geotif file name 
    #targetGeoTif <- unlist(htmlResult)["children.html.children.body.children.getcdlfileresponse.children.returnurl.children.text.value"]
   
    # change the name associated with the targetGeoTif 
    names(targetGeoTif) <- year 

    # write the raster object into the list
    cdl.url.list[[sprintf("%s",year)]] <- targetGeoTif 

    # parse the html for  

  }

  return(cdl.url.list)
}
