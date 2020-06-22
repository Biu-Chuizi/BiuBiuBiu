close all;clear;clc;

video_file = 'D:\20190904\video\17'; 

list = dir(fullfile(video_file))
for k = 3:size(list,1)
    video_name=list(k).name
    new_name=strsplit(video_name, '.');
    new_name=new_name{1,1};
    video_path=fullfile(video_file,video_name);
%     dir_name = split(num2str(list(k).name),'.')
    mkdir( 'D:\20190904\frame', new_name)
%     mkdir( 'D:\a', num2str(list(k).name))
%     num2str(list(k).name))
    obj = VideoReader(video_path);
    numFrames = obj.NumberOfFrames;
    for bb = 1: numFrames
        if rem(bb,1) == 0
            i=bb;
            image_name=strcat(['D:\20190904\frame\',new_name,'\',num2str(i)],'.jpg');
%                 num2str(video_name),'\',num2str(i)],'.jpg');
            frame = read(obj,i);
            imwrite(frame,image_name,'jpg');
            frame=[];
        end
    end
end


% close all;clear;clc;
% fileName = 'E:\BiuBiuBiu\Polyps_data\20161004\AizuVideo02\M_20160927092955_0000000002151129_1_001_001-1.mp4'; 
% obj = VideoReader(fileName);
% numFrames = obj.NumberOfFrames;% 帧的总数
%  for k = 1: numFrames% 读取数据
%      frame = read(obj,k);
%      %imshow(frame);%显示帧
%      imwrite(frame,strcat(num2str(k),'.png'),'png');% 保存帧
% end


% close all;clear;clc;
% video_file='F:\Polyps_data\20180730\20180713120710(no\video_files\000001-001.mov'; %where you put the video file
% video=VideoReader(video_file);
% frame_number=floor(video.Duration*video.FrameRate);
% for bb=1:frame_number
%    if rem(bb,10) == 1
%         i=bb;
%         image_name=strcat('0',num2str(i));
%         image_name=strcat(image_name,'.tiff');
%         I=read(video,i);   %读出图片        
%         imwrite(I,image_name,'tiff');   %写图片
%         I=[];
%    end
% end






