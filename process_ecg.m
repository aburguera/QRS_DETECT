% Name        : [Rdata,cecg]=process_ecg(ecg,Fs)
% Description : Performe ECG compression and QRS detection.
% Input       : ecg   - Raw ECG. 1xN vector, where each item is an ECG
%               sample.
%               Fs    - ECG Sampling frequency (Hz)
% Output      : Rdada - Detected R-peaks. 2xM vector, where the first row
%                       contains the sample number where the R-peak occured
%                       and the second column contains the corresponding
%                       sample value. Note that the second column is
%                       equivalent to ecg(Rdata(1,:))
%               cecg  - Compressed ECG. 2xP vector, where the first row
%                       contains the sample number of each feature and the
%                       second row contains the sample value. Note that the
%                       second column is equivalent to ecg(cecg(1,:))
% Author      : Antoni Burguera Burguera
%               antoni.burguera@uib.es
% Note        : Please, refer to the README.TXT file for information about
%               how to properly cite us if you use this software.
function [Rdata,cecg]=process_ecg(ecg,Fs)
    % Parameter values
    Fc=5;      % Cutoff frequency (Hz) for high-pass filter.
    maxHR=210; % Maximum allowable heart rate (bpm)
    minHR=30;  % Minimum allowable heart rate (bpm)
    % Check ecg basic errors
    if size(ecg,2)==1
        ecg=ecg';
    end;
    if (size(ecg,1)~=1)
        error('[ERROR] ECG must have one single signal');
    end;
    % Detrend
    filteredECG=highpass_filter(ecg,Fs,Fc);
    % Smooth (Moving Linear Regression)
    smoothedECG=smooth_signal(filteredECG,8);
    % Find peaks and valleys
    [theFeatures]=find_features(smoothedECG);
    % Filter peaks and valleys
    theFeatures=filter_by_proximity(theFeatures,Fs);
    % Compute the envelope.
    [t,b]=envelope(theFeatures,Fs);
    %[t,~,b]=envelope2(theFeatures,Fs);
    % Compute the R-peak candidates
    Rind=find_candidates(theFeatures,(t-b)*0.5);
    % Optimize according to maximum and minimum heart rates
    newR=[];
    iterCount=0;
    while (~isequal(Rind,newR) && iterCount<50)
        newR=Rind;
        Rind=trim_candidates(Rind,theFeatures,Fs,maxHR);
        Rind=add_candidates(Rind,theFeatures,Fs,minHR);
        iterCount=iterCount+1;
    end;
    % Adjust R-peaks to the original ECG
    Rdata=transport_qrs(ecg,theFeatures,Rind);
    % Adjust the features to build the final compressed ECG
    cecg=adjust_cecg(ecg,theFeatures);
return;