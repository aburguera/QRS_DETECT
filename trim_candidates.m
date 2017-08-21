% Name        : function [Rind]=trim_candidates(Rind,theFeatures,Fs,maxHR)
% Description : Removes R-peak candidates that are too close to be
%               possible.
% Input       : Rind         - Indexes of R-peaks within theFeatures
%               theFeatures  - Feature vector in the format provided by
%                              find_features.
%               Fs           - ECG sampling frequency (Hz)
%               maxHR        - Maximum allowable heart rate (bpm)
% Output      : Rind         - Indexes of the corrected R peaks relative to
%                              theFeatures
function [Rind]=trim_candidates(Rind,theFeatures,Fs,maxHR)
    deleteIndexes=[];
    for i=1:length(Rind)-1
        if (theFeatures(1,Rind(i+1))-theFeatures(1,Rind(i)))<60*Fs/maxHR
            if theFeatures(2,Rind(i+1))>theFeatures(2,Rind(i))
                deleteIndexes=[deleteIndexes i];
            else
                deleteIndexes=[deleteIndexes i+1];
            end;
        end;
    end;
    Rind(deleteIndexes)=[];
return;