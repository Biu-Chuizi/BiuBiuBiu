fold_name = 'E:\BiuBiuBiu\data\data_LST-8\data_LST-8';%'D:\Polyp\data\ROI\All\data_aizuvideo01';
load([fold_name '_map_1.mat'])
file_info = keys(m);
file_num  = length(file_info);
contour_info = values(m);

% for i = 1 : file_num
%     name_num = length(file_info{i});
%     the_num  = 1;
%     for j = name_num:-1:1
%         if file_info{i}(j) == '\'
%             the_num = j + 1;
%             break;
%         end
%     end
%     file_info{i} = file_info{i}(the_num:end);
% end

%the_image = zeros(1920,1080);
for i = 1 : file_num
    x_index = repmat([1:1920],1080,1);
    y_index = repmat([1:1080]',1,1920);
    [in,on] = inpolygon(x_index,y_index,contour_info{i}(:,1),contour_info{i}(:,2));
    imwrite(in,[file_info{i}, '.tif']);
end
    
    
    



