function [ output ] = JFM_D(img,maxorder,P,Q)
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
rho(pz)     = 1;
rho(~pz)     = r(~pz); 
output=zeros(maxorder,maxorder);
for order=0:1:maxorder
    R=getRadialPoly(order,rho,P,Q);
    for repetition=-maxorder:1:maxorder
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1; 
        output(order+1,repetition+maxorder+1)=sum(Product(:))*(4/cnt)*(1/(2*pi))*(1/(factorial(order)*gamma(order+Q)*gamma(order+P)*gamma(P-Q+order+1)/(gamma(P+2*order)*gamma(P+2*order)*(P+2*order))));       % calculate the moments
    end
end
end

function [output] = getRadialPoly(order,rho,P,Q)
% obtain the order and repetition
n = order;
output = zeros(size(rho));      % initilization

% compute the radial polynomial
for s = 0:n
    c = ((-1)^s)* nchoosek(n,s)*gamma(P+2*n-s) / ...
        (gamma(Q+n-s));
    output = output + c * (rho.^(n-s));
end
output=output.*(gamma(Q+n)/gamma(P+2*n)).*sqrt(((1-rho).^(P-Q)).*(rho.^(Q-1))./rho);
end % end getRadialPoly method