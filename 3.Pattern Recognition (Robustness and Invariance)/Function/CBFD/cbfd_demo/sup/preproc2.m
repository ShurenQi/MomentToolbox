function im = preproc2(im,gamma,sigma0,sigma1,shift,mask,do_norm)

% Preprocess image for face recognition.
% (C) Bill Triggs & Xiaoyang Tan, 03/12/2006.
%
% This is the method used in our papers in the AMFG workshop at ICCV
% 2007.  We give recommended settings for 130x150 FRGC images, but
% these seem to be about right for many other natural images with
% significant lighting variations.
%
% IM - positive grayscale input image, with graylevels scaled any way
% you like.
% 
% GAMMA (gamma correction power) is 0-1. 0 or 0.2 are probably
% fine. Set this so that the output image doesn't look dim or blurred
% in shadowed regions, but check that noise in such regions is not
% amplified too much, especially with jpeged input images. If so
% consider adding a small constant to the input image, but resistance
% to shadowing will be decreased.
%
% SIGMA0 (inner / low pass filter stddev) is 0-1 pixels, 0-0.5
% should be fine unless there are a lot of aliasing / resampling /
% JPEG artifacts. Visually, keep the image as sharp as possible
% without too many visible jaggy artifacts.
%
% SIGMA1 (outer / high pass filter stdev) is 1.5-8 pixels. This can be
% set quite small -- 2-4, and we usually used 2. The idea is to keep
% some overall shape information, but try to be relatively invariant
% to overall shading / illumination gradients.
%
% SHIFT - spatial offset vector of the inner filter relative to the
% outer one. This is just a curiosity. Set it to [].
%
% MASK - binary matrix masking out unwanted pixels (e.g. hair,
% ears). Set to [] if you don't want this.
%
% DO_NORM - 0 if you don't want the final global contrast
% normalization phase. Negative to normalize but not clip highlights
% and lowlights, Positive to nonlinearly clip (tanh sigmoid) as
% well. We usually just set this to 10, i.e. clip signals at about 10x
% the average variation.
%
% Things to look for in the output: noise/blurring in regions that
% were shadowed, jaggies/aliasing, residual effects of shading (the
% output image should look fairly "flat"), residual highlights that
% disturb your face descriptor, false edges produced by hard shadow
% boundaries (difficult to fix).

   % Gamma correct input image to increase local contrast in shadowed
   % regions.
   if gamma == 0
      im = log(im+max(1,max(max(im)))/256); 
   else
      im = im.^gamma;
   end
   
   % run prefilter, if any
   if sigma1
      border=1;
      if border % add extend-as-constant image border to reduce
                % boundary effects
	 [m,n] = size(im);
	 b=floor(3*abs(sigma1));
	 c=ones(b); d=ones(b,1);
	 im = [ c*im(1,1), d*im(1,:), c*im(1,n);...
		im(:,1)*d', im, im(:,n)*d';...
		im(m,1)*c, d*im(m,:), c*im(m,n) ];
      end
      if sigma1>0
	 % Build difference of gaussian filter and apply it to image.
	 [x,y,r] = fftcoord(size(im,1),size(im,2));
	 g0 = exp(-0.5*(r/max(sigma0,1e-6)).^2); 
	 g0 = g0./sum(sum(g0));
	 g1 = exp(-0.5*(r/max(sigma1,1e-6)).^2); 
	 if ~isempty(shift)
	    g1 = circshift(g1,shift);
	 end
	 g1 = g1./sum(sum(g1));
	 im = real(ifft2(fft2(im).*fft2(g0-g1)));
      else  % sigma1<0, alternative implementation using explicit convolution
	 if sigma0>0
	    im = gaussianfilter(im,sigma0)-gaussianfilter(im,-sigma1,shift);
	 else
	    im = im-gaussianfilter(im,-sigma1,shift);
	 end
      end
      if border
	 im = im(b+(1:m),b+(1:n));
      end
   end
   
   if ~isempty(mask) % mask out unwanted pixels
      im=im.*mask; 
   end       

   if do_norm
       % Global contrast normalization. Normalizes the spread of output
       % values. The mean is near 0 so we don't bother to subtract
       % it. We use a trimmed robust scatter measure for resistance to
       % outliers such as specularities and image borders that have
       % different values from the main image.  Usually trim is about
       % 10.
       a = 0.1;
       trim = abs(do_norm);
       im = im./mean(mean(abs(im).^a))^(1/a);
       im = im./mean(mean(min(trim,abs(im)).^a))^(1/a);
       if do_norm>0
	  % trim/squash any large outliers (e.g. specularities) if
	  % required. Can be omitted if your descriptor / image
	  % display method is not sensitive to these.

	  % im = min(trim,max(-trim,im)); % truncate
	  im = trim*tanh(im/trim); % squash with tanh sigmoid
       end
   end
% end
im = (im-min(im(:)))/(max(im(:)) - min(im(:)))*255;