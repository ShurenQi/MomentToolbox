function X = extractFeature(Img,W,D,params)
% Extract face representation for image set
% Input: 
%       Img: image set
%       W: MxN Projection matrices
%       D: MxN Dictionary matrices
% Output:
%       X: representation for whole image set

numimg = size(Img,3);
X = zeros(numimg,params.M*params.N*params.dictsize);
for i=1:numimg
    img = double(Img(:,:,i));
    img = preproc2(img,0.2,1,2,[],[],10);
    X(i,:)=cbfd_test(img,W,D,params);
%     fprintf('extract pdm for img %i\n',i);
end

