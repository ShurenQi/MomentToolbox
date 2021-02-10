function [ output ] = ZM_R(img,moments,maxorder)
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
    for j=1:2:i
        order=i-1;
        repetition=-order+j-1;
        moment=moments(i,j);
        R=getRadialPoly(order,repetition,rho);       % get the radial polynomial
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end

%% Direct
% function [output] = getRadialPoly(order,repetition,rho)
% % obtain the order and repetition
% n = order;
% m = repetition;
% output = zeros(size(rho));      % initilization
% 
% % compute the radial polynomial
% for k = 0:(n-abs(m))/2
%     c = ((-1)^k)*factorial(n-k) / ...
%         (factorial(k)*factorial((n+abs(m))/2-k)*factorial((n-abs(m))/2-k));
%     output = output + c * rho .^ (n-2*k);
% end
% end % end getRadialPoly method

%% Recursive
function [output] = getRadialPoly(order,repetition,rho)
rr = rho.^2;
for p=0:1:order+1
    q = p-4;
    while q>= 0
        H3mn(p+1,q+1) = -(4*(q + 2)*(q + 1))/((p+q+2)*(p-q));
        H2mn(p+1,q+1) = H3mn(p+1,q+1)*(p+q+4)*(p-q-2)/(4*(q+3))+(q+2);
        H1mn(p+1,q+1) = (q+4)*(q+3)/2-H2mn(p+1,q+1)*(q+4)+H3mn(p+1,q+1)*(p+q+6)*(p-q-4)/8;
        q = q-2;
    end
end

for p=0:1:order+1
    q = p;
    Rn = rho.^p;
    if p>1
        Rnm2 = rho.^(p-2);
    end
    while q>= 0
        if q == p
            Rnm = Rn;
            Rnmp4 = Rn;
        elseif q == p-2
            Rnnm2 = p.*Rn-(p-1).*Rnm2;
            Rnm = Rnnm2;
            Rnmp2 = Rnnm2;
        else
            H3 = H3mn(p+1,q+1);
            H2 = H2mn(p+1,q+1);
            H1 = H1mn(p+1,q+1);
            Rnm = H1.*Rnmp4+(H2+H3./rr).*Rnmp2;
            Rnmp4 = Rnmp2;
            Rnmp2 = Rnm;
        end
        if p == order &&  q == abs(repetition)
            output = Rnm;
            break;
        end
        q = q-2;
    end
    if p == order &&  q == abs(repetition)
        break;
    end
end
end
