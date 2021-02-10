% matrices with x,y and radial frequency coordinates of corresponding
% entry of fft matrix

function [x,y,r] = fftcoord(m,n)

   if nargin<2
      m2 = ceil(m/2);
      x = [0:m2-1,m2-m:-1];
   else
      m2 = ceil(m/2);
      n2 = ceil(n/2);
      x = ([0:m2-1, m2-m:-1])'*ones(1,n);
      if nargout>=2
	 y = ones(m,1)*([0:n2-1, n2-n:-1]);
	 if nargout>=3
	    r = sqrt(x.^2+y.^2);
	    % r(1,1) = 1e-8;
	 end
      end
   end
% end