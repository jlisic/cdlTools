download.files <-
function( urls , filenames, ...) {
    
  # first see if we need to create temp files, and if so, creat them. 
  if ( missing(filenames) ) {

    filenames <- list()

    for( i in 1:length(urls)) {    
      filenames[[i]] <- tempfile() 
    }

  }

  # check if we have matching urls and filenames
  if( length(urls) != length(filenames) ) {
    stop("urls and filenames lists not of equal length.", call.=FALSE)  
  }

  # create a variable to return with status
  status <- c()

  # download the files
  for( i in 1:length(urls)) {

    # try to download
    status[i] <- tryCatch({ 
      download.file(urls[[i]], destfile=filenames[[i]], ...)
      },
      warning = function(x){
         message(x)
         return(-1)
      },
      error = function(x){
         message(x)
         return(-1)
       },
       finally = {
       })

    if( status[i] == -1 ) {
       # remove the target file if it exists
       unlink( filenames[[i]] )
       filenames[[i]] <- NA
    }

  }

  return( list( urls=urls, filenames=filenames, status=status ) )
}
