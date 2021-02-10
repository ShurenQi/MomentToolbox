%% REF
%	Hoang T V, Tabbone S. Generic polar harmonic transforms for invariant image representation. Image and Vision Computing, 2014, 32(8): 497-509.
function [output] = getGPST_RBF(order,rho,alpha)
% compute the radial polynomial
output=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*sin(pi*order.*rho.^alpha);
end % end getRadialPoly method
