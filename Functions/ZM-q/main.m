clc;
clear all;
close all;

I = imread('lena512.tif');
I = imresize(I,[256,256]);
I = double(I);

[I,It]=ZM_qRecursive(I,40);

figure;
subplot(121);
imshow(I,[0,255]);
subplot(122);
imshow(It,[0,255]);
