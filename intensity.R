
intensity <- function( x, subsets, window, filename="", ... ) {

n.subsets <- length(subsets)
n.window <- length(dim(v)[3] - window + 1) 

# fail if there is nothing to compute
if(n.window <= 0) return(NULL)

# make a copy of our input object
result <- brick( extent(x), nrows=nrow(x),ncols=ncol(x), nl= n.window * n.subsets) 

# handle cluster
cl <- getCluster()
on.exit( returnCluster() )

# get the number of nodes
nodes <- length( cl )

# get data to process 
bs <- blockSize(x, minblocks=nodes*4 )
pb <- pbCreate( bs$n ) # create progress bar



foo <- function( i ) {
# get our first chunk of data
v <- getValues(x,bs$row[i],bs$nrows[i])

# calculate our result


incident <- function(x) {

result <- c()

for( j in 1:n.subsets ) {

inc.sum <- vector(mode="integer",length=n.window)
inc <- x %in% subsets[[j]] 

inc.sum[1] <- sum( inc[1:window] )
for(k in 2:n.window ) inc.sum[k] <- inc.sum[k-1] - inc[k-1] + inc[k+window -1]

result <- c(result, inc.sum)

}

return(result)

}

return( apply(v,1,incident) )  

}  

# run our program
for( i in 1:nodes ) {
sendCall( cl[[i]], foo, i, tag=i)
}

# if we can't process in memory we need to specify where to write our output to
filename <- trim(filename)
if( !canProcessInMemory(out) & filename == "") {
filename <- rasterTmpFile()
}

if( filename != "" ) {
out <- writeStart( result, filename=filename, ... )
} else {
vv <- <- matrix(ncol=nrow(result), ncol=ncol(result) )
}


# collect results
for ( i in 1:bs$n ) {

# get the first data chunk
d <- recvOneData(cl)

# check for error
if (! d$value$success) {
stop('cluster error')
}

# which block is this?
b <- d$value$tag
cat('received block: ',b,'\n'); fluch.console();

if (filename != "") {
out <- writeValues(out,d$value$value, bs$row[b])
} else {
# get the column numbers to output too
cols <- bs$row[b]:(bs$row[b] + bs$nrows[b] -1)

}

}



return( result )
}


