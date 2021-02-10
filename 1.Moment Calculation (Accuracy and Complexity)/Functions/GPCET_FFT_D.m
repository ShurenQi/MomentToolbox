function [ output,mask ]= GPCET_FFT_D(img,maxorder,alpha)
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
TEMP= 2*pi*TEMP/(M^2);
output= zeros(2*maxorder+1,2*maxorder+1);
output(1:maxorder,1:maxorder) = TEMP(M-maxorder+1:M,M-maxorder+1:M);
output(1:maxorder,maxorder+1:2*maxorder+1) = TEMP(M-maxorder+1:M,1:maxorder+1);
output(maxorder+1:2*maxorder+1,1:maxorder) = TEMP(1:maxorder+1,M-maxorder+1:M);
output(maxorder+1:2*maxorder+1,maxorder+1:2*maxorder+1) = TEMP(1:maxorder+1,1:maxorder+1);
mask=ones(2*maxorder+1,2*maxorder+1);
for order=-maxorder:1:maxorder
    for repetition=-maxorder:1:maxorder
        if repetition==0
            mask(order+maxorder+1,repetition+maxorder+1)=0;
        end
    end
end
end

