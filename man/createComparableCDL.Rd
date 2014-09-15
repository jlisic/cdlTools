\name{createComparableCDL}
\alias{createComparableCDL}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Internal function
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
createComparableCDL(filenames, rasterList, baseIndex, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filenames}{
%%     ~~Describe \code{filenames} here~~
}
  \item{rasterList}{
%%     ~~Describe \code{rasterList} here~~
}
  \item{baseIndex}{
%%     ~~Describe \code{baseIndex} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
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
function (filenames, rasterList, baseIndex, ...) 
{
    if (!missing(filenames)) {
        rasterList <- list()
        for (i in 1:length(filenames)) {
            rasterList[i] <- raster(filenames[[i]])
        }
    }
    base.extent <- extent(rasterList[[baseIndex]])
    base.xres <- xres(rasterList[[baseIndex]])
    base.yres <- yres(rasterList[[baseIndex]])
    rasterList.comparable <- list()
    for (i in 1:length(rasterList)) {
        if ((extent(rasterList[[i]]) != base.extent) & (xres(rasterList[[i]]) != 
            base.xres) & (yres(rasterList[[i]]) != base.yres)) {
            rasterList.comparable[i] <- resample(rasterList[[i]], 
                rasterList[[baseIndex]], progress = "text")
        }
        else {
            rasterList.comparable[i] <- rasterList[[i]]
        }
    }
    return(rasterList.comparable)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
