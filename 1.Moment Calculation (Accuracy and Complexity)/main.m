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
I=ones(128,128);
%% MODE
MD={'1.ZM';'2.PZM';'3.OFMM';'4.CHFM';'5.PJFM';'6.JFM';...   % Direct computation of Classical Jacobi polynomial based moments
    '7.RHFM';'8.EFM';'9.PCET';'10.PCT';'11.PST';...         % Direct computation of Classical Harmonic function based moments
    '12.BFM';...                                            % Direct computation of Classical Eigenfunction based moments
    '13.FJFM';...                                           % Direct computation of Fractional-order Jacobi polynomial based moments
    '14.GRHFM';'15.GPCET';'16.GPCT';'17.GPST';...           % Direct computation of Fractional-order Harmonic function based moments
    '18.FJFM-Recursive';...                                 % Recursive computation of Fractional-order Jacobi polynomial-based moments
    '19.GPCET-FFT';};                                       % FFT-based computation of Fractional-order Harmonic function-based moments         
for i=1:1:19, disp(MD{i}); end
MODE = input('Please select a mode (1~19): ');
K = input('Please enter the maximum order K (K>=0): ');
%% COMPUTE
if MODE==1
    [I,X,L,E,CE,DT]=ZM(I,K);
elseif MODE==2
    [I,X,L,E,CE,DT]=PZM(I,K);
elseif MODE==3
    [I,X,L,E,CE,DT]=OFMM(I,K);
elseif MODE==4
    [I,X,L,E,CE,DT]=CHFM(I,K);
elseif MODE==5
    [I,X,L,E,CE,DT]=PJFM(I,K);
elseif MODE==6
    [I,X,L,E,CE,DT,p,q]=JFM(I,K);
elseif MODE==7
    [I,X,L,E,CE,DT]=RHFM(I,K);
elseif MODE==8
    [I,X,L,E,CE,DT]=EFM(I,K);
elseif MODE==9
    [I,X,L,E,CE,DT]=PCET(I,K);
elseif MODE==10
    [I,X,L,E,CE,DT]=PCT(I,K);
elseif MODE==11
    [I,X,L,E,CE,DT]=PST(I,K);
elseif MODE==12
    [I,X,L,E,CE,DT,v]=BFM(I,K);
elseif MODE==13
    [I,X,L,E,CE,DT,p,q,alpha]=FJFM(I,K);
elseif MODE==14
    [I,X,L,E,CE,DT,alpha]=GRHFM(I,K);
elseif MODE==15
    [I,X,L,E,CE,DT,alpha]=GPCET(I,K);
elseif MODE==16
    [I,X,L,E,CE,DT,alpha]=GPCT(I,K);
elseif MODE==17
    [I,X,L,E,CE,DT,alpha]=GPST(I,K);
elseif MODE==18
    [I,X,L,E,CE,DT,p,q,alpha]=FJFM_Recursive(I,K);
elseif MODE==19
    [I,X,L,E,CE,DT,alpha]=GPCET_FFT(I,K);
else
    disp('Error!');
    return;
end
%% OUTPUT
figure;
subplot(121);bar3(abs(X));title('Moments');
subplot(122);bar3(abs(E));title({'Errors'; ['K=',num2str(K),'  DT=',num2str(DT),'  CE=',num2str(CE)]});
ADT=DT/L; ACE=CE/L;
clc;
if MODE==6
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),';']);
elseif MODE==12
    disp([MD{MODE},':    v=',num2str(v),';']);
elseif MODE==13 || MODE==18
    disp([MD{MODE},':    p=',num2str(p),', q=',num2str(q),', alpha=',num2str(alpha),';']);
elseif MODE==14 || MODE==15 || MODE==16 || MODE==17 || MODE==19
    disp([MD{MODE},':    alpha=',num2str(alpha),';']);
else
    disp(MD{MODE});
end
disp(table([K;L;DT;ADT;CE;ACE],'RowNames',{'K';'L';'DT';'ADT';'CE';'ACE'},'VariableNames',{'Value'}));
