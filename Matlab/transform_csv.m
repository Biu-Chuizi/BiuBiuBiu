%datafold = 'C:\Polyp\data\ROI\Whitelight\aizuvideo01\';
%image_0  = imread([datafold,'216.jpg']);
%216,"816,746,349,172"
%imshow(image_0(746:746+171,816:816+348,:))
datafold = 'C:\Users\Joe\Desktop\data\';
the_dir  = dir(datafold);
fold_num = length(the_dir);


for i = 11 : 11%fold_num
    
    csv_data = [];
    fid = fopen([datafold the_dir(i).name '\normal_coordinate.csv']);
    while feof(fid) == 0
        data_0 = fscanf(fid, '%d', 1);
        fscanf(fid,'%2s',1);
        data_1 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_2 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_3 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_4 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        csv_data = [csv_data;data_0, data_1, data_2, data_3, data_4];
    end
    fclose(fid);
    csvwrite([datafold the_dir(i).name '\normal_coordinate_1.csv'], csv_data);

    csv_data = [];
    fid = fopen([datafold the_dir(i).name '\polyp_coordinate.csv']);
    while feof(fid) == 0
        data_0 = fscanf(fid, '%d', 1);
        fscanf(fid,'%2s',1);
        data_1 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_2 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_3 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        data_4 = fscanf(fid, '%d', 1);
        fscanf(fid,'%1s',1);
        csv_data = [csv_data;data_0, data_1, data_2, data_3, data_4];
    end
    fclose(fid);
    csvwrite([datafold the_dir(i).name '\polyp_coordinate_1.csv'], csv_data);
end

