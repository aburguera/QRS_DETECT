% Name        : [theFeatures]=filter_by_proximity(theFeatures,Fs)
% Description : Filters features that are too close.
% Input       : theFeatures - Feature vector in the format provided by
%                             find_features.
%               Fs          - Sampling frequency (Hz)
% Output      : theFeatures - Filtered feature set, in the same format as
%                             the input features.
function [theFeatures]=filter_by_proximity(theFeatures,Fs)
    theIndexes=find(diff([0 diff(theFeatures(1,:))<0.03*Fs])~=0);
    if length(theIndexes)<2
        return;
    end;
    if mod(length(theIndexes),2)~=0
        theIndexes=[theIndexes size(theFeatures,2)];
    end;
    % Put the indexes in the following format
    % Row 1 : Start index of too-close features
    % Row 2 : End index of too-close features
    theIndexes=reshape(theIndexes,2,length(theIndexes)/2);
    for i=1:size(theIndexes,2)
        intervalLength=theIndexes(2,i)-theIndexes(1,i);
        % If two elements (valley-peak or peak-valley), just remove them.
        if intervalLength==1
            theFeatures(3,theIndexes(1,i):theIndexes(2,i))=2;
        % If three elements or more, check the cases
        elseif intervalLength>1
            curFeatures=theFeatures(:,theIndexes(1,i):theIndexes(2,i));
            % If the interval begins and ends with a valley
            if curFeatures(3,1)==0 && curFeatures(3,end)==0
                % Substitute the interval by a single valley located
                % at the position of the lowest value of the interval.
                [newY,tmp]=min(curFeatures(2,:));
                newX=curFeatures(1,tmp);
                newT=0;
                theFeatures(3,theIndexes(1,i):theIndexes(2,i))=2;
                theFeatures(:,theIndexes(1,i))=[newX;newY;newT];
            % If the interval begins with valley and ends with peak
            elseif curFeatures(3,1)==0 && curFeatures(3,end)==1
                % Put a valley with the minimum value at the beginning of
                % the interval, a peak with the maximum value at the end
                % and remove the remaining items.
                newY0=min(curFeatures(2,:));
                newX0=curFeatures(1,1);
                newT0=0;
                newY1=max(curFeatures(2,:));
                newX1=curFeatures(1,end);
                newT1=1;
                theFeatures(3,theIndexes(1,i):theIndexes(2,i))=2;
                theFeatures(:,theIndexes(1,i))=[newX0;newY0;newT0];
                theFeatures(:,theIndexes(1,i)+1)=[newX1;newY1;newT1];
            % If the interval begins with a peak and ends with a valley
            elseif curFeatures(3,1)==1 && curFeatures(3,end)==0
                % Put a peak with the maximum value at the beginning of
                % the interval, a valley with the minimum value at the end
                % and remove the remaining items.
                newY0=max(curFeatures(2,:));
                newX0=curFeatures(1,1);
                newT0=1;
                newY1=min(curFeatures(2,:));
                newX1=curFeatures(1,end);
                newT1=0;
                theFeatures(3,theIndexes(1,i):theIndexes(2,i))=2;
                theFeatures(:,theIndexes(1,i))=[newX0;newY0;newT0];
                theFeatures(:,theIndexes(1,i)+1)=[newX1;newY1;newT1];
            % If the interval begins and ends with a peak
            elseif curFeatures(3,1)==1 && curFeatures(3,end)==1
                % Substitute the interval by a single peak located
                % at the position of the highest value of the interval.
                [newY,tmp]=max(curFeatures(2,:));
                newX=curFeatures(1,tmp);
                newT=1;
                theFeatures(3,theIndexes(1,i):theIndexes(2,i))=2;
                theFeatures(:,theIndexes(1,i))=[newX;newY;newT];
            end;
        end;
    end;
    i=find(theFeatures(3,:)==2);
    theFeatures(:,i)=[];
return;