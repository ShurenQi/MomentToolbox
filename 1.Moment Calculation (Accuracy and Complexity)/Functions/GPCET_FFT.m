function [I,X,L,E,CE,DT,alpha]=GPCET_FFT(I,K)
%% REF
%	Yang H, Qi S, Niu P, et al. Color image zero-watermarking based on fast quaternion generic polar complex exponential transform. Signal Processing: Image Communication, 2020, 82: 115747.
%% MODE
disp('Parameter Setting: alpha>0;');
disp('e.g.');
disp('- PCET: alpha=2;');
disp('- EFM: alpha=1;');
alpha=input('alpha=');
if alpha<=0
    disp('Error!');
    return;
end
% alpha=1;
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=GPCET_FFT_D(I,K,alpha);
DT=toc(t1);
L=(2*K+1)^2;
E=abs(X.*mask);
CE=sum(E(:));
end