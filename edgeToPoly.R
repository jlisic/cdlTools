library(rgdal)
library(RPostgreSQL)


srid = 4269 


# subset out the roads
edges <- edgeData[[1]]
edges <- edges[edges$ROADFLG=='Y',]

rasterPoints.longLat <-spTransform(rasterPoints, CRS(projection(edges)))
rasterPoints.bbox <- bbox(rasterPoints.longLat)



drv <- dbDriver("PostgreSQL")
con <- dbConnect( drv, host="10.0.1.103", dbname="edges", user="postgres", password="zoot4321!")
dbSendQuery(con, sprintf("drop table inputEdges;"))
dbSendQuery(con, sprintf("drop table inputPoints;"))
dbSendQuery(con, sprintf("drop table localEdges;"))
dbSendQuery(con, sprintf("drop table localPolygons;"))
dbSendQuery(con, sprintf("drop table finalPoly;"))

dbDisconnect(con)
dbUnloadDriver(drv)



# write edges data to the database
a <- writeOGR( edges, dsn="PG:host=10.0.1.103 port=5432 dbname=edges user=postgres password=zoot4321!", driver="PostgreSQL", layer='inputEdges', layer_options="OVERWRITE=YES" )

b <- writeOGR( rasterPoints.longLat, dsn="PG:host=10.0.1.103 port=5432 dbname=edges user=postgres password=zoot4321!", driver="PostgreSQL", layer='inputPoints', layer_options="OVERWRITE=YES" )


# submit an sql query to polygonize the result
drv <- dbDriver("PostgreSQL")
con <- dbConnect( drv, host="10.0.1.103", dbname="edges", user="postgres", password="zoot4321!")


# create a subset of the edges to use to form polygons
dbSendQuery(con,
  sprintf("create table localEdges as select * from inputEdges where wkb_geometry && st_makeEnvelope(%f,%f,%f,%f,%d) ;",
    #rasterPoints.bbox[1,1] - .01,
    rasterPoints.bbox[1,1],
    rasterPoints.bbox[2,2],
    rasterPoints.bbox[1,2],
    rasterPoints.bbox[2,1],
    srid
    )
  )


# use polygonize to create the 
dbSendQuery(con,
  sprintf("create table localPolygons as select st_polygonize(wkb_geometry) from localEdges;")
  )


# extract the polygons from the 
dbSendQuery(con,"create table finalPoly as select st_collectionextract( st_polygonize,3) from localPolygons;")

dbDisconnect(con)
dbUnloadDriver(drv)


# bring back the polygons



