function [ output ] = PJFM_D(img,maxorder)
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
    for repetition=-maxorder:1:maxorder
        output(order+1,repetition+maxorder+1)=getPseudoJacobiFourierMoments(img,rho,theta,order,repetition);
    end
end
end

function [output] = getPseudoJacobiFourierMoments(img,rho,theta,order,repetition)
R=getRadialPoly(order,rho);       % get the radial polynomial
pupil =R.*exp(-1j*repetition * theta);
Product = double(img) .* pupil;
cnt = nnz(R)+1;
output = sum(Product(:))*(4/cnt)*(1/(2*pi));       % calculate the moments
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