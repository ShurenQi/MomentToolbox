%% REF
%	Hoang T V, Tabbone S. Generic polar harmonic transforms for invariant image representation. Image and Vision Computing, 2014, 32(8): 497-509.
function [output] = getGRHFM_RBF(order,rho,alpha)
% compute the radial polynomial
if order==0
    output=sqrt(alpha*rho.^(alpha-2));
elseif mod(order,2)==1
    output=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*sin(pi*(order+1).*rho.^alpha);
else
    output=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*cos(pi*order.*rho.^alpha);
end
end % end getRadialPoly method