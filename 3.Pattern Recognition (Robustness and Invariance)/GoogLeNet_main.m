%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code was developed by Shuren Qi
% https://shurenqi.github.io/
% i@srqi.email / shurenqi@nuaa.edu.cn
% All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test retrained GoogLeNet %%
close all;
clear all;
clc;
warning('off'); 
addpath(genpath(pwd));
% dbstop if error
%% parameters
TrnSize=100;
NorSize=224;
UCCP=zeros(7,1);
flg=1;
%% Load retrained GoogLeNet model
load('retrainGoogLeNet.mat')
for VAR=0:0.05:0.3
%% GoogLeNet testing
testLabels=zeros(TrnSize*36,1);
labels=zeros(TrnSize*36,1);
for i=1:1:TrnSize
    for j=0:1:35
        I=imread(['Dateset\testing set\obj',num2str(i),'__',num2str(j),'.png']);
        NI=imnoise(I,'gaussian',0,VAR);
        NI=imresize(NI,[NorSize NorSize]);
        [YPred,~] = classify(retrainGoogLeNet,NI);
        labels((i-1)*36+j+1,1) = double(string(YPred));
        testLabels((i-1)*36+j+1,1)=i;
    end
end
%% OUTPUT
accuracy = length(find(labels == testLabels))/(size(testLabels,1))*100;
fprintf('\n Testing Accuracy: %.4f%%', accuracy);
UCCP(flg,1)=accuracy;
flg=flg+1;
end

