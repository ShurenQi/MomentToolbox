%% REF
% Teh C H, Chin R T. On image analysis by the methods of moments. IEEE Transactions on Pattern Analysis and Machine Intelligence, 1988, 10(4): 496-513.
% Al-Rawi M S. Fast computation of pseudo Zernike moments. Journal of Real-Time Image Processing, 2010, 5(1): 3-10.
function [output] = getPZM_RBF(order,repetition,rho)
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