\name{download.files}
\alias{download.files}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Internal
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
download.files(urls, filenames, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{urls}{
%%     ~~Describe \code{urls} here~~
}
  \item{filenames}{
%%     ~~Describe \code{filenames} here~~
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
function (urls, filenames, ...) 
{
    if (missing(filenames)) {
        filenames <- list()
        for (i in 1:length(urls)) {
            filenames[[i]] <- tempfile()
        }
    }
    if (length(urls) != length(filenames)) {
        stop("urls and filenames lists not of equal length.", 
            call. = FALSE)
    }
    status <- c()
    for (i in 1:length(urls)) {
        status[i] <- tryCatch({
            download.file(urls[[i]], destfile = filenames[[i]], 
                ...)
        }, warning = function(x) {
            message(x)
            return(-1)
        }, error = function(x) {
            message(x)
            return(-1)
        }, finally = {
        })
        if (status[i] == -1) {
            unlink(filenames[[i]])
            filenames[[i]] <- NA
        }
    }
    return(list(urls = urls, filenames = filenames, status = status))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