%% Retrain GoogLeNet on all rotation versions %%
% trainingSetup = load("Function\GoogLeNet\trainingSetupGoogLeNet.mat");
% imdsTrain = imageDatastore("Dateset\training set","IncludeSubfolders",true,"LabelSource","foldernames");
% [imdsTrain, imdsValidation] = splitEachLabel(imdsTrain,0.7);
% augimdsTrain = augmentedImageDatastore([224 224 3],imdsTrain);
% augimdsValidation = augmentedImageDatastore([224 224 3],imdsValidation);
% opts = trainingOptions("sgdm",...
%     "ExecutionEnvironment","auto",...
%     "InitialLearnRate",0.0001,...
%     "MiniBatchSize",360,...
%     "Shuffle","every-epoch",...
%     "ValidationFrequency",5,...
%     "Plots","training-progress",...
%     "ValidationData",augimdsValidation);
% lgraph = layerGraph();
% 
% tempLayers = [
%     imageInputLayer([224 224 3],"Name","data","Mean",trainingSetup.data.Mean)
%     convolution2dLayer([7 7],64,"Name","conv1-7x7_s2","BiasLearnRateFactor",2,"Padding",[3 3 3 3],"Stride",[2 2],"Bias",trainingSetup.conv1_7x7_s2.Bias,"Weights",trainingSetup.conv1_7x7_s2.Weights)
%     reluLayer("Name","conv1-relu_7x7")
%     maxPooling2dLayer([3 3],"Name","pool1-3x3_s2","Padding",[0 1 0 1],"Stride",[2 2])
%     crossChannelNormalizationLayer(5,"Name","pool1-norm1","K",1)
%     convolution2dLayer([1 1],64,"Name","conv2-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.conv2_3x3_reduce.Bias,"Weights",trainingSetup.conv2_3x3_reduce.Weights)
%     reluLayer("Name","conv2-relu_3x3_reduce")
%     convolution2dLayer([3 3],192,"Name","conv2-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.conv2_3x3.Bias,"Weights",trainingSetup.conv2_3x3.Weights)
%     reluLayer("Name","conv2-relu_3x3")
%     crossChannelNormalizationLayer(5,"Name","conv2-norm2","K",1)
%     maxPooling2dLayer([3 3],"Name","pool2-3x3_s2","Padding",[0 1 0 1],"Stride",[2 2])];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],64,"Name","inception_3a-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3a_1x1.Bias,"Weights",trainingSetup.inception_3a_1x1.Weights)
%     reluLayer("Name","inception_3a-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],96,"Name","inception_3a-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3a_3x3_reduce.Bias,"Weights",trainingSetup.inception_3a_3x3_reduce.Weights)
%     reluLayer("Name","inception_3a-relu_3x3_reduce")
%     convolution2dLayer([3 3],128,"Name","inception_3a-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_3a_3x3.Bias,"Weights",trainingSetup.inception_3a_3x3.Weights)
%     reluLayer("Name","inception_3a-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_3a-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],32,"Name","inception_3a-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3a_pool_proj.Bias,"Weights",trainingSetup.inception_3a_pool_proj.Weights)
%     reluLayer("Name","inception_3a-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],16,"Name","inception_3a-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3a_5x5_reduce.Bias,"Weights",trainingSetup.inception_3a_5x5_reduce.Weights)
%     reluLayer("Name","inception_3a-relu_5x5_reduce")
%     convolution2dLayer([5 5],32,"Name","inception_3a-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_3a_5x5.Bias,"Weights",trainingSetup.inception_3a_5x5.Weights)
%     reluLayer("Name","inception_3a-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_3a-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","inception_3b-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3b_1x1.Bias,"Weights",trainingSetup.inception_3b_1x1.Weights)
%     reluLayer("Name","inception_3b-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","inception_3b-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3b_3x3_reduce.Bias,"Weights",trainingSetup.inception_3b_3x3_reduce.Weights)
%     reluLayer("Name","inception_3b-relu_3x3_reduce")
%     convolution2dLayer([3 3],192,"Name","inception_3b-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_3b_3x3.Bias,"Weights",trainingSetup.inception_3b_3x3.Weights)
%     reluLayer("Name","inception_3b-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],32,"Name","inception_3b-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3b_5x5_reduce.Bias,"Weights",trainingSetup.inception_3b_5x5_reduce.Weights)
%     reluLayer("Name","inception_3b-relu_5x5_reduce")
%     convolution2dLayer([5 5],96,"Name","inception_3b-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_3b_5x5.Bias,"Weights",trainingSetup.inception_3b_5x5.Weights)
%     reluLayer("Name","inception_3b-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_3b-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],64,"Name","inception_3b-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_3b_pool_proj.Bias,"Weights",trainingSetup.inception_3b_pool_proj.Weights)
%     reluLayer("Name","inception_3b-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     depthConcatenationLayer(4,"Name","inception_3b-output")
%     maxPooling2dLayer([3 3],"Name","pool3-3x3_s2","Padding",[0 1 0 1],"Stride",[2 2])];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],16,"Name","inception_4a-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4a_5x5_reduce.Bias,"Weights",trainingSetup.inception_4a_5x5_reduce.Weights)
%     reluLayer("Name","inception_4a-relu_5x5_reduce")
%     convolution2dLayer([5 5],48,"Name","inception_4a-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_4a_5x5.Bias,"Weights",trainingSetup.inception_4a_5x5.Weights)
%     reluLayer("Name","inception_4a-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],96,"Name","inception_4a-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4a_3x3_reduce.Bias,"Weights",trainingSetup.inception_4a_3x3_reduce.Weights)
%     reluLayer("Name","inception_4a-relu_3x3_reduce")
%     convolution2dLayer([3 3],208,"Name","inception_4a-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_4a_3x3.Bias,"Weights",trainingSetup.inception_4a_3x3.Weights)
%     reluLayer("Name","inception_4a-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],192,"Name","inception_4a-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4a_1x1.Bias,"Weights",trainingSetup.inception_4a_1x1.Weights)
%     reluLayer("Name","inception_4a-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_4a-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],64,"Name","inception_4a-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4a_pool_proj.Bias,"Weights",trainingSetup.inception_4a_pool_proj.Weights)
%     reluLayer("Name","inception_4a-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_4a-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],112,"Name","inception_4b-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4b_3x3_reduce.Bias,"Weights",trainingSetup.inception_4b_3x3_reduce.Weights)
%     reluLayer("Name","inception_4b-relu_3x3_reduce")
%     convolution2dLayer([3 3],224,"Name","inception_4b-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_4b_3x3.Bias,"Weights",trainingSetup.inception_4b_3x3.Weights)
%     reluLayer("Name","inception_4b-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_4b-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],64,"Name","inception_4b-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4b_pool_proj.Bias,"Weights",trainingSetup.inception_4b_pool_proj.Weights)
%     reluLayer("Name","inception_4b-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],160,"Name","inception_4b-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4b_1x1.Bias,"Weights",trainingSetup.inception_4b_1x1.Weights)
%     reluLayer("Name","inception_4b-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],24,"Name","inception_4b-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4b_5x5_reduce.Bias,"Weights",trainingSetup.inception_4b_5x5_reduce.Weights)
%     reluLayer("Name","inception_4b-relu_5x5_reduce")
%     convolution2dLayer([5 5],64,"Name","inception_4b-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_4b_5x5.Bias,"Weights",trainingSetup.inception_4b_5x5.Weights)
%     reluLayer("Name","inception_4b-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_4b-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],24,"Name","inception_4c-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4c_5x5_reduce.Bias,"Weights",trainingSetup.inception_4c_5x5_reduce.Weights)
%     reluLayer("Name","inception_4c-relu_5x5_reduce")
%     convolution2dLayer([5 5],64,"Name","inception_4c-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_4c_5x5.Bias,"Weights",trainingSetup.inception_4c_5x5.Weights)
%     reluLayer("Name","inception_4c-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","inception_4c-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4c_1x1.Bias,"Weights",trainingSetup.inception_4c_1x1.Weights)
%     reluLayer("Name","inception_4c-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","inception_4c-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4c_3x3_reduce.Bias,"Weights",trainingSetup.inception_4c_3x3_reduce.Weights)
%     reluLayer("Name","inception_4c-relu_3x3_reduce")
%     convolution2dLayer([3 3],256,"Name","inception_4c-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_4c_3x3.Bias,"Weights",trainingSetup.inception_4c_3x3.Weights)
%     reluLayer("Name","inception_4c-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_4c-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],64,"Name","inception_4c-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4c_pool_proj.Bias,"Weights",trainingSetup.inception_4c_pool_proj.Weights)
%     reluLayer("Name","inception_4c-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_4c-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_4d-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],64,"Name","inception_4d-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4d_pool_proj.Bias,"Weights",trainingSetup.inception_4d_pool_proj.Weights)
%     reluLayer("Name","inception_4d-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],32,"Name","inception_4d-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4d_5x5_reduce.Bias,"Weights",trainingSetup.inception_4d_5x5_reduce.Weights)
%     reluLayer("Name","inception_4d-relu_5x5_reduce")
%     convolution2dLayer([5 5],64,"Name","inception_4d-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_4d_5x5.Bias,"Weights",trainingSetup.inception_4d_5x5.Weights)
%     reluLayer("Name","inception_4d-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],112,"Name","inception_4d-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4d_1x1.Bias,"Weights",trainingSetup.inception_4d_1x1.Weights)
%     reluLayer("Name","inception_4d-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],144,"Name","inception_4d-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4d_3x3_reduce.Bias,"Weights",trainingSetup.inception_4d_3x3_reduce.Weights)
%     reluLayer("Name","inception_4d-relu_3x3_reduce")
%     convolution2dLayer([3 3],288,"Name","inception_4d-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_4d_3x3.Bias,"Weights",trainingSetup.inception_4d_3x3.Weights)
%     reluLayer("Name","inception_4d-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_4d-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_4e-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],128,"Name","inception_4e-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4e_pool_proj.Bias,"Weights",trainingSetup.inception_4e_pool_proj.Weights)
%     reluLayer("Name","inception_4e-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],32,"Name","inception_4e-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4e_5x5_reduce.Bias,"Weights",trainingSetup.inception_4e_5x5_reduce.Weights)
%     reluLayer("Name","inception_4e-relu_5x5_reduce")
%     convolution2dLayer([5 5],128,"Name","inception_4e-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_4e_5x5.Bias,"Weights",trainingSetup.inception_4e_5x5.Weights)
%     reluLayer("Name","inception_4e-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","inception_4e-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4e_1x1.Bias,"Weights",trainingSetup.inception_4e_1x1.Weights)
%     reluLayer("Name","inception_4e-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],160,"Name","inception_4e-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_4e_3x3_reduce.Bias,"Weights",trainingSetup.inception_4e_3x3_reduce.Weights)
%     reluLayer("Name","inception_4e-relu_3x3_reduce")
%     convolution2dLayer([3 3],320,"Name","inception_4e-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_4e_3x3.Bias,"Weights",trainingSetup.inception_4e_3x3.Weights)
%     reluLayer("Name","inception_4e-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     depthConcatenationLayer(4,"Name","inception_4e-output")
%     maxPooling2dLayer([3 3],"Name","pool4-3x3_s2","Padding",[0 1 0 1],"Stride",[2 2])];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_5a-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],128,"Name","inception_5a-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5a_pool_proj.Bias,"Weights",trainingSetup.inception_5a_pool_proj.Weights)
%     reluLayer("Name","inception_5a-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],32,"Name","inception_5a-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5a_5x5_reduce.Bias,"Weights",trainingSetup.inception_5a_5x5_reduce.Weights)
%     reluLayer("Name","inception_5a-relu_5x5_reduce")
%     convolution2dLayer([5 5],128,"Name","inception_5a-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_5a_5x5.Bias,"Weights",trainingSetup.inception_5a_5x5.Weights)
%     reluLayer("Name","inception_5a-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","inception_5a-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5a_1x1.Bias,"Weights",trainingSetup.inception_5a_1x1.Weights)
%     reluLayer("Name","inception_5a-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],160,"Name","inception_5a-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5a_3x3_reduce.Bias,"Weights",trainingSetup.inception_5a_3x3_reduce.Weights)
%     reluLayer("Name","inception_5a-relu_3x3_reduce")
%     convolution2dLayer([3 3],320,"Name","inception_5a-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_5a_3x3.Bias,"Weights",trainingSetup.inception_5a_3x3.Weights)
%     reluLayer("Name","inception_5a-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = depthConcatenationLayer(4,"Name","inception_5a-output");
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],384,"Name","inception_5b-1x1","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5b_1x1.Bias,"Weights",trainingSetup.inception_5b_1x1.Weights)
%     reluLayer("Name","inception_5b-relu_1x1")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],192,"Name","inception_5b-3x3_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5b_3x3_reduce.Bias,"Weights",trainingSetup.inception_5b_3x3_reduce.Weights)
%     reluLayer("Name","inception_5b-relu_3x3_reduce")
%     convolution2dLayer([3 3],384,"Name","inception_5b-3x3","BiasLearnRateFactor",2,"Padding",[1 1 1 1],"Bias",trainingSetup.inception_5b_3x3.Bias,"Weights",trainingSetup.inception_5b_3x3.Weights)
%     reluLayer("Name","inception_5b-relu_3x3")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],48,"Name","inception_5b-5x5_reduce","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5b_5x5_reduce.Bias,"Weights",trainingSetup.inception_5b_5x5_reduce.Weights)
%     reluLayer("Name","inception_5b-relu_5x5_reduce")
%     convolution2dLayer([5 5],128,"Name","inception_5b-5x5","BiasLearnRateFactor",2,"Padding",[2 2 2 2],"Bias",trainingSetup.inception_5b_5x5.Bias,"Weights",trainingSetup.inception_5b_5x5.Weights)
%     reluLayer("Name","inception_5b-relu_5x5")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     maxPooling2dLayer([3 3],"Name","inception_5b-pool","Padding",[1 1 1 1])
%     convolution2dLayer([1 1],128,"Name","inception_5b-pool_proj","BiasLearnRateFactor",2,"Bias",trainingSetup.inception_5b_pool_proj.Bias,"Weights",trainingSetup.inception_5b_pool_proj.Weights)
%     reluLayer("Name","inception_5b-relu_pool_proj")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     depthConcatenationLayer(4,"Name","inception_5b-output")
%     globalAveragePooling2dLayer("Name","pool5-7x7_s1")
%     dropoutLayer(0.4,"Name","pool5-drop_7x7_s1")
%     fullyConnectedLayer(100,"Name","fc","BiasLearnRateFactor",10,"WeightLearnRateFactor",10)
%     softmaxLayer("Name","prob")
%     classificationLayer("Name","classoutput")];
% lgraph = addLayers(lgraph,tempLayers);
% clear tempLayers;
% lgraph = connectLayers(lgraph,"pool2-3x3_s2","inception_3a-1x1");
% lgraph = connectLayers(lgraph,"pool2-3x3_s2","inception_3a-3x3_reduce");
% lgraph = connectLayers(lgraph,"pool2-3x3_s2","inception_3a-pool");
% lgraph = connectLayers(lgraph,"pool2-3x3_s2","inception_3a-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_3a-relu_1x1","inception_3a-output/in1");
% lgraph = connectLayers(lgraph,"inception_3a-relu_pool_proj","inception_3a-output/in4");
% lgraph = connectLayers(lgraph,"inception_3a-relu_3x3","inception_3a-output/in2");
% lgraph = connectLayers(lgraph,"inception_3a-relu_5x5","inception_3a-output/in3");
% lgraph = connectLayers(lgraph,"inception_3a-output","inception_3b-1x1");
% lgraph = connectLayers(lgraph,"inception_3a-output","inception_3b-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_3a-output","inception_3b-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_3a-output","inception_3b-pool");
% lgraph = connectLayers(lgraph,"inception_3b-relu_1x1","inception_3b-output/in1");
% lgraph = connectLayers(lgraph,"inception_3b-relu_pool_proj","inception_3b-output/in4");
% lgraph = connectLayers(lgraph,"inception_3b-relu_5x5","inception_3b-output/in3");
% lgraph = connectLayers(lgraph,"inception_3b-relu_3x3","inception_3b-output/in2");
% lgraph = connectLayers(lgraph,"pool3-3x3_s2","inception_4a-5x5_reduce");
% lgraph = connectLayers(lgraph,"pool3-3x3_s2","inception_4a-3x3_reduce");
% lgraph = connectLayers(lgraph,"pool3-3x3_s2","inception_4a-1x1");
% lgraph = connectLayers(lgraph,"pool3-3x3_s2","inception_4a-pool");
% lgraph = connectLayers(lgraph,"inception_4a-relu_1x1","inception_4a-output/in1");
% lgraph = connectLayers(lgraph,"inception_4a-relu_3x3","inception_4a-output/in2");
% lgraph = connectLayers(lgraph,"inception_4a-relu_5x5","inception_4a-output/in3");
% lgraph = connectLayers(lgraph,"inception_4a-relu_pool_proj","inception_4a-output/in4");
% lgraph = connectLayers(lgraph,"inception_4a-output","inception_4b-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_4a-output","inception_4b-pool");
% lgraph = connectLayers(lgraph,"inception_4a-output","inception_4b-1x1");
% lgraph = connectLayers(lgraph,"inception_4a-output","inception_4b-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_4b-relu_pool_proj","inception_4b-output/in4");
% lgraph = connectLayers(lgraph,"inception_4b-relu_1x1","inception_4b-output/in1");
% lgraph = connectLayers(lgraph,"inception_4b-relu_3x3","inception_4b-output/in2");
% lgraph = connectLayers(lgraph,"inception_4b-relu_5x5","inception_4b-output/in3");
% lgraph = connectLayers(lgraph,"inception_4b-output","inception_4c-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_4b-output","inception_4c-1x1");
% lgraph = connectLayers(lgraph,"inception_4b-output","inception_4c-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_4b-output","inception_4c-pool");
% lgraph = connectLayers(lgraph,"inception_4c-relu_1x1","inception_4c-output/in1");
% lgraph = connectLayers(lgraph,"inception_4c-relu_5x5","inception_4c-output/in3");
% lgraph = connectLayers(lgraph,"inception_4c-relu_pool_proj","inception_4c-output/in4");
% lgraph = connectLayers(lgraph,"inception_4c-relu_3x3","inception_4c-output/in2");
% lgraph = connectLayers(lgraph,"inception_4c-output","inception_4d-pool");
% lgraph = connectLayers(lgraph,"inception_4c-output","inception_4d-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_4c-output","inception_4d-1x1");
% lgraph = connectLayers(lgraph,"inception_4c-output","inception_4d-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_4d-relu_5x5","inception_4d-output/in3");
% lgraph = connectLayers(lgraph,"inception_4d-relu_1x1","inception_4d-output/in1");
% lgraph = connectLayers(lgraph,"inception_4d-relu_pool_proj","inception_4d-output/in4");
% lgraph = connectLayers(lgraph,"inception_4d-relu_3x3","inception_4d-output/in2");
% lgraph = connectLayers(lgraph,"inception_4d-output","inception_4e-pool");
% lgraph = connectLayers(lgraph,"inception_4d-output","inception_4e-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_4d-output","inception_4e-1x1");
% lgraph = connectLayers(lgraph,"inception_4d-output","inception_4e-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_4e-relu_1x1","inception_4e-output/in1");
% lgraph = connectLayers(lgraph,"inception_4e-relu_5x5","inception_4e-output/in3");
% lgraph = connectLayers(lgraph,"inception_4e-relu_pool_proj","inception_4e-output/in4");
% lgraph = connectLayers(lgraph,"inception_4e-relu_3x3","inception_4e-output/in2");
% lgraph = connectLayers(lgraph,"pool4-3x3_s2","inception_5a-pool");
% lgraph = connectLayers(lgraph,"pool4-3x3_s2","inception_5a-5x5_reduce");
% lgraph = connectLayers(lgraph,"pool4-3x3_s2","inception_5a-1x1");
% lgraph = connectLayers(lgraph,"pool4-3x3_s2","inception_5a-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_5a-relu_1x1","inception_5a-output/in1");
% lgraph = connectLayers(lgraph,"inception_5a-relu_pool_proj","inception_5a-output/in4");
% lgraph = connectLayers(lgraph,"inception_5a-relu_5x5","inception_5a-output/in3");
% lgraph = connectLayers(lgraph,"inception_5a-relu_3x3","inception_5a-output/in2");
% lgraph = connectLayers(lgraph,"inception_5a-output","inception_5b-1x1");
% lgraph = connectLayers(lgraph,"inception_5a-output","inception_5b-3x3_reduce");
% lgraph = connectLayers(lgraph,"inception_5a-output","inception_5b-5x5_reduce");
% lgraph = connectLayers(lgraph,"inception_5a-output","inception_5b-pool");
% lgraph = connectLayers(lgraph,"inception_5b-relu_5x5","inception_5b-output/in3");
% lgraph = connectLayers(lgraph,"inception_5b-relu_1x1","inception_5b-output/in1");
% lgraph = connectLayers(lgraph,"inception_5b-relu_3x3","inception_5b-output/in2");
% lgraph = connectLayers(lgraph,"inception_5b-relu_pool_proj","inception_5b-output/in4");
% [net, traininfo] = trainNetwork(augimdsTrain,lgraph,opts);
