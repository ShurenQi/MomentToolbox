function [ output ] = PZM_D(img,maxorder)
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
output=zeros(maxorder,maxorder);
for order=0:1:maxorder
    for repetition=-order:1:order
        output(order+1,repetition+order+1)= getPseudoZernikeMoment(img,rho,theta,order,repetition);
    end
end
end

function [output] = getPseudoZernikeMoment(img,rho,theta,order,repetition)
% R=getRadialPoly(order,repetition,rho); % get the radial polynomial DIRICT
R = PZM_pRecursive(order,repetition,rho); R = reshape(R,size(img,1),size(img,2));  % get the radial polynomial RECURSIVE
pupil =R.*exp(-1j*repetition * theta);
Product = double(img) .* pupil;
cnt = nnz(R)+1;
output = sum(Product(:))*((order+1)/pi)*(4/cnt);       % calculate the moments
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
