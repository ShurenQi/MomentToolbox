function [ X,P ] = TM_D(img,maxorder)
[N, ~]  = size(img);
x       = 0:1:N-1;
P=zeros(maxorder+1,N);
if maxorder>=2
    P(1,:)=ones(1,N);
    P(2,:)=(2*x+1-N)/N;
    for n=3:1:maxorder+1
        order=n-1;
        P(n,:)=((P(2,:).*(2*order-1).*(P(n-1,:)))-((order-1).*(1-((order-1)^2/(N^2))).*(P(n-2,:))))./(order);
    end
elseif maxorder==1
    P(1,:)=ones(1,N);
    P(2,:)=(2*x+1-N)/N;
elseif maxorder==0
    P(1,:)=ones(1,N);
end
WP=P;
for n=1:1:maxorder+1
    order=n-1;
    temp=1;
    for i=1:1:order
        temp=temp*(1-(i/N)^2);
    end
    rho=N*temp/(2*order+1);
    WP(n,:)=P(n,:)/rho;
end
X=WP*double(img)*WP';
end