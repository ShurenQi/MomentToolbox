function [I,It,L,DT,RT,S ] =GPCET(I,K)
%% REF
% Thai V. Hoang, Salvatore Tabbone. Fast generic polar harmonic transforms. IEEE Transactions on Image Processing, Institute of Electrical and Electronics Engineers, 2014, 23 (7), pp.2961 - 2971.
%% MODE
disp('Exponent-Fourier Moments (S=1); Polar Complex Exponential Transform (S=2);')
S = input('S=');
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=GPCET_D(I,K,S);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=GPCET_R(I,X,K,S);
RT=toc;
It=abs(Y);
end

