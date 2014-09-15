\name{tifListProp}
\alias{tifListProp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Internal
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
tifListProp(fileNames)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fileNames}{
%%     ~~Describe \code{fileNames} here~~
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
function (fileNames) 
{
    n <- length(fileNames)
    xmin <- matrix(0, nrow = n, ncol = 1)
    ymin <- matrix(0, nrow = n, ncol = 1)
    xmax <- matrix(0, nrow = n, ncol = 1)
    ymax <- matrix(0, nrow = n, ncol = 1)
    xsize <- matrix(0, nrow = n, ncol = 1)
    ysize <- matrix(0, nrow = n, ncol = 1)
    xres <- matrix(0, nrow = n, ncol = 1)
    yres <- matrix(0, nrow = n, ncol = 1)
    for (i in 1:n) {
        tifProp <- raster(fileNames[i])
        xmin[i] <- slot(slot(tifProp, "extent"), "xmin")
        ymin[i] <- slot(slot(tifProp, "extent"), "ymin")
        xmax[i] <- slot(slot(tifProp, "extent"), "xmax")
        ymax[i] <- slot(slot(tifProp, "extent"), "ymax")
        xsize[i] <- ncol(tifProp)
        ysize[i] <- nrow(tifProp)
        xres[i] <- xres(tifProp)
        yres[i] <- yres(tifProp)
    }
    result <- cbind(xmin, ymin, xmax, ymax, xsize, ysize, xres, 
        yres)
    colnames(result) <- c("xmin", "ymin", "xmax", "ymax", "xsize", 
        "ysize", "xres", "yres")
    return(result)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
