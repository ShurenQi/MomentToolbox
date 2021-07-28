%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code was developed by Shuren Qi
% https://shurenqi.github.io/
% i@srqi.email / shurenqi@nuaa.edu.cn
% All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all;
clear all;
clc;
warning('off'); 
addpath(genpath(pwd));
% dbstop if error
%% METHOD
MD={'1.ZM';'2.PZM';'3.OFMM';'4.CHFM';'5.PJFM';'6.JFM';...   % Classical Jacobi polynomial based moments
    '7.RHFM';'8.EFM';'9.PCET';'10.PCT';'11.PST';...         % Classical Harmonic function based moments
    '12.BFM';...                                            % Classical Eigenfunction based moments
    '13.FJFM';...                                           % Fractional-order Jacobi polynomial based moments
    '14.GRHFM';'15.GPCET';'16.GPCT';'17.GPST'};             % Fractional-order Harmonic function based moments   
for i=1:1:17, disp(MD{i}); end
MODE = input('Please select a mode (1~17): ');
K = input('Please enter the maximum order K (K>=0): ');
SZ1=128; SZ2=128; OBJ=100;
VARrange=0:0.05:0.3;
%% COMPUTE
[BF,L,p,q,alpha,v]=getBF(MODE,SZ1,SZ2,K);
clc;
if MODE==6
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),';']);
elseif MODE==12
    disp([MD{MODE},':    v=',num2str(v),';']);
elseif MODE==13
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),', alpha=',num2str(alpha),';']);
elseif MODE==14 || MODE==15 || MODE==16 || MODE==17
    disp([MD{MODE},':    alpha=',num2str(alpha),';']);
else
    disp(MD{MODE});
end
disp(table([K;L],'RowNames',{'K';'L'},'VariableNames',{'Value'}));
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp(['	VAR      ','   CCP(%)']);
flg=1;
UCCP=zeros(size(VARrange,2),1);
for VAR=VARrange
% training
[r,o]=ro(SZ1,SZ2);
pz=r>1;
trainLabels =zeros(OBJ,1);
trainData=zeros(OBJ,L);
for i=1:1:OBJ
        I=imread(['Dateset\training set\',num2str(i),'\obj',num2str(i),'__0.png']);
        I=rgb2gray(I);
        I(pz)=0;
        trainLabels(i,1)=i;
        trainData(i,:)=features(double(I),L,BF)';
end
% testing
testLabels =zeros(OBJ*36,1);
testData=zeros(OBJ*36,L);
for i=1:1:OBJ
    for j=0:1:35
        I=imread(['Dateset\testing set\obj',num2str(i),'__',num2str(j),'.png']);
        I=rgb2gray(I);
        NI=imnoise(I,'gaussian',0,VAR);
        NI(pz)=0;
        k=(i-1)*36+j+1;
        testLabels(k,1)=i;
        testData(k,:)=features(double(NI),L,BF)';
    end
end
%% OUTPUT
Mdl = fitcknn(trainData,trainLabels,'NumNeighbors',1);
label = predict(Mdl,testData);
accuracy = length(find(label == testLabels))/(OBJ*36)*100;
UCCP(flg,1)=accuracy;
if mod(flg,2)==1
    disp(['	',num2str(VAR),'			',num2str(accuracy)]);
else
    disp(['	',num2str(VAR),'		',num2str(accuracy)]);
end
flg=flg+1;
close all;
end
