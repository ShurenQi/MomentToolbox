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
dbstop if error

mkdir('testing set');
S = [10,12,14,16,18];
T = [0,1,2,3,4];
PN = [1,-1];
for i=0:10:999
    I=imread(['corel\',num2str(i),'.jpg']);
    I=imresize(I,[128,128]);
    for r=0:10:350
        II=imrotate(I,r,'bicubic','crop');
        II=imresize(II,[128,128]+S(randi(5,1,1)));
        SIZE = [size(II,1),size(II,2)];
        PZ=(SIZE-[128,128])/2+[PN(randi(2,1,1))*T(randi(5,1,1)),PN(randi(2,1,1))*T(randi(5,1,1))];
        II=II(PZ(1):PZ(1)+127,PZ(2):PZ(2)+127,:);
        imwrite(uint8(II),['testing set\obj',num2str((i/10)+1),'__',num2str(r/10),'.png'])
    end
end