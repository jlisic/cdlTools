#include <stdlib.h>
#include <stdio.h>
#include <math.h>




void rMatchCount( 
    int * pixel,           /* this is the raster image of assignments */ 
    int * match,           /* this is what to match against */ 
    int * assign,
    int * count,
    int * mPtr,     /* max number of matches */
    int * nPtr
    ) {
  
  size_t m = *mPtr;

  size_t N = *nPtr;

  size_t i,j; /* iterator */
  int index;
  size_t assignIndex;

  /* for each observation find another observation to replace it */
  for( i =0; i < N; i ++){ 
    index = pixel[i]; 

    if( pixel[i] >= 0 ) 
      if( match[i] >= 0 ) 
        for( j = 0; j < m; j++) {
         
          assignIndex = index * m +j; 
         
          if( assign[assignIndex] < 0) {
            assign[assignIndex] = match[i]; 
            count[assignIndex]++; 
            break;
          }
          if( assign[assignIndex] == match[i]) {
            count[assignIndex]++; 
            break;
          } 

        }
  }

  return;
}


