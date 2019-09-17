function [ output ] = GPCET_D(img,maxorder,S)
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
output=zeros(2*maxorder+1,2*maxorder+1);
for order=-maxorder:1:maxorder
    for repetition=-maxorder:1:maxorder
        output(order+maxorder+1,repetition+maxorder+1)=getPolarComplexExponentialTransform(img,rho,theta,order,repetition,S);
    end
end
end

function [output] = getPolarComplexExponentialTransform(img,rho,theta,order,repetition,S)
R=getRadialPoly(order,rho,S);       % get the radial polynomial
pupil =R.*exp(-1j*repetition * theta);
Product = double(img) .* pupil;
cnt = nnz(R)+1;
output = sum(Product(:))*(1/(2*pi))*(4/cnt);       % calculate the moments
end

function [output] = getRadialPoly(order,rho,S)
% obtain the order and repetition
n = order;
% compute the radial polynomial
output=sqrt(S*rho.^(S-2)).*exp(1j*2*pi*n.*(rho.^S));
end % end getRadialPoly method
