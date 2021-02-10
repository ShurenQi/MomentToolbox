function [I,X,L,E,CE,DT]=PCET(I,K)
%% REF
% Yap P T, Jiang X, Kot A C. Two-dimensional polar harmonic transforms for invariant image representation. IEEE Transactions on Pattern Analysis and Machine Intelligence, 2009, 32(7): 1259-1270.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=PCET_D(I,K);
DT=toc(t1);
L=(2*K+1)^2;
E=abs(X.*mask);
CE=sum(E(:));
end