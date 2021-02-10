function [I,X,L,E,CE,DT]=PZM(I,K)
%% REF
% Teh C H, Chin R T. On image analysis by the methods of moments. IEEE Transactions on Pattern Analysis and Machine Intelligence, 1988, 10(4): 496-513.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=PZM_D(I,K);
DT=toc(t1);
L=(K+1)^2;
E=abs(X.*mask);
CE=sum(E(:));
end

