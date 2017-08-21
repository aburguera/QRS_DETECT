/*
  Name        : outSignal=smooth_signal(inSignal,halfWinSize);
  Description : Smooths the input signal inSignal by means of Moving Linear
                Regression. The sliding window is symmetric of
                size 2*halfWinSize+1
  Input       : inSignal    - Input signal
                halfWinSize - See description
  Output      : outSignal   - Smoothed data
*/

#include "mex.h"

/* The linear regression taylored to regular X sampling */
void get_line_parameters(double *v, int delta, int sampleNum, double *m, double *b) {
    int i;
    double mv=0.0;
    double numerator,denominator;
    for (i=-delta;i<=delta;i++) {
        mv+=v[sampleNum+i];
    }
    mv/=(2.0*delta+1.0);
    numerator=0;
    for (i=-delta;i<=delta;i++) {
        numerator+=i*(v[sampleNum+i]-mv);
    }
    numerator*=3;
    denominator=delta*(2.0*delta+1.0)*(delta+1);
    *m=(numerator/denominator);
    *b=mv-*m*(double)sampleNum;
}

/* The gateway function */
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) {

    int halfWindowSize;             /* Half of the window size-1 */
    double *inData;                 /* The input data */
    double *outData;                /* The output data */
    double *outSum;                 /* The vector to compute the means */
    size_t dataLen;                 /* The size of input and output data */
    double m,b;                     /* The line parameters */
    int i,j;

    /* check for proper number of arguments */
    if(nrhs!=2) {
        mexErrMsgTxt("Two inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgTxt("One output required.");
    }

    /* make sure the first input argument is type double */
    if( !mxIsDouble(prhs[0]) ||
         mxIsComplex(prhs[0])) {
        mexErrMsgTxt("Input matrix must be type double.");
    }
    /* check that number of rows in first input argument is 1 */
    if(mxGetM(prhs[0])!=1) {
        mexErrMsgTxt("Input must be a row vector.");
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
    dataLen=mxGetN(prhs[0]);

    /* create the output matrix */
    plhs[0]=mxCreateDoubleMatrix(1,(mwSize)dataLen,mxREAL);

    /* get a pointer to the real data in the output matrix */
    outData=mxGetPr(plhs[0]);

    /* Get memory for count vector used to compute the means */
    outSum=(double *)malloc(dataLen*sizeof(double));

    /* Prepare the count vector */
    j=0;
    for (i=1;i<=2*halfWindowSize;i++) {
        outSum[j++]=i;
    }
    for (i=0;i<dataLen-4*halfWindowSize;i++) {
        outSum[j++]=2*halfWindowSize+1;
    }
    for (i=2*halfWindowSize;i>=1;i--){
        outSum[j++]=i;
    }

    /* Smooth */
    for (i=halfWindowSize;i<dataLen-halfWindowSize;i++) {
        get_line_parameters(inData, (int)halfWindowSize, i, &m, &b);
        for (j=i-halfWindowSize;j<=i+halfWindowSize;j++){
            outData[j]+=(m*j+b);
        }
    }

    /* Divide by the pre-computed count vector */
    for (i=0;i<dataLen;i++){
        outData[i]/=outSum[i];
    }

    free(outSum);
}