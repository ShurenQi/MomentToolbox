function [ output ] = PJFM_R(img,moments,maxorder)
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
for k = 0:n
    c = ((-1)^(n+k))*factorial(n+k+3) / ...
        (factorial(n-k)*factorial(k)*factorial(k+2));
    output = output + c * rho .^ (k);
end
output=output.*sqrt((2*n+4)*(rho-rho.^2)/((n+3)*(n+1)));
end % end getRadialPoly method