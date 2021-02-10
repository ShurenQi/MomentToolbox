%% Direct
% function [ output ] = PCET_D(img,maxorder)
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
% output=zeros(2*maxorder+1,2*maxorder+1);
% for order=-maxorder:1:maxorder
%     R=exp(-1j*2*pi*order.*rho.^2);       % get the radial polynomial
%     for repetition=-maxorder:1:maxorder
%         pupil =R.*exp(-1j*repetition * theta);
%         Product = double(img) .* pupil;
%         cnt = nnz(R)+1;
%         output(order+maxorder+1,repetition+maxorder+1)=sum(Product(:))*(1/(pi))*(4/cnt);
%     end
% end
% end

%% FFT-based
function [ output ]= PCET_D(img,maxorder)
alpha = 2;
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
TEMP= fft2(G);
TEMP= sqrt(4*pi)*TEMP/(M^2);
output= zeros(2*maxorder+1,2*maxorder+1);
output(1:maxorder,1:maxorder) = TEMP(M-maxorder+1:M,M-maxorder+1:M);
output(1:maxorder,maxorder+1:2*maxorder+1) = TEMP(M-maxorder+1:M,1:maxorder+1);
output(maxorder+1:2*maxorder+1,1:maxorder) = TEMP(1:maxorder+1,M-maxorder+1:M);
output(maxorder+1:2*maxorder+1,maxorder+1:2*maxorder+1) = TEMP(1:maxorder+1,1:maxorder+1);
end
