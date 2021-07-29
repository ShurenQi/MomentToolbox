%% REF
%	Hoang T V, Tabbone S. Generic polar harmonic transforms for invariant image representation. Image and Vision Computing, 2014, 32(8): 497-509.
function [output] = getGPCT_RBF(order,rho,alpha)
% compute the radial polynomial
if order==0
    output=sqrt(alpha*rho.^(alpha-2));
else
    output=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*cos(pi*order.*rho.^alpha);
end
end