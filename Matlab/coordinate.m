close all;clear;clc;
%sourceFile='C:\Users\Joe\Desktop\data_aizuvideo01\normal_labelingSession.mat'; 
load('normal_labelingSession', 'labelingSession');
imagesNum = size(labelingSession.ImageSet.ImageStruct,2);
fd = fopen('normal_coordinate.csv','w');
    for x=1:imagesNum
        str_name=labelingSession.ImageSet.ImageStruct(x).ImageLabel;
        coordinate_num = size(labelingSession.ImageSet.ImageStruct(x).objectBoundingBoxes,1);
        for i=1:coordinate_num
            str_coordinate=sprintf('%d,',labelingSession.ImageSet.ImageStruct(x).objectBoundingBoxes(i,:));
            str_coordinate=str_coordinate(1:end-1);
            str_coordinate=sprintf('"%s"',str_coordinate); 
            line = strcat(str_name,',',str_coordinate);
            fprintf(fd, "%s\r\n",line);
        end
    end
fclose(fd);
