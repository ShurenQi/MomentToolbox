function [I,It,L,DT,RT ] =PZM(I,K)
%% REF
% Hoang, Thai V., and Salvatore Tabbone. "Errata and comments on ¡°Generic orthogonal moments: Jacobi¨CFourier moments for invariant image description¡±." Pattern Recognition 46.11 (2013): 3148-3155.
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[XX,YY]   = meshgrid(x,y);
[~, r]  = cart2pol(XX, YY);
I(r>1)=0;
%% DE
tic;
X=PZM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=PZM_R(I,X,K);
RT=toc;
It=real(Y)+imag(Y);
end

