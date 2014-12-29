poly2RasterSummary <- function(p,r) {  

  # reduce the size of r
  r.reduced <- mask(crop(r,p),p)

  out.all <- c()
  out.name <- c()

  # class check
  isSPDF <- F
  isSP   <- F

  if( class(p) == "SpatialPolygonsDataFrame" ) {
    n <- nrow(p)
    isSPDF <- T 
  }
  if( class(p) == "SpatialPolygons" ) {
    n <- length(p)
    isSP <- T 
  }


  # change proj if not cdl proj
  if( proj4string(p) != cdl.proj) {
    cat("\nProjection of sp object is not cdl.proj, reprojecting\n")
    p <- spTransform(p,CRS(cdl.proj))
  }


  for( i in 1:n ) {

    print(i)

    # for spatial polygon data frame
    if( isSPDF) {
      area <- gArea(p[i,],byid=TRUE)
      out.name <- c( out.name, strsplit( names(area), " " )[[1]][2] )
      out <- c(area,rep(0,257))
      tmp <- table(values(mask(r.reduced,p[i,])))
    }

    # for spatial polygons  
    if( isSP) {
      area <- gArea(p[i],byid=TRUE)
      out.name <- c( out.name, strsplit( names(area), " " )[[1]][2] )
      out <- c(area,rep(0,257))
      tmp <- table(values(mask(r.reduced,p[i,])))
    }
  
    names(out) <- c('area',0:255,1024)
    if( length(tmp) > 0 ) out[names(tmp)] <- tmp 

    out.all <- rbind(out.all,out)
  }

  out.all <- matrix(out.all,ncol=258)
  colnames(out.all) <- c('area',0:255,1024)
  rownames(out.all) <- out.name

  return(out.all)
}

