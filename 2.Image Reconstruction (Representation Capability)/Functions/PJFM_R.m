function [ output ] = PJFM_R(img,moments,maxorder)
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
output=zeros(N,M);
for i=1:1:maxorder+1
    for j=1:1:2*maxorder+1
        order=i-1;
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        R=getRadialPoly(order,rho);       % get the radial polynomial
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

%% Direct
% function [output] = getRadialPoly(order,rho)
% % obtain the order and repetition
% n = order;
% output = zeros(size(rho));      % initilization
% 
% % compute the radial polynomial
% for k = 0:n
%     c = ((-1)^(n+k))*factorial(n+k+3) / ...
%         (factorial(n-k)*factorial(k)*factorial(k+2));
%     output = output + c * rho .^ (k);
% end
% output=output.*sqrt((2*n+4)*(rho-rho.^2)/((n+3)*(n+1)));
% end % end getRadialPoly method

%% Recursive
function [output] = getRadialPoly(order,rho)
% obtain the order
n = order;
p = 4; q = 3; alpha = 1;
% PN
if n>=2
    P0=(gamma(p)/gamma(q))*ones(size(rho));
    P1=(gamma(p+1)/gamma(q))*(1-((p+1)/q)*(rho.^alpha));
    PN1=P1;PN2=P0;
    for k = 2:n
        L1=-((2*k+p-1)*(2*k+p-2))/(k*(q+k-1));
        L2=(p+2*k-2)+(((k-1)*(q+k-2)*L1)/(p+2*k-3));
        L3=((p+2*k-4)*(p+2*k-3)/2)+((q+k-3)*(k-2)*L1/2)-((p+2*k-4)*L2);
        PN=(L1*(rho.^alpha)+L2).*PN1+L3.*PN2;
        PN2=PN1;
        PN1=PN;
    end
elseif n==1
    PN=(gamma(p+1)/gamma(q))*(1-((p+1)/q)*(rho.^alpha));
elseif n==0
    PN=(gamma(p)/gamma(q))*ones(size(rho));
end

%AN
if n>=1
    A0=sqrt(gamma(q)/(gamma(p)*gamma(p-q+1)));
    AN1=A0;
    for k = 1:n
        AN=sqrt(k*(q+k-1)/((p+k-1)*(p-q+k)))*AN1;
        AN1=AN;
    end
elseif n==0
    AN=sqrt(gamma(q)/(gamma(p)*gamma(p-q+1)));
end

output=sqrt((p+2*n)*alpha*((1-rho.^alpha).^(p-q)).*(rho.^(alpha*q-1))./rho)*AN.*PN;

end % end getRadialPoly method