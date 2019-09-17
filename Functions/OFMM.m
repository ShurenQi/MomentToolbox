function [I,It,L,DT,RT ] =OFMM(I,K)
%% REF
% Yap, Pew-Thian, Xudong Jiang, and Alex Chichung Kot. "Two-dimensional polar harmonic transforms for invariant image representation." IEEE Transactions on Pattern Analysis and Machine Intelligence 32.7 (2010): 1259-1270.
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=OFMM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=OFMM_R(I,X,K);
RT=toc;
It=abs(Y);
end

