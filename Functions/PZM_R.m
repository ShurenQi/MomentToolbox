function [ output ] = PZM_R(img,moments,maxorder)
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
rho(pz)     = 0.2;
rho(~pz)     = r(~pz);
output=zeros(N,M);
for i=1:1:maxorder+1
    for j=1:1:i
        order=i-1;
        repetition=-order+j-1;
        moment=moments(i,j);
%         R=getRadialPoly(order,repetition,rho); % get the radial polynomial DIRICT
        R = PZM_pRecursive(order,repetition,rho); R = reshape(R,size(rho,1),size(rho,1));% get the radial polynomial RECURSIVE
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

function [output] = getRadialPoly(order,repetition,rho)
% obtain the order and repetition
n = order;
m = repetition;
output = zeros(size(rho));      % initilization

% compute the radial polynomial
for s = 0:(n-abs(m))
    c = (-1)^s*factorial(2*n+1-s) / ...
        (factorial(s)*factorial(n+abs(m)-s+1)*factorial(n-abs(m)-s));
    output = output + c * rho .^ (n-s);
end
end % end getRadialPoly method
