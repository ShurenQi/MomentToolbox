function [I,X,L,E,CE,DT] =ZM(I,K)
%% REF
% Teague M R. Image analysis via the general theory of moments. Journal of the Optical Society of America, 1980, 70(8): 920-930.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=ZM_D(I,K);
DT=toc(t1);
L=(K+1)*(K+2)/2;
E=abs(X.*mask);
CE=sum(E(:));
end

