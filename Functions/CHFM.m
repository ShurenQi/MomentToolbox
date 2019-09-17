function [I,It,L,DT,RT ] =CHFM(I,K)
%% REF
%¡¡Jiang, Yongjing, Ziliang Ping, and Laibin Gao. "A fast algorithm for computing Chebyshev-Fourier moments." Future Information Technology and Management Engineering (FITME), 2010 International Conference on. Vol. 2. IEEE, 2010.
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=CHFM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=CHFM_R(I,X,K);
RT=toc;
It=abs(Y);
end

