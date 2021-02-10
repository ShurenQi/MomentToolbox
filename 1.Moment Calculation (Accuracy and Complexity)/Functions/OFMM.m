function  [I,X,L,E,CE,DT]  =OFMM(I,K)
%% REF
% Sheng Y, Shen L. Orthogonal Fourier-Mellin moments for invariant pattern recognition. Journal of the Optical Society of America A, 1994, 11(6): 1748-1757.
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=OFMM_D(I,K);
DT=toc(t1);
L=(K+1)*(2*K+1);
E=abs(X.*mask);
CE=sum(E(:));
end

