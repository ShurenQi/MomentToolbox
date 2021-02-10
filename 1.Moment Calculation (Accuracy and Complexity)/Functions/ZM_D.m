function [ output,mask ] = ZM_D(img,maxorder)
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
output=zeros(maxorder+1,2*maxorder+1);
mask=ones(maxorder+1,2*maxorder+1);
for order=0:1:maxorder
    for repetition=-order:2:order
        if repetition==0
            mask(order+1,repetition+order+1)=0;
        end
        output(order+1,repetition+order+1)=getZernikeMoment(img,rho,theta,order,repetition);
    end
end
end

function [output] = getZernikeMoment(img,rho,theta,order,repetition)
R=getRadialPoly(order,repetition,rho);       % get the radial polynomial
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
for k = 0:(n-abs(m))/2
    c = ((-1)^k)*factorial(n-k) / ...
        (factorial(k)*factorial((n+abs(m))/2-k)*factorial((n-abs(m))/2-k));
    output = output + c * rho .^ (n-2*k);
end
end % end getRadialPoly method
