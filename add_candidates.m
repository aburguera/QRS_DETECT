% Name        : [Rind]=add_candidates(Rind,theFeatures,Fs,minHR)
% Description : Adds R-peak candidates between R-peaks that are too far
%               away to be possible.
% Input       : Rind         - Indexes of R-peaks within theFeatures
%               theFeatures  - Feature vector in the format provided by
%                              find_features.
%               Fs           - ECG sampling frequency (Hz)
%               minHR        - Minimum allowable heart rate (bpm)
% Output      : Rind         - Indexes of the corrected R peaks relative to
%                              theFeatures
function [Rind]=add_candidates(Rind,theFeatures,Fs,minHR)
    addValues=[];
    for i=1:length(Rind)-1
        if (theFeatures(1,Rind(i+1))-theFeatures(1,Rind(i)))>60*Fs/minHR
            [~,j]=max(theFeatures(2,Rind(i)+1:Rind(i+1)-1));
            addValues=[addValues j+Rind(i)+1-1];
        end;
    end;
    Rind=[Rind addValues];
    [~,i]=sort(theFeatures(1,Rind),'ascend');
    Rind=Rind(i);
return;