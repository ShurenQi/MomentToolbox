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
%% INPUT
I=imread('lena.tif');
I=imresize(I,[256,256]);
%% MODE
MD={'1.ZM';'2.PZM';'3.OFMM';'4.CHFM';'5.PJFM';'6.JFM';...   % Recursive computation of Classical Jacobi polynomial based moments
    '7.RHFM';'8.EFM';'9.PCET';...                           % FFT-based computation of Classical Harmonic function based moments
    '10.BFM';...                                            % Direct computation of Classical Eigenfunction based moments
    '11.FJFM';...                                           % Recursive computation of Fractional-order Jacobi polynomial based moments
    '12.GRHFM';'13.GPCET'};                                 % FFT-based computation of Fractional-order Harmonic function based moments      
for i=1:1:13, disp(MD{i}); end
MODE = input('Please select a mode (1~13): ');
K = input('Please enter the maximum order K (K>=0): ');
%% COMPUTE
if MODE==1
    [I,RI,DT,RT]=ZM(I,K);
elseif MODE==2
    [I,RI,DT,RT]=PZM(I,K);
elseif MODE==3
    [I,RI,DT,RT]=OFMM(I,K);
elseif MODE==4
    [I,RI,DT,RT]=CHFM(I,K);
elseif MODE==5
    [I,RI,DT,RT]=PJFM(I,K);
elseif MODE==6
    [I,RI,DT,RT,p,q]=JFM(I,K);
elseif MODE==7
    [I,RI,DT,RT]=RHFM(I,K);
elseif MODE==8
    [I,RI,DT,RT]=EFM(I,K);
elseif MODE==9
    [I,RI,DT,RT]=PCET(I,K);
elseif MODE==10
    [I,RI,DT,RT,v]=BFM(I,K);
elseif MODE==11
    [I,RI,DT,RT,p,q,alpha]=FJFM(I,K);
elseif MODE==12
    [I,RI,DT,RT,alpha]=GRHFM(I,K);
elseif MODE==13
    [I,RI,DT,RT,alpha]=GPCET(I,K);
else
    disp('Error!');
    return;
end
%% OUTPUT
different_a = (abs(abs(double(RI)-double(I)))).^2;
different_b = (double(I)).^2;
MSRE = sum(different_a(:))/sum(different_b(:));
PSNR = psnr(uint8(I),uint8(RI));
SSIM = ssim(uint8(I),uint8(RI));
figure;
subplot(121); imshow(uint8(abs(I))); title('Original');
subplot(122); imshow(uint8(abs(RI)));title({'Reconstructed'; ['K=',num2str(K),'  MSRE=',num2str(MSRE)]});
clc;
if MODE==6
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),';']);
elseif MODE==10
    disp([MD{MODE},':    v=',num2str(v),';']);
elseif MODE==11
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),', alpha=',num2str(alpha),';']);
elseif MODE==12 || MODE==13
    disp([MD{MODE},':    alpha=',num2str(alpha),';']);
else
    disp(MD{MODE});
end
disp(table([K;DT;RT;MSRE;PSNR;SSIM],'RowNames',{'K';'DT';'RT';'MSRE';'PSNR';'SSIM'},'VariableNames',{'Value'}));

