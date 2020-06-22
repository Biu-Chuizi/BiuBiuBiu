close all;clear;clc;
sourceFile='C:\Users\Joe\Desktop\data_aizuvideo02\coordinate'; 
sourceDir='C:\Users\Joe\Desktop\data_aizuvideo02'; 
sourceTable = readtable(sourceFile);
imageIds = table2array(sourceTable(:,1));
length = size(imageIds,1);
for i=1:length
    imageId = int2str(imageIds(i));
    imagePath = strcat(sourceDir,'\', imageId, '.tiff');
    imageFile = imread(imagePath);
    imageNewPath = strcat(imageId, '.tiff');
    imwrite(imageFile, imageNewPath);
end
