function [I,X,L,E,CE,DT]=EFM(I,K)
%% REF
% Hu H, Zhang Y, Shao C, et al. Orthogonal moments based on exponent functions: Exponent-Fourier moments. Pattern Recognition, 2014, 47(8): 2596-2606.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=EFM_D(I,K);
DT=toc(t1);
L=(2*K+1)^2;
E=abs(X.*mask);
CE=sum(E(:));
end