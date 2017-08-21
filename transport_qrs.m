% Name        : [Rdata]=transport_qrs(ecg,theFeatures,Rind)
% Description : Given QRS estimates expressed with Rind and theFeatures,
%               outputs the R peaks with sample accuracy over the original
%               ECG.
% Input       : ecg          - The ECG to use (usually, the original raw
%                              ECG).
%               theFeatures  - Feature vector in the format provided by
%                              find_features.
%               Rind         - Indexes of R-peaks within theFeatures
% Output      : Rdata        - The corrected R-peaks. First row contains
%                              an index relative to ecg and the second row,
%                              the value (equivalent to ecg(Rdata(1,:))).
function [Rdata]=transport_qrs(ecg,theFeatures,Rind)
    Rdata=zeros(2,length(Rind));
    for i=1:length(Rind)
        il=theFeatures(1,Rind(i)-1);
        ir=theFeatures(1,Rind(i)+1);
        [v,p]=max(ecg(il:ir));
        Rdata(:,i)=[p+il-1;v];
    end;
return;