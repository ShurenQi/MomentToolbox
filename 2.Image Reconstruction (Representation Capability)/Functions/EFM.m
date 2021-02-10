function [I,RI,DT,RT]=EFM(I,K)
%% REF
% Hu H, Zhang Y, Shao C, et al. Orthogonal moments based on exponent functions: Exponent-Fourier moments. Pattern Recognition, 2014, 47(8): 2596-2606.
% Yang H, Qi S, Niu P, et al. Color image zero-watermarking based on fast quaternion generic polar complex exponential transform. Signal Processing: Image Communication, 2020, 82: 115747.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
X=EFM_D(I,K);
DT=toc(t1);
%% RE
t2=tic;
Y=EFM_R(I,X,K);
RT=toc(t2);
RI=abs(Y);
end