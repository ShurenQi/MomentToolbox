function [ output ] = GRHFM_R(img,moments,maxorder,alpha)
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
    order=i-1;
    if order==0
        R=sqrt(alpha*rho.^(alpha-2));
    elseif mod(order,2)==1
        R=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*sin(pi*(order+1).*rho.^alpha);
    else
        R=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*cos(pi*order.*rho.^alpha);
    end
    for j=1:1:2*maxorder+1
        repetition=-maxorder+j-1;
        moment=moments(i,j);
        pupil =R.*exp(1j*repetition * theta);
        output=output+moment*pupil;
        output(r>1)=0;
    end
end
end