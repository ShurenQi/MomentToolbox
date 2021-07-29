%% CBFD Implementation

clc;
close all;
clear variables

addpath orth_opt
addpath sp
addpath sup

% Set parameters
params.ht = 128;
params.wt = 128;
params.N = 8;
params.M = 8; 
params.lambda1 = 0.001;
params.lambda2 = 0.0001;
params.binsize = 15;
params.dictsize = 500;
params.n_iter = 20;
params.coeff = 1000;

cbfd_train;
%load cbfd.mat

load feret\gallery.mat    
ytr = label;
Xtrain = extractFeature(data,W,D,params);
[eigvec2,eigval,~,sampleMean] = PCA(Xtrain);
eigvec = (bsxfun(@rdivide,eigvec2',sqrt(eigval))');
xtr = (bsxfun(@minus, Xtrain, mean(Xtrain))*eigvec(:,1:params.coeff))';

probe{1}='dup1'; probe{2}='dup2';
for i =1:2
    load(['feret\' probe{i} '.mat']);
    yts = label;
    Xtest = extractFeature(data,W,D,params);
    xts = (bsxfun(@minus, Xtest, sampleMean)*eigvec(:,1:params.coeff))';
    acc(i) = NN(xtr',ytr',xts',yts',2);
end
fprintf('\nRank-1 recognition rate for %s set:%2.2f\n',probe{1},acc(1));
fprintf('\nRank-1 recognition rate for %s set:%2.2f\n',probe{2},acc(2));
