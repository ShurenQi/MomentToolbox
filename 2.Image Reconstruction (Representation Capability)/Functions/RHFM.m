function [I,RI,DT,RT]=RHFM(I,K)
%% REF
%	Ren H, Ping Z, Bo W, et al. Multidistortion-invariant image recognition with radial harmonic Fourier moments. Journal of the Optical Society of America A, 2003, 20(4): 631-637.
%	Yang H, Qi S, Niu P, et al. Color image zero-watermarking based on fast quaternion generic polar complex exponential transform. Signal Processing: Image Communication, 2020, 82: 115747.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
X=RHFM_D(I,K);
DT=toc(t1);
%% RE
t2=tic;
Y=RHFM_R(I,X,K);
RT=toc(t2);
RI=abs(Y);
end