%% REF
%¡¡Ping Z, Wu R, Sheng Y. Image description with Chebyshev¨CFourier moments. Journal of the Optical Society of America A, 2002, 19(9): 1748-1754.
% H. Yang, S. Qi, J. Tian, P. Niu, X. Wang, Robust and discriminative image representation: Fractional-order Jacobi-Fourier moments, Pattern Recognition.
function [output] = getCHFM_RBF(order,rho)
% obtain the order
n = order;
p = 2; q = 1.5; alpha = 1;
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