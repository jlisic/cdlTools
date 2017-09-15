/* Copyright (c) 2015-2017  Jonathan Lisic 
 * License: GPL (>=2) 
 */  

#include <stdio.h> 
#include <stdlib.h>
//#include <time.h>

#include "R.h"
#include "Rinternals.h"
#include "Rmath.h"
#include <R_ext/Rdynload.h>



/***********************************/
/* Function Prototypes             */
/***********************************/


void rMatchCount( 
    int * pixel,           /* this is the raster image of assignments */ 
    int * match,           /* this is what to match against */ 
    int * assign,
    int * count,
    int * mPtr,     /* max number of matches */
    int * nPtr
    ); 


/***********************************/
/* Register SO's                   */
/***********************************/

static R_NativePrimitiveArgType rMatchCount_t[] = {
  INTSXP, INTSXP, INTSXP,
  INTSXP, INTSXP, INTSXP
};

static const R_CMethodDef cMethods[] = {
     {"rMatchCount", (DL_FUNC) &rMatchCount, 6, rMatchCount_t},
        {NULL, NULL, 0, NULL}
};

void R_init_myLib(DllInfo *info)
{
     R_registerRoutines(info, cMethods, NULL, NULL, NULL);
     R_useDynamicSymbols(info, TRUE); 
}



