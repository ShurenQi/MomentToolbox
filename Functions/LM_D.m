function [ X,P ] = LM_D(img,maxorder)
[N, ~]  = size(img);
x       = -1+1/N:2/N:1-1/N;
P=zeros(maxorder+1,N);
if maxorder>=2
    P(1,:)=ones(1,N);
    P(2,:)=x;
    for n=3:1:maxorder+1
        order=n-1;
        P(n,:)=((x.*(2*order-1).*(P(n-1,:)))-((order-1).*(P(n-2,:))))./(order);
    end
elseif maxorder==1
    P(1,:)=ones(1,N);
    P(2,:)=x;
elseif maxorder==0
    P(1,:)=ones(1,N);
end
WP=P;
for n=1:1:maxorder+1
    order=n-1;
    WP(n,:)=P(n,:)*(2*order+1);
end
X=WP*double(img)*WP';
X=X./N^2;
end