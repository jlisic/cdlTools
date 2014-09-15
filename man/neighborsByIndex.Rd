\name{neighborsByIndex}
\alias{neighborsByIndex}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Internal
  %%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
neighborsByIndex(rasterPoints, index, func, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rasterPoints}{
%%     ~~Describe \code{rasterPoints} here~~
}
  \item{index}{
%%     ~~Describe \code{index} here~~
}
  \item{func}{
%%     ~~Describe \code{func} here~~
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
function (rasterPoints, index, func, ...) 
{
    rasterPoint <- rasterPoints[index, c("x", "y")]
    neighbors <- func(rasterPoint, rasterPoints, ...)
    return(rasterPoints[(rasterPoints[, "x"] \%in\% neighbors[, 
        "x"]) & (rasterPoints[, "y"] \%in\% neighbors[, "y"]), 
        ])
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
