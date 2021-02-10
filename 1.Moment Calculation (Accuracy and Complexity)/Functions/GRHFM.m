function [I,X,L,E,CE,DT,alpha]=GRHFM(I,K)
%% REF
%	Hoang T V, Tabbone S. Generic polar harmonic transforms for invariant image representation. Image and Vision Computing, 2014, 32(8): 497-509.
%% MODE
disp('Parameter Setting: alpha>0;');
disp('e.g.');
disp('- RHFM: alpha=1;');
alpha=input('alpha=');
if alpha<=0
    disp('Error!');
    return;
end
% alpha=2;
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=GRHFM_D(I,K,alpha);
DT=toc(t1);
L=(K+1)*(2*K+1);
E=abs(X.*mask);
CE=sum(E(:));
end
