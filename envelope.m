% Name        : [t,b]=envelope(theFeatures,Fs)
% Description : Finds the top (t) and bottom (b) envelope of theFeatures.
% Input       : theFeatures - Feature vector in the format provided by
%                             find_features.
%               Fs          - Sampling frequency (Hz)
% Output      : t           - top envelope
%               b           - bottom envelope
function [t,b]=envelope(theFeatures,Fs)
    newFeatures=[theFeatures(1,:);theFeatures(2,:).*theFeatures(2,:).*sign(theFeatures(2,:));theFeatures(3,:)];

    tmpSize=.5*Fs;
    meanStep=mean(diff(theFeatures(1,:)));
    winSize=round(tmpSize/meanStep);

    [it,ib,kt,kb]=compute_envelope_nodes(newFeatures,winSize);
    if (kb<size(newFeatures,2)*0.025)
        b=contingency_plan(theFeatures,winSize,0);
        disp('[WARNING] Contingeny BOTTOM ENVELOPE used');
    else
        b=interp1(theFeatures(1,ib(1:kb)),theFeatures(2,ib(1:kb)),theFeatures(1,:),'linear','extrap');
    end;
    if (kt<size(newFeatures,2)*0.025)
        t=contingency_plan(theFeatures,winSize,1);
        disp('[WARNING] Contingeny TOP ENVELOPE used');
    else
        t=interp1(theFeatures(1,it(1:kt)),theFeatures(2,it(1:kt)),theFeatures(1,:),'linear','extrap');
    end;
return;

% The "contingency plan" for cases in which not enough outliers exist to
% build the envelope node list.
function [v]=contingency_plan(theFeatures,winSize,theType)
    nFeatures=size(theFeatures,2);
    v=zeros(1,nFeatures);
    for i=1:nFeatures
        lBound=max(1,i-winSize);
        rBound=min(nFeatures,i+winSize);
        if theType==0
            v(i)=min(theFeatures(2,lBound:rBound));
        else
            v(i)=max(theFeatures(2,lBound:rBound));
        end;
    end;
return;