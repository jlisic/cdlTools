#\name{cdlList}
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
poly2RasterSummary(p,r)   
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{p}{
    An sp SpatialPolygons object or a SpatialPolygonsDataFrame. 
    The projection must follow cdl.proj.
}
  \item{r}{
   A raster image.
  }
}
\value{
  The number of pixels by cdl category (0-255), and all categories (1024) 
  within the list of polygons.  Area is also returned.  
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
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
