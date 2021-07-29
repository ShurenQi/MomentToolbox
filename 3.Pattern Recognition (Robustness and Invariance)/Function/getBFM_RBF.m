%% REF
% Xiao B, Ma J, Wang X. Image analysis by Bessel¨CFourier moments. Pattern Recognition, 2010, 43(8): 2620-2629.
function [output] = getBFM_RBF(order,rho,v)
Roots=zeros(1,max(order)+2);
syms x;
Roots(1,1)=vpasolve(besselj(v, x) == 0, x);
for i=2:1:max(order)+2
    ST=Roots(1,i-1)+3;
    Roots(1,i)=vpasolve(besselj(v, x) == 0, ST);
end
% obtain the order and repetition
n = order;
% compute the radial polynomial
rho=rho*Roots(n+2);
output=besselj(v,rho);
output=output*sqrt((1/(pi*(besselj(v+1,Roots(order+2)))^2)));
end % end getRadialPoly method