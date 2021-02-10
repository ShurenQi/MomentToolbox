%% REF
% Hu H, Zhang Y, Shao C, et al. Orthogonal moments based on exponent functions: Exponent-Fourier moments. Pattern Recognition, 2014, 47(8): 2596-2606.
function [output] = getEFM_RBF(order,rho)
% compute the radial polynomial
output=sqrt(rho.^(-1)).*exp(1j*2*pi*order.*rho);
end