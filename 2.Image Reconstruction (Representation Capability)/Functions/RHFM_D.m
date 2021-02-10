%% Direct
% function [ output ] = RHFM_D(img,maxorder)
% [N, M]  = size(img);
% x       = -1+1/M:2/M:1-1/M;
% y       = 1-1/N:-2/N:-1+1/N;
% [X,Y]   = meshgrid(x,y);
% [th, r]  = cart2pol(X, Y);
% pz=th<0;
% theta =zeros(N,M);
% theta(pz)     = th(pz) + 2*pi;
% theta(~pz)     = th(~pz);
% pz=r>1;
% rho =zeros(N,M);
% rho(pz)     = 0.5;
% rho(~pz)     = r(~pz); 
% output=zeros(maxorder+1,2*maxorder+1);
% for order=0:1:maxorder
%     if order==0
%         R=sqrt(rho.^(-1));
%     elseif mod(order,2)==1
%         R=sqrt(rho.^(-1)).*sqrt(2).*sin(pi*(order+1).*rho);
%     else
%         R=sqrt(rho.^(-1)).*sqrt(2).*cos(pi*order.*rho);
%     end
%     for repetition=-maxorder:1:maxorder
%         pupil =R.*exp(-1j*repetition * theta);
%         Product = double(img) .* pupil;
%         cnt = nnz(R)+1;
%         output(order+1,repetition+maxorder+1)=sum(Product(:))*(1/(2*pi))*(4/cnt);
%     end
% end
% end

%% FFT-based
function [ output ]= RHFM_D(img,maxorder)
alpha = 1;
img = double(img);
[N,~] = size(img);
M=10*N;
G = zeros(M,M);
for u = 1:M
    for v = 1:M
        rho = ((u-1)/M)^(1/alpha);
        theta = (2*pi*(v-1))/M;
        k = ceil(rho*(N/2)*sin(theta));
        l = ceil(rho*(N/2)*cos(theta));
        G(u,v) = img((-1)*k+(N/2)+1,l+(N/2))*sqrt(((u/M)^(2/alpha-1))/(2*pi*alpha));
    end
end
TEMP= sqrt(pi)*fft2(G);
TEMP= TEMP/(M^2);
EFM= zeros(2*maxorder+1,2*maxorder+1);
EFM(1:maxorder,1:maxorder) = TEMP(M-maxorder+1:M,M-maxorder+1:M);
EFM(1:maxorder,maxorder+1:2*maxorder+1) = TEMP(M-maxorder+1:M,1:maxorder+1);
EFM(maxorder+1:2*maxorder+1,1:maxorder) = TEMP(1:maxorder+1,M-maxorder+1:M);
EFM(maxorder+1:2*maxorder+1,maxorder+1:2*maxorder+1) = TEMP(1:maxorder+1,1:maxorder+1);

output = zeros(maxorder+1,2*maxorder+1);
output(1,:) = sqrt(2)*EFM(maxorder+1,:);
for i=2:maxorder+1
    j = floor(i/2);
    if(mod(i,2)==0)
        output (i,:) = 1j.*(EFM(maxorder+1+j,:)-EFM(maxorder+1-j,:));
    else
        output (i,:) = EFM(maxorder+1+j,:)+EFM(maxorder+1-j,:);
    end
end
end
