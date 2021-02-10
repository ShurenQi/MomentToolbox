%% REF
% Yap P T, Jiang X, Kot A C. Two-dimensional polar harmonic transforms for invariant image representation. IEEE Transactions on Pattern Analysis and Machine Intelligence, 2009, 32(7): 1259-1270.
function [output] = getPCT_RBF(order,rho)
% compute the radial polynomial
if order==0
    output=rho.^0;
else
    output=sqrt(2).*cos(pi*order.*rho.^2);
end
end