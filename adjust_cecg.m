function [cecg]=adjust_cecg(ecg,theFeatures)
    cecg=zeros(2,size(theFeatures,2));
    for i=2:size(theFeatures,2)-1
        lb=theFeatures(1,i-1);
        rb=theFeatures(1,i+1);
        if theFeatures(3,i)==0
            [v,p]=min(ecg(lb:rb));
        else
            [v,p]=max(ecg(lb:rb));
        end;
        cecg(1,i)=p+lb-1;
        cecg(2,i)=v;
    end;
    cecg(:,1)=[];
    cecg(:,end)=[];
    [~,i]=sort(cecg(1,:),'ascend');
    cecg=cecg(:,i);
    i=find(diff(cecg(1,:))==0);
    cecg(:,i)=[];
return;