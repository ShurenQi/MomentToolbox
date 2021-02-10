clc;
close all;
clear;
for i=1:1:100
    I=imread(['training set\obj',num2str(i),'__0.png']);
    for r=0:10:350
        II=imrotate(I,r,'bicubic','crop');
        imwrite(uint8(II),['testing set\obj',num2str(i),'__',num2str(r/10),'.png'])
    end
end