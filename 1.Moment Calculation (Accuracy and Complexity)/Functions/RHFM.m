function [I,X,L,E,CE,DT]=RHFM(I,K)
%% REF
%	Ren H, Ping Z, Bo W, et al. Multidistortion-invariant image recognition with radial harmonic Fourier moments. Journal of the Optical Society of America A, 2003, 20(4): 631-637.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=RHFM_D(I,K);
DT=toc(t1);
L=(K+1)*(2*K+1);
E=abs(X.*mask);
CE=sum(E(:));
end
