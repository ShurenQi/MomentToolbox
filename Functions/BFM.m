function [I,It,L,DT,RT,V ] =BFM(I,K)
%% REF
% Xiao, Bin, Jian-Feng Ma, and Xuan Wang. "Image analysis by Bessel–Fourier moments." Pattern Recognition 43.8 (2010): 2620-2629.
% Hoang, Thai V., and Salvatore Tabbone. "Fast generic polar harmonic transforms." IEEE Transactions on Image Processing 23.7 (2014): 2961-2971.
%% MODE
V = 1; %如改变V的值需要根据基函数图像改写ST=Roots(1,i-1)+3;
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=BFM_D(I,K,V);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=BFM_R(I,X,K,V);
RT=toc;
It=abs(Y);
end

