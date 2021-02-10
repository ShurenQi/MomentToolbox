function [I,RI,DT,RT ] =ZM(I,K)
%% REF
% Teague M R. Image analysis via the general theory of moments. Journal of the Optical Society of America, 1980, 70(8): 920-930.
% Chong C W, Raveendran P, Mukundan R. A comparative analysis of algorithms for fast computation of Zernike moments. Pattern Recognition, 2003, 36(3): 731-742.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
tic;
X=ZM_D(I,K);
DT=toc;
%% RE
tic;
Y=ZM_R(I,X,K);
RT=toc;
RI=abs(Y);
end

