close all;clear;clc;
xyloObj = VideoReader('M_20160920094232_0000000001769241_1_001_001-1.mp4'); %��Ӧ�޸�Ϊ��Ҫ��ȡ����Ƶ�ļ�

nFrames = xyloObj.NumberOfFrames; %��ȡ��Ƶ��֡��
vidHeight = xyloObj.Height; %��ȡ��Ƶ�߶�
vidWidth = xyloObj.Width; %��ȡ��Ƶ���

for k =10000 : nFrames %����ÿһ֡
    I = read(xyloObj, k); %������ǰ֡
    imshow(I); %��ʾ��ǰ֡
    %display(I);%��������ʾ���ص��
    % imshow(nFrames);
    figure(k);
    pause(0.5); %��ͣϵͳ��ʹ��������۲쵽ÿһ֡������Ϊ0.005��
end