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
rho(pz)     = 0.5;
rho(~pz)     = r(~pz);
output=zeros(maxorder,maxorder);
for order=0:1:maxorder
    for repetition=-order:1:order
        R=getRadialPoly(order,repetition,rho); % get the radial polynomial
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1;
        output(order+1,repetition+order+1)= sum(Product(:))*((order+1)/pi)*(4/cnt);       % calculate the moments;
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
% for s = 0:(n-abs(m))
%     c = (-1)^s*factorial(2*n+1-s) / ...
%         (factorial(s)*factorial(n+abs(m)-s+1)*factorial(n-abs(m)-s));
%     output = output + c * rho .^ (n-s);
% end
% end % end getRadialPoly method

%% Recursive
function [output] =  getRadialPoly(order,repetition,rho)
N=size(rho,1); M=size(rho,2);
repetition=abs(repetition);
rho=rho(:); 
output = zeros(order+1, length(rho) );
if rho==0 
    if repetition==0
        output( (0:order)+1,:)= 1;
    else
        output( (0:order)+1,:) = 0;
    end
    output=reshape(output,N,M);
    return;
end
q=repetition; p = order;
output(q +1,:) = rho.^q;
if q==p
    output=output(end,:);
    output=reshape(output,N,M);
    return;
end
if q == p-1   
    Rpp=rho.^p; 
    output(p +1,:)=(2*p+1)*Rpp - 2*p*rho.^q;
    output=output(end,:);
    output=reshape(output,N,M);
    return;
end
p=q+1;
Rpp=rho.^p; 
output(p +1,:)=(2*p+1)*Rpp - 2*p*rho.^q; 
q2=q+2;
for p = q2:order
    L1 = ((2*p+1)*2*p)/((p+q +1.0)*(p-q));
    L2 = -2*p + L1*((p+q)*(p-q-1))/(2.0*p-1);
    L3 = (2*p-1)*(p-1)-  L1*(p+q-1)*(p-q-2)/2.0   + 2*(p-1)*L2;    
    output(p +1,:) = (L1*rho+L2)'.*output(p-1 +1,:) + L3*output(p-2 +1,:);
end
output=output(end,:);
output=reshape(output,N,M);
end






