%% REF
% Teague M R. Image analysis via the general theory of moments. Journal of the Optical Society of America, 1980, 70(8): 920-930.
% Chong C W, Raveendran P, Mukundan R. A comparative analysis of algorithms for fast computation of Zernike moments. Pattern Recognition, 2003, 36(3): 731-742.
function [output] = getZM_RBF(order,repetition,rho)
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