function [ output ] = OFMM_D(img,maxorder)
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
output=zeros(maxorder,maxorder);
for order=0:1:maxorder
    R=getRadialPoly(order,rho); 
    for repetition=-maxorder:1:maxorder
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1;
        output(order+1,repetition+maxorder+1)=sum(Product(:))*((2*(order+1))/(2*pi))*(4/cnt);
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
