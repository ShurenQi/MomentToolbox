    function [ output ] = JFM_R(img,moments,maxorder,P,Q)
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
output=zeros(N,M);
for i=1:1:maxorder+1
    order=i-1;
    R=getRadialPoly(order,rho,P,Q);       % get the radial polynomial
    for j=1:1:2*maxorder+1
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
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