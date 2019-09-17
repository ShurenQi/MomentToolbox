function [I,It,L,DT,RT,P,Q ] =JFM(I,K)
%% REF
% Hoang, Thai V., and Salvatore Tabbone. "Errata and comments on ¡°Generic orthogonal moments: Jacobi¨CFourier moments for invariant image description¡±." Pattern Recognition 46.11 (2013): 3148-3155.
%% MODE
disp('-ZM: P=|m|+1, Q=|m|+1;');
disp('-PZM: P=2|m|+2, Q=2|m|+2;');
disp('-OFMM: P=2, Q=2;');
disp('-CHFM: P=2, Q=3/2;');
disp('-PJFM: P=4, Q=3;');
disp('-LFM: P=1, Q=1');
disp('Constraints: (P-Q>-1, Q>0).');
P = input('P=');
Q = input('Q=');
%% PRE
[N, M]  = size(I);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[~, r]  = cart2pol(X, Y);
I(r>1)=0;
%% DE
tic;
X=JFM_D(I,K,P,Q);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=JFM_R(I,X,K,P,Q);
RT=toc;
It=abs(Y);
end

