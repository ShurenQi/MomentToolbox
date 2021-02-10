%% REF
% Yap P T, Jiang X, Kot A C. Two-dimensional polar harmonic transforms for invariant image representation. IEEE Transactions on Pattern Analysis and Machine Intelligence, 2009, 32(7): 1259-1270.
function [output] = getPST_RBF(order,rho)
% compute the radial polynomial
output=sqrt(2).*sin(pi*order.*rho.^2);
end