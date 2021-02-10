function [I,RI,DT,RT,v] =BFM(I,K)
%% REF
% Xiao B, Ma J, Wang X. Image analysis by Bessel¨CFourier moments. Pattern Recognition, 2010, 43(8): 2620-2629.
%% MODE
v = 1; %ST=Roots(1,i-1)+3;
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
X=BFM_D(I,K,v);
DT=toc(t1);
%% RE
t2=tic;
Y=BFM_R(I,X,K,v);
RT=toc(t2);
RI=abs(Y);
end

