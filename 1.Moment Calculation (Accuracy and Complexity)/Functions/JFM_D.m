function  [ output,mask ]  = JFM_D(img,maxorder,p,q)
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
rho(pz)     = 0.5;
rho(~pz)     = r(~pz); 
output=zeros(maxorder+1,2*maxorder+1);
mask=ones(maxorder+1,2*maxorder+1);
for order=0:1:maxorder
    R=getRadialPoly(order,rho,p,q);
    for repetition=-maxorder:1:maxorder
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1; 
        if repetition==0
            mask(order+1,repetition+maxorder+1)=0;
        end
        output(order+1,repetition+maxorder+1)=sum(Product(:))*(4/cnt)*(1/(2*pi));       % calculate the moments
    end
end
end

function [output] = getRadialPoly(order,rho,p,q)
% obtain the order and repetition
n = order;
output = zeros(size(rho));      % initilization
% compute the radial polynomial
for k = 0:n
    c = ((-1)^k)*gamma(p+n+k)/(factorial(n-k)*factorial(k)*gamma(q+k));
    output = output + c * (rho.^(k));
end
output=output.*(factorial(n)*gamma(q)/gamma(p+n)).*sqrt(((1-rho).^(p-q)).*(rho.^(q-1))./(rho*(factorial(order)*gamma(q)*gamma(q)*gamma(p-q+order+1)/(gamma(q+order)*gamma(p+order)*(p+2*order)))));
end % end getRadialPoly method