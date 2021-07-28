%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% J Lu, VE Liong, X Zhou, J Zhou
% Learning compact binary face descriptor for face recognition.
% IEEE transactions on pattern analysis and machine intelligence, 2015, 37(10): 2041-2056.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is slightly modified for experiment by Shuren Qi 
% i@srqi.email
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;
warning('off'); 
addpath(genpath(pwd));
% dbstop if error
%% CBFD parameters %%
params.ht = 128;
params.wt = 128;
params.N = 4;
params.M = 4;
params.lambda1 = 0.001;
params.lambda2 = 0.0001;
params.binsize = 15;
params.dictsize = 500;
params.n_iter = 20;
params.coeff = 1000;
TrnSize=100;ImgSize=128; 
UCCP=zeros(7,1);
flg=1;

for VAR=0:0.05:0.3
%% Loading data %%
%% CASE1: training without rotation images
% training
[r,o]=ro(ImgSize,ImgSize);
pz=r>1;
trainData=zeros(ImgSize,ImgSize,TrnSize);
trainLabels=zeros(TrnSize,1);
for i=1:1:TrnSize
        I=imread(['Dateset\training set\',num2str(i),'\obj',num2str(i),'__0.png']);
        I=rgb2gray(I);
        I=imresize(I,[ImgSize,ImgSize]);
        I(pz)=0;
        trainData(:,:,i)=I;
        trainLabels(i,1)=i;
end
% testing
testData=zeros(ImgSize,ImgSize,TrnSize*36);
testLabels=zeros(TrnSize*36,1);
for i=1:1:TrnSize
    for j=0:1:35
        I=imread(['Dateset\testing set\obj',num2str(i),'__',num2str(j),'.png']);
        I=rgb2gray(I);
        I=imresize(I,[ImgSize,ImgSize]);
        NI=imnoise(I,'gaussian',0,VAR);
        NI(pz)=0;
        testData(:,:,(i-1)*36+j+1)=NI;
        testLabels((i-1)*36+j+1,1)=i;
    end
end
%% CASE2: training with rotation images
% % training
% [r,o]=ro(ImgSize,ImgSize);
% pz=r>1;
% trainData=zeros(ImgSize,ImgSize,TrnSize*36);
% trainLabels=zeros(TrnSize*36,1);
% for i=1:1:TrnSize
%     for j=0:1:35
%         I=imread(['Dateset\training set\',num2str(i),'\obj',num2str(i),'__',num2str(j),'.png']);
%         I=rgb2gray(I);
%         I=imresize(I,[ImgSize,ImgSize]);
%         I(pz)=0;
%         trainData(:,:,(i-1)*36+j+1)=I;
%         trainLabels((i-1)*36+j+1,1)=i;
%     end
% end
% % testing
% testData=zeros(ImgSize,ImgSize,TrnSize*36);
% testLabels=zeros(TrnSize*36,1);
% for i=1:1:TrnSize
%     for j=0:1:35
%         I=imread(['Dateset\testing set\obj',num2str(i),'__',num2str(j),'.png']);
%         I=rgb2gray(I);
%         I=imresize(I,[ImgSize,ImgSize]);
%         NI=imnoise(I,'gaussian',0,VAR);
%         NI(pz)=0;
%         testData(:,:,(i-1)*36+j+1)=NI;
%         testLabels((i-1)*36+j+1,1)=i;
%     end
% end
%% CBFD Training %%
% PDV =pdv_extract(trainData,params.M,params.N);
% for i=1:params.M
%     for j=1:params.N
%         W{i,j} = cbfd_learn(PDV{i,j},params.binsize, ...
%             params.n_iter,params.lambda1,params.lambda2);
%         D{i,j} = CalculateDictionary(double(PDV{i,j}*W{i,j} >0), ...
%             params.dictsize);
%     end
% end
%% Load pre-trained models for CASE1 %%
load('W1.mat')
load('D1.mat')
%% Load pre-trained models for CASE2 %%
% load('W2.mat')
% load('D2.mat')
%% CBFD Feature Extraction and Testing %%
%training set
Xtrain = extractFeature(trainData,W,D,params);
[eigvec2,eigval,~,sampleMean] = PCA(Xtrain);
eigvec = (bsxfun(@rdivide,eigvec2',sqrt(eigval))');
if params.coeff>size(eigvec,2)
    params.coeff=size(eigvec,2);
end
trainData = (bsxfun(@minus, Xtrain, mean(Xtrain))*eigvec(:,1:params.coeff));
%testing set
Xtest = extractFeature(testData,W,D,params);
testData = (bsxfun(@minus, Xtest, sampleMean)*eigvec(:,1:params.coeff));
%% OUTPUT
model = svmtrain(trainLabels ,trainData,'-t 2 -g 0.1 -c 1000');
[label,~, ~] = svmpredict(testLabels,testData, model);
accuracy = length(find(label == testLabels))/(size(testLabels,1))*100;
fprintf('\n ===== Results of CBFD, followed by a linear SVM classifier =====');
fprintf('\n     Testing Accuracy: %.4f%%', accuracy);
UCCP(flg,1)=accuracy;
flg=flg+1;
end
