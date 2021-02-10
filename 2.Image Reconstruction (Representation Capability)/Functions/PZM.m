function [I,RI,DT,RT ] =PZM(I,K)
%% REF
% Teh C H, Chin R T. On image analysis by the methods of moments. IEEE Transactions on Pattern Analysis and Machine Intelligence, 1988, 10(4): 496-513.
% Al-Rawi M S. Fast computation of pseudo Zernike moments. Journal of Real-Time Image Processing, 2010, 5(1): 3-10.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
tic;
X=PZM_D(I,K);
DT=toc;
%% RE
tic;
Y=PZM_R(I,X,K);
RT=toc;
RI=abs(Y);
end

