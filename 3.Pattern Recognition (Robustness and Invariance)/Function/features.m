function [Z] = features(I,L,BF)
Z= zeros(L,1);
for i=1:1:L
    temp = I.*BF{i};
    Z(i,1) = sum(temp(:));
end
Z=abs(Z);
% Z=(Z-min(Z))/(max(Z)-min(Z));
end
