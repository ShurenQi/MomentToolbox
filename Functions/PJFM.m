function [I,It,L,DT,RT ] =PJFM(I,K)
%% REF
%¡¡G. Amu, S. Hasi, X. Yang, and Z. Ping, ¡°Image analysis by pseudo-Jacobi (p = 4, q =3)¨CFourier moments,¡± Applied Optics, vol. 43, no. 10, pp. 2093¨C2101, 2004..
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=PJFM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=PJFM_R(I,X,K);
RT=toc;
It=abs(Y);
end

