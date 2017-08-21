% Name        : [theFeatures]=find_features(inData)
% Description : Finds peaks and valleys in the input data.
% Input       : inData - Filtered ECG. 1xN vector with N samples.
% Output      : theFeatures - 3xM vector.
%               Row 1: Feature index relative to inData.
%               Row 2: Feature value. Equivalent to inData(theFeatures(1))
%               Row 3: Feature type. 0: Valley. 1: Peak
function [theFeatures]=find_features(inData)
    theFeatures=[];
    for i=2:length(inData)-1
        condPeak=inData(i)>inData(i-1) && inData(i)>inData(i+1);
        condValley=inData(i)<inData(i-1) && inData(i)<inData(i+1);
        if condPeak || condValley
            theFeatures=[theFeatures [i;inData(i);condPeak*1]];
        end;
    end;
return;