%     function Save_Raw_Samples_ROIs(labelingression_data_path, output_path)
    output_path='C:\Users\lab\Desktop\polyp';
    roi_info = load( 'C:\Users\lab\Desktop\imageLabelingSession_polyp_20190623.mat'); 
    gTruth = load( 'C:\Users\lab\Desktop\polyp_gTruth.mat');
    gTruth = gTruth.gTruth;
%     image_counts = size(roi_info.labelingSession.ImageSet.ImageStruct,2);%struct�ṹ����ͨ�����������ʽ��ͬ����һ��Ϊ�У��ڶ���Ϊ��  
    image_counts = size(gTruth.LabelData,1);%struct�ṹ����ͨ�����������ʽ��ͬ����һ��Ϊ�У��ڶ���Ϊ��  
    roi_index = 0;  
    pause(1);%��ʱ1s��ȷ���������������  
    current_time = datestr(now,'yyyy-mm-dd-HH-MM-SS_');  
    if ~isdir(output_path) %�ж�·���Ƿ����  
        mkdir(output_path);  
    end
    for i = 1:image_counts%��ÿ��ͼ���δ�����ȡROI����  
%         image_info = roi_info.labelingSession.ImageSet.ImageStruct(i);
        image_info = roi_info.imageLabelingSession.ImageFilenames{i};
%         image = imread(image_info.imageFilename); 
        image = imread(image_info);
        box_info=gTruth.LabelData{i,1}{1,1};
        box_row = size(gTruth.LabelData{i,1}{1,1});
        box_rows = box_row(1,1);
        for j = 1:box_rows
            box = box_info(j,:);
            cropped_roi = imcrop(image,box);
            image_full_name = strcat(output_path,'\',current_time,num2str(roi_index),'.jpg');
            imwrite(cropped_roi,image_full_name);
            roi_index=roi_index + 1;
        end
%         box_rows = size(image_info.objectBoundingBoxes,1);  
%             for j = 1:box_rows%��ÿ��ͼ������ROI���������ȡ  
%                 box =image_info.objectBoundingBoxes(j,:);  
%                 cropped_roi = imcrop(image,box);  
%                 %imshow(cropped_roi);  
%                 image_full_name = strcat(output_path,'\',current_time,num2str(roi_index),'.jpg');  
%                 imwrite(cropped_roi,image_full_name);  
%                 roi_index=roi_index + 1;  
%             end  
    end  