% Name        : [outECG]=highpass_filter(inECG,Fs,fc)
% Description : Cuts frequencies below fc from the ECG inECG sampled with a
%               sampling frequency Fc by means of a Butterworth IIR filter.
% Input       : inECG - Raw ECG
%               Fs    - Sampling frequency (Hz)
%               fc    - Cutoff frequency (Hz)
% Output      : outECG - Filtered ECG
function [outECG]=highpass_filter(inECG,Fs,fc)
    N=3;
    [b,a]=butter(N,fc*2/Fs,'high');
    outECG=filtfilt(b,a,inECG);
return;