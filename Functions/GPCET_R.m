function [ output ] = GPCET_R(img,moments,maxorder,S)
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
for i=1:1:2*maxorder+1
    for j=1:1:2*maxorder+1
        order=-maxorder+i-1;
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        R=getRadialPoly(order,rho,S);       % get the radial polynomial
        pupil =conj(R).*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

function [output] = getRadialPoly(order,rho,S)
% obtain the order and repetition
n = order;
% compute the radial polynomial
output=sqrt(S*rho.^(S-2)).*exp(1j*2*pi*n.*(rho.^S));
end % end getRadialPoly method

