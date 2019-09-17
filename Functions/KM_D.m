function [ X,K ] = KM_D(img,maxorder,P)
[N, ~]  = size(img);
x       = 0:1:N-1;
K=zeros(maxorder+1,N);
W=zeros(1,N);
W(1,1)=(1-P)^N;     %xy=0
for i=1:N-1;        %xy=0:1:N-2
    xy=i-1;
    W(i+1)=((N-xy)/(xy+1))*(P/(1-P))*W(i);
end
if maxorder>=2
    K(1,:)=sqrt(W);
    K(2,:)=((P*N-x)/sqrt(P*(1-P)*N)).*K(1,:);
    for n=3:1:maxorder+1
        order=n-1;
        A = (N*P+(order-1)*(1-2*P)-x)/sqrt(P*(1-P)*order*(N-n+2));
        B = sqrt((order-1)*(N-order+2)/(order*(N-order+1))); 
        K(n,:)=A.*K(n-1,:)-B.*K(n-2,:);
    end
elseif maxorder==1
    K(1,:)=sqrt(W);
    K(2,:)=((P*N-x)/sqrt(P*(1-P)*N)).*K(1,:);
elseif maxorder==0
    K(1,:)=sqrt(W);
end
X=K*double(img)*K';
end