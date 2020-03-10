%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code was developed by Qi Shuren 
% i@srqi.email
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
% I=imresize(I,[256 256]);
%% MODE
MD={'1.ZM[1980]';'2.PZM[1988]';'3.OFMM[1994]';'4.CHFM[2002]';'5.PJFM[2004]';'6.JFM[2007]';'7.BFM[2010]';'8.GPCET[2014]';'9.LM[1980]';'10.TM[2001]';'11.KM[2003]'};for i=1:1:11, disp(MD{i}); end
MODE = input('Please select a mode: (1 ~ 11)');
K = input('Please enter the maximum order K: (a natural number)');
%% COMPUTE
if MODE==1
    [I,It,L,DT,RT ]=ZM(I,K);
elseif MODE==2
    [I,It,L,DT,RT ]=PZM(I,K);
elseif MODE==3
    [I,It,L,DT,RT ]=OFMM(I,K);
elseif MODE==4
    [I,It,L,DT,RT ]=CHFM(I,K);
elseif MODE==5
    [I,It,L,DT,RT ]=PJFM(I,K);
elseif MODE==6
    [I,It,L,DT,RT,P,Q ]=JFM(I,K);
elseif MODE==7
    [I,It,L,DT,RT,V ]=BFM(I,K);
elseif MODE==8
    [I,It,L,DT,RT,S ]=GPCET(I,K);
elseif MODE==9
    [I,It,L,DT,RT ]=LM(I,K); 
elseif MODE==10
    [I,It,L,DT,RT ]=TM(I,K);
elseif MODE==11
    [I,It,L,DT,RT,P ]=KM(I,K);
else
    disp('Error!');
    return;
end
%% OUTPUT
figure;
subplot(121);
imshow(uint8(abs(I)));
title('Original');
subplot(122);
imshow(uint8(abs(It)));
different_a = (abs(abs( double(abs(It))-double(I)))).^2;
different_b = (double(I)).^2;
MSRE = sum(different_a(:))/sum(different_b(:));
clc;
if MODE==6
    disp([MD{MODE},':    P=',num2str(P),', Q=',num2str(Q),';']);
elseif MODE==7
    disp([MD{MODE},':    V=',num2str(V),';']);
elseif MODE==8
    disp([MD{MODE},':    S=',num2str(S),';']);
elseif MODE==11
    disp([MD{MODE},':    P=',num2str(P),';']);
else
    disp(MD{MODE});
end
disp(table([K;L;DT;RT;MSRE],'RowNames',{'K';'L';'DT';'RT';'MSRE'},'VariableNames',{'Value'}));
title({'Reconstructed'; ['K=',num2str(K),'  L=',num2str(L),'  MSRE=',num2str(MSRE)]});
