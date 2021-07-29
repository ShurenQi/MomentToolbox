%% REF
%	Ren H, Ping Z, Bo W, et al. Multidistortion-invariant image recognition with radial harmonic Fourier moments. Journal of the Optical Society of America A, 2003, 20(4): 631-637.
function [output] = getRHFM_RBF(order,rho)
% compute the radial polynomial
if order==0
    output=sqrt(rho.^(-1));
elseif mod(order,2)==1
    output=sqrt(rho.^(-1)).*sqrt(2).*sin(pi*(order+1).*rho);
else
    output=sqrt(rho.^(-1)).*sqrt(2).*cos(pi*order.*rho);
end
end