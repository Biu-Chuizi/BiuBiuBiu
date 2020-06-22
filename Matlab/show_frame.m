close all;clear;clc;
xyloObj = VideoReader('M_20160920094232_0000000001769241_1_001_001-1.mp4'); %相应修改为需要读取的视频文件

nFrames = xyloObj.NumberOfFrames; %获取视频总帧数
vidHeight = xyloObj.Height; %获取视频高度
vidWidth = xyloObj.Width; %获取视频宽度

for k =10000 : nFrames %遍历每一帧
    I = read(xyloObj, k); %读出当前帧
    imshow(I); %显示当前帧
    %display(I);%好像是显示像素点的
    % imshow(nFrames);
    figure(k);
    pause(0.5); %暂停系统，使人眼连贯观察到每一帧，此设为0.005秒
end