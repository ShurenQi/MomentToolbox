function [acc, d1] = NN(x_tr,labels, x_ts, testlabels,type)

%% Euclidean distance metric
ntest =  size(x_ts, 1);
ntrain = size(x_tr, 1);

if type==1
    d1 = sqdist(x_ts', x_tr');
else
    d1 = pdist2(x_ts,x_tr,'cosine');
end

mind = zeros(1,ntest);
for i=1:ntest
    mind(i) = min(d1(i,:));
end

for i = 1:ntest
    for j = 1:ntrain
        if d1(i,j) == mind(i)
            gnd_pred(i) = labels(j);
            break;
        end
    end
end

acc = sum(gnd_pred==testlabels')*100/ntest;
end