function [I,X,L,E,CE,DT,p,q,alpha]=FJFM(I,K)
%% REF
% H. Yang, S. Qi, J. Tian, P. Niu, X. Wang, Robust and discriminative image representation: Fractional-order Jacobi-Fourier moments, Pattern Recognition.
%% MODE
disp('Parameter Setting: p-q>-1, q>0, alpha>0;');
disp('e.g.');
disp('- OFMM: p=2, q=2, alpha=1;');
disp('- CHFM: p=2, q=3/2, alpha=1;');
disp('- PJFM: p=4, q=3, alpha=1;');
disp('- LFM: p=1, q=1, alpha=1;');
p = input('p=');
q = input('q=');
alpha=input('alpha=');
if K<0 || p-q<=-1 || q<=0 || alpha<=0
    disp('Error!');
    return;
end
% p=5;q=5;alpha=2;
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
[X,mask]=FJFM_D(I,K,p,q,alpha);
DT=toc(t1);
L=(K+1)*(2*K+1);
E=abs(X.*mask);
CE=sum(E(:));
end

