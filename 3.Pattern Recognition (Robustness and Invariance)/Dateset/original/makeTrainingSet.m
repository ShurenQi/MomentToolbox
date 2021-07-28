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

mkdir('training set');
for i=0:10:999
    I=imread(['corel\',num2str(i),'.jpg']);
    I=imresize(I,[128,128]);
    mkdir('training set',num2str((i/10)+1))
    for r=0:10:350
        II=imrotate(I,r,'bicubic','crop');
        imwrite(uint8(II),['training set\',num2str((i/10)+1),'\obj',num2str((i/10)+1),'__',num2str(r/10),'.png'])
    end
end
