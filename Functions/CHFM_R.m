function [ output ] = CHFM_R(img,moments,maxorder)
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
for i=1:1:maxorder+1
    for j=1:1:2*maxorder+1
        order=i-1;
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        R=getRadialPoly(order,rho);       % get the radial polynomial
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

function [output] = getRadialPoly(order,rho)
% obtain the order and repetition
n = order;
output = zeros(size(rho));      % initilization

% compute the radial polynomial
for s = 0:floor(n/2)
    c = ((-1)^s)*factorial(n-s) / ...
        (factorial(s)*factorial(n-2*s));
    output = output + c * (4*rho-2) .^ (n-2*s);
end
output=output.*(((1-rho)./rho).^(1/4));
end % end getRadialPoly method