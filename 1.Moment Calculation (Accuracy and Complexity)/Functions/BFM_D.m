function  [ output,mask ]= BFM_D(img,maxorder,V)
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
Roots=zeros(1,maxorder+2);
syms x;
Roots(1,1)=vpasolve(besselj(V, x) == 0, x);
for i=2:1:maxorder+2
    ST=Roots(1,i-1)+3; %依赖观察法，随V改变。
    Roots(1,i)=vpasolve(besselj(V, x) == 0, ST);
end
for order=0:1:maxorder
    R=getRadialPoly(order,rho,V,Roots);       % get the radial polynomial
    for repetition=-maxorder:1:maxorder
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1;
        if repetition==0
            mask(order+1,repetition+maxorder+1)=0;
        end
        output(order+1,repetition+maxorder+1)=sum(Product(:))*(1/(pi*(besselj(V+1,Roots(order+2)))^2))*(4/cnt);
    end
end
end

function [output] = getRadialPoly(order,rho,V,Roots)
% obtain the order and repetition
n = order;
% compute the radial polynomial
rho=rho*Roots(n+2);
output=besselj(V,rho);
end % end getRadialPoly method
