function [I,RI,DT,RT ] =PJFM(I,K)
%% REF
%¡¡Amu G, Hasi S, Yang X, et al. Image analysis by pseudo-Jacobi (p=4, q=3)¨CFourier moments. Applied Optics, 2004, 43(10): 2093-2101.
% H. Yang, S. Qi, J. Tian, P. Niu, X. Wang, Robust and discriminative image representation: Fractional-order Jacobi-Fourier moments, Pattern Recognition.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
X=PJFM_D(I,K);
DT=toc(t1);
%% RE
t2=tic;
Y=PJFM_R(I,X,K);
RT=toc(t2);
RI=abs(Y);
end

