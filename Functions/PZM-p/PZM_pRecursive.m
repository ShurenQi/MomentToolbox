function R = PZM_pRecursive(n,m,r)

% Computes pzeudo Zernike radial polynomials using the hybrid method mentioned
% in the work: 
%   Mohammed S. Al-Rawi. Fast Computation of Pseudo Zernike
%   Moments. Journal of Real-Time Image Processing, vol. 5, p. 3-10, 2010.
%
%
%  The method is based on fast computation of Zernike radial polynomials.
%  Depends the p-recursive algorithm. 
%
%
% r could be a vector, i.e., contains many r values computed using
% vectorized operations, very fast.
% 
%  R(n,n) is obtained from the result with R(n +1)
%  R(0,0) is written as R(0 +1) since the matrix always starts at
%  The whole results R(n+1)=R_nm, R(n-1 +1)=R_n-1_m,..., R(m+1,m)= R_m_m, so this is
%  p-recursive since p(or n) is the one that is changed.
%
%
%
%  Example 1:   pseudo_zernike_polynomials_p_recursive(4, [0.2 0.34 0.73]')
%  pseudo_zernike_polynomials_p_recursive(4, 0, [0.2 0.34 0.73]')
% 
% ans =
% 
%     1.0000    1.0000    1.0000
%    -1.4000   -0.9800    0.1900
%     1.0000    0.0760   -0.4310
%    -0.1200    0.6396   -0.4584
%    -0.6384   -0.4453   -0.0340
%
%
%
%
%
% Example 2: Generating up to the order 8, compared to the other method which 
% is based on q-recursive ZM radials
%
%
% p=8;
% r=.50;
% 
% R2=zeros(p+1,p+1);
% 
% for q =0:p
%     R2(q+1,:) = pseudo_zernike_polynomials_p_recursive(p, q, r);
% end
% 
% 
% 
% 
% R1=zeros(p+1,p+1);
% 
% for q=0:p
% tmp = pseudo_zernike_radial_polynomials(q,r);
% R1(1:length(tmp),q+1) = tmp;
% end
% 
% 
% R1
% R2
% 
% R1 =
% 
%     1.0000   -0.5000   -0.5000    0.3750    0.3750   -0.3125   -0.3125    0.2734    0.2734
%          0    0.5000   -0.7500    0.1250    0.5000   -0.1875   -0.3906    0.1953    0.3281
%          0         0    0.2500   -0.6250    0.5000    0.1563   -0.4531   -0.0078    0.3906
%          0         0         0    0.1250   -0.4375    0.5937   -0.2187   -0.3359    0.3281
%          0         0         0         0    0.0625   -0.2812    0.5313   -0.4453   -0.0469
%          0         0         0         0         0    0.0313   -0.1719    0.4141   -0.5156
%          0         0         0         0         0         0    0.0156   -0.1016    0.2969
%          0         0         0         0         0         0         0    0.0078   -0.0586
%          0         0         0         0         0         0         0         0    0.0039
% 
% 
% R2 =
% 
%     1.0000   -0.5000   -0.5000    0.3750    0.3750   -0.3125   -0.3125    0.2734    0.2734
%          0    0.5000   -0.7500    0.1250    0.5000   -0.1875   -0.3906    0.1953    0.3281
%          0         0    0.2500   -0.6250    0.5000    0.1563   -0.4531   -0.0078    0.3906
%          0         0         0    0.1250   -0.4375    0.5937   -0.2188   -0.3359    0.3281
%          0         0         0         0    0.0625   -0.2812    0.5313   -0.4453   -0.0469
%          0         0         0         0         0    0.0312   -0.1719    0.4141   -0.5156
%          0         0         0         0         0         0    0.0156   -0.1016    0.2969
%          0         0         0         0         0         0         0    0.0078   -0.0586
%          0         0         0         0         0         0         0         0    0.0039
%
%
%
%
%
%
%
%
%
%
%
%
%
% Written by Mohammed S. Al-Rawi, 2008
% rawi707@yahoo.com
% Last updated, April 2012.
% 




% if any( r>1 | r<0 | n<0 | m>n | n<0 | m<0)
%     error(':zernike_radial_polynomials either r is less than or greater thatn 1,   r must be between 0 and 1 or n is less than 0.')
% end

m=abs(m);
% R=r;
r=r(:); % columninzing it   :)
R = zeros(n+1, length(r) ); % a mat to store results


if r==0   %  this is an extreme case...
    if m==0
        R( (0:n)+1,:)= 1;
    else
        R( (0:n)+1,:) = 0;
    end
    return;  % exit out of this function, r is 0, and thats it
end


q=m; p = n;
R(q +1,:) = r.^q;
if q==p
    R=R(end,:);
    return;
end

if q == p-1   
    Rpp=r.^p; 
    R(p +1,:)=(2*p+1)*Rpp - 2*p*r.^q;
    R=R(end,:);
    return;
end

p=q+1;
Rpp=r.^p; 
R(p +1,:)=(2*p+1)*Rpp - 2*p*r.^q; 

q2=q+2;
for p = q2:n
    L1 = ((2*p+1)*2*p)/((p+q +1.0)*(p-q));
    L2 = -2*p + L1*((p+q)*(p-q-1))/(2.0*p-1);
    L3 = (2*p-1)*(p-1)-  L1*(p+q-1)*(p-q-2)/2.0   + 2*(p-1)*L2;    
    R(p +1,:) = (L1*r+L2)'.*R(p-1 +1,:) + L3*R(p-2 +1,:);
end
R=R(end,:);
end





