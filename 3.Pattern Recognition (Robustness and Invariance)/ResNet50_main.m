%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code was developed by Shuren Qi
% https://shurenqi.github.io/
% i@srqi.email / shurenqi@nuaa.edu.cn
% All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test retrained ResNet-50 %%
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
%% Load retrained ResNet-50 model
load('retrainResNet50.mat')
for VAR=0:0.05:0.3
%% ResNet-50 testing
testLabels=zeros(TrnSize*36,1);
labels=zeros(TrnSize*36,1);
for i=1:1:TrnSize
    for j=0:1:35
        I=imread(['Dateset\testing set\obj',num2str(i),'__',num2str(j),'.png']);
        NI=imnoise(I,'gaussian',0,VAR);
        NI=imresize(NI,[NorSize NorSize]);
        [YPred,~] = classify(retrainResNet50,NI);
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

%% Retrain ResNet-50 on all rotation versions %%
% trainingSetup = load("Function\ResNet-50\trainingSetupResNet-50.mat");
% imdsTrain = imageDatastore("Dateset\training set","IncludeSubfolders",true,"LabelSource","foldernames");
% [imdsTrain, imdsValidation] = splitEachLabel(imdsTrain,0.7);
% 
% augimdsTrain = augmentedImageDatastore([224 224 3],imdsTrain);
% augimdsValidation = augmentedImageDatastore([224 224 3],imdsValidation);
% 
% opts = trainingOptions("sgdm",...
%     "ExecutionEnvironment","auto",...
%     "InitialLearnRate",0.0001,...
%     "MiniBatchSize",360,...
%     "Shuffle","every-epoch",...
%     "ValidationFrequency",5,...
%     "Plots","training-progress",...
%     "ValidationData",augimdsValidation);
% 
% lgraph = layerGraph();
% 
% tempLayers = [
%     imageInputLayer([224 224 3],"Name","input_1","Mean",trainingSetup.input_1.Mean)
%     convolution2dLayer([7 7],64,"Name","conv1","Padding",[3 3 3 3],"Stride",[2 2],"Bias",trainingSetup.conv1.Bias,"Weights",trainingSetup.conv1.Weights)
%     batchNormalizationLayer("Name","bn_conv1","Epsilon",0.001,"Offset",trainingSetup.bn_conv1.Offset,"Scale",trainingSetup.bn_conv1.Scale,"TrainedMean",trainingSetup.bn_conv1.TrainedMean,"TrainedVariance",trainingSetup.bn_conv1.TrainedVariance)
%     reluLayer("Name","activation_1_relu")
%     maxPooling2dLayer([3 3],"Name","max_pooling2d_1","Padding",[1 1 1 1],"Stride",[2 2])];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res2a_branch1","BiasLearnRateFactor",0,"Bias",trainingSetup.res2a_branch1.Bias,"Weights",trainingSetup.res2a_branch1.Weights)
%     batchNormalizationLayer("Name","bn2a_branch1","Epsilon",0.001,"Offset",trainingSetup.bn2a_branch1.Offset,"Scale",trainingSetup.bn2a_branch1.Scale,"TrainedMean",trainingSetup.bn2a_branch1.TrainedMean,"TrainedVariance",trainingSetup.bn2a_branch1.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],64,"Name","res2a_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res2a_branch2a.Bias,"Weights",trainingSetup.res2a_branch2a.Weights)
%     batchNormalizationLayer("Name","bn2a_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn2a_branch2a.Offset,"Scale",trainingSetup.bn2a_branch2a.Scale,"TrainedMean",trainingSetup.bn2a_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn2a_branch2a.TrainedVariance)
%     reluLayer("Name","activation_2_relu")
%     convolution2dLayer([3 3],64,"Name","res2a_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res2a_branch2b.Bias,"Weights",trainingSetup.res2a_branch2b.Weights)
%     batchNormalizationLayer("Name","bn2a_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn2a_branch2b.Offset,"Scale",trainingSetup.bn2a_branch2b.Scale,"TrainedMean",trainingSetup.bn2a_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn2a_branch2b.TrainedVariance)
%     reluLayer("Name","activation_3_relu")
%     convolution2dLayer([1 1],256,"Name","res2a_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res2a_branch2c.Bias,"Weights",trainingSetup.res2a_branch2c.Weights)
%     batchNormalizationLayer("Name","bn2a_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn2a_branch2c.Offset,"Scale",trainingSetup.bn2a_branch2c.Scale,"TrainedMean",trainingSetup.bn2a_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn2a_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_1")
%     reluLayer("Name","activation_4_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],64,"Name","res2b_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res2b_branch2a.Bias,"Weights",trainingSetup.res2b_branch2a.Weights)
%     batchNormalizationLayer("Name","bn2b_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn2b_branch2a.Offset,"Scale",trainingSetup.bn2b_branch2a.Scale,"TrainedMean",trainingSetup.bn2b_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn2b_branch2a.TrainedVariance)
%     reluLayer("Name","activation_5_relu")
%     convolution2dLayer([3 3],64,"Name","res2b_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res2b_branch2b.Bias,"Weights",trainingSetup.res2b_branch2b.Weights)
%     batchNormalizationLayer("Name","bn2b_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn2b_branch2b.Offset,"Scale",trainingSetup.bn2b_branch2b.Scale,"TrainedMean",trainingSetup.bn2b_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn2b_branch2b.TrainedVariance)
%     reluLayer("Name","activation_6_relu")
%     convolution2dLayer([1 1],256,"Name","res2b_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res2b_branch2c.Bias,"Weights",trainingSetup.res2b_branch2c.Weights)
%     batchNormalizationLayer("Name","bn2b_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn2b_branch2c.Offset,"Scale",trainingSetup.bn2b_branch2c.Scale,"TrainedMean",trainingSetup.bn2b_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn2b_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_2")
%     reluLayer("Name","activation_7_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],64,"Name","res2c_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res2c_branch2a.Bias,"Weights",trainingSetup.res2c_branch2a.Weights)
%     batchNormalizationLayer("Name","bn2c_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn2c_branch2a.Offset,"Scale",trainingSetup.bn2c_branch2a.Scale,"TrainedMean",trainingSetup.bn2c_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn2c_branch2a.TrainedVariance)
%     reluLayer("Name","activation_8_relu")
%     convolution2dLayer([3 3],64,"Name","res2c_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res2c_branch2b.Bias,"Weights",trainingSetup.res2c_branch2b.Weights)
%     batchNormalizationLayer("Name","bn2c_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn2c_branch2b.Offset,"Scale",trainingSetup.bn2c_branch2b.Scale,"TrainedMean",trainingSetup.bn2c_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn2c_branch2b.TrainedVariance)
%     reluLayer("Name","activation_9_relu")
%     convolution2dLayer([1 1],256,"Name","res2c_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res2c_branch2c.Bias,"Weights",trainingSetup.res2c_branch2c.Weights)
%     batchNormalizationLayer("Name","bn2c_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn2c_branch2c.Offset,"Scale",trainingSetup.bn2c_branch2c.Scale,"TrainedMean",trainingSetup.bn2c_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn2c_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_3")
%     reluLayer("Name","activation_10_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","res3a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res3a_branch2a.Bias,"Weights",trainingSetup.res3a_branch2a.Weights)
%     batchNormalizationLayer("Name","bn3a_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn3a_branch2a.Offset,"Scale",trainingSetup.bn3a_branch2a.Scale,"TrainedMean",trainingSetup.bn3a_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn3a_branch2a.TrainedVariance)
%     reluLayer("Name","activation_11_relu")
%     convolution2dLayer([3 3],128,"Name","res3a_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res3a_branch2b.Bias,"Weights",trainingSetup.res3a_branch2b.Weights)
%     batchNormalizationLayer("Name","bn3a_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn3a_branch2b.Offset,"Scale",trainingSetup.bn3a_branch2b.Scale,"TrainedMean",trainingSetup.bn3a_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn3a_branch2b.TrainedVariance)
%     reluLayer("Name","activation_12_relu")
%     convolution2dLayer([1 1],512,"Name","res3a_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res3a_branch2c.Bias,"Weights",trainingSetup.res3a_branch2c.Weights)
%     batchNormalizationLayer("Name","bn3a_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn3a_branch2c.Offset,"Scale",trainingSetup.bn3a_branch2c.Scale,"TrainedMean",trainingSetup.bn3a_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn3a_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],512,"Name","res3a_branch1","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res3a_branch1.Bias,"Weights",trainingSetup.res3a_branch1.Weights)
%     batchNormalizationLayer("Name","bn3a_branch1","Epsilon",0.001,"Offset",trainingSetup.bn3a_branch1.Offset,"Scale",trainingSetup.bn3a_branch1.Scale,"TrainedMean",trainingSetup.bn3a_branch1.TrainedMean,"TrainedVariance",trainingSetup.bn3a_branch1.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_4")
%     reluLayer("Name","activation_13_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","res3b_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res3b_branch2a.Bias,"Weights",trainingSetup.res3b_branch2a.Weights)
%     batchNormalizationLayer("Name","bn3b_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn3b_branch2a.Offset,"Scale",trainingSetup.bn3b_branch2a.Scale,"TrainedMean",trainingSetup.bn3b_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn3b_branch2a.TrainedVariance)
%     reluLayer("Name","activation_14_relu")
%     convolution2dLayer([3 3],128,"Name","res3b_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res3b_branch2b.Bias,"Weights",trainingSetup.res3b_branch2b.Weights)
%     batchNormalizationLayer("Name","bn3b_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn3b_branch2b.Offset,"Scale",trainingSetup.bn3b_branch2b.Scale,"TrainedMean",trainingSetup.bn3b_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn3b_branch2b.TrainedVariance)
%     reluLayer("Name","activation_15_relu")
%     convolution2dLayer([1 1],512,"Name","res3b_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res3b_branch2c.Bias,"Weights",trainingSetup.res3b_branch2c.Weights)
%     batchNormalizationLayer("Name","bn3b_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn3b_branch2c.Offset,"Scale",trainingSetup.bn3b_branch2c.Scale,"TrainedMean",trainingSetup.bn3b_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn3b_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_5")
%     reluLayer("Name","activation_16_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","res3c_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res3c_branch2a.Bias,"Weights",trainingSetup.res3c_branch2a.Weights)
%     batchNormalizationLayer("Name","bn3c_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn3c_branch2a.Offset,"Scale",trainingSetup.bn3c_branch2a.Scale,"TrainedMean",trainingSetup.bn3c_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn3c_branch2a.TrainedVariance)
%     reluLayer("Name","activation_17_relu")
%     convolution2dLayer([3 3],128,"Name","res3c_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res3c_branch2b.Bias,"Weights",trainingSetup.res3c_branch2b.Weights)
%     batchNormalizationLayer("Name","bn3c_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn3c_branch2b.Offset,"Scale",trainingSetup.bn3c_branch2b.Scale,"TrainedMean",trainingSetup.bn3c_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn3c_branch2b.TrainedVariance)
%     reluLayer("Name","activation_18_relu")
%     convolution2dLayer([1 1],512,"Name","res3c_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res3c_branch2c.Bias,"Weights",trainingSetup.res3c_branch2c.Weights)
%     batchNormalizationLayer("Name","bn3c_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn3c_branch2c.Offset,"Scale",trainingSetup.bn3c_branch2c.Scale,"TrainedMean",trainingSetup.bn3c_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn3c_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_6")
%     reluLayer("Name","activation_19_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],128,"Name","res3d_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res3d_branch2a.Bias,"Weights",trainingSetup.res3d_branch2a.Weights)
%     batchNormalizationLayer("Name","bn3d_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn3d_branch2a.Offset,"Scale",trainingSetup.bn3d_branch2a.Scale,"TrainedMean",trainingSetup.bn3d_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn3d_branch2a.TrainedVariance)
%     reluLayer("Name","activation_20_relu")
%     convolution2dLayer([3 3],128,"Name","res3d_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res3d_branch2b.Bias,"Weights",trainingSetup.res3d_branch2b.Weights)
%     batchNormalizationLayer("Name","bn3d_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn3d_branch2b.Offset,"Scale",trainingSetup.bn3d_branch2b.Scale,"TrainedMean",trainingSetup.bn3d_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn3d_branch2b.TrainedVariance)
%     reluLayer("Name","activation_21_relu")
%     convolution2dLayer([1 1],512,"Name","res3d_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res3d_branch2c.Bias,"Weights",trainingSetup.res3d_branch2c.Weights)
%     batchNormalizationLayer("Name","bn3d_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn3d_branch2c.Offset,"Scale",trainingSetup.bn3d_branch2c.Scale,"TrainedMean",trainingSetup.bn3d_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn3d_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_7")
%     reluLayer("Name","activation_22_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res4a_branch2a.Bias,"Weights",trainingSetup.res4a_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4a_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4a_branch2a.Offset,"Scale",trainingSetup.bn4a_branch2a.Scale,"TrainedMean",trainingSetup.bn4a_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4a_branch2a.TrainedVariance)
%     reluLayer("Name","activation_23_relu")
%     convolution2dLayer([3 3],256,"Name","res4a_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4a_branch2b.Bias,"Weights",trainingSetup.res4a_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4a_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4a_branch2b.Offset,"Scale",trainingSetup.bn4a_branch2b.Scale,"TrainedMean",trainingSetup.bn4a_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4a_branch2b.TrainedVariance)
%     reluLayer("Name","activation_24_relu")
%     convolution2dLayer([1 1],1024,"Name","res4a_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4a_branch2c.Bias,"Weights",trainingSetup.res4a_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4a_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4a_branch2c.Offset,"Scale",trainingSetup.bn4a_branch2c.Scale,"TrainedMean",trainingSetup.bn4a_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4a_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],1024,"Name","res4a_branch1","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res4a_branch1.Bias,"Weights",trainingSetup.res4a_branch1.Weights)
%     batchNormalizationLayer("Name","bn4a_branch1","Epsilon",0.001,"Offset",trainingSetup.bn4a_branch1.Offset,"Scale",trainingSetup.bn4a_branch1.Scale,"TrainedMean",trainingSetup.bn4a_branch1.TrainedMean,"TrainedVariance",trainingSetup.bn4a_branch1.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_8")
%     reluLayer("Name","activation_25_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4b_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res4b_branch2a.Bias,"Weights",trainingSetup.res4b_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4b_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4b_branch2a.Offset,"Scale",trainingSetup.bn4b_branch2a.Scale,"TrainedMean",trainingSetup.bn4b_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4b_branch2a.TrainedVariance)
%     reluLayer("Name","activation_26_relu")
%     convolution2dLayer([3 3],256,"Name","res4b_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4b_branch2b.Bias,"Weights",trainingSetup.res4b_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4b_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4b_branch2b.Offset,"Scale",trainingSetup.bn4b_branch2b.Scale,"TrainedMean",trainingSetup.bn4b_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4b_branch2b.TrainedVariance)
%     reluLayer("Name","activation_27_relu")
%     convolution2dLayer([1 1],1024,"Name","res4b_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4b_branch2c.Bias,"Weights",trainingSetup.res4b_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4b_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4b_branch2c.Offset,"Scale",trainingSetup.bn4b_branch2c.Scale,"TrainedMean",trainingSetup.bn4b_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4b_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_9")
%     reluLayer("Name","activation_28_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4c_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res4c_branch2a.Bias,"Weights",trainingSetup.res4c_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4c_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4c_branch2a.Offset,"Scale",trainingSetup.bn4c_branch2a.Scale,"TrainedMean",trainingSetup.bn4c_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4c_branch2a.TrainedVariance)
%     reluLayer("Name","activation_29_relu")
%     convolution2dLayer([3 3],256,"Name","res4c_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4c_branch2b.Bias,"Weights",trainingSetup.res4c_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4c_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4c_branch2b.Offset,"Scale",trainingSetup.bn4c_branch2b.Scale,"TrainedMean",trainingSetup.bn4c_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4c_branch2b.TrainedVariance)
%     reluLayer("Name","activation_30_relu")
%     convolution2dLayer([1 1],1024,"Name","res4c_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4c_branch2c.Bias,"Weights",trainingSetup.res4c_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4c_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4c_branch2c.Offset,"Scale",trainingSetup.bn4c_branch2c.Scale,"TrainedMean",trainingSetup.bn4c_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4c_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_10")
%     reluLayer("Name","activation_31_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4d_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res4d_branch2a.Bias,"Weights",trainingSetup.res4d_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4d_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4d_branch2a.Offset,"Scale",trainingSetup.bn4d_branch2a.Scale,"TrainedMean",trainingSetup.bn4d_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4d_branch2a.TrainedVariance)
%     reluLayer("Name","activation_32_relu")
%     convolution2dLayer([3 3],256,"Name","res4d_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4d_branch2b.Bias,"Weights",trainingSetup.res4d_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4d_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4d_branch2b.Offset,"Scale",trainingSetup.bn4d_branch2b.Scale,"TrainedMean",trainingSetup.bn4d_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4d_branch2b.TrainedVariance)
%     reluLayer("Name","activation_33_relu")
%     convolution2dLayer([1 1],1024,"Name","res4d_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4d_branch2c.Bias,"Weights",trainingSetup.res4d_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4d_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4d_branch2c.Offset,"Scale",trainingSetup.bn4d_branch2c.Scale,"TrainedMean",trainingSetup.bn4d_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4d_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_11")
%     reluLayer("Name","activation_34_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4e_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res4e_branch2a.Bias,"Weights",trainingSetup.res4e_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4e_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4e_branch2a.Offset,"Scale",trainingSetup.bn4e_branch2a.Scale,"TrainedMean",trainingSetup.bn4e_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4e_branch2a.TrainedVariance)
%     reluLayer("Name","activation_35_relu")
%     convolution2dLayer([3 3],256,"Name","res4e_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4e_branch2b.Bias,"Weights",trainingSetup.res4e_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4e_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4e_branch2b.Offset,"Scale",trainingSetup.bn4e_branch2b.Scale,"TrainedMean",trainingSetup.bn4e_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4e_branch2b.TrainedVariance)
%     reluLayer("Name","activation_36_relu")
%     convolution2dLayer([1 1],1024,"Name","res4e_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4e_branch2c.Bias,"Weights",trainingSetup.res4e_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4e_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4e_branch2c.Offset,"Scale",trainingSetup.bn4e_branch2c.Scale,"TrainedMean",trainingSetup.bn4e_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4e_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_12")
%     reluLayer("Name","activation_37_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],256,"Name","res4f_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res4f_branch2a.Bias,"Weights",trainingSetup.res4f_branch2a.Weights)
%     batchNormalizationLayer("Name","bn4f_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn4f_branch2a.Offset,"Scale",trainingSetup.bn4f_branch2a.Scale,"TrainedMean",trainingSetup.bn4f_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn4f_branch2a.TrainedVariance)
%     reluLayer("Name","activation_38_relu")
%     convolution2dLayer([3 3],256,"Name","res4f_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res4f_branch2b.Bias,"Weights",trainingSetup.res4f_branch2b.Weights)
%     batchNormalizationLayer("Name","bn4f_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn4f_branch2b.Offset,"Scale",trainingSetup.bn4f_branch2b.Scale,"TrainedMean",trainingSetup.bn4f_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn4f_branch2b.TrainedVariance)
%     reluLayer("Name","activation_39_relu")
%     convolution2dLayer([1 1],1024,"Name","res4f_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res4f_branch2c.Bias,"Weights",trainingSetup.res4f_branch2c.Weights)
%     batchNormalizationLayer("Name","bn4f_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn4f_branch2c.Offset,"Scale",trainingSetup.bn4f_branch2c.Scale,"TrainedMean",trainingSetup.bn4f_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn4f_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_13")
%     reluLayer("Name","activation_40_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],2048,"Name","res5a_branch1","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res5a_branch1.Bias,"Weights",trainingSetup.res5a_branch1.Weights)
%     batchNormalizationLayer("Name","bn5a_branch1","Epsilon",0.001,"Offset",trainingSetup.bn5a_branch1.Offset,"Scale",trainingSetup.bn5a_branch1.Scale,"TrainedMean",trainingSetup.bn5a_branch1.TrainedMean,"TrainedVariance",trainingSetup.bn5a_branch1.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],512,"Name","res5a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2],"Bias",trainingSetup.res5a_branch2a.Bias,"Weights",trainingSetup.res5a_branch2a.Weights)
%     batchNormalizationLayer("Name","bn5a_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn5a_branch2a.Offset,"Scale",trainingSetup.bn5a_branch2a.Scale,"TrainedMean",trainingSetup.bn5a_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn5a_branch2a.TrainedVariance)
%     reluLayer("Name","activation_41_relu")
%     convolution2dLayer([3 3],512,"Name","res5a_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res5a_branch2b.Bias,"Weights",trainingSetup.res5a_branch2b.Weights)
%     batchNormalizationLayer("Name","bn5a_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn5a_branch2b.Offset,"Scale",trainingSetup.bn5a_branch2b.Scale,"TrainedMean",trainingSetup.bn5a_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn5a_branch2b.TrainedVariance)
%     reluLayer("Name","activation_42_relu")
%     convolution2dLayer([1 1],2048,"Name","res5a_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res5a_branch2c.Bias,"Weights",trainingSetup.res5a_branch2c.Weights)
%     batchNormalizationLayer("Name","bn5a_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn5a_branch2c.Offset,"Scale",trainingSetup.bn5a_branch2c.Scale,"TrainedMean",trainingSetup.bn5a_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn5a_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_14")
%     reluLayer("Name","activation_43_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],512,"Name","res5b_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res5b_branch2a.Bias,"Weights",trainingSetup.res5b_branch2a.Weights)
%     batchNormalizationLayer("Name","bn5b_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn5b_branch2a.Offset,"Scale",trainingSetup.bn5b_branch2a.Scale,"TrainedMean",trainingSetup.bn5b_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn5b_branch2a.TrainedVariance)
%     reluLayer("Name","activation_44_relu")
%     convolution2dLayer([3 3],512,"Name","res5b_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res5b_branch2b.Bias,"Weights",trainingSetup.res5b_branch2b.Weights)
%     batchNormalizationLayer("Name","bn5b_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn5b_branch2b.Offset,"Scale",trainingSetup.bn5b_branch2b.Scale,"TrainedMean",trainingSetup.bn5b_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn5b_branch2b.TrainedVariance)
%     reluLayer("Name","activation_45_relu")
%     convolution2dLayer([1 1],2048,"Name","res5b_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res5b_branch2c.Bias,"Weights",trainingSetup.res5b_branch2c.Weights)
%     batchNormalizationLayer("Name","bn5b_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn5b_branch2c.Offset,"Scale",trainingSetup.bn5b_branch2c.Scale,"TrainedMean",trainingSetup.bn5b_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn5b_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_15")
%     reluLayer("Name","activation_46_relu")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     convolution2dLayer([1 1],512,"Name","res5c_branch2a","BiasLearnRateFactor",0,"Bias",trainingSetup.res5c_branch2a.Bias,"Weights",trainingSetup.res5c_branch2a.Weights)
%     batchNormalizationLayer("Name","bn5c_branch2a","Epsilon",0.001,"Offset",trainingSetup.bn5c_branch2a.Offset,"Scale",trainingSetup.bn5c_branch2a.Scale,"TrainedMean",trainingSetup.bn5c_branch2a.TrainedMean,"TrainedVariance",trainingSetup.bn5c_branch2a.TrainedVariance)
%     reluLayer("Name","activation_47_relu")
%     convolution2dLayer([3 3],512,"Name","res5c_branch2b","BiasLearnRateFactor",0,"Padding","same","Bias",trainingSetup.res5c_branch2b.Bias,"Weights",trainingSetup.res5c_branch2b.Weights)
%     batchNormalizationLayer("Name","bn5c_branch2b","Epsilon",0.001,"Offset",trainingSetup.bn5c_branch2b.Offset,"Scale",trainingSetup.bn5c_branch2b.Scale,"TrainedMean",trainingSetup.bn5c_branch2b.TrainedMean,"TrainedVariance",trainingSetup.bn5c_branch2b.TrainedVariance)
%     reluLayer("Name","activation_48_relu")
%     convolution2dLayer([1 1],2048,"Name","res5c_branch2c","BiasLearnRateFactor",0,"Bias",trainingSetup.res5c_branch2c.Bias,"Weights",trainingSetup.res5c_branch2c.Weights)
%     batchNormalizationLayer("Name","bn5c_branch2c","Epsilon",0.001,"Offset",trainingSetup.bn5c_branch2c.Offset,"Scale",trainingSetup.bn5c_branch2c.Scale,"TrainedMean",trainingSetup.bn5c_branch2c.TrainedMean,"TrainedVariance",trainingSetup.bn5c_branch2c.TrainedVariance)];
% lgraph = addLayers(lgraph,tempLayers);
% 
% tempLayers = [
%     additionLayer(2,"Name","add_16")
%     reluLayer("Name","activation_49_relu")
%     globalAveragePooling2dLayer("Name","avg_pool")
%     fullyConnectedLayer(100,"Name","fc","BiasLearnRateFactor",10,"WeightLearnRateFactor",10)
%     softmaxLayer("Name","fc1000_softmax")
%     classificationLayer("Name","classoutput")];
% lgraph = addLayers(lgraph,tempLayers);
% 
% clear tempLayers;
% 
% lgraph = connectLayers(lgraph,"max_pooling2d_1","res2a_branch1");
% lgraph = connectLayers(lgraph,"max_pooling2d_1","res2a_branch2a");
% lgraph = connectLayers(lgraph,"bn2a_branch1","add_1/in2");
% lgraph = connectLayers(lgraph,"bn2a_branch2c","add_1/in1");
% lgraph = connectLayers(lgraph,"activation_4_relu","res2b_branch2a");
% lgraph = connectLayers(lgraph,"activation_4_relu","add_2/in2");
% lgraph = connectLayers(lgraph,"bn2b_branch2c","add_2/in1");
% lgraph = connectLayers(lgraph,"activation_7_relu","res2c_branch2a");
% lgraph = connectLayers(lgraph,"activation_7_relu","add_3/in2");
% lgraph = connectLayers(lgraph,"bn2c_branch2c","add_3/in1");
% lgraph = connectLayers(lgraph,"activation_10_relu","res3a_branch2a");
% lgraph = connectLayers(lgraph,"activation_10_relu","res3a_branch1");
% lgraph = connectLayers(lgraph,"bn3a_branch2c","add_4/in1");
% lgraph = connectLayers(lgraph,"bn3a_branch1","add_4/in2");
% lgraph = connectLayers(lgraph,"activation_13_relu","res3b_branch2a");
% lgraph = connectLayers(lgraph,"activation_13_relu","add_5/in2");
% lgraph = connectLayers(lgraph,"bn3b_branch2c","add_5/in1");
% lgraph = connectLayers(lgraph,"activation_16_relu","res3c_branch2a");
% lgraph = connectLayers(lgraph,"activation_16_relu","add_6/in2");
% lgraph = connectLayers(lgraph,"bn3c_branch2c","add_6/in1");
% lgraph = connectLayers(lgraph,"activation_19_relu","res3d_branch2a");
% lgraph = connectLayers(lgraph,"activation_19_relu","add_7/in2");
% lgraph = connectLayers(lgraph,"bn3d_branch2c","add_7/in1");
% lgraph = connectLayers(lgraph,"activation_22_relu","res4a_branch2a");
% lgraph = connectLayers(lgraph,"activation_22_relu","res4a_branch1");
% lgraph = connectLayers(lgraph,"bn4a_branch1","add_8/in2");
% lgraph = connectLayers(lgraph,"bn4a_branch2c","add_8/in1");
% lgraph = connectLayers(lgraph,"activation_25_relu","res4b_branch2a");
% lgraph = connectLayers(lgraph,"activation_25_relu","add_9/in2");
% lgraph = connectLayers(lgraph,"bn4b_branch2c","add_9/in1");
% lgraph = connectLayers(lgraph,"activation_28_relu","res4c_branch2a");
% lgraph = connectLayers(lgraph,"activation_28_relu","add_10/in2");
% lgraph = connectLayers(lgraph,"bn4c_branch2c","add_10/in1");
% lgraph = connectLayers(lgraph,"activation_31_relu","res4d_branch2a");
% lgraph = connectLayers(lgraph,"activation_31_relu","add_11/in2");
% lgraph = connectLayers(lgraph,"bn4d_branch2c","add_11/in1");
% lgraph = connectLayers(lgraph,"activation_34_relu","res4e_branch2a");
% lgraph = connectLayers(lgraph,"activation_34_relu","add_12/in2");
% lgraph = connectLayers(lgraph,"bn4e_branch2c","add_12/in1");
% lgraph = connectLayers(lgraph,"activation_37_relu","res4f_branch2a");
% lgraph = connectLayers(lgraph,"activation_37_relu","add_13/in2");
% lgraph = connectLayers(lgraph,"bn4f_branch2c","add_13/in1");
% lgraph = connectLayers(lgraph,"activation_40_relu","res5a_branch1");
% lgraph = connectLayers(lgraph,"activation_40_relu","res5a_branch2a");
% lgraph = connectLayers(lgraph,"bn5a_branch1","add_14/in2");
% lgraph = connectLayers(lgraph,"bn5a_branch2c","add_14/in1");
% lgraph = connectLayers(lgraph,"activation_43_relu","res5b_branch2a");
% lgraph = connectLayers(lgraph,"activation_43_relu","add_15/in2");
% lgraph = connectLayers(lgraph,"bn5b_branch2c","add_15/in1");
% lgraph = connectLayers(lgraph,"activation_46_relu","res5c_branch2a");
% lgraph = connectLayers(lgraph,"activation_46_relu","add_16/in2");
% lgraph = connectLayers(lgraph,"bn5c_branch2c","add_16/in1");
% 
% [net, traininfo] = trainNetwork(augimdsTrain,lgraph,opts);

