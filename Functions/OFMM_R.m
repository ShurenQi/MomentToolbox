function [ output ] = OFMM_R(img,moments,maxorder)
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
    order=i-1;
    R=getRadialPoly(order,rho);
    for j=1:1:2*maxorder+1
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

function [output] = getRadialPoly(order,rho)
% obtain the order and repetition
n = order;
t = 1;
output = zeros(size(rho));      % initilization

% compute the radial polynomial
for s = 0:n
    c = ((-1)^(n+s))*factorial(n+s+1) / ...
        (factorial(n-s)*factorial(s)*factorial(s+1));
    output = output + c * (rho .^ (t*s)).*sqrt(t).*rho.^((t-1));
end
end % end getRadialPoly method
