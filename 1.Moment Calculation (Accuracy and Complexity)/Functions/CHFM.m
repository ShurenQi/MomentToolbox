function [I,X,L,E,CE,DT] =CHFM(I,K)
%% REF
%¡¡Ping Z, Wu R, Sheng Y. Image description with Chebyshev¨CFourier moments. Journal of the Optical Society of America A, 2002, 19(9): 1748-1754.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=CHFM_D(I,K);
DT=toc(t1);
L=(K+1)*(2*K+1);
E=abs(X.*mask);
CE=sum(E(:));
end

