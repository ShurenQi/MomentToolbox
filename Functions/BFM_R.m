function [ output ] = BFM_R(img,moments,maxorder,V)
[N, M]  = size(img);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[th, r]  = cart2pol(X, Y);
pz=th<0;
theta =zeros(N,M);
theta(pz)     = th(pz) + 2*pi;
theta(~pz)     = th(~pz);
pz=r>1;
rho =zeros(N,M);
rho(pz)     = 10000;
rho(~pz)     = r(~pz);
output=zeros(N,M);
Roots=zeros(1,maxorder+2);
syms x;
Roots(1,1)=vpasolve(besselj(V, x) == 0, x);
for i=2:1:maxorder+2
    Roots(1,i)=vpasolve(besselj(V, x) == 0, Roots(1,i-1)+3);
end
for i=1:1:maxorder+1
    for j=1:1:2*maxorder+1
        order=i-1;
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        R=getRadialPoly(order,rho,V,Roots);       % get the radial polynomial
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

function [output] = getRadialPoly(order,rho,V,Roots)
% obtain the order and repetition
n = order;
% compute the radial polynomial
rho=rho*Roots(n+2);
output=besselj(V,rho);
end % end getRadialPoly method
