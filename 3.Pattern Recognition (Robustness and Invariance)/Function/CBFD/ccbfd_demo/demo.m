%% C-CBFD Implementation

clc;
close all;
clear variables
addpath sup

% Set parameters
params.ht = 128;
params.wt = 128;
params.N = 8;
params.M = 8; 
params.dictsize = 500;
params.coeffs=1000;

load vis_nir_test.mat % pre-computed W and B

% training data
load ('casia2.0\vis_train_1.mat');
Xtr1 = zeros(size(data,3),params.M*params.N*params.dictsize);
for i=1:size(data,3)
   img = tantriggs(data(:,:,i));
    Xtr1(i,:) = cbfd_test(img,W1,D, params);
end
Ytr1 = label;

load ('casia2.0\nir_train_1.mat');
Xtr2 = zeros(size(data,3),params.M*params.N*params.dictsize);
for i=1:size(data,3)
   img = tantriggs(data(:,:,i));
    Xtr2(i,:) =  cbfd_test(img,W2,D, params);
end
Ytr2 = label;

% testing data
load ('casia2.0\vis_gallery_1.mat');
Xts1 = zeros(size(data,3),params.M*params.N*params.dictsize);
for i=1:size(data,3)
    img = tantriggs(data(:,:,i));
    Xts1(i,:) =  cbfd_test(img,W1,D, params);
end
Yts1 = label;

load ('casia2.0\nir_probe_1.mat');
Xts2 = zeros(size(data,3),params.M*params.N*params.dictsize);
for i=1:size(data,3)
    img = tantriggs(data(:,:,i));
    Xts2(i,:) = cbfd_test(img,W2,D,params);
end
Yts2 = label;

[eigvec2,eigval,~,sampleMean] = PCA([Xtr1; Xtr2]);
eigvec = (bsxfun(@rdivide,eigvec2',sqrt(eigval))');

xtr1 = (bsxfun(@minus, Xtr1, sampleMean)*eigvec(:,1:params.coeffs))';
xtr2 = (bsxfun(@minus, Xtr2, sampleMean)*eigvec(:,1:params.coeffs))';
xts1 = (bsxfun(@minus, Xts1, sampleMean)*eigvec(:,1:params.coeffs))';
xts2 = (bsxfun(@minus, Xts2, sampleMean)*eigvec(:,1:params.coeffs))';

NIR_VIS1 = NN(xts1',Yts1',xts2',Yts2',2);
VIS_NIR1 = NN(xts2',Yts2',xts1',Yts1',2);

fprintf('\nRank-1 recognition rate for VIS-NIR matching:%2.2f percent\n',VIS_NIR1);
fprintf('\nRank-1 recognition rate for NIR-VIS matching:%2.2f percent\n',NIR_VIS1);
