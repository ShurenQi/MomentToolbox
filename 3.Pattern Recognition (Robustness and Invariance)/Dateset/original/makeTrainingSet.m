clc;
close all;
clear;
addpath(genpath(pwd));
for i=0:10:999
    I=imread(['original\corel\',num2str(i),'.jpg']);
    I=rgb2gray(I);
    I=imresize(I,[128,128]);
    imwrite(I,['dateset\corel\training set\obj',num2str(i/10+1),'__0.png']);
end