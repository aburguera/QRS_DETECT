% Name        : [Rind]=find_candidates(theFeatures,theThreshold)
% Description : Finds the R peak candidates within theFeatures.
% Input       : theFeatures  - Feature vector in the format provided by
%                              find_features.
%               theThreshold - |RS| must be greater than this threshold,
%                              among other criteria, to consider a
%                              candidate.
% Output      : Rind         - Indexes of the R peaks relative to
%                              theFeatures
function [Rind]=find_candidates(theFeatures,theThreshold)
    Rind=[];
    curPoint=1;
    while curPoint+3<=size(theFeatures,2)
        if isequal(theFeatures(3,curPoint:curPoint+3),[1,0,1,0])
            pqdist=abs(theFeatures(2,curPoint)-theFeatures(2,curPoint+1));
            qrdist=abs(theFeatures(2,curPoint+1)-theFeatures(2,curPoint+2));
            rsdist=abs(theFeatures(2,curPoint+2)-theFeatures(2,curPoint+3));

            if rsdist>pqdist && qrdist>pqdist && rsdist>theThreshold(curPoint)
                Rind=[Rind curPoint+2];
            end;
        end;
        curPoint=curPoint+1;
    end;
return;