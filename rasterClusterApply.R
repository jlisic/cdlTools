# function to apply an arbitrary function to cells in a raster or brick object 
rasterClusterApply <- function(x, cellFun, needed, filename="", ...) {

  cl <- getCluster()
  on.exit( returnCluster() )
 
  nodes <- length(cl)
 
  bs <- blockSize(x,minblocks=nodes*4)
  pb <- pbCreate(bs$n)
 
  # the function to be used (simple example)
  clFun <- function(i) {
    v <- getValues(x, bs$row[i], bs$nrows[i])
    if( is.null( nrow(v) ) ) {
      w <- sapply(v,cellFun)
    } else { 
      w <- apply(v,1,cellFun)
    }

    # transpose the end result if it isn't an array
    if( !is.null( nrow(w) ) ) {
      w <- t(w)
    }  

    return(w)
  }
   
  funcName <-  as.character(as.list( match.call() )$cellFun) 
 
  if( !missing(needed) ) clusterExport(cl, needed )
  clusterExport(cl, list( funcName  ) )

  # get all nodes going
  for (i in 1:nodes) {
    sendCall(cl[[i]], clFun, i, tag=i)
  }

  # at this point we have a filename 
  filename <- trim(filename)
  if (filename == "") {
    filename <- rasterTmpFile()
  }

  result <<- list()
  result.index <<- c() 

  for (i in 1:bs$n) {
    # receive results from a node
    d <- recvOneData(cl)
 
    # error?
    if (! d$value$success) {
      stop( 'cluster error')
    }
 
    # which block is this?a
    b <- d$value$tag
    cat( 'received block:' ,b, ' \n '); flush.console();

    # on first iteration get the dim of the response
    out.nlayer <- ncol(d$value$value)

    # on the first iteration we create a block
    if ( i == 1 ) {
      if( is.null( out.nlayer ) ) {
        out <- raster(x) 
      } else {
        out <- brick(extent(x), nrow=nrow(x), ncol=ncol(x), nl=out.nlayer, crs=proj4string(x) ) 
      }
      out <- writeStart(out, filename=filename, ... )

    }
 
    out <- writeValues(out, d$value$value, bs$row[b])

    result[[i]] <<- d$value$value
    result.index[i] <<- b


    # need to send more data?
    ni <- nodes + i
    if (ni <= bs$n) {
      sendCall(cl[[d$node]], clFun, ni, tag=ni)
    }
    pbStep(pb)
  }
 
  # write out our data  
  out <- writeStop(out)
  pbClose(pb)

  return(out)
#  return( list( result=result, result.index=result.index ) )
}





