\name{cdlList}
\alias{cdlList}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Function to construct a raster list from multiple years of CDL data.
  %%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
cdlList(Dir, years, State, Fips)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Dir}{
%%     ~~Describe \code{Dir} here~~
}
  \item{years}{
%%     ~~Describe \code{years} here~~
}
  \item{State}{
%%     ~~Describe \code{State} here~~
}
  \item{Fips}{
%%     ~~Describe \code{Fips} here~~
}
  \item{nodes}{
%%     ~~Describe \code{nodes} here~~
}
  \item{extent}{
%%     ~~Describe \code{extent} here~~
}
  \item{setId}{
%%     ~~Describe \code{setId} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (Dir, years, State, Fips, nodes, extent, setId = NULL) 
{
    dir.create(file.path(Dir, sprintf("CDL_\%s", State)), showWarnings = FALSE)
    cdl.fileNames <- c()
    for (i in 1:length(years)) {
        year <- years[i]
        cdl.fileName <- sprintf("\%sCDL_\%s/CDL_\%d_\%02d.tif", Dir, 
            State, year, Fips)
        print(paste("Downloading", cdl.fileName))
        if (!file.exists(cdl.fileName)) {
            download.files(getCDLURL.fips(Fips, year), list(cdl.fileName))
        }
        cdl.fileNames <- c(cdl.fileNames, cdl.fileName)
    }
    cdl.properties <- cbind(years, tifListProp(cdl.fileNames))
    base.index <- which.max(cdl.properties[, "xres"])
    cdl.resampleList <- as.matrix(apply(cdl.properties, 1, function(x) x != 
        cdl.properties[base.index, ]))
    cdl.resampleList <- colSums(cdl.resampleList[-1, ])
    cdl.resampleList <- cdl.resampleList > 0
    print(sprintf("The following years need to be resampled: \%s", 
        paste(years[cdl.resampleList], collapse = " ")))
    if (missing(nodes)) {
        beginCluster()
    }
    else {
        beginCluster(nodes)
    }
    cdl.baseRaster <- raster(cdl.fileNames[base.index])
    for (index in which(cdl.resampleList == T)) {
        year <- years[index]
        fileName <- cdl.fileNames[index]
        print(sprintf("Starting year \%d", year))
        if (file.exists(sprintf("\%sCDL_\%s/CDL_\%d_\%02d_resampled.tif", 
            Dir, State, year, Fips))) {
            print(sprintf("File exists skipping for year \%d", 
                year))
        }
        else {
            cdl.reproj <- raster(fileName)
            print(proj4string(cdl.reproj))
            print(proj4string(cdl.baseRaster))
            if (proj4string(cdl.reproj) != proj4string(cdl.baseRaster)) {
                print(sprintf("Requires Reprojection year \%d", 
                  year))
                cdl.reproj <- projectRaster(cdl.reproj, cdl.baseRaster, 
                  method = "ngb", progress = "text")
                print(sprintf("Resampling year \%d", year))
                cdl.resampled <- raster:::resample(cdl.reproj, 
                  cdl.baseRaster, method = "ngb", progress = "text")
            }
            else {
                print(sprintf("Resampling year \%d", year))
                cdl.resampled <- raster:::resample(cdl.reproj, 
                  cdl.baseRaster, method = "ngb", progress = "text")
            }
            print(sprintf("Writing year \%d, filename = \%s", year, 
                sprintf("\%sCDL_\%s/CDL_\%d_\%02d_resampled.tif", 
                  Dir, State, year, Fips)))
            writeRaster(cdl.resampled, sprintf("\%sCDL_\%s/CDL_\%d_\%02d_resampled.tif", 
                Dir, State, year, Fips), "GTiff", overwrite = T)
        }
        cdl.fileNames[index] <- sprintf("\%sCDL_\%s/CDL_\%d_\%02d_resampled.tif", 
            Dir, State, year, Fips)
    }
    endCluster()
    cdl.properties <- cbind(years, tifListProp(cdl.fileNames))
    for (i in 1:length(cdl.fileNames)) {
        print(sprintf("Opening New files: \%s", cdl.fileNames[i]))
        if (i == 1) {
            a <- list(raster(cdl.fileNames[i]))
        }
        else {
            a[[i]] <- raster(cdl.fileNames[i])
            projection(a[[i]]) <- proj4string(a[[1]])
        }
        if (!missing(extent)) {
            print(sprintf("  Cropping: \%s", cdl.fileNames[i]))
            a[[i]] <- crop(a[[i]], extent)
        }
    }
    brick.names <- sprintf("\%d", years)
    if (!is.null(setId)) {
        a[[i + 1]] <- raster.setId(a[[i]])
        brick.names <- c(brick.names, setId)
    }
    print("Creating Brick")
    CDLRaster <- brick(unlist(a))
    names(CDLRaster) <- brick.names
    return(CDLRaster)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
