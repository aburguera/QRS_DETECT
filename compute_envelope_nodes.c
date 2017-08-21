/*
  Name        : [it,ib,kt,kb]=compute_envelope_nodes(theFeatures,halfWinSize);
  Description : Computes the signal envelope nodes as those that are
                outliers within a sliding window. The sliding window is
                symmetric of size 2*halfWinSize+1
  Input       : theFeatures - Feature vector in the same format provided by
                find_features.
                halfWinSize - See description
  Output      : it,ib       - Indexes (1-based) to theFeatures. Only the
                              first kt and kb respectively are valid.
                kt,kb       - Number of valid elements within it and ib.
*/
#include "mex.h"
#include <math.h>

/* The gateway function */
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) {
    int halfWindowSize;             /* Half of the window size-1 */
    int numRows,numCols;            /* Input matrix dimensions */
    double *inData;                 /* The input matrix */
    double *tData;
    double *bData;
    double curMean,curStd;
    int i,j,k,jl,jr,it,ib;
    double tmp;

    /* check for proper number of arguments */
    if(nrhs!=2) {
        mexErrMsgTxt("Two inputs required.");
    }
    if(nlhs!=4) {
        mexErrMsgTxt("Two outputs required.");
    }
    /* check that number of rows in first input argument is 3 */
    if(mxGetM(prhs[0])!=3) {
        mexErrMsgTxt("Input 1 must be have three rows.");
    }

    /* make sure the second input argument is scalar */
    if(!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) || mxGetNumberOfElements(prhs[1])!=1) {
        mexErrMsgTxt("Second parameter must be a scalar.");
    }
    /* get the value of the half of the window size-1 */
    halfWindowSize=(int)mxGetScalar(prhs[1]);

    /* create a pointer to the real data in the input matrix  */
    inData=mxGetPr(prhs[0]);

    /* get dimensions of the input matrix */
    numCols=mxGetN(prhs[0]);
    numRows=mxGetM(prhs[0]);

    /* Create output vectors */
    plhs[0]=mxCreateDoubleMatrix(1,(mwSize)numCols,mxREAL);
    plhs[1]=mxCreateDoubleMatrix(1,(mwSize)numCols,mxREAL);

    /* get pointers to the actual data in the output matrices */
    tData=mxGetPr(plhs[0]);
    bData=mxGetPr(plhs[1]);

    it=0;
    ib=0;

    for (i=0;i<numCols;i++){
        curMean=0;
        curStd=0;
        k=0;
        /* Compute the mean and the standard deviation within the sliding
           window */
        jl=(int)((i-halfWindowSize)>0?i-halfWindowSize:0);
        jr=(int)((i+halfWindowSize+1)<numCols?(i+halfWindowSize+1):numCols);
        for (j=jl;j<jr;j++) {
            curMean+=inData[(j*numRows)+1];
            k++;
        }
        curMean/=(double)k;

        k=0;
        for (j=jl;j<jr;j++) {
            tmp=(inData[(j*numRows)+1]-curMean);
            curStd+=(tmp*tmp);
            k++;
        }
        curStd=sqrt(curStd/(double)(k-1));

        /* Search outliers and store the corresponding indexes */
        if (inData[(i*numRows)+1]>(curMean+curStd)) {
            tData[it++]=(double)(i+1);
        } else if (inData[(i*numRows)+1]<(curMean-curStd)) {
            bData[ib++]=(double)(i+1);
        }
    }

    plhs[2] = mxCreateDoubleScalar(it);
    plhs[3] = mxCreateDoubleScalar(ib);
}