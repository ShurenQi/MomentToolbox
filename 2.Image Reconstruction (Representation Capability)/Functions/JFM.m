function [I,RI,DT,RT,p,q] =JFM(I,K)
%% REF
% Ping Z, Ren H, Zou J, et al. Generic orthogonal moments: Jacobi¨CFourier moments for invariant image description. Pattern Recognition, 2007, 40(4): 1245-1254.
% H. Yang, S. Qi, J. Tian, P. Niu, X. Wang, Robust and discriminative image representation: Fractional-order Jacobi-Fourier moments, Pattern Recognition.
%% MODE
disp('Parameter Setting: p-q>-1, q>0;');
disp('e.g.');
disp('-OFMM: p=2, q=2;');
disp('-CHFM: p=2, q=3/2;');
disp('-PJFM: p=4, q=3;');
disp('-LFM: p=1, q=1');
p = input('p=');
q = input('q=');
if K<0 || p-q<=-1 || q<=0
    disp('Error!');
    return;
end
% p=5;q=5;
%% PRE
[N, M]=size(I);
x= -1+1/M:2/M:1-1/M;
y = 1-1/N:-2/N:-1+1/N;
[xx,yy]= meshgrid(x,y);
[~, r]=cart2pol(xx, yy);
I(r>1)=0;
%% DE
t1=tic;
X=JFM_D(I,K,p,q);
DT=toc(t1);
%% RE
t2=tic;
Y=JFM_R(I,X,K,p,q);
RT=toc(t2);
RI=abs(Y);
end

